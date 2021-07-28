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
export(PackedScene) var level_10_scn

func _ready():
	Global.load();
	print(Global.furthestCompleted)
	$PanelContainer/Control2/level2.visible = Global.furthestCompleted >= 1
	$PanelContainer/Control2/level3.visible = Global.furthestCompleted >= 2
	$PanelContainer/Control2/level4.visible = Global.furthestCompleted >= 3
	$PanelContainer/Control2/level5.visible = Global.furthestCompleted >= 4
	$PanelContainer/Control2/level6.visible = Global.furthestCompleted >= 5
	$PanelContainer/Control2/level7.visible = Global.furthestCompleted >= 6
	$PanelContainer/Control2/level8.visible = Global.furthestCompleted >= 7
	$PanelContainer/Control2/level9.visible = Global.furthestCompleted >= 8
	$PanelContainer/Control2/level10.visible = Global.furthestCompleted >= 9
		
	$PanelContainer/Control2/level2.disabled = Global.furthestCompleted < 1
	$PanelContainer/Control2/level3.disabled = Global.furthestCompleted < 2
	$PanelContainer/Control2/level4.disabled = Global.furthestCompleted < 3
	$PanelContainer/Control2/level5.disabled = Global.furthestCompleted < 4
	$PanelContainer/Control2/level6.disabled = Global.furthestCompleted < 5
	$PanelContainer/Control2/level7.disabled = Global.furthestCompleted < 6
	$PanelContainer/Control2/level8.disabled = Global.furthestCompleted < 7
	$PanelContainer/Control2/level9.disabled = Global.furthestCompleted < 8
	$PanelContainer/Control2/level10.disabled = Global.furthestCompleted < 9
	

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		if app_state:
			app_state.set_trigger("back")
	if event.is_action_pressed("cheat"):
		Global.furthestCompleted += 1;
		_ready()

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


func _on_level10_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_10_scn)
		app_state.set_trigger("level_selected")
