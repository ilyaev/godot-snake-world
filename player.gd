extends Node3D

signal change_position

# Set by the authority, synchronized on spawn.
@export var player := 1 :
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$PlayerInput.set_multiplayer_authority(id)

@export var speed = 8.0

var direction := Vector3(0.0,0.0,0.0)
@export var collision_mutation = PI/16
@export var pos := Vector3(0,0,0)
@export var state_timestamp := Time.get_unix_time_from_system()
@export var title := 'Robot'
@export var autopilot := true

# Player synchronized input.
@onready var input = $PlayerInput

var TAIL = preload("res://tail.tscn")
var INTERPOLATION_INTERVAL = 0.1

var last_state := Time.get_unix_time_from_system()
var state_buffer := []

var T := 0.0
var S_TAIL = 0.5

var prev = Time.get_unix_time_from_system()
var prev_pos = Vector3(0,0,0)
var elapsed := 0.0
var T_LAST_COLLIDED = 0.0
var T_LAST_COLLIDED_OBJECT = null

var seek_time = 0.0
var seek_position = Vector3(0., 0., 0.)
var seek_food : Food = null

func _ready():
	$Tails.get_child(1).add_collision_exception_with($Tails.get_child(0))

func _physics_process(delta):
	elapsed += delta
	var alpha = $PlayerInput.direction

	direction.x = sin(alpha)
	direction.y = cos(alpha)

	$Tails.get_child(1).basis = Basis().rotated(Vector3.FORWARD, ($Tails.get_child(0).position - $Tails.get_child(1).position).signed_angle_to(Vector3.UP, Vector3.BACK))

	if is_multiplayer_authority() && autopilot == true:
		do_autopilot(delta)


	if is_multiplayer_authority() || state_buffer.size() < 2:
		$head.position += direction * delta * speed
		pos = $head.position
		state_timestamp = Time.get_unix_time_from_system()
	else:
		if state_buffer.size() > 1:
			var render_time = Time.get_unix_time_from_system() - INTERPOLATION_INTERVAL
			while state_buffer.size() > 2 and render_time > state_buffer[1]["T"]:
				state_buffer.remove_at(0)
			var interpolation_factor = float(render_time - state_buffer[0]["T"]) / float(state_buffer[1]["T"] - state_buffer[0]["T"])
			var new_position = lerp(state_buffer[0]["P"], state_buffer[1]["P"], interpolation_factor)
			if render_time > state_buffer[0]["T"]:
				$head.position = new_position
				pos = new_position
			else:
				$head.position += direction * delta * speed

#	var collision : KinematicCollision3D = $head.move_and_collide(direction * delta * speed, true)
	var head_direction = ($Tails.get_child(0).position - $Tails.get_child(1).position).normalized()
	var collision : KinematicCollision3D = $Tails.get_child(1).move_and_collide(head_direction * delta * speed, true)

	T_LAST_COLLIDED += delta
	
	if collision && is_multiplayer_authority():

		var collider = collision.get_collider()
		
		if collider is Food:
			collider.queue_free()
			spawn_tail()
			get_parent().get_parent().spawn_food()
		else:
			if T_LAST_COLLIDED > .3 || T_LAST_COLLIDED_OBJECT != collider:
				T_LAST_COLLIDED = 0
				T_LAST_COLLIDED_OBJECT = collider
				alpha = head_direction.bounce(collision.get_normal()).signed_angle_to(Vector3.UP, Vector3.BACK)
				alpha += randf_range(-collision_mutation, collision_mutation)
				$PlayerInput.rpc("update_direction", alpha)
				$head.position = $Tails.get_child(1).position + Vector3(sin(alpha), cos(alpha), 0.)
				pos = $head.position

	move_tails(delta)

	T += delta
	if is_multiplayer_authority() && T > S_TAIL && $Tails.get_child_count() < 10:
		T = 0
		spawn_tail()

	var orig = $head.global_transform.origin
	if $Tails.get_child_count() > 1:
		orig = $Tails.get_child(1).global_transform.origin
	var screen_pos = get_parent().get_parent().get_node("Camera").unproject_position(orig)
#	$Label.set_text(str(player) + ':'+title)
	$Label.set_text(title)
	$Label.set_position(screen_pos)

	if $Tails.get_child_count() > 1:
		emit_signal("change_position", $Tails.get_child(1).position)
	else:
		emit_signal("change_position", head_position())

func move_tails(delta):
	var next_position = $head.position
	var c = $Tails.get_child_count()
	for i in range(0, c):
		var tail = $Tails.get_child(i)
		var d_to_tail = (next_position - tail.position).length()
		if i < 2 or d_to_tail > 5.:
			d_to_tail = 1.
		tail.position = tail.position + (next_position - tail.position) * delta * speed * (.9 - (1. - d_to_tail)*3.)
		next_position = tail.position

func spawn_tail():
	if !multiplayer.is_server():
		return
	# if $Tails.get_child_count() > 10:
	# 	return
	var tail = TAIL.instantiate()
	tail.position = pos
	if $Tails.get_child_count() > 1:
		var next = $Tails.get_child($Tails.get_child_count() - 1)
		tail.position = next.position
	tail.name = "tail_" + str(player) + '_' + str(randi_range(100,10000))
	tail.index = $Tails.get_child_count()
	$Tails.add_child(tail, true)
#	if $Tails.get_child_count() < 4:
	$Tails.get_child(1).add_collision_exception_with(tail)
	seek_time = 0

func head_position():
	return $head.position

func sync_position(new_position):
	$head.position = new_position
	pos = $head.position
	$Tails.get_child(0).position = new_position
	$Tails.get_child(1).position = new_position


func _on_server_synchronizer_synchronized():
	if state_buffer.size() < 1:
		$head.position = pos
	state_timestamp = Time.get_unix_time_from_system()
	if state_timestamp > last_state:
		last_state = state_timestamp
		state_buffer.append({"T": state_timestamp, "P": pos})


func _on_multiplayer_spawner_spawned(node):
#	if $Tails.get_child_count() < 4:
	$Tails.get_child(1).add_collision_exception_with(node)
	node.index = $Tails.get_child_count()

func get_all_food():
	return get_parent().get_parent().get_node('Objects').get_children()

func find_next_food():
	var foods = get_all_food()
	if foods.size() < 1:
		seek_food = null
		return
	seek_food = foods[randi_range(0, foods.size() - 1)]

func do_autopilot(delta):
	var T = Time.get_unix_time_from_system()
	if seek_food == null || seek_food.is_queued_for_deletion() || seek_time > 5:
		seek_time = 0.0
		find_next_food()
		return
	seek_time += delta
	seek_position = seek_food.position
	var n_direction = direction.lerp(seek_food.position - $head.position, delta * $PlayerInput.rotation_speed)
	var n_angle = n_direction.signed_angle_to(Vector3.UP, Vector3.BACK) + sin(T * 7.) * PI*delta*2.
	$PlayerInput.direction = n_angle
