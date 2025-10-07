extends Camera2D
class_name QuickCamera2D ## Custom 2D Camera with added functionality

static var main_camera: QuickCamera2D

#region TESTER_VARIABLES
@export_category("Testing")
@export var camera_test_ui: bool = false
@onready var _camera_tester_prefab: PackedScene = preload("res://addons/quicktools/scenes/camera_tester.tscn")
#endregion


#region SHAKE_VARIABLES
var _shake_timer: Timer
var _shaking: bool = false
var _shake_fade: bool = false
var _shake_strength: float = 0.0
var _shake_duration: float

#endregion

func _ready() -> void:
	if get_viewport().get_camera_2d() == self:
		main_camera = self
	if camera_test_ui:
		var tester = _camera_tester_prefab.instantiate()
		get_tree().current_scene.add_child.call_deferred(tester)
	
	_shake_ready()

func _process(_delta: float) -> void:
	_process_shake()

func _exit_tree() -> void:
	if get_viewport().get_camera_2d() == self:
		main_camera = null

#region SHAKE
func _shake_ready() -> void:
	_shake_timer = Timer.new()
	_shake_timer.autostart = false
	_shake_timer.timeout.connect(_on_shake_timer_timeout)

func start_shake(strength: float = 30.0, duration: float = 1.0, fade: bool = false) -> void:
	randomize()
	_shaking = true
	_shake_strength = strength
	_shake_fade = fade
	_shake_duration = duration

static func main_camera_start_shake(strength: float = 30.0, duration: float = 1.0, fade: bool = false) -> void:
	if not main_camera:
		return
	main_camera.start_shake(strength, duration, fade)

func _process_shake() -> void:
	if not _shaking: return
	if _shake_fade:
		_shake_strength = lerpf(_shake_strength, 0.0, 1.0 - (_shake_timer.time_left / _shake_duration))
	
	offset = _random_shake_offset()

func _on_shake_timer_timeout() -> void:
	_shaking = false
	offset = Vector2.ZERO

func _random_shake_offset() -> Vector2:
	return Vector2(randf_range(-_shake_strength, _shake_strength), \
					randf_range(-_shake_strength, _shake_strength))
#endregion
