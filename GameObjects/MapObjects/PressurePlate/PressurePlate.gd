extends Area2D

@export_enum("Circle", "Square") var design: String = "Circle"

@export var to_activate: Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	if design == "Square":
		sprite_2d.frame_coords.x = 1
	if not to_activate:
		printerr("%s is missing object to activate." % name)
		return
	if not to_activate.has_method("activate"):
		printerr("%s is missing 'activate' method." % to_activate.name)


func entered() -> void:
	if to_activate and to_activate.has_method("activate"):
		to_activate.activate()
	sprite_2d.frame_coords.y = clamp(sprite_2d.frame_coords.y + 1, 0, 1)

func exited() -> void:
	if to_activate and to_activate.has_method("activate"):
		to_activate.activate()
	sprite_2d.frame_coords.y = clamp(sprite_2d.frame_coords.y - 1, 0, 1)

func _on_area_entered(_area: Area2D) -> void:
	entered()
	
func _on_body_entered(_body: Node2D) -> void:
	entered()

func _on_area_exited(_area: Area2D) -> void:
	exited()
	
func _on_body_exited(_body: Node2D) -> void:
	exited()
