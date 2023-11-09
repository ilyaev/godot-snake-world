extends Node

@export var players : Node3D
@export var field : Field

var slate_queue : Array[Slate] = []

const MIN_DISTANCE := 2.5;
const CHECK_INTERVAL := .5;

var T := 0.

func _ready():
	set_process(multiplayer.is_server())


func _process(delta):
	T += delta
	if T < CHECK_INTERVAL:
		return
	T = 0.
	
	var new_queue : Array[Slate] = []
	
	for slate in slate_queue:
		var flag = true
		for player in players.get_children():
			var d = (player.pos - slate.position).length()
			if d < MIN_DISTANCE:
				flag = false
			else:
				for tail in player.get_tails():
					d = (tail.position - slate.position).length()
					if d < MIN_DISTANCE:
						flag = false
			if !flag:
				break
		if flag:
			for food in field.get_foods():
				var d = (food.position - slate.position).length()
				if d < MIN_DISTANCE:
					flag = false
					break
		if flag:
			var block = field.level.add_block(slate.x, slate.y)
			field.get_node("Objects").add_child(block, true)
			slate.despawn()
		else:
			new_queue.push_back(slate)
			
	slate_queue = new_queue
