## ─────────────────────────────────────────────────────────────────────────────
## BlockState
## ─────────────────────────────────────────────────────────────────────────────
class_name BlockState
extends CharacterState

func enter(prev: CharacterState) -> void:
	super(prev)
	set_vel_x(0.0)
	print("Blocking...")
	character.is_blocking = true


func physics_update(delta: float) -> StringName:
	super(delta)


	# Slip: block + down within the slip window
	if input.buffer.is_held_combo(InputBuffer.Action.BLOCK, InputBuffer.Action.MOVE_DOWN):
		if frame <= stats.slip_window:
			return &"SlipState"

	# Parry window: the first N frames of block are a parry window.
	# The character's is_in_parry_window flag is checked by HurtboxReceiver.
	character.is_in_parry_window = (frame <= stats.parry_window)

	if not input.buffer.is_held(InputBuffer.Action.BLOCK):
		character.is_blocking = false
		character.is_in_parry_window = false
		return &"IdleState"

	return &""


func exit() -> void:
	character.is_blocking = false
	print("Done Blocking.")
	character.is_in_parry_window = false
