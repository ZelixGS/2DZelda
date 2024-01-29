extends AnimatedSprite2D

@onready var parent: Entity = owner
var is_paused: bool = false

func _process(_delta: float) -> void:
	if is_paused:
		pause()
	else:
		update_facing()

func update_facing() -> void:
	match parent.facing:
		"up":
			play("move_up")
		"down":
			play("move_down")
		"left":
			flip_h = true
			play("move_side")
		"right":
			flip_h = false
			play("move_side")
		_:
			play("move_side")

func _on_stunned_start_stun() -> void:
	is_paused = true

func _on_stunned_end_stun() -> void:
	is_paused = false
