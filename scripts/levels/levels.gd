extends Node

const ROOT_PATH = "res://levels/"

func _on_body_entered(body):
	if not body.is_in_group("Player"): 
		return
	
	var tree = get_tree()
	tree.change_scene_to_file(ROOT_PATH + "level_" + str(tree.current_scene.scene_file_path.to_int() + 1) + ".tscn")
