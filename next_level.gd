extends Node3D

signal animation_finished
var scores : Dictionary = {}
var T := 0.

var CONTINUE_IN = 2.

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 1
	%Countdown.hide()
	for label in $Panel/Container.get_children():
		label.hide()
	for key in scores.keys():
		if index <= $Panel/Container.get_child_count():
			var score_label = get_node("Panel/Container/score" + str(index))
			score_label.show()
			score_label.set_text(key + ': ' + str(scores[key]))
			index += 1
	await get_tree().create_timer(2.).timeout
	%Countdown.show()
	await get_tree().create_timer(CONTINUE_IN).timeout
	animation_finished.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	T += delta
	var left = (CONTINUE_IN + 2.5) - T
	%Countdown.set_text('Continue in ' + str(round(left)))
