extends Control

var app_state;


func _ready():
	pass;

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		if app_state:
			get_tree().set_input_as_handled() # Must be set as handled, as Game.gd also listening same input
			app_state.set_trigger("continue")


func _process(delta):
	Global.volume = $HSlider.value;

func _on_quit_pressed():
	if app_state:
		get_tree().paused = false
		app_state.set_trigger("quit")


func _on_continue_pressed():
	if app_state:
		get_tree().paused = false
		app_state.set_trigger("continue")
