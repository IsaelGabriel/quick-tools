extends Node

@export var fade_toggle: CheckButton

func _on_start_shake_button_pressed() -> void:
	QuickCamera2D.main_camera_start_shake(30, 1.0, fade_toggle.toggle_mode)
