class_name GSAIEvade
extends GSAIPursue

# Calculates acceleration to take an agent away from where a target agent is
# moving.
# @category - Individual behaviors

func _get_modified_acceleration() -> float:
	return -agent.linear_acceleration_max
