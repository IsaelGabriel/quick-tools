extends Node

@export var fade_toggle: CheckButton
@export var strength_text: LineEdit
@export var duration_text: LineEdit

func _on_start_shake_button_pressed() -> void:
	var strength: float = 30.0
	var duration: float = 1.0
	if strength_text.text.is_valid_float() and not strength_text.text.is_empty():
		strength = strength_text.text.to_float()
	else:
		strength_text.text = ''
		
	if duration_text.text.is_valid_float() and not duration_text.text.is_empty():
		duration = duration_text.text.to_float()
	else:
		duration_text.text = ''
	
	QuickCamera2D.main_camera_start_shake(strength, duration, fade_toggle.toggle_mode)
