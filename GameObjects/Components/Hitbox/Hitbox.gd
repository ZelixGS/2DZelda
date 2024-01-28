class_name Hitbox extends Area2D

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
