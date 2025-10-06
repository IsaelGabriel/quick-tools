@icon("res://addons/quicktools/thirdparty/kenney_board-game-icons/Vector/Icons/arrow_right_curve.svg")
extends Node
class_name State ## A state to be used in the StateMachine.


signal _attempt_transition(from: State, to: StringName)

func _enter_state() -> void: ## Called when the StateMachine transitions into the state.
	pass

func _exit_state() -> void: ## Called when the StateMachine transitionns out of the state.
	pass

func _update_state(_delta: float) -> void: ## Replaces '_process' for the state.
	pass

func _physics_update_state(_delta: float) -> void: ## Replaces '_physics_process' for the state.
	pass

func change_state(to: StringName): ## Call this to attempt to change the state.
	_attempt_transition.emit(self, to)
