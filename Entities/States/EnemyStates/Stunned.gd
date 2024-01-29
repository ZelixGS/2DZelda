class_name Stunned extends EnemyState

signal start_stun
signal end_stun

@export var stun_cooldown: float = 3.0

var stun_timer: float = 3.0

func enter() -> void:
	emit_signal("start_stun")
	stun_timer = stun_cooldown

func exit() -> void:
	emit_signal("end_stun")

func update(delta: float) -> void:
	if stun_timer > 0:
		stun_timer -= delta
	else:
		transition.emit(self, "wander")
