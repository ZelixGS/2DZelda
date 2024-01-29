class_name Entity extends CharacterBody2D

signal knocked_back

@export var knockback_vuln: float = 10.0

var facing: String = "down"

var knockback_force: Vector2 = Vector2.ZERO
var external_force: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	standard_movement()

func standard_movement() -> void:
	#print("Vel: [%s] KB: [%s] EF: [%s]" % [velocity, knockback_force, external_force])
	velocity += knockback_force + external_force
	move_and_slide()
	reduced_forced()
	update_facing()
	velocity = Vector2.ZERO

func reduced_forced() -> void:
	knockback_force = knockback_force.move_toward(Vector2.ZERO, 6)
	external_force = external_force.move_toward(Vector2.ZERO, 6)
	
func update_facing() -> String:
	if abs(Global.facing_to_vector(facing).angle_to(velocity)) < PI * 0.3:
		return facing
	if is_knocked_backed():
		return facing
	facing = Global.vector_to_facing(velocity)
	return facing

func is_backpedalling() -> bool:
	return get_real_velocity().dot(Global.facing_to_vector(facing)) < 0

func is_knocked_backed() -> bool:
	return knockback_force.abs() > Vector2.ZERO

func apply_external_force(force: Vector2) -> void:
	external_force = force

func apply_knockback(force: float, knockback_pos: Vector2) -> void:
	velocity = Vector2.ZERO
	knockback_force = knockback_pos.direction_to(global_position) * (knockback_vuln * force)
	emit_signal("knocked_back")
