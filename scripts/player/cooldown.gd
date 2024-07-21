extends Node2D

const CollectionTypeEnum = preload("res://scripts/collectables/CollectionType.gd")

signal cooldown_end(powerup: String)

@export var cooldown: int
@export var type: CollectionTypeEnum.CollectableType

@onready var label = $Label
@onready var cooldown_timer = $CooldownTimer
@onready var countdown_timer = $CountdownTimer
@onready var collectable = $collectable

func _ready():
	cooldown_timer.wait_time = cooldown
	collectable.type = CollectionTypeEnum.CollectableType.keys()[type]
	
func start_cooldown():
	collectable.visible = false
	label.text = str(cooldown)
	label.visible = true
	countdown_timer.start()
	cooldown_timer.start()

func on_countdown():
	label.text = str(str_to_var(label.text) - 1)
	
func on_cooldown_end():
	collectable.visible = true	
	label.visible = false
	cooldown_end.emit(collectable.type)
	countdown_timer.stop()
	cooldown_timer.stop()
