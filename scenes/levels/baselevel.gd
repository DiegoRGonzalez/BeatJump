extends Node2D


const Player = preload("res://scenes/common/Player.gd")

export(PackedScene) var next_level;
export(int) var level_num;

export(bool) var last_scene = false;

var app_state;
var end = false;

var slow_fade = false;

func slow_fadeout():
	slow_fade = true;

func _on_Area2D_body_entered(body):
	if body is Player:
		if app_state:
			if $Exit.current_level > Global.furthestCompleted:
				Global.furthestCompleted = $Exit.current_level
				Global.save();
			if(last_scene):
				app_state.set_param("game/End/win", true)
				app_state.set_trigger("game_end")
			else:
				app_state.set_trigger("next_level")
				app_state.set_param("game/next_level", next_level)
				end = true;

func end_game():
	app_state.set_param("game/End/win", true)
	app_state.set_trigger("game_end")

func _ready():
	Global.music.connect("beat", self, "_on_Music_beat")
	end = false;
	$Fade.visible = true;
	if Global.music.playing:
		if level_num >= 7 && Global.music.playing:
			if(Global.music.current_song.get_parent().name != "Song2"):
				Global.music.queue_bar_transition("Song2")
				Global.music.fade_out("Song1", 0)
		else:
			if(Global.music.current_song.get_parent().name != "Song1"):
				Global.music.queue_bar_transition("Song1")
				Global.music.fade_out("Song2", 0)
	elif !last_scene:
		if level_num >= 7:
			Global.music.quickplay("Song2")
		else:
			Global.music.quickplay("Song1")
	pass;
	
func _process(delta):
	if end:
		queue_free();
	elif slow_fade:
		$Fade.modulate.a += 0.0001;
		$Fade.modulate.a = min($Fade.modulate.a, 1)
		if $Fade.modulate.a >= 1:
			app_state.set_trigger("next_level")
			app_state.set_param("game/next_level", next_level)
			queue_free();
	else:
		$Fade.modulate.a -= 0.01;
		$Fade.modulate.a = max($Fade.modulate.a, 0)

func _fade_out():
	app_state.set_trigger("restart_level")
	if $projectiles:
		var active_projectiles = $projectiles.get_children();
		for i in range(active_projectiles.size()):
			active_projectiles[i].queue_free();
	end = true;

func _on_DeathArea2D_body_entered(body):
	if body is Player:
		body.die();

func reload():
	var crow = $Crow;
	if crow:
		crow.started = true;

func _on_Music_beat(beat):
	if(beat%4==2 || beat%4==0):
		var projectiles = get_node("projectiles")
		if projectiles:
			for projectile in projectiles.get_children():
				projectile.beat();
