extends "res://scenes/common/BaseUi.gd"

export(PackedScene) var level_outside_scn
export(PackedScene) var level_vanilla1_scn
export(PackedScene) var level_vanilla2_scn
export(PackedScene) var level_vanilla3_scn
export(PackedScene) var level_bullet1_scn
export(PackedScene) var level_bullet2_scn
export(PackedScene) var level_platform1_scn
export(PackedScene) var level_platform2_scn
export(PackedScene) var level_mixed1_scn
export(PackedScene) var level_wizard_scn
export(PackedScene) var level_wizard_post_scn

func update_buttons():
	$PanelContainer/Control2/LevelVanilla1.visible = Global.furthestCompleted >= 1
	$PanelContainer/Control2/LevelVanilla2.visible = Global.furthestCompleted >= 2
	$PanelContainer/Control2/LevelVanilla3.visible = Global.furthestCompleted >= 3
	$PanelContainer/Control2/LevelPlatform1.visible = Global.furthestCompleted >= 4
	$PanelContainer/Control2/LevelPlatform2.visible = Global.furthestCompleted >= 5
	$PanelContainer/Control2/LevelBullet1.visible = Global.furthestCompleted >= 6
	$PanelContainer/Control2/LevelBullet2.visible = Global.furthestCompleted >= 7
	$PanelContainer/Control2/LevelMixed1.visible = Global.furthestCompleted >= 8
	$PanelContainer/Control2/LevelWizard.visible = Global.furthestCompleted >= 9
		
	$PanelContainer/Control2/LevelVanilla1.disabled = Global.furthestCompleted < 1
	$PanelContainer/Control2/LevelVanilla2.disabled = Global.furthestCompleted < 2
	$PanelContainer/Control2/LevelVanilla3.disabled = Global.furthestCompleted < 3
	$PanelContainer/Control2/LevelPlatform1.disabled = Global.furthestCompleted < 4
	$PanelContainer/Control2/LevelPlatform2.disabled = Global.furthestCompleted < 5
	$PanelContainer/Control2/LevelBullet1.disabled = Global.furthestCompleted < 6
	$PanelContainer/Control2/LevelBullet2.disabled = Global.furthestCompleted < 7
	$PanelContainer/Control2/LevelMixed1.disabled = Global.furthestCompleted < 8
	$PanelContainer/Control2/LevelWizard.disabled = Global.furthestCompleted < 9
	
	#Debug:
	$PanelContainer/Control2/LevelWizardPost.disabled = false
	$PanelContainer/Control2/LevelWizardPost.visible = false
	if(Global.music.playing):
		return;
	if Global.furthestCompleted < 8:
		Global.music.quickplay("Song1");
	else:
		Global.music.quickplay("Song2");
	

func _ready():
	Global.load();
	print(Global.furthestCompleted)
	update_buttons();


func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		if app_state:
			app_state.set_trigger("back")
	if event.is_action_pressed("cheat"):
		Global.furthestCompleted += 1;
		update_buttons();
	if event.is_action_pressed("cheatdown"):
		Global.furthestCompleted -= 1;
		update_buttons();

func _on_LevelOutside_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_outside_scn)
		app_state.set_trigger("level_selected")


func _on_LevelVanilla1_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_vanilla1_scn)
		app_state.set_trigger("level_selected")


func _on_LevelVanilla2_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_vanilla2_scn)
		app_state.set_trigger("level_selected")


func _on_LevelVanilla3_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_vanilla3_scn)
		app_state.set_trigger("level_selected")


func _on_LevelBullet1_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_bullet1_scn)
		app_state.set_trigger("level_selected")


func _on_LevelBullet2_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_bullet2_scn)
		app_state.set_trigger("level_selected")


func _on_LevelPlatform1_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_platform1_scn)
		app_state.set_trigger("level_selected")


func _on_LevelPlatform2_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_platform2_scn)
		app_state.set_trigger("level_selected")


func _on_LevelMixed1_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_mixed1_scn)
		app_state.set_trigger("level_selected")


func _on_LevelWizard_pressed():
	if app_state:
		app_state.set_param("game/level_scn", level_wizard_scn)
		app_state.set_trigger("level_selected")


func _on_LevelWizardPost_pressed():
	Global.music.stop("Song2")
	if app_state:
		app_state.set_param("game/level_scn", level_wizard_post_scn)
		app_state.set_trigger("level_selected")
	pass # Replace with function body.
