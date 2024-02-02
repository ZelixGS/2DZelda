class_name Enemy extends Entity

signal disabled

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var state_machine: StateMachine = $StateMachine
@onready var health: Health = $Health
@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var wall_check: RayCast2D = $RotationHelper/WallCheck

var starting_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	if health:
		health.connect("died", _on_death)
	starting_position = global_position

func enable() -> void:
	if state_machine:
		state_machine.disabled = false
		state_machine.current_state = state_machine.initial_state

func disable() -> void:
	emit_signal("disabled")
	visible = false
	velocity = Vector2.ZERO
	if collision_shape_2d:
		collision_shape_2d.set_deferred("disabled", true)
	if state_machine:
		state_machine.disabled = true
	if hitbox:
		hitbox.disable()
	if hurtbox:
		hurtbox.disable()
	
func reset() -> void:
	visible = true
	global_position = starting_position
	if animated_sprite_2d:
		animated_sprite_2d.is_paused = false
	if health:
		health.current_health = health.max_health
	if collision_shape_2d:
		collision_shape_2d.set_deferred("disabled", false)
	if hitbox:
		hitbox.enable()
	if hurtbox:
		hurtbox.enable()

func _on_death() -> void:
	disable()
