extends Node2D

@export var speed: float = 30

func _process(delta: float) -> void:
	var movement = Input.get_vector("p_left", "p_right", "p_up", "p_down")
	
	position = lerp(position, position + movement * speed, delta)
