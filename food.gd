extends StaticBody3D
class_name Food

var eaten := false
var multiplier := 1.0

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
	remove_child($CollisionShape3D)
	eaten = true
	$AnimationPlayer.play("fade")
		
		
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade":
		if multiplayer.is_server():
			queue_free()
