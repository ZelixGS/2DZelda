extends CanvasModulate

@export var default_color: Color = Color.WHITE

func _ready() -> void:
	color = default_color

func transition_color(new_color: Color, speed: float = 0.25) -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "color", new_color, speed)

func reset(speed: float = 0.25) -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "color", default_color, speed)
