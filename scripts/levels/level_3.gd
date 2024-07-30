extends Node2D

@onready var dialogue_box = %DialogueBox
@onready var camera = $player/camera
@onready var player = $player
@onready var damage_timer = $DamageTimer
@onready var audio_player = $AudioStreamPlayer

var shown_tutorial := false
var timer_cycles := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_box.custom_effects[0].char_displayed.connect(_on_char_displayed)
	dialogue_box.start()
	player.health_bar.value = PlayerState.health
	player.health_pots.update(PlayerState.pots)
	PlayerState.reset()
	player.show_ui()
	
func entered_sunlight(body):
	if not body.is_in_group("Player"):
		return 
	
	player.take_damage(10, "sunlight")	
	timer_cycles = 1
	damage_timer.start()

func left_sunlight(body):
	if body.is_in_group("Player"):
		damage_timer.stop()
		
func _damage_player(): 
	player.take_damage(5 * timer_cycles, "sunlight")
	timer_cycles += 1
	
	if player.dead:
		damage_timer.stop()

func _start_dialog(dialog_path: String):
	dialogue_box.data = load(dialog_path)
	dialogue_box.set_position(Vector2i(player.position.x - 328, player.position.y - 176))
	dialogue_box.start()

func _on_health_pickup(_amount):
	if shown_tutorial == false:
		_start_dialog("res://dialogues/level_3_health.tres")
		shown_tutorial = true
		PlayerState.add_upgrade("pots", {})
		
func on_player_reset(): 
	player.position = Vector2i(-124, -79)

func _on_char_displayed(_idx):
	audio_player.play()

