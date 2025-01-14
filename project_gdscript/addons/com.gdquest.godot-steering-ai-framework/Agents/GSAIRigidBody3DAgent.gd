extends GDGSAISpecializedAgent
class_name GDGSAIRigidBody3DAgent

# A specialized steering agent that updates itself every frame so the user does
# not have to using a RigidBody
# @category - Specialized agents

# The RigidBody to keep track of
var body: RigidBody setget _set_body

var _last_position: Vector3
var _body_ref: WeakRef

func _body_ready() -> void:
	# warning-ignore:return_value_discarded
	body.get_tree().connect("physics_frame", self, "_on_SceneTree_frame")


# Moves the agent's `body` by target `acceleration`.
# @tags - virtual
func _apply_steering(acceleration: GDGSAITargetAcceleration, _delta: float) -> void:
	var _body: RigidBody = _body_ref.get_ref()
	if !_body:
		return
		
	applied_steering = true
	_body.apply_central_impulse(acceleration.linear)
	_body.apply_torque_impulse(Vector3.UP * acceleration.angular)
	if calculate_velocities:
		linear_velocity = _body.linear_velocity
		angular_velocity = _body.angular_velocity.y


func _set_body(value: RigidBody) -> void:
	var had_body : bool = false
	
	if body:
		had_body = true
	
	body = value
	_body_ref = weakref(value)

	_last_position = value.transform.origin
	last_orientation = value.rotation.y

	position = _last_position
	orientation = last_orientation
	
	if !had_body:
		if !body.is_inside_tree():
			body.connect("ready", self, "_body_ready")
		else:
			_body_ready()

func _on_SceneTree_frame() -> void:
	var _body: RigidBody = _body_ref.get_ref()
	if not _body:
		return
	
	if not _body.is_inside_tree() or _body.get_tree().paused:
		return
		
	var current_position : Vector3 = _body.transform.origin
	var current_orientation : float = _body.rotation.y

	position = current_position
	orientation = current_orientation

	if calculate_velocities:
		if applied_steering:
			applied_steering = false
		else:
			linear_velocity = _body.linear_velocity
			angular_velocity = _body.angular_velocity.y
