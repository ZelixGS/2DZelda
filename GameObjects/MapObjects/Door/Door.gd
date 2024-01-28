extends StaticBody2D

var opened: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func activate() -> void:
	if opened:
		animation_player.play("close")
		opened = false
	else:
		animation_player.play("open")
		opened = true
