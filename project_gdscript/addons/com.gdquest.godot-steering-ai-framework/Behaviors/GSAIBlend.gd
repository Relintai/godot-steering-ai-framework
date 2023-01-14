class_name GDGSAIBlend
extends GDGSAISteeringBehavior

# Blends multiple steering behaviors into one, and returns a weighted
# acceleration from their calculations.
#
# Stores the behaviors internally as dictionaries of the form
# {
# 	behavior : GDGSAISteeringBehavior,
# 	weight : float
# }
# @category - Combination behaviors

var _behaviors : Array = Array()
var _accel : GDGSAITargetAcceleration = GDGSAITargetAcceleration.new()

# Appends a behavior to the internal array along with its `weight`.
func add_behavior(behavior : GDGSAISteeringBehavior, weight : float) -> void:
	behavior.agent = agent
	
	var dict : Dictionary = Dictionary()
	
	dict["behavior"] = behavior;
	dict["weight"] = weight;
	
	_behaviors.append(dict)

# Returns the behavior at the specified `index`, or an empty `Dictionary` if
# none was found.
func get_behavior(index : int) -> Dictionary:
	if _behaviors.size() > index:
		return _behaviors[index]
		
	printerr("Tried to get index " + str(index) + " in array of size " + str(_behaviors.size()))
	
	return Dictionary()

func remove_behavior(index : int) -> void:
	if _behaviors.size() > index:
		_behaviors.remove(index)
		
		return
		
	printerr("Tried to get index " + str(index) + " in array of size " + str(_behaviors.size()))
	
	return

func get_behaviour_count() -> int:
	return _behaviors.size()

func get_accel() -> GDGSAITargetAcceleration:
	return _accel

func _calculate_steering(blended_accel: GDGSAITargetAcceleration) -> void:
	blended_accel.set_zero()

	for i in range(_behaviors.size()):
		var bw : Dictionary = _behaviors[i]
		bw.behavior.calculate_steering(_accel)

		blended_accel.add_scaled_accel(_accel, bw.weight)

	blended_accel.linear = GDGSAIUtils.clampedv3(blended_accel.linear, agent.linear_acceleration_max)
	blended_accel.angular = clamp(blended_accel.angular, -agent.angular_acceleration_max, agent.angular_acceleration_max)
