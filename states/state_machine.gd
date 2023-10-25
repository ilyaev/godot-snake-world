extends Node

var current_state : State = null
var states : Dictionary = {}

signal Transitioned(state : String, current_state : String)

@export var initial_state : State

func _ready():
	for child in get_children():
		if child is State:
			print('add statE: ', child.name)
			states[child.name] = child
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state


func _process(delta):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)


func on_child_transition(state, new_state_name):
	if state != current_state:
		return

	var new_state = states[new_state_name]
	if !new_state:
		return
		
	Transitioned.emit(new_state_name, state.name)

	if current_state:
		current_state.Exit()

	current_state = new_state
	current_state.Enter()

func transit(state_name : String):
	if current_state:
		current_state.Transitioned.emit(current_state, state_name)
