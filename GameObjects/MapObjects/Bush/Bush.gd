extends AnimatableBody2D

var unburned_uncut_region: Rect2 = Rect2(0, 176, 16, 16)
var unburned_cut_region: Rect2 = Rect2(80, 208, 16, 16)
var burned_uncut_region: Rect2 = Rect2(80, 192, 16, 16)
var burned_cut_region: Rect2 = Rect2(96, 192, 16, 16)

@onready var health: Health = $Health

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	reset()
	
func _on_health_died() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	sprite_2d.region_rect = unburned_cut_region

func reset() -> void:
	sprite_2d.region_rect = unburned_uncut_region
	collision_shape_2d.set_deferred("disabled", false)
	health.current_health = 1
