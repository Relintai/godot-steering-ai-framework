extends KinematicBody2D

var player_agent: GDGSAIAgentLocation
var velocity := Vector2.ZERO
var start_speed: float
var start_accel: float
var use_seek := true

var agent : GDGSAIKinematicBody2DAgent = null
var accel : GDGSAITargetAcceleration = null
var seek : GDGSAISeek = null
var flee : GDGSAIFlee = null


func _ready() -> void:
	agent = GDGSAIKinematicBody2DAgent.new()
	agent.body = self
	
	accel = GDGSAITargetAcceleration.new()
	
	seek = GDGSAISeek.new()
	seek.agent = agent
	seek.target = player_agent
	
	flee = GDGSAIFlee.new()
	flee.agent = agent
	flee.target = player_agent
	
	agent.linear_acceleration_max = start_accel
	agent.linear_speed_max = start_speed


func _physics_process(delta: float) -> void:
	if not player_agent:
		return

	if use_seek:
		seek.calculate_steering(accel)
	else:
		flee.calculate_steering(accel)

	agent.apply_steering(accel, delta)
