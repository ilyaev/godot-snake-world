extends MultiplayerSynchronizer

# Synchronized property.
@export var direction := PI/2.0
@export var rotation_speed = 1.2

func _ready():
	# Only process for the local player
#	direction = randf_range(-PI, PI)
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())


func _process(delta):
	if Input.is_action_pressed("ui_right"):
		direction += delta * PI * rotation_speed

	if Input.is_action_pressed("ui_left"):
		direction -= delta * PI * rotation_speed

	if Input.is_action_pressed("ui_up"):
		get_parent().autopilot = !get_parent().autopilot

@rpc("reliable", "call_local", "any_peer")
func update_direction(new_direction):
	direction = new_direction
