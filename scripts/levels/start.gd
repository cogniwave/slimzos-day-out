extends Node2D

func start_game():
	get_tree().change_scene_to_file("res://levels/level_1.tscn")
	
func credits():
	get_tree().change_scene_to_file("res://levels/credits.tscn")

func exit():
	get_tree().quit()
