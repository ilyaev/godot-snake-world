extends Node3D
class_name Player

var direction = Vector3(1,0,0)
@export var alpha = PI/2
@export var speed = 8
@export var rotation_speed = .8
@export var collision_mutation = PI/16
@export var pos = Vector3(0,0,0)

var autopilot = false
var next_alpha = 0
var next_position = Vector3(0,0,0)


var TAIL = preload("res://tail.tscn")

var T_SPAWN = 0
var T_AUTO = 0
var elapsed = 0

var search_next_target = true

@export var aID = "0"

func _enter_tree():
	set_multiplayer_authority(name.to_int())
	if name.to_int() == 1:
		autopilot = true
	if is_multiplayer_authority():
		init_position()
		set_visible(true)
	
func get_head():
	return $body

func _process(delta):
	T_SPAWN += delta	
	T_AUTO += delta
	elapsed += delta
	if T_SPAWN > 1:
		T_SPAWN = 0
		if is_multiplayer_authority():
			if $tails.get_child_count() < 3:
				spawn_tail()
#			rpc("spawn_tail")
		
func _physics_process(delta):
	if is_multiplayer_authority():
		if autopilot:
			do_autopilot(delta)
		else:
			if Input.is_action_pressed("ui_right"):
				alpha += delta * PI * rotation_speed

			if Input.is_action_pressed("ui_left"):
				alpha -= delta * PI * rotation_speed
			

	direction.x = sin(alpha)
	direction.y = cos(alpha)

	$body.position += direction * delta * speed
	
	if is_multiplayer_authority():
		get_parent().camera.position.x = $body.position.x
		get_parent().camera.position.y = $body.position.y

	var collision : KinematicCollision3D = $body.move_and_collide(direction * delta * speed, true)

	if collision:
		var collider = collision.get_collider()
		if !collider.get_parent() is Tail || collider.get_parent().head != $body:
			if collider.get_parent() is Food:
				pass
			else:
				alpha = direction.bounce(collision.get_normal()).signed_angle_to(Vector3.UP, Vector3.BACK)
				alpha += randf_range(-collision_mutation, collision_mutation)
			if is_multiplayer_authority():
				if collider.get_parent() is Food:
					spawn_tail()
					search_next_target = true
					collider.get_parent().rpc("eaten")
				else:
					reset_tail()
	
func reset_tail():
	var index = 0
	for n in $tails.get_children():
		if index > 2:
			$tails.remove_child(n)
			n.queue_free()	
		index += 1
	
func spawn_tail():
	var tail = TAIL.instantiate()
	tail.position = $body.position
	tail.next = $body
	tail.head = $body
	if $tails.get_child_count() > 1:
		var next = $tails.get_child($tails.get_child_count() - 1)
		tail.position = next.position
		tail.next = next
		
	tail.next_position = tail.next.position
	tail.position = Vector3(tail.position)
	$tails.add_child(tail, true)

func init_position():
	pos = Vector3(0, randf_range(-8,8), 0)
	$body.position = pos
	
func do_autopilot(delta):
	if next_alpha != 0 && abs(next_alpha - alpha) > .1:
		alpha += (next_alpha - alpha) * .2
	
	if search_next_target || T_AUTO > 1:
		T_AUTO = 0
		for food in get_parent().get_children():
			if food is Food:
				next_alpha = (food.position - $body.position).signed_angle_to(Vector3.UP, Vector3.BACK)
				search_next_target = false;
				break
