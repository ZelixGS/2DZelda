class_name Player extends CharacterBody2D

@export var speed: float = 60.0
@export var backpedal_speed_reduction: float = -15.0
@export var blocking_speed_reduction: float = -15.0

@onready var rotation_helper: Node2D = $RotationHelper
@onready var wall_check: RayCast2D = $RotationHelper/WallCheck

@onready var carry_position: RemoteTransform2D = $CarryPosition
@onready var carry_check: RayCast2D = $RotationHelper/CarryCheck
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tile_in_front: Marker2D = $RotationHelper/TileInFront
@onready var sword: Sword = $Sword

var direction: Vector2 = Vector2.ZERO
var facing: String = "down"
var held_object: Carryable
var knockback_force: Vector2 = Vector2.ZERO
var external_force: Vector2 = Vector2.ZERO

var has_shield: bool = true

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	get_input()
	velocity = direction.normalized() * get_speed() + knockback_force + external_force
	rotation_helper.rotation = snapped(Global.facing_to_vector(get_direction()).angle(), PI/4)
	#move_and_collide(velocity * _delta)
	move_and_slide()
	knockback_force = knockback_force.move_toward(Vector2.ZERO, 6)
	external_force = external_force.move_toward(Vector2.ZERO, 6)

func get_input() -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").snapped(Vector2(1,1))
	if is_locked_controls():
		direction = Vector2.ZERO

func get_direction() -> String:
	if Input.is_action_pressed("strafe") or is_knocked_backed():
		return facing

	if abs(Global.facing_to_vector(facing).angle_to(direction)) < PI * 0.3:
		return facing
	facing = Global.vector_to_facing(velocity)
	return facing

func get_speed() -> float:
	var backpedal_mod: float = backpedal_speed_reduction if is_backpedalling() else 0.0
	var blocking_mod: float = blocking_speed_reduction if is_blocking() else 0.0
	return speed + backpedal_mod + blocking_mod

func is_carrying() -> bool:
	return not carry_position.remote_path.is_empty()

func is_backpedalling() -> bool:
	return direction.dot(Global.facing_to_vector(get_direction())) < 0

func is_knocked_backed() -> bool:
	return knockback_force.abs() > Vector2.ZERO

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
		apply_external_force(Global.facing_to_vector(get_direction()) * 16)
		animation_player.advance_play("swing", true)

func apply_external_force(force: Vector2) -> void:
	direction = Vector2.ZERO
	external_force = force

func apply_knockback(force: float, knockback_pos: Vector2) -> void:
	direction = Vector2.ZERO
	knockback_force = knockback_pos.direction_to(global_position) * (120 * force)
