class_name Entity extends CharacterBody2D

var knockback_vuln: float = 80.0

var knockback_force: Vector2 = Vector2.ZERO
var external_force: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	velocity += knockback_force + external_force
	move_and_slide()
	knockback_force = knockback_force.move_toward(Vector2.ZERO, 6)
	external_force = external_force.move_toward(Vector2.ZERO, 6)

func apply_external_force(force: Vector2) -> void:
	external_force = force

func apply_knockback(force: float, knockback_pos: Vector2) -> void:
	knockback_force = knockback_pos.direction_to(global_position) * (knockback_vuln * force)
