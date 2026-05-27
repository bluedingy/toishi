class_name Hitbox
extends Area3D

## Attached to attack animations. Activated by combat states during
## the "active" frames of an attack. Carries all hit data.

@export var damage: float         = 10.0
@export var poise_damage: float   = 15.0
@export var knockback: float      = 300.0
@export var knockback_angle: float = 40.0  # degrees above horizontal
@export var hitstun: int          = 14

## Set by the state that fires this hitbox.
var owner_character: CharacterBody3D = null


var frames_to_wait = 100
var frames_elapsed = 0

func _ready():
	print("Attacking for  %d damage" % [damage])

func _physics_process(delta):
	frames_elapsed += 1
	if frames_elapsed >= frames_to_wait:
		queue_free()

func apply_strategy_patterns():
	damage = 100

func set_active(active: bool) -> void:
	monitoring = active
	visible = active  # toggle debug shape visibility; hook to animator in production
