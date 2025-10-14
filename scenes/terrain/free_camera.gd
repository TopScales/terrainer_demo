##
##
@icon("res://assets/icons/classes/FreeCamera.svg")
class_name FreeCamera
extends Camera3D

const MOVE_FORWARD: StringName = &"move_forward"
const MOVE_BACKWARD: StringName = &"move_backward"
const MOVE_LEFT: StringName = &"move_left"
const MOVE_RIGHT: StringName = &"move_right"
const MOVE_UP: StringName = &"move_up"
const MOVE_DOWN: StringName = &"move_down"
const MOVE_FAST: StringName = &"move_fast"
const ENABLE_ROTATION: StringName = &"sec_click"

const MIN_X_ROTATION: float = -PI / 2
const MAX_X_ROTATION: float = PI / 2

@export_range(1.0,100.0,0.1) var speed: float = 20.0
@export_range(1.5,10.0,0.1) var fast_factor: float = 3.0
@export_range(0.01,5.0,0.01) var velocity_decay_time: float = 0.3
@export_range(0.001,0.1,0.001) var rotation_sensitivity: float = 0.005
@export_range(0.01,5.0,0.01) var rotation_reach_time: float = 0.1

var _direction_local: Vector3 = Vector3()
var _direction: Vector3 = Vector3()
var _velocity_decay: float = 1.0
var _velocity: float = speed
var _stopping: bool = false
var _moving: bool = false
var _rotation_enabled: bool = false
var _rotating: bool = false
var _rotation: Vector2 = Vector2()
var _rotation_weight: float = 0.0


# =============================================================
# ========= Public Functions ==================================


# =============================================================
# ========= Callbacks =========================================

func _ready() -> void:
	set_physics_process(false)
	var angles: Vector3 = global_basis.get_euler()
	_rotation = Vector2(angles.x, angles.y)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return

	if event.is_action(MOVE_FORWARD) or event.is_action(MOVE_BACKWARD) or \
			event.is_action(MOVE_LEFT) or event.is_action(MOVE_RIGHT) or \
			event.is_action(MOVE_UP) or event.is_action(MOVE_DOWN):
		_get_input_direction()

	if event.is_action(MOVE_FAST):
		if event.is_pressed():
			_velocity = speed * fast_factor
		else:
			_velocity = speed

	if event.is_action(ENABLE_ROTATION):
		_rotation_enabled = event.is_pressed()

	if _rotation_enabled and event is InputEventMouseMotion:
		var mm: InputEventMouseMotion = event as InputEventMouseMotion
		_rotating = true
		_set_rotation(mm.relative)
		set_physics_process(true)


func _physics_process(delta: float) -> void:
	if _stopping:
		_velocity_decay -= delta / velocity_decay_time
		if _velocity_decay < 0.0:
			_moving = false

	if not _moving and not _rotating:
		set_physics_process(false)
		return

	if _moving:
		_move(delta)

	if _rotating:
		_rotate(delta)


# =============================================================
# ========= Virtual Methods ===================================


# =============================================================
# ========= Private Functions =================================

func _get_input_direction() -> void:
	var direction: Vector3 = Vector3()
	if Input.is_action_pressed(MOVE_FORWARD):
		direction.z -= 1.0
	if Input.is_action_pressed(MOVE_BACKWARD):
		direction.z += 1.0
	if Input.is_action_pressed(MOVE_LEFT):
		direction.x -= 1.0
	if Input.is_action_pressed(MOVE_RIGHT):
		direction.x += 1.0
	if Input.is_action_pressed(MOVE_UP):
		direction.y += 1.0
	if Input.is_action_pressed(MOVE_DOWN):
		direction.y -= 1.0
	if direction == Vector3.ZERO:
		_stopping = true
	else:
		_direction_local = direction
		_set_direction()
		_velocity_decay = 1.0
		_stopping = false
		_moving = true
		set_physics_process(true)


func _set_direction() -> void:
	_direction = Vector3()
	if _direction_local.x != 0.0:
		var right: Vector3 = global_basis.x
		_direction += _direction_local.x * right
	if _direction_local.z != 0.0:
		var forward: Vector3 = global_basis.z
		forward.y = 0
		_direction += _direction_local.z * forward.normalized()
	if _direction_local.y != 0.0:
		_direction += Vector3(0.0, _direction_local.y, 0.0)
	_direction = _direction.normalized()


func _set_rotation(mouse_motion: Vector2) -> void:
	_rotation.x = clampf(_rotation.x - mouse_motion.y * rotation_sensitivity, MIN_X_ROTATION, MAX_X_ROTATION)
	_rotation.y = _rotation.y - mouse_motion.x * rotation_sensitivity
	_rotation_weight = 0.0


func _move(delta: float) -> void:
	var v: float = _velocity * _velocity_decay
	var displacement: Vector3 = _direction * v * delta
	position += displacement


func _rotate(delta: float) -> void:
	var target: Quaternion =  Quaternion(Vector3.UP, _rotation.y) * Quaternion(Vector3.RIGHT, _rotation.x)
	_rotation_weight += delta / rotation_reach_time

	if _rotation_weight >= 1.0:
		quaternion = target
		_rotating = false
	else:
		quaternion = quaternion.slerp(target, _rotation_weight)

	if _moving:
		_set_direction()


# =============================================================
# ========= Signal Callbacks ==================================
