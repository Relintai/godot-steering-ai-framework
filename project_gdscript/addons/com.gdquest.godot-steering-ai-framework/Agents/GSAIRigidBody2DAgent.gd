extends GDGSAISpecializedAgent
class_name GDGSAIRigidBody2DAgent

# A specialized steering agent that updates itself every frame so the user does
# not have to using a RigidBody2D
# @category - Specialized agents

# The RigidBody2D to keep track of
var body : RigidBody2D setget _set_body

var _last_position : Vector2
var _body_ref : WeakRef


func _body_ready() -> void:
	# warning-ignore:return_value_discarded
	body.get_tree().connect("physics_frame", self, "_on_SceneTree_frame")


# Moves the agent's `body` by target `acceleration`.
# @tags - virtual
func _apply_steering(acceleration : GDGSAITargetAcceleration, _delta : float) -> void:
	var _body: RigidBody2D = _body_ref.get_ref()
	if not _body:
		return

	applied_steering = true
	_body.apply_central_impulse(GDGSAIUtils.to_vector2(acceleration.linear))
	_body.apply_torque_impulse(acceleration.angular)
	if calculate_velocities:
		linear_velocity = GDGSAIUtils.to_vector3(_body.linear_velocity)
		angular_velocity = _body.angular_velocity


func _set_body(value: RigidBody2D) -> void:
	var had_body : bool = false
	
	if body:
		had_body = true
		
	body = value
	_body_ref = weakref(value)

	_last_position = value.global_position
	last_orientation = value.rotation

	position = GDGSAIUtils.to_vector3(_last_position)
	orientation = last_orientation
	
	if !had_body:
		if !body.is_inside_tree():
			body.connect("ready", self, "_body_ready")
		else:
			_body_ready()


func _on_SceneTree_frame() -> void:
	var _body: RigidBody2D = _body_ref.get_ref()
	if !_body:
		return
	
	if !_body.is_inside_tree() or _body.get_tree().paused:
		return

	var current_position : Vector2 = _body.global_position
	var current_orientation : float = _body.rotation

	position = GDGSAIUtils.to_vector3(current_position)
	orientation = current_orientation

	if calculate_velocities:
		if applied_steering:
			applied_steering = false
		else:
			linear_velocity = GDGSAIUtils.to_vector3(_body.linear_velocity)
			angular_velocity = _body.angular_velocity
