class_name BotController
extends CharacterBody3D

## Root character controller for the robot boxer.
## Owns the state machine, input reader, poise system, and stats.
## Exposes public state flags read by states and the hurtbox receiver.

# ── Configuration ─────────────────────────────────────────────────────────────

# ── Runtime Stats (modified by upgrades) ─────────────────────────────────────

# ── Subsystems ────────────────────────────────────────────────────────────────

var health_component: HealthComponent

# ── Public State Flags (read by states and hurtbox) ─────a ─────────────────────-
var look_dir: Vector3 = Vector3(1,0,0)
var damage: float = 55.0
var speed: float = 100

# ── Signals ──────────────────────────────────────────────────────────────────


func _ready() -> void:

	health_component = $HealthComponent

	# State machine


#func _physics_process(delta: float) -> void:
		
	# Update state machine

	# Apply movement



# ── State Registration ────────────────────────────────────────────────────────

# ── Public API ────────────────────────────────────────────────────────────────


## Reset to base state for a new round (keeps upgrades, resets health/poise).
#func reset_for_round() -> void:
	



		
