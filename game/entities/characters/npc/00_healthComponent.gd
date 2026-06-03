class_name HealthComponent
extends Node

signal health_changed(current_health: float)
signal health_depleted

var max_health: float = 100
var current_health: float = 100

func _ready() -> void:
	print("Ready...")
	
func initialize(init_max_health: float, init_health: float):
	print("Initializing Health Component")
	max_health = init_max_health
	current_health = init_health
	
func heal(amount: float):
	print("Healing")

func damage(amount: float) -> void:
	if current_health <= 0:
		return
		
	current_health = clamp(current_health - amount, 0, max_health)
	health_changed.emit(current_health)
	print(current_health)
	
	if current_health <= 0:
		health_depleted.emit()
