extends GDGSAIProximity
class_name GDGSAIInfiniteProximity

# Determines any agent that is in the specified list as being neighbors with the
# owner agent, regardless of distance.
# @category - Proximities

# Returns a number of neighbors based on a `callback` function.
#
# `_find_neighbors` calls `callback` for each agent in the `agents` array and
# adds one to the count if its `callback` returns true.
# @tags - virtual
func _find_neighbors(callback: FuncRef) -> int:
	var neighbor_count : int = 0
	var agent_count : int = agents.size()
	for i in range(agent_count):
		var current_agent : GDGSAISteeringAgent = agents[i] as GDGSAISteeringAgent

		if current_agent != agent:
			if callback.call_func(current_agent):
				neighbor_count += 1

	return neighbor_count
