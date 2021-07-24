extends "res://scenes/common/BaseUi.gd"

export(PackedScene) var level_1_scn
export(PackedScene) var level_2_scn
export(PackedScene) var level_3_scn

func _ready():
	pass;

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		if app_state:
			app_state.set_trigger("back")


func _on_level1_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_1_scn)
		app_state.set_trigger("level_selected")


func _on_level2_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_2_scn)
		app_state.set_trigger("level_selected")


func _on_level3_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_3_scn)
		app_state.set_trigger("level_selected")
