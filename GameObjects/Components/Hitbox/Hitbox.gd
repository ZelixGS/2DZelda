class_name Hitbox extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var damage: int = 1
@export var knockback: float = 1.0
@export var faction: String = "enemy"

signal on_struck(node: Node2D)

func _ready() -> void:
	if "damage" in owner:
		damage = owner.damage
	if "knockback" in owner:
		knockback = owner.knockback
	if "faction" in owner:
		faction = owner.faction

func enable() -> void:
	if collision_shape_2d:
		collision_shape_2d.set_deferred("disabled", false)

func disable() -> void:
	if collision_shape_2d:
		collision_shape_2d.set_deferred("disabled", true)
