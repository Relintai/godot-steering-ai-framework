class_name GDGSAISeek
extends GDGSAISteeringBehavior

# Calculates an acceleration to take an agent to a target agent's position
# directly.
# @category - Individual behaviors

# The target that the behavior aims to move the agent to.
var target : GDGSAIAgentLocation


func _calculate_steering(acceleration: GDGSAITargetAcceleration) -> void:
	acceleration.linear = ((target.position - agent.position).normalized() * agent.linear_acceleration_max)
	acceleration.angular = 0
