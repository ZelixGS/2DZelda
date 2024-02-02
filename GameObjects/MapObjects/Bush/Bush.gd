class_name Bush extends GameObject

var grass: int = 0
var cut: int = 1
var burned: int = 2
var burned_cut: int = 3

@onready var health: Health = $Health

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurtbox: Hurtbox = $Hurtbox

func _on_health_died() -> void:
	sprite_2d.frame = cut
	disable_collision()
	hurtbox.disable()

func additional_reset() -> void:
	sprite_2d.frame = grass
	enable_collision()
	hurtbox.enable()
	health.current_health = 1
