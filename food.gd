extends Node3D
class_name Food

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	if is_multiplayer_authority():
		position.x = randi_range(-10, 10)
		position.y = randi_range(-7, 7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_x(delta * PI/4)
	rotate_y(delta * PI/2)
	rotate_z(delta * PI/8)
	pass

@rpc("any_peer")
func eaten():
	call_deferred("queue_free")
