extends RigidBody2D


var shoot_dir = Vector2.UP;
var speed = 800;

func _on_Missle_body_entered(body):
	if "Player" in body.name:
		body.die();
	queue_free();


func beat():
	pass;
	apply_impulse(Vector2(), shoot_dir*speed)
