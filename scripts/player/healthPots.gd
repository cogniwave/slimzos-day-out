extends AnimatedSprite2D

@onready var label = $Label

func update(number: int): 
	label.text = str(number)
	
	if not visible: 
		visible = true
