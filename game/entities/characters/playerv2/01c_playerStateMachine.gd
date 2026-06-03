class_name PlayerStateMachine
extends Node

## Hierarchical state machine for the character controller.
## States are registered by name and transitions are driven by
## each state's physics_update return value.

signal state_changed(from: StringName, to: StringName)

var _states: Dictionary = {}
var _current_state: PlayerState = null
var _current_state_name: StringName = &""

var character: CharacterBody3D
var input: InputReaderInterface


func _init(p_character: CharacterBody3D, p_input: InputReaderInterface) -> void:
	character = p_character
	input = p_input


## Register all states before calling start().
func register_state(state_name: StringName, state: PlayerState) -> void:
	state.setup(character, input)
	_states[state_name] = state


## Enter the initial state.
func start(initial_state: StringName) -> void:
	_transition_to(initial_state, null)


## Call every physics frame from the character's _physics_process.
func update(delta: float) -> void:
	if _current_state == null:
		return
	var next := _current_state.physics_update(delta)
	if next != &"":
		_transition_to(next, _current_state)


func get_current_state_name() -> StringName:
	return _current_state_name


func get_current_state() -> PlayerState:
	return _current_state


## Force a transition from outside the state machine (e.g., on hit).
func force_transition(state_name: StringName) -> void:
	_transition_to(state_name, _current_state)


func _transition_to(state_name: StringName, prev: PlayerState) -> void:
	if not _states.has(state_name):
		push_error("PlayerStateMachine: unknown state '%s'" % state_name)
		return

	if _current_state != null:
		_current_state.exit()

	var from_name := _current_state_name
	_current_state = _states[state_name]
	_current_state_name = state_name
	_current_state.enter(prev)

	state_changed.emit(from_name, state_name)
