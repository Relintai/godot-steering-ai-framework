extends Reference
class_name GDGSAISteeringBehavior

# Base class for all steering behaviors.
#
# Steering behaviors calculate the linear and the angular acceleration to be
# to the agent that owns them.
#
# The `calculate_steering` function is the entry point for all behaviors.
# Individual steering behaviors encapsulate the steering logic.
# @category - Base types

# If `false`, all calculations return zero amounts of acceleration.
var is_enabled : bool = true
# The AI agent on which the steering behavior bases its calculations.
var agent : GDGSAISteeringAgent

# Sets the `acceleration` with the behavior's desired amount of acceleration.
func calculate_steering(acceleration: GDGSAITargetAcceleration) -> void:
	if is_enabled:
		call("_calculate_steering", acceleration)
	else:
		acceleration.set_zero()

func _calculate_steering(acceleration: GDGSAITargetAcceleration) -> void:
	acceleration.set_zero()
