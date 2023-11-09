extends Node

@export var players : Node3D
@export var field : Field

signal level_completed

const CHECK_INTERVAL := 1.

var T := 0.

func _ready():
	set_process(multiplayer.is_server())

func _process(delta):
	T += delta;
	if T < CHECK_INTERVAL:
		return
	T = 0.
	var empty_map = field.level.empty_map
	var not_empty = 0
	for key in empty_map.keys():
		if empty_map[key]:
			not_empty += 1
	if not_empty == 0 and field.level.block_queue.size() == 0:
		field.next_level()
