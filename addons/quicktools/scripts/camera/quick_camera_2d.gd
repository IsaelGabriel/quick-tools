extends Camera2D
class_name QuickCamera2D ## Custom 2D Camera with added functionality

static var main_camera: QuickCamera2D

#region TESTER_VARIABLES
@export_category("Testing")
@onready var _camera_tester_prefab: PackedScene = preload("res://addons/quicktools/scenes/camera_tester.tscn")
#endregion


#region SHAKE_VARIABLES
var _shake_timer: Timer
var _shaking: bool = false
var _shake_fade: bool = false
var _shake_strength: float = 0.0
var _current_shake_strength: float = 0.0
var _shake_duration: float
#endregion

#region FOLLOW_VARIABLES
var _follow_target: Node2D
var _follow_speed: float = 1.0
var _following: bool = false
#endregion

#region ZOOM
var _zoom_target: float = 1.0
var _zoom_speed: float = 1.0
var _zooming: bool = false
#endregion

func _ready() -> void:
	if get_viewport().get_camera_2d() == self:
		main_camera = self
	if QuickTools.show_camera_tester_ui:
		var tester = _camera_tester_prefab.instantiate()
		get_tree().current_scene.add_child.call_deferred(tester)
	
	_shake_ready()

func _process(delta: float) -> void:
	_process_shake()
	_process_follow(delta)
	_process_zoom(delta)

func _exit_tree() -> void:
	if get_viewport().get_camera_2d() == self:
		main_camera = null

#region SHAKE
func _shake_ready() -> void:
	_shake_timer = Timer.new()
	_shake_timer.autostart = false
	_shake_timer.timeout.connect(_on_shake_timer_timeout)
	add_child(_shake_timer)

func start_shake(strength: float = 30.0, duration: float = 1.0, fade: bool = false) -> void:
	randomize()
	_shaking = true
	_shake_strength = strength
	_current_shake_strength = strength
	_shake_fade = fade
	_shake_duration = duration
	_shake_timer.start(duration)

static func main_camera_start_shake(strength: float = 30.0, duration: float = 1.0, fade: bool = false) -> void:
	if not main_camera:
		return
	main_camera.start_shake(strength, duration, fade)

func _process_shake() -> void:
	if not _shaking: return
	if _shake_fade:
		_current_shake_strength = lerpf(_shake_strength, 0.0, 1.0 - (_shake_timer.time_left / _shake_duration))
	
	offset = _random_shake_offset()

func _on_shake_timer_timeout() -> void:
	_shaking = false
	offset = Vector2.ZERO

func _random_shake_offset() -> Vector2:
	return Vector2(randf_range(-_current_shake_strength, _current_shake_strength), \
					randf_range(-_current_shake_strength, _current_shake_strength))
#endregion

#region FOLLOW
func start_follow(target: Node2D, speed: float = 1.0) -> void:
	if not target: 
		return
	_following = true
	_follow_target = target
	_follow_speed = speed

func stop_follow() -> void:
	_following = false

static func main_camera_start_follow(target: Node2D, speed: float = 1.0) -> void:
	if not main_camera:
		return
	main_camera.start_follow(target, speed)
	
static func main_camera_stop_follow() -> void:
	if not main_camera:
		return
	main_camera.stop_follow()
	
func _process_follow(delta: float) -> void:
	if not _following:
		return
	
	global_position = lerp(global_position, _follow_target.global_position, delta * _follow_speed)
	
#endregion

#region ZOOM
func _process_zoom(delta: float) -> void:
	if not _zooming: 
		return
	if zoom.x != _zoom_target:
		zoom.x = lerpf(zoom.x, _zoom_target, delta * _zoom_speed)
	if zoom.y != _zoom_target:
		zoom.y = lerpf(zoom.y, _zoom_target, delta * _zoom_speed)
	if zoom.x == zoom.y and zoom.x == _zoom_target:
		_zooming = false

func start_zoom_transition(ammount: float, speed: float = 1.0):
	_zooming = true
	_zoom_target = ammount
	_zoom_speed = speed
	
static func main_camera_start_zoom_transition(ammount: float, speed: float = 1.0):
	if not main_camera:
		return
	main_camera.start_zoom_transition(ammount, speed)
#endregion
