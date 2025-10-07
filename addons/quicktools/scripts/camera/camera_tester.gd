extends Node

@export_category("Shake")
@export var fade_toggle: CheckButton
@export var strength_text: LineEdit
@export var duration_text: LineEdit

@export_category("Movement")
@export_subgroup("Follow")
@export var target_selectable: OptionButton
var targetable_nodes: Array[Node2D] = []

func _ready():
	_fetch_2d_nodes()

func _fetch_2d_nodes() -> void:
	var current_scene = get_tree().current_scene
	var nodes: Array[Node] = _get_nodes_in_scene(current_scene)
	for node in nodes:
		if node is Node2D:
			targetable_nodes.append(node)
			target_selectable.add_item(current_scene.get_path_to(node))

func _get_nodes_in_scene(scene:Node) -> Array[Node]:
	var nodes: Array[Node] = []
	for child in scene.get_children():
		nodes.append(child)
		nodes.append_array(_get_nodes_in_scene(child))
	
	return nodes

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
