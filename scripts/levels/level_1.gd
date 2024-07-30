extends Node2D

@onready var dialogue_box = %DialogueBox

@onready var audio_player = $AudioStreamPlayer2D

func _ready():
	dialogue_box.custom_effects[0].char_displayed.connect(_on_char_displayed)
	dialogue_box.start()

func _on_char_displayed(_idx):
	audio_player.play()
