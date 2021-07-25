extends "res://scenes/common/BaseUi.gd"

export(PackedScene) var level_1_scn
export(PackedScene) var level_2_scn
export(PackedScene) var level_3_scn
export(PackedScene) var level_4_scn
export(PackedScene) var level_5_scn
export(PackedScene) var level_6_scn
export(PackedScene) var level_7_scn
export(PackedScene) var level_8_scn
export(PackedScene) var level_9_scn

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


func _on_level4_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_4_scn)
		app_state.set_trigger("level_selected")


func _on_level5_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_5_scn)
		app_state.set_trigger("level_selected")
		
func _on_level6_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_6_scn)
		app_state.set_trigger("level_selected")


func _on_level7_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_7_scn)
		app_state.set_trigger("level_selected")
		
func _on_level8_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_8_scn)
		app_state.set_trigger("level_selected")


func _on_level9_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_9_scn)
		app_state.set_trigger("level_selected")
