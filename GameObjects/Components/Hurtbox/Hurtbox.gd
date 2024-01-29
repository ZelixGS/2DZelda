class_name Hurtbox extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var health: Health
@export var faction: String = "enemy"

func _ready() -> void:
	area_entered.connect(on_entered)

func on_entered(area: Area2D) -> void:
	if not area is Hitbox:
		return
	
	if not health:
		printerr("%s is missing Health component." % owner.name)
		return

	var hit: Hitbox = area
	if hit.faction == faction:
		return
	health.change_health(hit.damage, hit.knockback, hit.global_position)
	hit.emit_signal("on_struck", owner)

func enable() -> void:
	if collision_shape_2d:
		collision_shape_2d.set_deferred("disabled", false)

func disable() -> void:
	if collision_shape_2d:
		collision_shape_2d.set_deferred("disabled", true)
