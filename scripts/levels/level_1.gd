extends Node2D

@onready var dialogue_box = %DialogueBox

func _ready():
	dialogue_box.start()
