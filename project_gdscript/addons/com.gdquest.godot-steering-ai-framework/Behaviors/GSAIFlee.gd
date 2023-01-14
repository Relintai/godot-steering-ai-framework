class_name GDGSAIFlee
extends GDGSAISeek

# Calculates acceleration to take an agent directly away from a target agent.
# @category - Individual behaviors

func _calculate_steering(acceleration: GDGSAITargetAcceleration) -> void:
	acceleration.linear = ((agent.position - target.position).normalized() * agent.linear_acceleration_max)
	acceleration.angular = 0
