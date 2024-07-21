extends Area2D

@onready var colider = $CollisionShape2D

@export var width : int = 20
@export var height : int = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	
	colider.shape.size = Vector2(width, height)
