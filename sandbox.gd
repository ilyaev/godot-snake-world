extends Node3D

var p1 := Vector3(0,0,0)
var p2 := Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#$point2.position = Vector3($point1.position.x + sin(PI*delta)*10,$point1.position.y + cos(PI*delta)*10, 0)
	
	var changed = false
	if p1 != $point1.position:
		p1 = $point1.position
		changed = true
	if p2 != $point2.position:
		p2 = $point2.position
		changed = true
	if !changed:
		return
		
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
	$plane.set_mesh(mesh)
	$plane.set_position(p1 + Vector3(width/2*sign(p2.x-p1.x), height/2*sign(p2.y-p1.y), 0))
	$plane.set_instance_shader_parameter("reverse", reversed)
	
	
	$plane.basis = Basis().rotated(Vector3.BACK, angle + PI/4)
