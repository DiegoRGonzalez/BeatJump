extends Control

var app_state;


func _ready():
	Global.paused = true;
	$HSlider.value = Global.volume;
	$Muted.pressed = Global.muted;
	pass;

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		if app_state:
			get_tree().set_input_as_handled() # Must be set as handled, as Game.gd also listening same input
			app_state.set_trigger("continue")


func _process(delta):
	$Muted.pressed = Global.muted;
	Global.volume = $HSlider.value;

func _on_quit_pressed():
	Global.paused = false;
	if app_state:
		get_tree().paused = false
		app_state.set_trigger("quit")
		Global.save();


func _on_continue_pressed():
	Global.paused = false;
	if app_state:
		get_tree().paused = false
		app_state.set_trigger("continue")
		Global.save();


func _on_Muted_toggled(button_pressed):
	Global.muted = button_pressed;
	pass # Replace with function body.
