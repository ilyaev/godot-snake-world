extends StaticBody3D
class_name Food


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	$MeshBox.rotate_x(delta * PI/4)
	$MeshBox.rotate_y(delta * PI/2)
	$MeshBox.rotate_z(delta * PI/8)
	
	$MeshCore.rotate_y(delta * PI)
