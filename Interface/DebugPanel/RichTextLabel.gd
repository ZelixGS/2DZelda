extends Label

var player: Player

func _ready() -> void:
	player = Global.get_player()
	if not player:
		printerr("Couldn't find Player")
		queue_free()

func _process(_delta: float) -> void:
	update()
	
func update() -> void:
	text = "%s\n%s\n%s" % [get_fps(), get_axis(), player.get_real_velocity()]

func get_fps() -> String:
	return "FPS: %s" % Engine.get_frames_per_second()

func get_axis() -> String:
	return "Axis: %.2f,%.2f" % [player.direction.x, player.direction.y]
