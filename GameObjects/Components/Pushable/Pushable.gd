class_name Pushable extends Area2D

@onready var parent: GameObject = owner
@onready var ray_cast_2d: RayCast2D = $RayCast2D

@export var push_limit: int = -1
@export var push_direction: Vector2 = Vector2.RIGHT

var push_count: int = 0
var at_limit_color: Color = Color.DIM_GRAY
var start_position: Vector2

var move_tween: Tween
var dim_tween: Tween

func check_collision(direction: Vector2) -> bool:
	ray_cast_2d.enabled = true
	ray_cast_2d.target_position = direction * Global.tile_size
	ray_cast_2d.force_raycast_update()
	var colliding: bool = ray_cast_2d.is_colliding()
	ray_cast_2d.enabled = false
	return colliding

func push(direction: Vector2 = push_direction) -> void:
	if move_tween and move_tween.is_running():
		return
		
	if push_direction != Vector2.ZERO and direction != push_direction:
		return
		
	if push_limit != -1 and push_count >= push_limit:
		return
	
	if check_collision(direction):
		return
	
	push_count += 1
	
	move_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	move_tween.tween_property(parent, "global_position", parent.global_position + direction * Global.tile_size, 0.25)
	await move_tween.finished
	
	parent.global_position = Global.snap_to_grid(parent.global_position)
	
	if push_limit != -1 and push_count >= push_limit:
		dim_block()

func dim_block() -> void:
	dim_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	dim_tween.tween_property(parent, "modulate", at_limit_color, 0.25)

func additional_reset() -> void:
	push_count = 0
