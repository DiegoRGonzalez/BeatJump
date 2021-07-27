extends Node2D


const Player = preload("res://scenes/common/Player.gd")

export(PackedScene) var next_level;

export(bool) var last_scene = false;

var app_state;
var end = false;

func _on_Area2D_body_entered(body):
	if body is Player:
		if app_state:
			if(last_scene):
				app_state.set_param("game/End/win", true)
				app_state.set_trigger("game_end")
			else:
				app_state.set_trigger("next_level")
				app_state.set_param("game/next_level", next_level)
				end = true;

func _ready():
	end = false;
	$Fade.visible = true;
#	$MusicBox.mute(0,0)
	pass;
	
func _process(delta):
	if end:
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
	$Music.stop_all();

func _on_DeathArea2D_body_entered(body):
	if body is Player:
		body.die();

func _unhandled_key_input(event):
	if Input.is_action_just_pressed("mute"):
		$Music.mute("EDM","EDM")


func _on_Music_beat(beat):
	if(beat%4==1 || beat%4==3):
		var projectiles = get_node("projectiles")
		if projectiles:
			for projectile in projectiles.get_children():
				projectile.beat();
