extends StaticBody3D
class_name Tail

@export var index := 0
@export var next_pos := Vector3(0,0,0)

func _ready():
	$MeshInstance3D.set_instance_shader_parameter('index', float(index))
	$AnimationPlayer.play("show")


func despawn():
	if multiplayer.is_server():
		queue_free()


@rpc("any_peer", "call_local")
func explode():
	$AnimationPlayer.play("fade")
	var particles = preload("res://tail_boom.tscn").instantiate()
	await get_tree().create_timer(randf_range(0,0.4)).timeout
	add_child(particles)
	pass

func set_color(color : Vector3):
	$MeshInstance3D.set_instance_shader_parameter("color", color)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade":
		despawn()
