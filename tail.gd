extends Node3D
class_name Tail

@export var next : Node3D
@export var head : Node3D
@export var next_position = Vector3(0,0,0)

var T = 0
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	index = get_parent().get_child_count()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
#	T = get_parent().T
#	position.z = sin(index + T) * 0.2;
#	if !next || next.is_queued_for_deletion():
#		return
#	T += delta
#	position = position + (next.position - position) * delta * get_parent().get_parent().speed * .9

@rpc("any_peer")
func despawn():
	get_parent().remove_child(self)
	call_deferred("queue_free")
	
