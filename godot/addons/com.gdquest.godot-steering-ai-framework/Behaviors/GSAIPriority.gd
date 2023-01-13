# Container for multiple behaviors that returns the result of the first child
# behavior with non-zero acceleration.
# @category - Combination behaviors
class_name GSAIPriority
extends GSAISteeringBehavior

var _behaviors : Array = Array()

# The index of the last behavior the container prioritized.
var _last_selected_index : int = 0
# If a behavior's acceleration is lower than this threshold, the container
# considers it has an acceleration of zero.
var zero_threshold : float = 0.0


# Appends a steering behavior as a child of this container.
func add_behavior(behavior: GSAISteeringBehavior) -> void:
	_behaviors.append(behavior)

# Returns the behavior at the position in the pool referred to by `index`, or
# `null` if no behavior was found.
func get_behavior(index : int) -> GSAISteeringBehavior:
	if _behaviors.size() > index:
		return _behaviors[index]
		
	printerr("Tried to get index " + str(index) + " in array of size " + str(_behaviors.size()))
	
	return null

func remove_behavior(index : int) -> void:
	if _behaviors.size() > index:
		_behaviors.remove(index)
		
		return
		
	printerr("Tried to get index " + str(index) + " in array of size " + str(_behaviors.size()))
	
	return

func get_behaviour_count() -> int:
	return _behaviors.size()
	

func _calculate_steering(accel : GSAITargetAcceleration) -> void:
	var threshold_squared : float = zero_threshold * zero_threshold

	_last_selected_index = -1

	var size : int = _behaviors.size()

	if size > 0:
		for i in range(size):
			_last_selected_index = i
			var behavior: GSAISteeringBehavior = _behaviors[i]
			behavior.calculate_steering(accel)

			if accel.get_magnitude_squared() > threshold_squared:
				break
	else:
		accel.set_zero()
