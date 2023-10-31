extends Node

@export var snake : Player
@export var field : Field
@export var is_active := false

var state = 'seek' # 'follow', 'evade'
var target : Food

var evade_time = 1
var follow_time = 3

var T = 0

func _ready():
	set_physics_process(is_active && multiplayer.is_server())


func _physics_process(delta):
	T += delta
	autopilot(delta)
	
func autopilot(delta):
	if state == 'follow' && T > follow_time:
		set_state('seek')
	
	if state == 'evade' && T > evade_time:
		set_state('seek')
		
	if state == 'seek':			
		var foods = field.get_foods()
		if foods.size() == 0:
			return
		target = foods[randi_range(0, foods.size() - 1)]
		set_state('follow')
	
	if state == 'follow':
		if !target or !is_instance_valid(target):
			set_state('seek')
		else:
			var n_direction = snake.get_input().direction.lerp(target.position - snake.get_head().position, delta)
			snake.get_input().set_direction(n_direction.normalized() * .9)

func set_state(new_state):
	if state != new_state:
		T = 0
	state = new_state
