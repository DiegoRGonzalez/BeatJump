extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tick = 0;
export(bool) var moving = true;
export(Vector2) var moveDirection = Vector2.UP;
export(int) var move_period = 16
export(int) var speed = 300;
export(Vector2) var velocity_mod = Vector2(1,1);

var curBeat = 0;
var startBeat;
var started = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.music.connect("beat", self, "_on_Music_beat")
	pass # Replace with function body.



func _process(delta):
	tick+=1;
	if moving and started:
		if curBeat%move_period >= move_period/2:
			$StaticBody2D.position += moveDirection*speed*delta
			$StaticBody2D.constant_linear_velocity = 1*moveDirection*speed
		else:
			$StaticBody2D.position -= moveDirection*speed*delta
			$StaticBody2D.constant_linear_velocity = -1*moveDirection*speed
		$StaticBody2D.constant_linear_velocity.x *= velocity_mod.x;
		$StaticBody2D.constant_linear_velocity.y *= velocity_mod.y;



func _on_Music_beat(beat):
	if not started:
		startBeat = beat;
		beat = 2;
		started = true;
	curBeat += 1;
