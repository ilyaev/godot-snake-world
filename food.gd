extends StaticBody3D
class_name Food

var eaten := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var multiplier = 1
	if eaten:
		multiplier = 5
	$MeshBox.rotate_x(delta * PI/4 * multiplier)
	$MeshBox.rotate_y(delta * PI/2 * multiplier)
	$MeshBox.rotate_z(delta * PI/8 * multiplier)
	
	$MeshBox/MeshCore.rotate_y(delta * PI * multiplier)

@rpc("any_peer", "call_local")
func eat():
	remove_child($CollisionShape3D)
	eaten = true
	$AnimationPlayer.play("fade")
	if multiplayer.is_server():
		await get_tree().create_timer(1.).timeout
		queue_free()
