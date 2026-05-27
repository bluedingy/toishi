class_name RobotBoxer
extends CharacterBody3D

## Root character controller for the robot boxer.
## Owns the state machine, input reader, poise system, and stats.
## Exposes public state flags read by states and the hurtbox receiver.

# ── Configuration ─────────────────────────────────────────────────────────────
@export var player_index: int = 0
@export var base_stats: CharacterStats

# ── Runtime Stats (modified by upgrades) ─────────────────────────────────────
var stats: CharacterStats

# ── Subsystems ────────────────────────────────────────────────────────────────
var state_machine: CharacterStateMachine
var input_reader: LocalInputReader

# ── Public State Flags (read by states and hurtbox) ──────────────────────────
var facing: int = 1               # 1 = right, -1 = left
var health: float = 100.0
var is_blocking: bool = false
var is_in_parry_window: bool = false
var is_invincible: bool = false   # i-frames during slip

var jumps_remaining: int = 1
var dash_cooldown_remaining: int = 0
var rocket_cooldown_remaining: int = 0

# ── References ────────────────────────────────────────────────────────────────
var opponent: Node3D = null       # set by GameManager each round

# ── Signals ──────────────────────────────────────────────────────────────────
signal health_changed(new_health: float, max_health: float)
signal died()


func _ready() -> void:
	assert(base_stats != null, "RobotBoxer requires a CharacterStats resource.")

	# Deep copy so upgrades don't mutate the base resource
	stats = base_stats.duplicate_stats()
	health = stats.max_health

	# Input
	input_reader = LocalInputReader.new(player_index)

	# State machine
	state_machine = CharacterStateMachine.new(self, input_reader)
	_register_states()
	state_machine.start(&"IdleState")


func _physics_process(delta: float) -> void:
	input_reader.poll()

	# Tick cooldowns
	if dash_cooldown_remaining > 0:
		dash_cooldown_remaining -= 1
	if rocket_cooldown_remaining > 0:
		rocket_cooldown_remaining -= 1


	# Update state machine
	state_machine.update(delta)

	# Apply movement
	move_and_slide()



# ── State Registration ────────────────────────────────────────────────────────

func _register_states() -> void:
	state_machine.register_state(&"IdleState",          IdleState.new())
	state_machine.register_state(&"RunState",           RunState.new())
	state_machine.register_state(&"JumpState",          JumpState.new())
	state_machine.register_state(&"AirState",           AirState.new())
	state_machine.register_state(&"LandState",          LandState.new())
	state_machine.register_state(&"DashState",          DashState.new())
	state_machine.register_state(&"AttackState",         AttackState.new())
	#state_machine.register_state(&"AerialAttackState",   _make_aerial_punch())
	#state_machine.register_state(&"ChargedAttackState",  ChargedAttackState.new())
	#state_machine.register_state(&"AerialChargedAttackState", ChargedAttackState.new())
	#state_machine.register_state(&"RocketState",        RocketState.new())
	#state_machine.register_state(&"ChargedRocketState", ChargedRocketState.new())
	state_machine.register_state(&"BlockState",         BlockState.new())
	#state_machine.register_state(&"SlipState",          SlipState.new())
	#state_machine.register_state(&"HitstunState",       HitstunState.new())
	#state_machine.register_state(&"KnockbackState",     KnockbackState.new())
	#state_machine.register_state(&"ParryStunState",     ParryStunState.new())




# ── Public API ────────────────────────────────────────────────────────────────


## Reset to base state for a new round (keeps upgrades, resets health/poise).
func reset_for_round() -> void:
	health = stats.max_health
	velocity = Vector3.ZERO
	is_blocking = false
	is_in_parry_window = false
	is_invincible = false
	jumps_remaining = 1
	dash_cooldown_remaining = 0
	rocket_cooldown_remaining = 0
	state_machine.force_transition(&"IdleState")
	health_changed.emit(health, stats.max_health)


# ── Private Callbacks ─────────────────────────────────────────────────────────

func _on_hit_received(_hit_data) -> void:
	health_changed.emit(health, stats.max_health)
	if health <= 0.0:
		died.emit()
