extends Node

@export var fade_toggle: CheckButton
@export var strength_text: LineEdit

func _on_start_shake_button_pressed() -> void:
	var strength: float = 30.0
	if strength_text.text.is_valid_float() and not strength_text.text.is_empty():
		strength = strength_text.text.to_float()
	else:
		strength_text.text = ''
	
	QuickCamera2D.main_camera_start_shake(strength, 1.0, fade_toggle.toggle_mode)
