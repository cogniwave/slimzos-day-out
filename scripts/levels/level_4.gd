extends Node2D

@onready var dialogue_box = %DialogueBox
@onready var camera = $player/camera
@onready var player = $player
@onready var damage_timer = $DamageTimer
@onready var shadows = $shadows
@onready var platforms = $platforms
@onready var tile_map = $environment/TileMap
@onready var pots = $pots
@onready var lava_dialog_trigger = $lavaDialogTrigger
@onready var audio_player = $AudioStreamPlayer

enum FloorTypes {
	lava, 
	ground,
	platform, 
	shade
}

var shown_tutorial := false
var timer_cycles := 1
var current_floor: FloorTypes = FloorTypes.ground

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_box.custom_effects[0].char_displayed.connect(_on_char_displayed)
	dialogue_box.start()
	player.health_bar.value = PlayerState.health
	player.health_pots.update(PlayerState.pots)
	PlayerState.reset()
	PlayerState.reset()
	player.show_ui()
	player.position = Vector2i(152, 43) 
	
	for shadow in $shadows.get_children():
		shadow.connect("body_entered", leave_sunlight)
		shadow.connect("body_exited", enter_sunlight)
	
	for platform in $platforms.get_children():
		platform.connect("body_entered", enter_platform)
		platform.connect("body_exited", leave_platform)
	
	for pot in pots.get_children():
		pot.connect("pickup_health", player._on_pickup_health)
	
func enter_sunlight(body):
	if not body.is_in_group("Player"):
		return 
	
	damage_timer.start()
	timer_cycles = 1
	current_floor = FloorTypes.ground
	_damage_player()

func leave_sunlight(body):
	if body.is_in_group("Player"):
		current_floor = FloorTypes.shade
		damage_timer.stop()
		
func _damage_player():
	if current_floor in [FloorTypes.platform, FloorTypes.shade] or dialogue_box.visible  :
		return
		
	return
	if current_floor == FloorTypes.ground:
		player.take_damage(5 * timer_cycles, "sunlight")
	else: 
		player.take_damage(15 * timer_cycles, "lava")
		
	timer_cycles += 1
	
	if player.dead:
		damage_timer.stop()

func _start_dialog(dialog_path: String):
	dialogue_box.data = load(dialog_path)
	dialogue_box.set_position(Vector2i(player.position.x - 330, player.position.y - 176))
	dialogue_box.start()

func _on_fire_pot_pickup(type, upgrade_config):
	if shown_tutorial == true:
		return
		
	_start_dialog("res://dialogues/level_4_pot.tres")
	shown_tutorial = true
	PlayerState.add_upgrade(type, upgrade_config)

func on_player_reset():
	get_tree().reload_current_scene()
	damage_timer.stop()

func on_pass_lava_colider(body):
	if not body.is_in_group("Player"):
		return 
	
	if body.position.x > -2530 and body.position.x < -320: 
		current_floor = FloorTypes.lava
	else:
		current_floor = FloorTypes.ground

func enter_platform(body):
	if body.is_in_group("Player"):
		damage_timer.stop()
		current_floor = FloorTypes.platform
	
func leave_platform(body):
	if body.is_in_group("Player"): 
		damage_timer.start()
		timer_cycles = 1
		current_floor = FloorTypes.lava

func trigger_lava_dialog(body):
	if body.is_in_group("Player"):
		_start_dialog("res://dialogues/level_4_lava.tres")
		lava_dialog_trigger.queue_free()

func _on_char_displayed(_idx):
	audio_player.play()
