extends Node2D


var missle = preload("res://scenes/Entities/Missle.tscn")

export(Vector2) var shoot_dir = Vector2.RIGHT
export(int) var beat_offset = 0;
var bullet_speed = 800;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fire():
	var missle_instance = missle.instance()
	missle_instance.position = get_global_position()
	missle_instance.shoot_dir = shoot_dir;
	missle_instance.apply_impulse(Vector2(), shoot_dir*bullet_speed)
	get_tree().get_root().find_node("projectiles", true, false).call_deferred("add_child", missle_instance)
	


func _on_Missle_body_entered(body):
	if "Player" in body.name:
		body.die();
	


func _on_Music_beat(beat):
	if beat%4 == 0+beat_offset:
		fire();
	pass # Replace with function body.
