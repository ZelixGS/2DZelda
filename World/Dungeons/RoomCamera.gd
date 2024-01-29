class_name RoomCamera extends Camera2D

@export_category("Camera Smoothing")
@export var smoothing_enabled: bool
@export_range(1, 10) var smoothing_distance : int = 8

@export var player: Player

var weight: float

func _ready() -> void:
	Events.connect("update_camera", update_camera_stuff)
	player = Global.get_player()
	weight = float(11 - smoothing_distance) / 100
	
func _physics_process(_delta: float) -> void:
	if not player:
		return
		
	var camera_position: Vector2
	if smoothing_enabled:
		camera_position = lerp(global_position, player.global_position, weight)
	else:
		camera_position = player.global_position
	global_position = camera_position.floor()

# Expects Array of [x, y, w, l]
func update_camera_stuff(size: Array) -> void:
	#print("Entering Room: %s" % size)
	limit_left = size[0]
	limit_top = size[1]
	limit_right = size[2]
	limit_bottom = size[3]
