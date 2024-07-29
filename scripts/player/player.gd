extends CharacterBody2D

const CollectionTypeEnum = preload("res://scripts/collectables/CollectionType.gd")
const SPEED = 200.0
const JUMP_VELOCITY = -400.0

const DAMAGE_IMMUNITY_MAPPER := {
	"sunlight": "water",
	"lava": "fire",
}

@onready var health_bar = $HealthBar
@onready var health_pots = $HealthPots
@onready var sprite_node = $Node2D
@onready var powerup_timer = $PowerupTimer
@onready var cooldown_water = $CooldownWater
@onready var cooldown_fire = $CooldownFire

signal die()
signal on_pickup_item(item: String)
signal on_reset()

var types = CollectionTypeEnum.CollectableType.keys()
var animation_node: AnimatedSprite2D

var _can_move := false
var dead := false
var tile_ref: TileMap

func _ready(): 
	animation_node = sprite_node.get_node("AnimatedSprite2D")
	animation_node.connect("animation_finished", _on_animation_end)
	 
func _physics_process(_delta):
	_handle_movement()
		
	if Input.is_action_just_pressed("action_1"): 
		_change_to_water()
		
	if Input.is_action_just_pressed("action_2"): 
		_change_to_fire()
	
	if Input.is_action_just_pressed("heal"): 
		_heal(10)
	
func _animation(animation: String):
	animation_node.play(PlayerState.current_form + "_" + animation)

func _handle_movement():
	if _can_move == false or dead:
		# make sure we're displaying the idle animation
		_animation("idle")
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
	if PlayerState.cooldowns.has("water") or "water" not in PlayerState.upgrades:
		return
	
	powerup_timer.wait_time = PlayerState.activate_upgrade("water")
	powerup_timer.start()

	_update_form("water")
	
func _change_to_fire():
	if PlayerState.cooldowns.has("fire") or "fire" not in PlayerState.upgrades:
		return
	
	powerup_timer.wait_time = PlayerState.activate_upgrade("fire")
	powerup_timer.start()

	_update_form("fire")

func _update_form(form): 
	PlayerState.current_form = form
	_animation(animation_node.animation.split("_")[-1])

func on_pickup(type: String, item: Dictionary):
	on_pickup_item.emit(item)

	# add upgrade if user doesn't have it yet	
	PlayerState.add_upgrade(type, item)
	
	if type == "water": 
		cooldown_water.visible = true
	
	if type == "fire": 
		cooldown_fire.visible = true
		
	if type == "pots": 
		health_pots.visible = true

func _on_dialogue_box_dialogue_started(_id):
	_can_move = false
	velocity = Vector2(0, 0)

func _on_dialogue_box_dialogue_ended():
	_can_move = true

func take_damage(damage: int, damage_type := ""):
	if _is_immune(damage_type):
		return
	
	health_bar.value = PlayerState.take_damage(damage)
	await _animation("take_damage")
	_animation("idle")
	
	if PlayerState.health <= 0:
		dead = true
		_animation("die")
	
func show_ui(): 
	health_bar.visible = true
	
	if "water" in PlayerState.upgrades: 
		cooldown_water.visible = true
		
	if "pots" in PlayerState.upgrades: 
		health_pots.visible = true

func _is_immune(damage_type := ""):
	if not damage_type: 
		return false
	
	return DAMAGE_IMMUNITY_MAPPER[damage_type] == PlayerState.current_form

func _on_powerup_end():
	if PlayerState.current_form == "water": 
		cooldown_water.start_cooldown()
		
	if PlayerState.current_form == "fire": 
		cooldown_fire.start_cooldown()
		
	_update_form("default")
	

func _on_cooldown_end(upgrade: String):
	PlayerState.reset_cooldown(upgrade)

# only dead animation doesn't repeat 
func _on_animation_end():
	dead = false
	PlayerState.health = 100
	health_bar.value = 100
	on_reset.emit()

func _heal(amount: int): 
	if PlayerState.health == 100:
		return 

	health_bar.value = PlayerState.use_pot(amount)
	health_pots.update(PlayerState.pots)

func _on_pickup_health(amount: int):
	# if user not at 100%, health up
	if PlayerState.health < 100:
		health_bar.value = PlayerState.heal(amount)
		return
		
	# if not, add to inventory
	PlayerState.add_pot()
	health_pots.update(PlayerState.pots)
