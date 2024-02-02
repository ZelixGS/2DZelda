extends CollisionShape2D

@onready var player: Player = owner

func _physics_process(_delta: float) -> void:
	set_deferred("disabled", not player.is_blocking())
