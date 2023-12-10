extends Control

signal single_player
signal multi_player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_single_player_button_down():
	single_player.emit()


func _on_multiplayer_button_down():
	multi_player.emit()
