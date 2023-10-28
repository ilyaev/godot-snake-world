extends Node3D
class_name Player

signal change_position
signal change_cell
signal change_state

var SPEED := 6.
var INTERPOLATION_INTERVAL = 0.1
var index = 0
var T = 0

var elapsed = 0

var last_state := Time.get_unix_time_from_system()
var state_buffer := []

var first_head = null
var slate_color : Color = Color(1., 1., 1.)

var cell_pos = Vector2(0, 0)

@export var state_timestamp := Time.get_unix_time_from_system()
@export var pos := Vector3(0,0,0)
@export var player := 1 :
	set(id):
		player = id
		$PlayerInput.set_multiplayer_authority(id)

func _ready():
	$StateMachine.Transitioned.connect(func (state, current_state): change_state.emit(state, current_state, self) )

func _physics_process(delta):
	pre_process(delta)

	if is_multiplayer_authority():
		server_process(delta)
	else:
		client_process()

	move_tails(delta)

	if player == multiplayer.get_unique_id():
		player_process(delta)


func server_process(delta):
	state_timestamp = Time.get_unix_time_from_system()
	$head.position += $PlayerInput.direction.normalized() * delta * SPEED
	pos = $head.position
	collision_detection(delta)
	var new_cell_pos = Vector2(floor((pos.x)/2), floor((pos.y)/2))
	if new_cell_pos.x != cell_pos.x || new_cell_pos.y != cell_pos.y:
		change_cell.emit(new_cell_pos, self)
		on_cell_change(new_cell_pos)
	cell_pos = new_cell_pos
	spawn_control()

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


func player_process(_delta):
	Events.PLAYER_POSITION.emit($head.position)

func collision_detection(delta):
	var head_direction = $PlayerInput.direction.normalized()
	var collision : KinematicCollision3D = $head.move_and_collide(head_direction * delta * SPEED*1.1, true)
	if collision:
		var collider = collision.get_collider()
		if collider is Food && get_state() != 'PlayerCarrySlate':
			collider.rpc("eat")
			if collider.type == 'food':
				set_state("PlayerNormal")
				spawn_tail()
				#trim_tail()
			else:
				rpc("set_slate_color", collider.color)
				set_state('PlayerCarrySlate')
		elif !(collider is Food):
			var bounced = head_direction.bounce(collision.get_normal()).rotated(Vector3.BACK, randf_range(-PI/8, PI/8))
			$PlayerInput.direction = Vector3(bounced.x, bounced.y, 0)
			$PlayerInput.next_direction = $PlayerInput.direction
			set_state("PlayerEliminated")
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
	if $Tails.get_child_count() == 0:
		first_head = false
	if first_head:
		direction = $head.position - first_head.position
		var camera = get_parent().get_parent().get_node("Camera")
		var screen_pos = camera.unproject_position($Tails.get_child(0).global_transform.origin)
		$Title.set_position(screen_pos)
		if is_active():
			$Title.show()
	$head.basis = Basis().rotated(Vector3.FORWARD, direction.signed_angle_to(Vector3.UP, Vector3.BACK) - PI/2)

func spawn_control():
	if T > 1 and $Tails.get_child_count() < 3 and is_active() and $PlayerInput.direction.length() != 0:
		T = 0
		spawn_tail()

func get_tails():
	var sorted = $Tails.get_children()
	sorted.sort_custom(func(a, b): return a.index < b.index)
	return sorted

func move_tails(delta):
	if !is_active():
		return
	var t_pos = $head.position

	var sorted = get_tails()

	for tail in sorted:
		var dist = (t_pos - tail.position).length()
		if dist > 1:
			dist = 1
		tail.position += (t_pos - tail.position) * delta * SPEED * (.9 - (1. - dist)*3.)
		t_pos = tail.position


func trim_tail():
	if $Tails.get_child_count() > 3:
		$Tails.get_child($Tails.get_child_count() - 1).despawn()

func spawn_tail():
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

func set_state(state_name : String):
	rpc("rpc_set_state", state_name)

func get_state():
	return $StateMachine.current_state.name

@rpc("any_peer", "call_local")
func set_slate_color(color : Color):
	slate_color = color

@rpc("any_peer", "call_local")
func rpc_set_state(state_name : String):
	$StateMachine.transit(state_name)

func on_cell_change(new_cell_pos):
	pass
	#print([cell_pos, new_cell_pos])

func is_active():
	if get_state() == "PlayerEliminated":
		return false
	return true
