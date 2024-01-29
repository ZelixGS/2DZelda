extends AnimatableBody2D

func reset_children() -> void:
	for child: Node2D in get_children():
		if child.has_method("reset"):
			child.reset()
