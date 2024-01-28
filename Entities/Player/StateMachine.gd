extends Node

@onready var player: Player = $".."

var state: String = "idle"

func _process(_delta: float) -> void:
	update_state()

func update_state() -> void:
	if player.direction.abs() > Vector2.ZERO:
		if not player.is_carrying() and player.wall_check.is_colliding() and not player.is_blocking():
			state = "pushing"
		else:
			state = "moving"
	else:
		state = "idle"
