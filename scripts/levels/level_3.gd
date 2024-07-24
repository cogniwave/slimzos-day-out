extends Node2D

@onready var dialogue_box = %DialogueBox
@onready var camera = $player/camera
@onready var player = $player
@onready var damage_timer = $DamageTimer

var shown_tutorial := false
var timer_cycles := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_box.start()
	player.health_bar.value = PlayerState.health
	PlayerState.reset()
	
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
	dialogue_box.set_position(Vector2i(player.position.x - 320, player.position.y - 170))
	dialogue_box.start()

func _on_health_pickup(_amount):
	if shown_tutorial == false:
		_start_dialog("res://dialogues/level_3_health.tres")
		shown_tutorial = true
		
