extends MultiplayerSynchronizer

@export var direction := Vector3(1, 0, 0)
@export var next_direction := Vector3(1, 0, 0)

func _ready():
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())

func _process(_delta):
	if !get_parent().is_active() || get_parent().is_autopilot:
		return 
	if Input.is_action_pressed("ui_right"):
		next_direction = Vector3(1, 0, 0)
	if Input.is_action_pressed("ui_left"):
		next_direction = Vector3(-1, 0, 0)
	if Input.is_action_pressed("ui_up"):
		next_direction = Vector3(0, 1, 0)
	if Input.is_action_pressed("ui_down"):
		next_direction = Vector3(0, -1, 0)
	if next_direction != direction * -1:
		direction = next_direction

func set_direction(new_direction):
	direction = new_direction
	next_direction = direction
