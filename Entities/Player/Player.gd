class_name Player extends Entity

@export var speed_max: float = 60.0
@export var acceleration: float = 6.0
@export var deceleration: float = 20.0

@export var backpedal_speed_reduction: float = -15.0
@export var blocking_speed_reduction: float = -15.0

@onready var rotation_helper: Node2D = $RotationHelper
@onready var wall_check: RayCast2D = $RotationHelper/WallCheck

@onready var carry_position: RemoteTransform2D = $CarryPosition
@onready var carry_check: RayCast2D = $RotationHelper/CarryCheck
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tile_in_front: Marker2D = $RotationHelper/TileInFront
@onready var sword: Sword = $Sword

var current_speed: float = 0.0
var direction: Vector2 = Vector2.ZERO
var held_object: Carryable

var has_shield: bool = true

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	velocity = get_input().normalized() * get_speed()
	check_facing()
	standard_movement()

func get_input() -> Vector2:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").snapped(Vector2(1,1))
	if is_locked_controls():
		direction = Vector2.ZERO
	return direction

func check_facing() -> void:
	if is_backpedalling():
		return
	if direction.dot(Global.facing_to_vector(facing)) < 0:
		current_speed = current_speed / 3

func update_facing() -> String:
	if abs(Global.facing_to_vector(facing).angle_to(velocity)) < PI * 0.3:
		return facing
	if is_knocked_backed():
		return facing
	if Input.is_action_pressed("strafe"):
		return facing
	facing = Global.vector_to_facing(velocity)
	return facing

func get_speed() -> float:
	var backpedal_mod: float = backpedal_speed_reduction if is_backpedalling() else 0.0
	var blocking_mod: float = blocking_speed_reduction if is_blocking() else 0.0
	if direction.abs() > Vector2.ZERO:
		current_speed = move_toward(current_speed, speed_max, acceleration)
	else:
		current_speed = move_toward(current_speed, 0, deceleration)
	return clamp(current_speed + backpedal_mod + blocking_mod, 10.0, 100.0)

# Expects Array of [x, y, w, l]
func clamp_to_room(size: Array[float]) -> void:
	var room_min: Vector2 = Vector2(size[0], size[1])+Vector2(8,8)
	var room_max: Vector2 = Vector2(size[2], size[3])-Vector2(8,8)
	global_position = global_position.clamp(room_min, room_max)

func is_carrying() -> bool:
	return not carry_position.remote_path.is_empty()

func is_blocking() -> bool:
	return has_shield and Input.is_action_pressed("block")

func is_locked_controls() -> bool:
	return is_knocked_backed() or sword.is_swinging
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("A"):
		if is_carrying():
			if direction == Vector2.ZERO:
				if wall_check.is_colliding():
					return
				carry_position.remote_path = ""
				animation_player.advance_play("lift", true, 1.0, true)
				held_object.putdown(Global.snap_to_grid(tile_in_front.global_position))
			else:
				print("Throw!")
		if carry_check.is_colliding():
			var collider: Node2D = carry_check.get_collider()
			if collider is Carryable:
				held_object = collider
				animation_player.advance_play("lift", true)
				held_object.pickup(carry_position)
	if event.is_action_pressed("B"):
		if sword.is_swinging:
			return
		apply_external_force(Global.facing_to_vector(facing) * 16)
		animation_player.advance_play("swing", true)
