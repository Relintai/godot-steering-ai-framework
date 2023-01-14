class_name GDGSAIGroupBehavior
extends GDGSAISteeringBehavior

# Base type for group-based steering behaviors.
# @category - Base types

# Container to find neighbors of the agent and calculate group behavior.
var proximity : GDGSAIProximity

var _callback : FuncRef = funcref(self, "_report_neighbor")

func get_callback() -> FuncRef:
	return _callback

# Internal callback for the behavior to define whether or not a member is
# relevant
# @tags - virtual
func _report_neighbor(_neighbor : GDGSAISteeringAgent) -> bool:
	return false
