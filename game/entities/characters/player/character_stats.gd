class_name CharacterStats
extends Resource

## All numeric parameters that define a character's behavior.
## Upgrades modify a CharacterStats instance rather than hardcoding values
## throughout the codebase. Keep defaults balanced for the base character.

# ── Movement ────────────────────────────────────────────────────────────────
@export var walk_speed: float         = 220.0   # px/s
@export var dash_speed: float         = 420.0   # px/s
@export var dash_duration: int        = 14      # frames
@export var dash_cooldown: int        = 22      # frames between dashes
@export var air_speed: float          = 190.0   # horizontal air drift speed
@export var air_acceleration: float   = 1400.0  # how quickly air speed is reached
@export var jump_velocity: float      = -620.0  # negative = upward in Godot
@export var double_jump_velocity: float = -520.0
@export var gravity: float            = 1800.0  # px/s²
@export var fall_gravity_multiplier: float = 1.45  # extra gravity when falling
@export var max_fall_speed: float     = 900.0
@export var coyote_frames: int        = 6       # frames after walking off edge to still jump

# ── Health ───────────────────────────────────────────────────────────────────
@export var max_health: float         = 100.0

# ── Poise ────────────────────────────────────────────────────────────────────
# Poise breaks when poise_current reaches 0.
# After each break, max_poise decreases and knockback_multiplier increases.
@export var max_poise: float          = 60.0
@export var poise_regen_per_second: float = 8.0   # slow passive regen
@export var poise_regen_delay: int    = 90         # frames after hit before regen starts
@export var poise_break_stages: int   = 3          # total tiers before fully staggered
@export var poise_stage_reduction: float = 0.30    # each break reduces max poise by 30%
@export var knockback_multiplier: float = 1.0      # increased each poise break

# ── Hitstun / Knockback ───────────────────────────────────────────────────────
@export var base_hitstun_frames: int  = 12
@export var knockback_decay: float    = 700.0  # px/s² deceleration of knockback velocity

# ── Punch ────────────────────────────────────────────────────────────────────
@export var punch_damage: float       = 8.0
@export var punch_poise_damage: float = 12.0
@export var punch_hitstun: int        = 14
@export var punch_knockback: float    = 280.0
@export var punch_startup: int        = 5    # frames before hitbox is active
@export var punch_active: int         = 4    # frames hitbox is active
@export var punch_recovery: int       = 10   # frames after active before next action

# ── Charged Punch ────────────────────────────────────────────────────────────
@export var charged_punch_min_charge: int   = 20   # frames to reach minimum charge
@export var charged_punch_max_charge: int   = 50   # frames for full charge
@export var charged_punch_damage_min: float = 14.0
@export var charged_punch_damage_max: float = 26.0
@export var charged_punch_poise_damage_min: float = 18.0
@export var charged_punch_poise_damage_max: float = 35.0
@export var charged_punch_knockback_min: float = 380.0
@export var charged_punch_knockback_max: float = 680.0
@export var charged_punch_startup: int  = 6
@export var charged_punch_active: int   = 6
@export var charged_punch_recovery: int = 18

# ── Rocket Fist ──────────────────────────────────────────────────────────────
@export var rocket_damage: float       = 12.0
@export var rocket_poise_damage: float = 16.0
@export var rocket_speed: float        = 500.0
@export var rocket_hitstun: int        = 18
@export var rocket_knockback: float    = 360.0
@export var rocket_startup: int        = 8
@export var rocket_recovery: int       = 24    # long — punishable if blocked/dodged
@export var rocket_cooldown: int       = 45    # frames between rockets

# ── Charged Rocket Fist ───────────────────────────────────────────────────────
@export var charged_rocket_min_charge: int    = 25
@export var charged_rocket_max_charge: int    = 60
@export var charged_rocket_damage_min: float  = 18.0
@export var charged_rocket_damage_max: float  = 32.0
@export var charged_rocket_speed_min: float   = 620.0
@export var charged_rocket_speed_max: float   = 950.0
@export var charged_rocket_knockback_min: float = 480.0
@export var charged_rocket_knockback_max: float = 820.0
@export var charged_rocket_startup: int  = 10
@export var charged_rocket_recovery: int = 30

# ── Block / Parry / Slip ──────────────────────────────────────────────────────
@export var parry_window: int          = 8    # frames after block starts that count as parry
@export var parry_stun_on_attacker: int = 30  # frames attacker is stunned on successful parry
@export var block_damage_reduction: float = 0.85  # 85% damage blocked
@export var block_poise_reduction: float  = 0.50  # 50% poise damage blocked
@export var slip_window: int           = 12   # frames after block+down registers a slip


## Returns a deep copy so upgrades don't mutate the base resource.
func duplicate_stats() -> CharacterStats:
	var copy := CharacterStats.new()
	for prop in get_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			copy.set(prop.name, get(prop.name))
	return copy
