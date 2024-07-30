extends Area2D

@export var amount := 10

@onready var animation_player = $AnimationPlayer

signal pickup_health(amount: int)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		pickup_health.emit(amount)
		animation_player.play("pickup")
