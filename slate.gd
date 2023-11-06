@tool
extends MeshInstance3D
class_name Slate

var score := 10
var T := -1.
var a := 0.

@export var x := 0:
	set(new_x):
		x = new_x
		position = Vector3(1.07 + x * 2, .93 + y * 2, 0.001)

@export var y := 0:
	set(new_y):
		y = new_y
		position = Vector3(1.07 + x * 2, .93 + y * 2, 0.001)

@export var color: Color:
	set(new_color):
		color = new_color
		set_instance_shader_parameter('color', color)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	#show_score()

@rpc("any_peer","call_local")
func show_score(new_score):
	T = -1
	score = new_score
	$Label.set_text(str(score))
	$Label.position = Events.camera.unproject_position(global_transform.origin) + Vector2(randi_range(-50,50), randi_range(-50,50))
	position = Vector3(1.07 + x * 2, .93 + y * 2, 0.001)
	set_instance_shader_parameter('color', color)
	await get_tree().create_timer(randf_range(0,0.3)).timeout
	set_process(true)
	T = 0
	a = 0
	$Label.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if T < 0:
		return
	T += delta
	a += delta * 1500
	$Label.position.y -= delta*(100. + a)
	if T > .6:
		set_process(false)
		$Label.hide()
	pass
	
func despawn():
	await get_tree().create_timer(.5).timeout
	queue_free()
