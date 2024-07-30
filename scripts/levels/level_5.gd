extends Node2D

@onready var dialogue_box = %DialogueBox
@onready var player = $player
@onready var audio_player = $AudioStreamPlayer

var cinematic_move := false
var target_position := Vector2(964, 159)
var direction := global_position.direction_to(target_position)

func _ready():
	dialogue_box.custom_effects[0].char_displayed.connect(_on_char_displayed)	
	player._can_move = true
	
func _physics_process(_delta):
	if not cinematic_move:
		return 

	if player.position.distance_to(target_position) > 3:
		player.velocity = (target_position - player.position) * 3
		player.move_and_slide()
		dialogue_box.set_position(Vector2i(player.position.x - 329, player.position.y - 176))
	else: 
		cinematic_move = false

func on_reach_endzone(_body):
	cinematic_move = true
	
	dialogue_box.set_position(Vector2i(player.position.x - 329, player.position.y - 176))
	dialogue_box.start()

func on_dialog_end():
	get_tree().change_scene_to_file("res://levels/end.tscn")

func _on_char_displayed(idx):
	audio_player.play()
