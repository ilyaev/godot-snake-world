extends Node3D

var T = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	T += delta
	var next = get_parent().get_head()
	var c = get_child_count()
	for i in range(1, c):
		var tail = get_child(i)
		if tail is Tail:
			tail.position = tail.position + (next.position - tail.position) * delta * get_parent().speed * .9
			next = tail


func _on_multiplayer_spawner_spawned(node):
	if node.position.length() == 0:
		if get_child_count() < 3:
			node.position = get_parent().get_head().position
		else:	
			node.position = get_child(get_child_count() - 2).position
