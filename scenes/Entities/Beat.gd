extends Node2D


var beatBall = preload("res://scenes/Entities/BeatBall.tscn")

export(Vector2) var shoot_dir = Vector2.RIGHT
export(int) var beat_offset = 0;
var bullet_speed = 1200;

var viewport;
# Called when the node enters the scene tree for the first time.
func _ready():
	viewport = get_viewport();
	Global.music.connect("beat", self, "_on_Music_beat")	
	pass # Replace with function body.

func fire():
	var missle_instance = beatBall.instance()
	missle_instance.position = Vector2(10,get_viewport_rect().size.y - 30)
	get_parent().add_child(missle_instance)
	


func _on_Missle_body_entered(body):
	if "Player" in body.name:
		body.die();
	


func _on_Music_beat(beat):
	print("fire")
	fire();
	pass # Replace with function body.
