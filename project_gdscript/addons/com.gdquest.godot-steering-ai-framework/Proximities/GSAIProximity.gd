extends Reference
class_name GDGSAIProximity

# Base container type that stores data to find the neighbors of an agent.
# @category - Proximities
# @tags - abstract

# The owning agent whose neighbors are found in the group
var agent : GDGSAISteeringAgent
# The agents who are part of this group and could be potential neighbors
var agents : Array = Array()

func find_neighbors(_callback: FuncRef) -> int:
	return call("_find_neighbors", _callback)

# Returns a number of neighbors based on a `callback` function.
#
# `_find_neighbors` calls `callback` for each agent in the `agents` array and
# adds one to the count if its `callback` returns true.
# @tags - virtual
func _find_neighbors(_callback: FuncRef) -> int:
	return 0
