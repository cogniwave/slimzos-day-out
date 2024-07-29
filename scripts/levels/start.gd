extends Node2D

func _ready():
	get_viewport().size = Vector2i(1920, 1080)
	

func start_game():
	get_tree().change_scene_to_file("res://levels/level_1.tscn")
	
func credits():
	get_tree().change_scene_to_file("res://levels/credits.tscn")

func exit():
	get_tree().quit()
