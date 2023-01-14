class_name GDGSAILookWhereYouGo
extends GDGSAIMatchOrientation

# Calculates an angular acceleration to match an agent's orientation to its
# direction of travel.
# @category - Individual behaviors

func _calculate_steering(accel: GDGSAITargetAcceleration) -> void:
	if agent.linear_velocity.length_squared() < agent.zero_linear_speed_threshold:
		accel.set_zero()
	else:
		var orientation : float 
		
		if use_z:
			orientation = GDGSAIUtils.vector3_to_angle(agent.linear_velocity)
		else:
			orientation = GDGSAIUtils.vector2_to_angle(GDGSAIUtils.to_vector2(agent.linear_velocity))

		match_orientation(accel, orientation)
