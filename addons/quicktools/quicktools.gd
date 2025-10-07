@tool
extends EditorPlugin
class_name QuickTools

const CONFIG_PATH = "user://quick_tools.cfg"

static var show_camera_tester_ui: bool :
	set(value):
		config.set_value("camera", "show_camera_tester_ui", value)
		config.save(CONFIG_PATH)
	get:
		return config.get_value("camera", "show_camera_tester_ui", false)

var plugin_menu: Control
static var config: ConfigFile :
	get:
		if not config:
			config = ConfigFile.new()
			config.load(CONFIG_PATH)
		return config

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	plugin_menu = preload("res://addons/quicktools/scenes/quick_tools_menu.tscn").instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR, plugin_menu)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	if plugin_menu:
		remove_control_from_docks(plugin_menu)
		plugin_menu.free()
