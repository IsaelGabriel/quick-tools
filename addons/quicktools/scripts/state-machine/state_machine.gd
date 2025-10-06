@icon("res://addons/quicktools/thirdparty/kenney_board-game-icons/Vector/Icons/arrow_reserve.svg")
extends Node
class_name StateMachine

@export var initial_state : State

var states : Dictionary[StringName,State] = {} ## Holds information about its states
var current_state : State

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child._attempt_transition.connect(_on_attempt_transition)
	if initial_state:
			current_state = initial_state
			current_state._enter_state()

func _process(delta: float) -> void:
	if current_state:
		current_state._update_state(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state._physics_update_state(delta)

func _on_attempt_transition(from: State, to: StringName) -> void:
	if from != current_state:
		return
		
	var new_state = states.get(to.to_lower())
	if not new_state:
		return
	
	if current_state:
		current_state._exit_state()
	
	current_state = new_state
	current_state._enter_state()
