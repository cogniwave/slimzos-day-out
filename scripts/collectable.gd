extends Area2D

const CollectionTypeEnum = preload("res://scripts/utils/CollectionType.gd")

@onready var sprite = $AnimatedSprite2D
@onready var player = %player

var types = CollectionTypeEnum.CollectableType.keys()

@export var collectable_type: CollectionTypeEnum.CollectableType

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play(types[collectable_type])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_pickup(body: Player):
	player.on_pickup(types[collectable_type])
	queue_free()
