extends CharacterBody2D

class_name Player
const CollectionTypeEnum = preload("res://scripts/utils/CollectionType.gd")
const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@onready var sprite_node = $Node2D
@onready var dialogue_box = $"../DialogueBox"

signal on_pickup_item(item: String)

var types = CollectionTypeEnum.CollectableType.keys()

# list of upgrades power got
var player_upgrades: Array[String] = ["default"]
var current_form := 0
var current_form_prefix := "default"
var can_move := true

func _ready(): 
	dialogue_box.connect("dialogue_ended", _on_dialog_end)


func _on_dialog_end(): 
	can_move = true

func _handle_movement(delta: float):
	if can_move == false:
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
		
	# player is standing still
	else: 
		velocity = input_vector

	move_and_slide()
	return input_vector
	
func _physics_process(delta):
	var user_vector = _handle_movement(delta)
	
	if Input.is_action_just_pressed("change_form"): 
		_update_current_form()
	
	
func _update_current_form(): 
	# at the end, restart from the beginning
	if current_form == player_upgrades.size() - 1:
		current_form = 0
	else:
		current_form += 1
		
	current_form_prefix = player_upgrades[current_form]
		
	sprite_node.get_node("AnimatedSprite2D").play(current_form_prefix + "_move")
	

func on_pickup(item: String):
	on_pickup_item.emit(item)

	# add upgrade if user doesn't have it yet	
	if not player_upgrades.has(item):
		player_upgrades.append(item)
		_update_current_form()
