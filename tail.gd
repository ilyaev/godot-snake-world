extends StaticBody3D
class_name Tail

@export var index := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$MeshInstance3D.set_instance_shader_parameter('index', float(index))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
