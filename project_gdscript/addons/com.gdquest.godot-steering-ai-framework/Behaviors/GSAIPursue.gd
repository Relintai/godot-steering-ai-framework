class_name GDGSAIPursue
extends GDGSAISteeringBehavior

# Calculates an acceleration to make an agent intercept another based on the
# target agent's movement.
# @category - Individual behaviors

# The target agent that the behavior is trying to intercept.
var target : GDGSAISteeringAgent
# The maximum amount of time in the future the behavior predicts the target's
# location.
var predict_time_max : float = 1.0

func _calculate_steering(acceleration : GDGSAITargetAcceleration) -> void:
	var target_position : Vector3 = target.position
	var distance_squared : float = (target_position - agent.position).length_squared()

	var speed_squared : float = agent.linear_velocity.length_squared()
	var predict_time : float = predict_time_max

	if speed_squared > 0:
		var predict_time_squared := distance_squared / speed_squared
		if predict_time_squared < predict_time_max * predict_time_max:
			predict_time = sqrt(predict_time_squared)

	acceleration.linear = ((target_position + (target.linear_velocity * predict_time)) - agent.position).normalized()
	acceleration.linear *= get_modified_acceleration()

	acceleration.angular = 0

func get_modified_acceleration() -> float:
	return call("_get_modified_acceleration")

func _get_modified_acceleration() -> float:
	return agent.linear_acceleration_max
