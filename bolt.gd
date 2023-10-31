extends MeshInstance3D
class_name Bolt

@export var p1 := Vector3(0,0,0):
	set(new_p1):
		p1 = new_p1
		recalc()
		
@export var p2 := Vector3(0,0,0):
	set(new_p2):
		p2 = new_p2
		recalc()

@export var alpha := 1.:
	set(new_alpha):
		set_instance_shader_parameter("alpha", new_alpha)
		alpha = new_alpha

@export var fill := 1.:
	set(new_fill):
		set_instance_shader_parameter("fill", new_fill)
		fill = new_fill
		
@export var reverse := false:
	set(new_reverse):
		set_instance_shader_parameter("reverse", new_reverse)
		reverse = new_reverse

@export var color := Color(.9, .3, .1):
	set(new_color):
		set_instance_shader_parameter("color", Vector3(new_color.r,new_color.g,new_color.b))
		color = new_color

func recalc():
	var mesh = QuadMesh.new()
	
	var diagonal = (p2-p1).length()
	var a = diagonal/sqrt(2)
	
	var width = p2.x - p1.x
	
	var reversed = false
	
	if p1.x > p2.x:
		width = p1.x - p2.x
		
	var height = p2.y - p1.y
	if p1.y > p2.y:
		height = p1.y - p2.y
	
	var angle = atan((p2.y - p1.y)/(p2.x-p1.x))

	mesh.set_size(Vector2(a, a));
	set_mesh(mesh)
	set_position(p1 + Vector3(width/2*sign(p2.x-p1.x), height/2*sign(p2.y-p1.y), 0))
	set_instance_shader_parameter("reverse", reversed)
	var extra = 0
	if reverse:
		extra += PI
	basis = Basis().rotated(Vector3.BACK, angle + PI/4 + extra)

func _ready():
	await get_tree().create_timer(randf_range(0,0.3)).timeout
	$AnimationPlayer.play("show")

func _on_animation_player_animation_finished(anim_name):
	if not Engine.is_editor_hint():
		queue_free()
