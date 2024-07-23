extends CharacterBody2D

class_name Player

const CollectionTypeEnum = preload("res://scripts/collectables/CollectionType.gd")
const SPEED = 200.0
const JUMP_VELOCITY = -400.0

const DAMAGE_IMMUNITY_MAPPER := {
	"sunlight": "water",
	#dsadsa: "fire",
	#earth,
	#position,
	#pumpkin,
	#shroom_red,
}

@onready var health_bar = $HealthBar
@onready var inventory = %Inventory
@onready var sprite_node = $Node2D
@onready var dialogue_box = %DialogueBox
@onready var powerup_timer = $"../timers/PowerupTimer"
@onready var cooldown_water = $CooldownWater

signal die()
signal on_pickup_item(item: String)

var types = CollectionTypeEnum.CollectableType.keys()
var animation_node: AnimatedSprite2D

# list of upgrades power got
var _player_upgrades: Dictionary = {
	"default": { 
		"cooldown": 0,
		"duration": 0
	} 
}
var _current_form := "default"
var _can_move := false
var health := 100
var dead := false
var cooldowns := []

func _ready(): 
	animation_node = sprite_node.get_node("AnimatedSprite2D")
	animation_node.connect("animation_finished", _on_animation_end)
	
func _physics_process(_delta):
	_handle_movement()
	
	if Input.is_action_just_pressed("action_1"): 
		_change_to_water()
	
func _animation(animation: String):
	animation_node.play(_current_form + "_" + animation)

func _handle_movement():
	if _can_move == false or dead:
		return
	
	var input_right = Input.get_action_strength("move_right")
	var input_left = Input.get_action_strength("move_left")
	var input_vector = Vector2.ZERO
	
	# allows for 8 dimensional move
	input_vector.x =  input_right - input_left
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector:
		if input_right: 
			sprite_node.scale.x  = 1
		elif input_left: 
			sprite_node.scale.x = -1
		
		velocity = input_vector * SPEED
		_animation("move")
		
	# player is standing still
	else: 
		velocity = input_vector
		_animation("idle")

	move_and_slide()
	return input_vector
	
func _change_to_water():
	if cooldowns.has("water"):
		return

	powerup_timer.wait_time = _player_upgrades["water"].duration
	powerup_timer.start()
	cooldowns.append("water")

	_update_form("water")

func _update_form(form): 
	_current_form = form
	_animation(animation_node.animation.split("_")[-1])

func on_pickup(type: String, item: Dictionary):
	on_pickup_item.emit(item)

	# add upgrade if user doesn't have it yet	
	if _player_upgrades not in item:
		_player_upgrades[type] = item
		
	cooldown_water.visible = true

func _on_dialogue_box_dialogue_started(_id):
	_can_move = false
	velocity = Vector2(0, 0)

func _on_dialogue_box_dialogue_ended():
	_can_move = true

func take_damage(damage: int, damage_type := ""):
	if _is_immune(damage_type):
		return
	
	health -= damage
	health_bar.value = health
	await _animation("take_damage")
	_animation("idle")
	
	if health <= 0:
		dead = true
		_animation("die")
	
func show_ui(): 
	health_bar.visible = true
	#inventory.visible = true

func _is_immune(damage_type := ""):
	if not damage_type: 
		return false
	
	return DAMAGE_IMMUNITY_MAPPER[damage_type] == _current_form

func _on_powerup_end():
	_update_form("default")
	cooldown_water.start_cooldown()

func _on_cooldown_end(powerup: String):
	cooldowns.erase(powerup)

# only dead animation doesn't repeat 
func _on_animation_end():
	get_tree().reload_current_scene()
