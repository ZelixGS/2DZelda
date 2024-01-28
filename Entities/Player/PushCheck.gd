extends RayCast2D

@onready var state_machine: Node = $"../../StateMachine"

@export var pushing_length: float = 1.0
@onready var pushing: Timer = $Pushing

var player: Player = null

func _ready() -> void:
	player = owner

func _physics_process(_delta: float) -> void:
	if state_machine.state != "pushing" and not pushing.is_stopped():
		pushing.stop()
	
	if state_machine.state == "pushing" and pushing.is_stopped():
		pushing.start(pushing_length)

func _on_pushing_timeout() -> void:
	if state_machine.state != "pushing":
		return
		
	var collider: Pushable = get_collider()
	if collider:
		var direction: Vector2 = global_position.direction_to(collider.global_position).snapped(Vector2(1,1))
		collider.push(direction)
