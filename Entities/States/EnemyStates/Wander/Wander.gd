class_name Wander extends State

@export var enemy: CharacterBody2D
@export var speed: float = 20.0

@export var min_distance: float = -1.0
@export var max_distance: float = 1.0

@export var min_time: float = 1.0
@export var max_time: float = 3.0

var move_direction: Vector2
var wander_time: float

func randomize_wander() -> void:
	move_direction = Vector2(randf_range(min_distance,max_distance), randf_range(min_distance,max_distance)).normalized()
	wander_time = randf_range(min_time, max_time)

func enter() -> void:
	randomize_wander()

func update(delta: float) -> void:
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
		
func physics_update(_delta: float) -> void:
	if enemy:
		enemy.velocity = move_direction * speed
