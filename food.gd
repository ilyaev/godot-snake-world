extends StaticBody3D
class_name Food

var eaten := false
var multiplier := 1.0

@export_enum("food", "slate") var type : String = "food"
@export var color : Color = Color(1., 1., 1.)

func _ready():
	if type == 'food':
		$MeshBox/MeshCore.show()
		$MeshBox/MeshSlate.hide()
	else:
		$MeshBox/MeshCore.hide()
		$MeshBox/MeshSlate.show()
		$MeshBox/MeshSlate.set_instance_shader_parameter("color", color)

	$AnimationPlayer.play("show")

func _physics_process(delta):
	if eaten:
		multiplier += delta * 6.

	$MeshBox.rotate_x(delta * PI/4 * multiplier)
	$MeshBox.rotate_y(delta * PI/2 * multiplier)
	$MeshBox.rotate_z(delta * PI/8 * multiplier)

	$MeshBox/MeshCore.rotate_y(delta * PI * multiplier)

@rpc("any_peer", "call_local")
func eat():
	multiplier = 5.
	$CollisionShape3D.queue_free()
	eaten = true
	$AnimationPlayer.play("fade")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade":
		if multiplayer.is_server():
			queue_free()
