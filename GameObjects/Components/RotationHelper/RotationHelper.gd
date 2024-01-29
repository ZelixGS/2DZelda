extends Node2D

@onready var parent: Entity = owner

func _physics_process(_delta: float) -> void:
	rotation = Global.snap_angle_to_facing(parent.facing)
