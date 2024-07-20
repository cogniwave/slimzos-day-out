extends Node2D

const CollectionTypeEnum = preload("res://scripts/utils/CollectionType.gd")

@onready var player = %player
@onready var collectable = $collectable
@onready var label = $Label

var types = CollectionTypeEnum.CollectableType.keys()

var collectable_type: CollectionTypeEnum.CollectableType

# Called when the node enters the scene tree for the first time.
func _ready():
	collectable.collectable_type = collectable_type
	
func update_inventory(item):
	print('inv', item)
	label.text = str(int(label.text) + 1)
