extends Node

@export var players : Node3D
@export var field : Field

signal level_completed

var T := 0.

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(multiplayer.is_server())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	T += delta;
	if T < 1.:
		return
	T = 0.
	var empty_map = field.level.empty_map
	var not_empty = 0
	for key in empty_map.keys():
		if empty_map[key]:
			not_empty += 1
	if not_empty == 0 and field.level.block_queue.size() == 0:
		field.next_level()
