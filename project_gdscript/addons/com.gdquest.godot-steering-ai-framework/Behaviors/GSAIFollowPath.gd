class_name GDGSAIFollowPath
extends GDGSAIArrive

# Produces a linear acceleration that moves the agent along the specified path.
# @category - Individual behaviors

# The path to follow and travel along.
var path : GDGSAIPath
# The distance along the path to generate the next target position.
var path_offset : float = 0.0

# Whether to use `GDGSAIArrive` behavior on an open path.
var is_arrive_enabled : bool = true
# The amount of time in the future to predict the owning agent's position along
# the path. Setting it to 0.0 will force non-predictive path following.
var prediction_time : float = 0.0


func _calculate_steering(acceleration: GDGSAITargetAcceleration) -> void:
	var location : Vector3 
	
	if prediction_time == 0:
		location = agent.position
	else:
		location = agent.position + (agent.linear_velocity * prediction_time)

	var distance : float = path.calculate_distance(location)
	var target_distance : float = distance + path_offset

	if prediction_time > 0 and path.is_open:
		if target_distance < path.calculate_distance(agent.position):
			target_distance = path.length

	var target_position : Vector3 = path.calculate_target_position(target_distance)

	if is_arrive_enabled and path.is_open:
		if path_offset >= 0:
			if target_distance > path.length - deceleration_radius:
				arrive(acceleration, target_position)
				return
		else:
			if target_distance < deceleration_radius:
				arrive(acceleration, target_position)
				return

	acceleration.linear = (target_position - agent.position).normalized()
	acceleration.linear *= agent.linear_acceleration_max
	acceleration.angular = 0
