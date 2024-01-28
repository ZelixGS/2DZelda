class_name Sword extends Sprite2D

signal start_swing
signal middle_swing
signal end_swing

@export var damage: int = 4
@export var knockback_force: float = 1.2
@export var faction: String = "enemy"

@export var is_swinging: bool = false
