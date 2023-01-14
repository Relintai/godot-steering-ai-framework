class_name GDGSAISeparation
extends GDGSAIGroupBehavior

# Calculates an acceleration that repels the agent from its neighbors in the
# given `GDGSAIProximity`.
#
# The acceleration is an average based on all neighbors, multiplied by a
# strength decreasing by the inverse square law in relation to distance, and it
# accumulates.
# @category - Group behaviors

# The coefficient to calculate how fast the separation strength decays with distance.
var decay_coefficient : float = 1.0

var acceleration : GDGSAITargetAcceleration


func _calculate_steering(_acceleration : GDGSAITargetAcceleration) -> void:
	self.acceleration = _acceleration
	acceleration.set_zero()
	# warning-ignore:return_value_discarded
	proximity.find_neighbors(_callback)


# Callback for the proximity to call when finding neighbors. Determines the amount of
# acceleration that `neighbor` imposes based on its distance from the owner agent.
# @tags - virtual
func _report_neighbor(neighbor : GDGSAISteeringAgent) -> bool:
	var to_agent : Vector3 = agent.position - neighbor.position

	var distance_squared : float = to_agent.length_squared()
	var acceleration_max : float = agent.linear_acceleration_max

	var strength := decay_coefficient / distance_squared
	if strength > acceleration_max:
		strength = acceleration_max

	acceleration.linear += to_agent * (strength / sqrt(distance_squared))

	return true
