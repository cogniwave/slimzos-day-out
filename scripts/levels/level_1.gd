extends Node2D

@onready var dialogue_box = $DialogueBox

# Called when the node enters the scene tree for the first time.
func _ready():
	#get_viewport().size = DisplayServer.screen_get_size()
	get_viewport().size = Vector2i(1920, 1080)
	
	#dialogue_box.start()