extends AnimatedSprite2D

var player: Player = null

var current_state: String = "idle"
var current_direction: String = "down"

var current_animation: String = ""
var previous_animation: String = ""

var one_shot_animations: PackedStringArray = [
	"lift",
	"swing"
]

func _ready() -> void:
	player = owner

func _process(_delta: float) -> void:
	update_state()
	
func update_state() -> void:
	if is_playing() and one_shot_animations.has(current_animation):
		return
	current_state = player.state
	match current_state:
		"idle":
			if player.is_carrying():
				advance_play("carry_idle")
			else:
				advance_play("idle")
		"moving":
			if player.is_carrying():
				advance_play("carry_move")
			else:
				advance_play("move")
		"pushing":
			advance_play("push")

func advance_play(anim_name: String, wait: bool = false, speed: float = 1.0, reversed: bool = false) -> void:
	var mod_name: String = "%s_%s" % [anim_name, player.get_direction()]
	if wait and not one_shot_animations.has(anim_name):
		one_shot_animations.append(anim_name)
	previous_animation = current_animation
	current_animation = anim_name
	if reversed:
		play_backwards(mod_name)
	else:
		play(mod_name, speed)
