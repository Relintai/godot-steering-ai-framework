class_name GSAIFlee
extends GSAISeek

# Calculates acceleration to take an agent directly away from a target agent.
# @category - Individual behaviors

func _calculate_steering(acceleration: GSAITargetAcceleration) -> void:
	acceleration.linear = ((agent.position - target.position).normalized() * agent.linear_acceleration_max)
	acceleration.angular = 0
