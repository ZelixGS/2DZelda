class_name Charge extends EnemyState

@export var speed: float = 60.0

var charge_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	parent.knocked_back.connect(_on_knocked_back)

func enter() -> void:
	charge_direction = Global.direction_to_player(parent.global_position)
	parent.facing = Global.vector_to_facing(charge_direction)

func physics_update(_delta: float) -> void:
	if parent:
		parent.velocity = charge_direction * speed
	if parent.wall_check.is_colliding():
		parent.velocity = Vector2.ZERO
		transition.emit(self, "stunned")

func random_direction() -> Vector2:
	var rng: int = randi_range(0, 3)
	match rng:
		0:
			return Vector2.UP
		1:
			return Vector2.DOWN
		2:
			return Vector2.LEFT
		3:
			return Vector2.RIGHT
	return Vector2.RIGHT

func _on_knocked_back() -> void:
	parent.velocity = Vector2.ZERO
	transition.emit(self, "stunned")
