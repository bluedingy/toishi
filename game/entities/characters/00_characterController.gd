class_name CharacterController
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
var health_component: HealthComponent
var state_machine: PlayerStateMachine
var movement_machine: PlayerStateMachine

# ── Public State Flags (read by states and hurtbox) ──────────────────────────
var facing: int = 1               # 1 = right, -1 = left
var look_dir: Vector3 = Vector3(1,0,0)
var is_blocking: bool = false
var is_in_parry_window: bool = false
var is_invincible: bool = false   # i-frames during slip

var lives = 3
var jumps_remaining: int = 2
var max_hand_size = 10
var current_hand_size = 10
var dash_cooldown_remaining: int = 0


# ── References ────────────────────────────────────────────────────────────────
var opponent: Node3D = null       # set by GameManager each round

# ── Signals ──────────────────────────────────────────────────────────────────
signal health_changed(new_health: float, max_health: float)
signal died()


func _ready() -> void:
	
	add_to_group("Entities")
	assert(base_stats != null, "PlayerController requires a CharacterStats resource.")

	# Deep copy so upgrades don't mutate the base resource
	stats = base_stats.duplicate_stats()
	
	health_component = $HealthComponent
	health_component.initialize(stats.max_health*5, stats.max_health)
	health_component.health_depleted.connect(_on_health_component_died)

	# Input

	# State machine
	_register_states()


func _physics_process(delta: float) -> void:
	
	# Update state machine
	state_machine.update(delta)
	movement_machine.update(delta)

	# Apply movement
	move_and_slide()



# ── State Registration ────────────────────────────────────────────────────────

func _register_states() -> void:
	print("I need states")


# ── Public API ────────────────────────────────────────────────────────────────


## Reset to base state for a new round (keeps upgrades, resets health/poise).
func reset_for_round() -> void:
	velocity = Vector3.ZERO
	

# ── Private Callbacks ─────────────────────────────────────────────────────────

func _on_hit_received(_hit_data) -> void:
		died.emit()
	

func _on_health_component_died():
	print("The parent received the death signal!")
	
	if lives <= 0:
		queue_free() # Removes the parent from the game
	else: 
		lives -= 1
		health_component.initialize(stats.max_health*5, stats.max_health)
		

		
