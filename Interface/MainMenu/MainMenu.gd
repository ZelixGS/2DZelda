extends Control

func _ready() -> void:
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_menu"):
		visible = !visible

func _on_resume_pressed() -> void:
	visible = false

func _on_settings_pressed() -> void:
	print("Settings!")

func _on_exit_pressed() -> void:
	get_tree().quit()
