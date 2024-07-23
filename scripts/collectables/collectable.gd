extends Area2D

class_name Collectable

const CollectionTypeEnum = preload("res://scripts/collectables/CollectionType.gd")

@onready var sprite = $AnimatedSprite2D
@onready var player = %player

@export var collectable_type: CollectionTypeEnum.CollectableType
@export var cooldown: int
@export var duration: int

var type: String 

# Called when the node enters the scene tree for the first time.
func _ready():
	type = CollectionTypeEnum.CollectableType.keys()[collectable_type]
	sprite.play(type)

func _on_player_pickup(body):
	if body.is_in_group("Player") and visible: 
		player.on_pickup(type, { "cooldown": cooldown, "duration": duration })
		queue_free()
