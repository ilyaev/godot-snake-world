extends Node

@export var players : Node3D
@export var field : Field

var slate_queue : Array[Slate] = []

var T := 0.

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(multiplayer.is_server())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	T += delta
	if T < .5:
		return
	T = 0.
	var new_queue : Array[Slate] = []
	for slate in slate_queue:
		var flag = true
		for player in players.get_children():
			var d = (player.pos - slate.position).length()
			if d < 2.5:
				flag = false
			else:
				for tail in player.get_tails():
					d = (tail.position - slate.position).length()
					if d < 2.5:
						flag = false
			if !flag:
				break
		if flag:
			for food in field.get_foods():
				var d = (food.position - slate.position).length()
				if d < 2.5:
					flag = false
					break
		if flag:
			var block = field.level.add_block(slate.x, slate.y)
			field.get_node("Objects").add_child(block, true)
			slate.despawn()
		else:
			new_queue.push_back(slate)
			
	slate_queue = new_queue
