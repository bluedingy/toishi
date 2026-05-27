class_name InputBuffer
extends RefCounted

## Stores recent inputs with timestamps so they can be consumed by the state machine
## even if the player pressed the button a few frames early (input buffering).

const BUFFER_WINDOW: int = 10  # frames an input stays buffered

enum Action {
	MOVE_LEFT,
	MOVE_RIGHT,
	MOVE_UP,
	MOVE_DOWN,
	JUMP,
	JUMP_HOLD,
	DASH,
	DASH_HOLD,
	ATTACK,
	ATTACK_HOLD,
	SPECIAL,
	SPECIAL_HOLD,
	BLOCK,
	BLOCK_HOLD,
}

# Each entry: { action: Action, frames_remaining: int }
var _buffer: Array[Dictionary] = []

# Raw held state this frame (not buffered, just current)
var held: Dictionary = {}


func _init() -> void:
	for action in Action.values():
		held[action] = 0.0


## Call once per physics frame with the current raw input state.
func update(raw_held: Dictionary) -> void:
	held = raw_held

	# Tick down existing buffered inputs
	var i := _buffer.size() - 1
	while i >= 0:
		_buffer[i].frames_remaining -= 1
		if _buffer[i].frames_remaining <= 0:
			_buffer.remove_at(i)
		i -= 1
		#print(_buffer)

	# Register newly pressed inputs (rising edge)
	for action in raw_held:
		if raw_held[action] and not _was_held_last_frame(action):
			_push(action, raw_held.get(action))

	_prev_held = raw_held.duplicate()


## Returns true and consumes the buffered input if it exists.
func consume(action: Action) -> bool:
	for i in range(_buffer.size()):
		if _buffer[i].action == action:
			_buffer.remove_at(i)
			return true
	return false


## Returns true if the action is currently held (not buffered).
func is_held(action: Action) -> float:
	return held.get(action, 0.0)

## Returns true if both actions are held simultaneously.
func is_held_combo(action_a: Action, action_b: Action) -> bool:
	return is_held(action_a) and is_held(action_b)


func _push(action: Action, strength) -> void:
	# Avoid duplicates — refresh the window instead
	for entry in _buffer:
		if entry.action == action:
			entry.frames_remaining = BUFFER_WINDOW
			return
	_buffer.append({ "action": action, "strength":strength, "frames_remaining": BUFFER_WINDOW })


var _prev_held: Dictionary = {}

func _was_held_last_frame(action: Action) -> bool:
	return _prev_held.get(action, 0.0)
