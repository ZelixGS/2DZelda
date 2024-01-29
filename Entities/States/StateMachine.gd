class_name StateMachine extends Node

@export var initial_state: State

@onready var parent: CharacterBody2D = owner
@onready var player: Player = Global.get_player()

var current_state: State
var states: Dictionary = {}

var disabled: bool = false

func _ready() -> void:
	for child: Node in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(on_child_transition)
			
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if disabled:
		return
		
	if current_state:
		current_state.update(delta)
		
func _physics_process(delta: float) -> void:
	if disabled:
		return
		
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(state: State, new_state_name: String) -> void:
	#print("[%s] State Change: %s -> %s" % [owner.name, state.name.to_lower(), new_state_name.to_lower()])
	if state != current_state:
		return
	
	var new_state: State = states.get(new_state_name.to_lower())
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
