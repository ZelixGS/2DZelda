class_name GameObject extends AnimatableBody2D

@onready var start_position: Vector2 = global_position
@onready var starting_zindex: int = z_index
@onready var starting_collision: bool = $CollisionShape2D.disabled

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func reset() -> void:
	visible = true
	modulate = Color.WHITE
	global_position = start_position
	z_index = starting_zindex
	if collision_shape_2d:
		collision_shape_2d.set_deferred("disabled", starting_collision)
	reset_children()

func reset_children() -> void:
	additional_reset()
	for child: Node in get_children():
		if child.has_method("additional_reset"):
			child.additional_reset()

func additional_reset() -> void:
	pass

func enable_collision() -> void:
	if collision_shape_2d:
		collision_shape_2d.set_deferred("disabled", false)

func disable_collision() -> void:
	if collision_shape_2d:
		collision_shape_2d.set_deferred("disabled", true)
