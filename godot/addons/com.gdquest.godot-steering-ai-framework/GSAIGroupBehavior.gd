# Base type for group-based steering behaviors.
# @category - Base types
class_name GSAIGroupBehavior
extends GSAISteeringBehavior

# Container to find neighbors of the agent and calculate group behavior.
var proximity : GSAIProximity

var _callback : FuncRef = funcref(self, "_report_neighbor")


# Internal callback for the behavior to define whether or not a member is
# relevant
# @tags - virtual
func _report_neighbor(_neighbor : GSAISteeringAgent) -> bool:
	return false
