extends Area2D

static var default_room_size: Vector2 = Vector2(272, 176)
@export var room_size: Vector2 = Vector2(272, 176)
var grid_position: Vector2 = Vector2.ZERO

@onready var canvas_modulate: CanvasModulate = $"../CanvasModulate"
@export var canvas_color: Color = Color.WHITE

@export var kill_count: int = -1
var kill_counter: int = 0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	grid_position = (global_position / room_size).floor()
	#collision_shape_2d.shape.size = room_size

func enable_children() -> void:
	for child: Node2D in get_children():
		if child.has_method("enable"):
			child.enable()
			
func reset_children() -> void:
	for child: Node2D in get_children():
		if child.has_method("reset"):
			child.reset()

func calculate_size() -> Array[float]:
	var size: Array[float] = []
	size.append(room_size.x * grid_position.x)
	size.append(room_size.y * grid_position.y)
	size.append(room_size.x * (grid_position.x + 1))
	size.append(room_size.y * (grid_position.y + 1))
	return size

func _on_body_entered(_body: Node2D) -> void:
	Events.emit_signal("update_camera", calculate_size())
	Global.get_player().clamp_to_room(calculate_size())
	enable_children()
	if canvas_modulate.has_method("transition_color") and canvas_color != Color.WHITE:
		canvas_modulate.transition_color(canvas_color)

func _on_body_exited(_body: Node2D) -> void:
	if canvas_modulate.has_method("reset") and canvas_color != Color.WHITE:
		canvas_modulate.reset()
	reset_children()
