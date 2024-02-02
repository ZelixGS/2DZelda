class_name Carryable extends Area2D

@onready var parent: GameObject = owner
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var weight: int = 1

var speed: float = 0.33
var pickup_tween: Tween
var putdown_tween: Tween

func pickup(remote: RemoteTransform2D) -> void:
	if pickup_tween and pickup_tween.is_running():
		return
	
	parent.disable_collision()
	parent.z_index += 2
	
	collision_shape_2d.set_deferred("disabled", true)
	
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
	parent.enable_collision()
	collision_shape_2d.set_deferred("disabled", false)

func throw() -> void:
	pass
