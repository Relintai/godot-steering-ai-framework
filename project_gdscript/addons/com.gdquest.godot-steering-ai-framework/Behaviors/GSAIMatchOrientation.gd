class_name GDGSAIMatchOrientation
extends GDGSAISteeringBehavior

# Calculates an angular acceleration to match an agent's orientation to that of
# its target. Attempts to make the agent arrive with zero remaining angular
# velocity.
# @category - Individual behaviors

# The target orientation for the behavior to try and match rotations to.
var target : GDGSAIAgentLocation
# The amount of distance in radians for the behavior to consider itself close
# enough to be matching the target agent's rotation.
var alignment_tolerance : float = 0.0
# The amount of distance in radians from the goal to start slowing down.
var deceleration_radius : float = 0.0
# The amount of time to reach the target velocity
var time_to_reach : float = 0.1
# Whether to use the X and Z components instead of X and Y components when
# determining angles. X and Z should be used in 3D.
var use_z : bool = false

func match_orientation(acceleration: GDGSAITargetAcceleration, desired_orientation: float) -> void:
	call("_match_orientation", acceleration, desired_orientation)

func _match_orientation(acceleration: GDGSAITargetAcceleration, desired_orientation: float) -> void:
	var rotation : float = wrapf(desired_orientation - agent.orientation, -PI, PI)

	var rotation_size : float = abs(rotation)

	if rotation_size <= alignment_tolerance:
		acceleration.set_zero()
	else:
		var desired_rotation : float = agent.angular_speed_max

		if rotation_size <= deceleration_radius:
			desired_rotation *= rotation_size / deceleration_radius

		desired_rotation *= rotation / rotation_size

		acceleration.angular = ((desired_rotation - agent.angular_velocity) / time_to_reach)

		var limited_acceleration : float = abs(acceleration.angular)
		if limited_acceleration > agent.angular_acceleration_max:
			acceleration.angular *= (agent.angular_acceleration_max / limited_acceleration)

	acceleration.linear = Vector3.ZERO


func _calculate_steering(acceleration: GDGSAITargetAcceleration) -> void:
	match_orientation(acceleration, target.orientation)
