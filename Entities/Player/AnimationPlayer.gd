extends AnimationPlayer

@onready var player: Player = $".."
@onready var state_machine: Node = $"../StateMachine"

var current_state: String = "idle"
var current_direction: String = "down"

var cur_animation: String = ""
var pre_animation: String = ""

var one_shot_animations: PackedStringArray = [
	"lift",
	"swing"
]

func _ready() -> void:
	player = owner

func _process(_delta: float) -> void:
	update_state()
	
func update_state() -> void:
	if is_playing() and one_shot_animations.has(cur_animation):
		return
	current_state = state_machine.state
	match current_state:
		"idle":
			if player.is_carrying():
				advance_play("carry_idle")
			elif player.has_shield:
				if player.is_blocking():
					advance_play("block_idle")
				else:
					advance_play("shield_idle")
			else:
				advance_play("idle")
		"moving":
			if player.is_carrying():
				advance_play("carry_move")
			elif player.has_shield:
				if player.is_blocking():
					advance_play("block_move")
				else:
					advance_play("shield_move")
			else:
				advance_play("move")
		"pushing":
			advance_play("push")

func advance_play(anim_name: String, wait: bool = false, speed: float = 1.0, reversed: bool = false) -> void:
	var mod_name: String = "%s_%s" % [anim_name, player.facing]
	if current_animation == mod_name:
		return
	stop(true)
	if wait and not one_shot_animations.has(anim_name):
		one_shot_animations.append(anim_name)
	pre_animation = cur_animation
	cur_animation = anim_name
	if reversed:
		play_backwards(mod_name)
	else:
		play(mod_name, speed)
