class_name Health extends Node

signal health_changed(current: int, max: int)
signal damaged(amount: int, force: float, knockback_pos: Vector2)
signal healed(amount: int)
signal died

@export var max_health: int = 10
@export var damage_cooldown: float = 0.2
@export_group("Options")
#@export var drop_component: DropComponent
@export var death_effect: PackedScene
@export_subgroup("Flash")
@export var can_flash: bool = true
@export var flash_damage: Color = Color.RED
@export var flash_heal: Color = Color.GREEN
@export_subgroup("Debug")
@export var god_mode: bool = false

var parent: Node2D
var current_health: int = 0
var flash_tween: Tween

@onready var damage_timer: Timer = $Timer

func _ready() -> void:
	parent = owner
	current_health = max_health
	emit_signal("health_changed")

func change_health(amount: int, knockback_force: float, knockback_pos: Vector2) -> void:
	if god_mode:
		return
	if amount < 0:
		heal(amount)
	else:
		damage(amount, knockback_force, knockback_pos)
	emit_signal("health_changed", current_health, max_health)

func heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
	emit_signal("healed", amount)
	flash(flash_heal)

func damage(amount: int, knockback_force: float, knockback_pos: Vector2) -> void:
	if not damage_timer.is_stopped():
		return
	current_health = max(current_health - amount, 0)
	damage_timer.start(damage_cooldown)
	if current_health > 0:
		emit_signal("damaged", amount)
		if parent.has_method("apply_knockback"):
			parent.apply_knockback(knockback_force, knockback_pos)
		flash(flash_damage)
	if current_health == 0:
		death()

func death() -> void:
	died.emit()
	#if drop_component:
		#drop_component.drop()
	if death_effect:
		Create.particle_to_world(death_effect, parent.global_transform)

func flash(flash_color: Color) -> void:
	if flash_tween && flash_tween.is_running():
		return
	flash_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	flash_tween.tween_property(owner, "modulate", flash_color, 0.25)
	flash_tween.tween_property(owner, "modulate", Color.WHITE, 0.25)
