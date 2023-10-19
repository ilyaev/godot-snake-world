extends Node3D

signal change_position

var SPEED := 6.
var INTERPOLATION_INTERVAL = 0.1
var index = 0
var T = 0

var elapsed = 0

var last_state := Time.get_unix_time_from_system()
var state_buffer := []

var first_head = null

@export var state_timestamp := Time.get_unix_time_from_system()
@export var pos := Vector3(0,0,0)
@export var player := 1 :
	set(id):
		player = id
		$PlayerInput.set_multiplayer_authority(id)

func _physics_process(delta):
	pre_process(delta)
	
	if is_multiplayer_authority():
		server_process(delta)
	else:
		client_process()

	move_tails(delta)
	
	if player == multiplayer.get_unique_id():
		player_process(delta)


func player_process(_delta):
	Events.emit_signal("player_position", $head.position)

func server_process(delta):
	state_timestamp = Time.get_unix_time_from_system()
	$head.position += $PlayerInput.direction.normalized() * delta * SPEED
	pos = $head.position
	collision_detection(delta)
	spawn_control()

func collision_detection(delta):
	var head_direction = $PlayerInput.direction.normalized()
	var collision : KinematicCollision3D = $head.move_and_collide(head_direction * delta * SPEED*1.1, true)
	if collision:
		var collider = collision.get_collider()
		if collider is Food:
			spawn_tail()
			collider.rpc("eat")
		else:
			var bounced = head_direction.bounce(collision.get_normal()).rotated(Vector3.BACK, randf_range(-PI/8, PI/8))
			$PlayerInput.direction = Vector3(bounced.x, bounced.y, 0)
			$PlayerInput.next_direction = $PlayerInput.direction
	pass

func pre_process(delta):
	T += delta
	elapsed += delta
	
	$Label.set_text(str(multiplayer.get_unique_id()))
	
	# Rotate head toward direction
	var direction = $PlayerInput.direction
	if !first_head:
		for tail in $Tails.get_children():
			if tail.index == 0:
				first_head = tail
				break
	if first_head:
		direction = $head.position - first_head.position
	$head.basis = Basis().rotated(Vector3.FORWARD, direction.signed_angle_to(Vector3.UP, Vector3.BACK) - PI/2)

func spawn_control():
	if T > 1 and $Tails.get_child_count() < 3:
		T = 0
		spawn_tail()

func client_process():
	if state_buffer.size() > 1:
		var render_time = Time.get_unix_time_from_system() - INTERPOLATION_INTERVAL
		while state_buffer.size() > 2 and render_time > state_buffer[1]["T"]:
			state_buffer.remove_at(0)
		var interpolation_factor = float(render_time - state_buffer[0]["T"]) / float(state_buffer[1]["T"] - state_buffer[0]["T"])
		var new_position = lerp(state_buffer[0]["P"], state_buffer[1]["P"], interpolation_factor)
		if render_time > state_buffer[0]["T"]:
			$head.position = new_position
	else:
		$head.position = pos
	
func get_tails():
	var sorted = $Tails.get_children()
	sorted.sort_custom(func(a, b): return a.index < b.index)
	return sorted

func move_tails(delta):
	var t_pos = $head.position

	var sorted = get_tails()

	for tail in sorted:
		var dist = (t_pos - tail.position).length()
		if dist > 1:
			dist = 1
		tail.position += (t_pos - tail.position) * delta * SPEED * (.9 - (1. - dist)*3.)
		t_pos = tail.position


func spawn_tail():
	if $Tails.get_child_count() > 70:
		return
	var tail = preload("res://tail.tscn").instantiate()
	var t_pos = pos

	if $Tails.get_child_count() > 0:
		t_pos = $Tails.get_child($Tails.get_child_count() - 1).position
	tail.position = t_pos
	tail.next_pos = t_pos
	tail.index = $Tails.get_child_count()
	$head.add_collision_exception_with(tail)
	$Tails.add_child(tail, true)

func _on_server_synchronizer_synchronized():
	if state_timestamp > last_state:
		last_state = state_timestamp
		state_buffer.append({"T": state_timestamp, "P": pos})


func _on_multiplayer_spawner_spawned(node):
	$head.add_collision_exception_with(node)
	if elapsed > 2.:
		var sorted = get_tails()
		node.position = sorted[sorted.size() - 2].position
