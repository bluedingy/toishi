class_name ProjectileController
extends CharacterBody3D

## Root character controller for the robot boxer.
## Owns the state machine, input reader, poise system, and stats.
## Exposes public state flags read by states and the hurtbox receiver.

# ── Configuration ─────────────────────────────────────────────────────────────
@export var source_player_index: int = 0
@export var base_stats: CharacterStats
@export var destination_player_reference: CharacterBody3D

# ── Runtime Stats (modified by upgrades) ─────────────────────────────────────
var stats: CharacterStats

# ── Subsystems ────────────────────────────────────────────────────────────────
var state_machine: ProjectileStateMachine

# ── Public State Flags (read by states and hurtbox) ──────────────────────────-
var look_dir: Vector3 = Vector3(1,0,0)
var damage: float = 55.0
var speed: float = 100
# ── Signals ──────────────────────────────────────────────────────────────────


func _ready() -> void:
	
	assert(base_stats != null, "RobotBoxer requires a CharacterStats resource.")

	# Deep copy so upgrades don't mutate the base resource
	stats = base_stats.duplicate_stats()

	# State machine
	state_machine = ProjectileStateMachine.new(self)
	_register_states()
	state_machine.start(&"FlyState")


func _physics_process(delta: float) -> void:
		
	# Update state machine
	state_machine.update(delta)

	# Apply movement
	move_and_slide()



# ── State Registration ────────────────────────────────────────────────────────

func _register_states() -> void:
	#state_machine.register_state(&"IdleState",         ProjectileIdleState.new())
	#state_machine.register_state(&"ShootState",          ProjectileAimingState.new())
	state_machine.register_state(&"FlyState",         ProjectileFlyingState.new())
	#state_machine.register_state(&"HitState",         ProjectileHittingState.new())
	#state_machine.register_state(&"ClashState",         ProjectileClashingState.new())
	state_machine.register_state(&"LandState",         ProjectileLandingState.new())
	#state_machine.register_state(&"IdleState",         ProjectileIdleState.new())
	state_machine.register_state(&"PickUpState",         ProjectilePickUpState.new())


# ── Public API ────────────────────────────────────────────────────────────────


## Reset to base state for a new round (keeps upgrades, resets health/poise).
func reset_for_round() -> void:
	velocity = Vector3.ZERO
	state_machine.force_transition(&"IdleState")
	



# ── Private Callbacks ─────────────────────────────────────────────────────────


		
