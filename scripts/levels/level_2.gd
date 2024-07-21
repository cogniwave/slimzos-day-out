extends Node2D

@onready var collectable = $environment/collectable
@onready var dialogue_box = %DialogueBox
@onready var camera = $player/camera
@onready var player = $player
@onready var damage_timer = $timers/DamageTimer

var dialogue_shown := false

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_box.start()
	
func entered_sunlight(body):
	if not body.is_in_group("Player"):
		return 
	
	if not dialogue_shown:
		_start_dialog("res://dialogues/level_2_sun.tres")
		
		collectable.visible = true
		player.position.y = player.position.y - 10

		dialogue_shown = true
		player.show_ui()
		
	player.take_damage(10, "sunlight")	
	damage_timer.start()

func left_sunlight(body):
	if body.is_in_group("Player"):
		damage_timer.stop()
		
func _damage_player(): 
	player.take_damage(20, "sunlight")
	
	if player.dead:
		damage_timer.stop()

func collect_powerup():
	if collectable.visible:
		player.cooldown_water.visible = true
		_start_dialog("res://dialogues/level_2_powerups.tres")
	
func _start_dialog(dialog_path: String):
	dialogue_box.data = load(dialog_path)
	dialogue_box.set_position(Vector2i(player.position.x - 320, player.position.y - 170))
	dialogue_box.start()

