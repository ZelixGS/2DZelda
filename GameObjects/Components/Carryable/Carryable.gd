class_name Carryable extends Area2D

@export var weight: int = 1

var speed: float = 0.33

@onready var parent: AnimatableBody2D = owner
@onready var start_position: Vector2 = parent.global_position
@onready var start_collision: int = parent.collision_layer

var pickup_tween: Tween
var putdown_tween: Tween

func pickup(remote: RemoteTransform2D) -> void:
	if pickup_tween and pickup_tween.is_running():
		return
	
	parent.collision_layer = 0
	collision_layer = 0
	parent.z_index += 2
	pickup_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	pickup_tween.tween_property(parent, "global_position", remote.global_position, speed)
	await pickup_tween.finished
	
	remote.remote_path = parent.get_path()

func putdown(to_pos: Vector2) -> void:
	if putdown_tween and putdown_tween.is_running():
		return
	
	putdown_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	putdown_tween.tween_property(parent, "global_position", to_pos, speed)
	await putdown_tween.finished
	
	parent.z_index -= 2
	parent.collision_layer = start_collision
	collision_layer = 256

func throw() -> void:
	pass
	
func reset() -> void:  
	parent.global_position = start_position
