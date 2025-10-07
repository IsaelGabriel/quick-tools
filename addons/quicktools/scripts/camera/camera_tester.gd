extends Node

@export_category("Shake")
@export var shake_fade_toggle: CheckButton
@export var shake_strength: SpinBox
@export var shake_duration: SpinBox

@export_category("Movement")
@export_subgroup("Follow")
@export var follow_target_selectable: OptionButton
@export var follow_speed: SpinBox
var targetable_nodes: Array[Node2D] = []

func _ready():
	_fetch_2d_nodes()

func _fetch_2d_nodes() -> void:
	if not get_tree():
		return
	targetable_nodes = []
	follow_target_selectable.clear()
	follow_target_selectable.add_item("< null >")
	
	var current_scene = get_tree().current_scene
	var nodes: Array[Node] = _get_nodes_in_scene(current_scene)
	for node in nodes:
		if node is Node2D:
			targetable_nodes.append(node)
			follow_target_selectable.add_item(current_scene.get_path_to(node))
	
	current_scene.child_entered_tree.connect(_fetch_2d_nodes)
	current_scene.child_exiting_tree.connect(_fetch_2d_nodes)
	current_scene.child_order_changed.connect(_fetch_2d_nodes)

func _get_nodes_in_scene(scene:Node) -> Array[Node]:
	var nodes: Array[Node] = []
	for child in scene.get_children():
		nodes.append(child)
		nodes.append_array(_get_nodes_in_scene(child))
	
	return nodes

func _on_start_shake_button_pressed() -> void:
	var strength: float = shake_strength.value
	var duration: float = shake_duration.value
	
	QuickCamera2D.main_camera_start_shake(strength, duration, shake_fade_toggle.toggle_mode)


func _on_follow_target_selected(index: int) -> void:
	if index == 0:
		QuickCamera2D.main_camera_stop_follow()
	else:
		QuickCamera2D.main_camera_start_follow(targetable_nodes.get(index - 1), follow_speed.value)
