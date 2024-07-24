extends Node

@export var health: int = 100
@export var pots: int = 0

@export var current_form: String = "default"

@export var upgrades: Dictionary = {
	"default": { 
		"cooldown": 0,
		"duration": 0
	} 
}

@export var cooldowns: Array[String] = []

func _ready(): 
	clamp(health, 0, 100)

func heal(amount: int) -> int:
	health += amount
	return health
	
func take_damage(amount) -> int: 
	health -= amount
	return health
	
func update_form(form: String):
	current_form = form

func add_upgrade(type: String, upgrade: Dictionary):
	if not upgrades.has(type):
		upgrades[type] = upgrade

func add_pot():
	pots += 1
	
func use_pot(amount: int):
	if pots == 0:
		return
	
	heal(amount)
	pots -= 1

func activate_upgrade(upgrade: String) -> int: 
	if upgrade not in upgrades: 
		return 0
	
	cooldowns.append(upgrade)
	update_form(upgrade)
	return upgrades[upgrade].duration
	
func reset_cooldown(upgrade: String): 
	cooldowns.erase(upgrade)

# temporary, to be removed when player becomes singleton
func reset():
	cooldowns = []
	update_form("default")
