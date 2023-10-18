extends MultiplayerSynchronizer

@export var direction := Vector3(1, 0, 0)
@export var next_direction := Vector3(1, 0, 0)

func _ready():
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		next_direction = Vector3(1, 0, 0)
	if Input.is_action_pressed("ui_left"):
		next_direction = Vector3(-1, 0, 0)
	if Input.is_action_pressed("ui_up"):
		next_direction = Vector3(0, 1, 0)
	if Input.is_action_pressed("ui_down"):
		next_direction = Vector3(0, -1, 0)
	direction = next_direction
