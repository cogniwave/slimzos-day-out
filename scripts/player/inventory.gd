extends Node2D

const CollectionTypeEnum = preload("res://scripts/collectables/CollectionType.gd")

@onready var collectable = $collectable
@onready var label = $Label

var types = CollectionTypeEnum.CollectableType.keys()

var collectable_type: CollectionTypeEnum.CollectableType

# Called when the node enters the scene tree for the first time.
func _ready():
	collectable.collectable_type = collectable_type
	
func update_inventory(_item):
	label.text = str(int(label.text) + 1)
