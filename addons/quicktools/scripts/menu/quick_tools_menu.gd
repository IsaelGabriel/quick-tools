@tool
extends Control

@export var show_camera_toggle: CheckBox

func _on_ready() -> void:
	show_camera_toggle.toggle_mode = QuickTools.show_camera_tester_ui

func _on_show_camera_tester_check_box_toggled(toggled_on: bool) -> void:
	QuickTools.show_camera_tester_ui = toggled_on
