extends "res://scenes/common/BaseUi.gd"



func _on_quit_pressed():
	app_state.set_trigger("quit")


func _on_start_pressed():
	app_state.set_trigger("start_game")
