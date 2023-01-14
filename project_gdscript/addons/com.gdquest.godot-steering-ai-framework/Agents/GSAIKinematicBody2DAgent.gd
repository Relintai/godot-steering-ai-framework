extends GDGSAISpecializedAgent
class_name GDGSAIKinematicBody2DAgent

# A specialized steering agent that updates itself every frame so the user does
# not have to using a KinematicBody2D
# @category - Specialized agents

# SLIDE uses `move_and_slide`
# COLLIDE uses `move_and_collide`
# POSITION changes the `global_position` directly
enum MovementType { 
	SLIDE, 
	COLLIDE, 
	POSITION 
}

# The KinematicBody2D to keep track of
var body: KinematicBody2D setget _set_body

# The type of movement the body executes
var movement_type : int = MovementType.SLIDE

var _last_position : Vector2
var _body_ref : WeakRef


func _body_ready() -> void:
	# warning-ignore:return_value_discarded
	body.get_tree().connect("physics_frame", self, "_on_SceneTree_physics_frame")


# Moves the agent's `body` by target `acceleration`.
# @tags - virtual
func _apply_steering(acceleration: GDGSAITargetAcceleration, delta: float) -> void:
	applied_steering = true
	
	if movement_type == MovementType.COLLIDE:
		_apply_collide_steering(acceleration.linear, delta)
	elif movement_type == MovementType.SLIDE:
		_apply_sliding_steering(acceleration.linear, delta)
	else:
		_apply_position_steering(acceleration.linear, delta)

	_apply_orientation_steering(acceleration.angular, delta)


func _apply_sliding_steering(accel: Vector3, delta: float) -> void:
	var _body: KinematicBody2D = _body_ref.get_ref()
	
	if !_body:
		return

	if !_body.is_inside_tree() or _body.get_tree().paused:
		return
		
	var velocity : Vector2 = GDGSAIUtils.to_vector2(linear_velocity + accel * delta).clamped(linear_speed_max)
	
	if apply_linear_drag:
		velocity = velocity.linear_interpolate(Vector2.ZERO, linear_drag_percentage)
		
	velocity = _body.move_and_slide(velocity)
	
	if calculate_velocities:
		linear_velocity = GDGSAIUtils.to_vector3(velocity)


func _apply_collide_steering(accel: Vector3, delta: float) -> void:
	var _body: KinematicBody2D = _body_ref.get_ref()
	if !_body:
		return
		
	var velocity : Vector3 = GDGSAIUtils.clampedv3(linear_velocity + accel * delta, linear_speed_max)
	if apply_linear_drag:
		velocity = velocity.linear_interpolate(Vector3.ZERO, linear_drag_percentage)
		
	# warning-ignore:return_value_discarded
	_body.move_and_collide(GDGSAIUtils.to_vector2(velocity) * delta)
	
	if calculate_velocities:
		linear_velocity = velocity


func _apply_position_steering(accel: Vector3, delta: float) -> void:
	var _body: KinematicBody2D = _body_ref.get_ref()
	if !_body:
		return
		
	var velocity : Vector3 = GDGSAIUtils.clampedv3(linear_velocity + accel * delta, linear_speed_max)
	
	if apply_linear_drag:
		velocity = velocity.linear_interpolate(Vector3.ZERO, linear_drag_percentage)
		
	_body.global_position += GDGSAIUtils.to_vector2(velocity) * delta
	
	if calculate_velocities:
		linear_velocity = velocity


func _apply_orientation_steering(angular_acceleration: float, delta: float) -> void:
	var _body: KinematicBody2D = _body_ref.get_ref()
	
	if !_body:
		return
		
	var velocity = clamp(angular_velocity + angular_acceleration * delta, -angular_speed_max, angular_speed_max)
	
	if apply_angular_drag:
		velocity = lerp(velocity, 0, angular_drag_percentage)
		
	_body.rotation += velocity * delta
	
	if calculate_velocities:
		angular_velocity = velocity


func _set_body(value: KinematicBody2D) -> void:
	var had_body : bool = false
	
	if body:
		had_body = true
		
	body = value
	_body_ref = weakref(body)

	_last_position = value.global_position
	last_orientation = value.rotation

	position = GDGSAIUtils.to_vector3(_last_position)
	orientation = last_orientation
	
	if !had_body:
		if !body.is_inside_tree():
			body.connect("ready", self, "_body_ready")
		else:
			_body_ready()


func _on_SceneTree_physics_frame() -> void:
	var _body: KinematicBody2D = _body_ref.get_ref()
	if !_body:
		return
	
	var current_position : Vector2 = _body.global_position
	var current_orientation : float = _body.rotation

	position = GDGSAIUtils.to_vector3(current_position)
	orientation = current_orientation

	if calculate_velocities:
		if applied_steering:
			applied_steering = false
		else:
			linear_velocity = GDGSAIUtils.clampedv3(GDGSAIUtils.to_vector3(current_position - _last_position), linear_speed_max)
			
			if apply_linear_drag:
				linear_velocity = linear_velocity.linear_interpolate(Vector3.ZERO, linear_drag_percentage)

			angular_velocity = clamp(last_orientation - current_orientation, -angular_speed_max, angular_speed_max)

			if apply_angular_drag:
				angular_velocity = lerp(angular_velocity, 0, angular_drag_percentage)

			_last_position = current_position
			last_orientation = current_orientation