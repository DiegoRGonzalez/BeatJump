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
	pass;
	
func _process(delta):
	if end:
		queue_free();
	else:
		$Fade.modulate.a -= 0.01;
		$Fade.modulate.a = max($Fade.modulate.a, 0)

func _fade_out():
	app_state.set_trigger("restart_level")
	end = true;
	$MusicBox.stop(0)


func _on_DeathArea2D_body_entered(body):
	if body is Player:
		body.die();

func _unhandled_key_input(event):
	if Input.is_action_just_pressed("mute"):
		$MusicBox.mute(0,0)
