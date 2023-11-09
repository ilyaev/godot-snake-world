extends State
class_name FieldNextLevel

@export var field : Field

var next_level_scene = preload("res://next_level.tscn")
var next_level : Node

func Enter():
	next_level = next_level_scene.instantiate()
	
	for player in field.get_players():
		player.set_state_local('PlayerPaused')
		if !player.is_autopilot:
			next_level.scores[player.get_node('Title').get_text()] = player.score
		
	
	next_level.animation_finished.connect(func (): field.set_state("FieldStart"))
	
	field.add_child(next_level)
	
func Exit():
	field.remove_child(next_level)
	next_level.queue_free()
	await get_tree().create_timer(.2).timeout
	for obj in field.get_objects():
		obj.queue_free()
	
	field.change_level_id.rpc(field.level_id + 1)
	
	await get_tree().create_timer(.1).timeout
	
	for player in field.get_players():
		player.reset()
		var pos = field.level.find_empty_cell_center()
		player.pos = pos
		player.get_node('head').position = pos
