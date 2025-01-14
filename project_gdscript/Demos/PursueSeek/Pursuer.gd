extends KinematicBody2D
# Represents a ship that chases after the player.

export var use_seek: bool = false

var _blend: GDGSAIBlend

var _linear_drag_coefficient := 0.025
var _angular_drag := 0.1
var _direction_face := GDGSAIAgentLocation.new()

var agent : GDGSAIKinematicBody2DAgent= null
var accel : GDGSAITargetAcceleration = null
var player_agent : GDGSAISteeringAgent = null


func _ready() -> void:
	agent = GDGSAIKinematicBody2DAgent.new()
	agent.body = self
	
	accel = GDGSAITargetAcceleration.new()
	player_agent = owner.find_node("Player", true, false).agent
	
	agent.calculate_velocities = false
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	_direction_face.position = agent.position + accel.linear.normalized()

	_blend.calculate_steering(accel)

	agent.angular_velocity = clamp(
		agent.angular_velocity + accel.angular * delta, -agent.angular_speed_max, agent.angular_speed_max
	)
	agent.angular_velocity = lerp(agent.angular_velocity, 0, _angular_drag)

	rotation += agent.angular_velocity * delta

	var linear_velocity := (
		GDGSAIUtils.to_vector2(agent.linear_velocity)
		+ (GDGSAIUtils.angle_to_vector2(rotation) * -agent.linear_acceleration_max * delta)
	)
	linear_velocity = linear_velocity.clamped(agent.linear_speed_max)
	linear_velocity = linear_velocity.linear_interpolate(Vector2.ZERO, _linear_drag_coefficient)

	linear_velocity = move_and_slide(linear_velocity)
	agent.linear_velocity = GDGSAIUtils.to_vector3(linear_velocity)


func setup(predict_time: float, linear_speed_max: float, linear_accel_max: float) -> void:
	var behavior: GDGSAISteeringBehavior
	if use_seek:
		behavior = GDGSAISeek.new()
		behavior.agent = agent
		behavior.target = player_agent
	else:
		behavior = GDGSAIPursue.new()
		behavior.agent = agent
		behavior.target = player_agent
		behavior.predict_time_max = predict_time

	var orient_behavior : GDGSAIFace = GDGSAIFace.new()
	orient_behavior.agent = agent
	orient_behavior.target = _direction_face
	
	orient_behavior.alignment_tolerance = deg2rad(5)
	orient_behavior.deceleration_radius = deg2rad(30)

	_blend = GDGSAIBlend.new()
	_blend.agent = agent
	_blend.add_behavior(behavior, 1)
	_blend.add_behavior(orient_behavior, 1)

	agent.angular_acceleration_max = deg2rad(1080)
	agent.angular_speed_max = deg2rad(360)
	agent.linear_acceleration_max = linear_accel_max
	agent.linear_speed_max = linear_speed_max

	set_physics_process(true)
