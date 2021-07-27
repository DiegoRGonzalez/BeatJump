extends RigidBody2D


var shoot_dir = Vector2.UP;
var speed = 800;
# Called when the node enters the scene tree for the first time.
#func _ready():
#	add_central_force(-shoot_dir*100)
#	pass # Replace with function body.




func _on_Missle_body_entered(body):
	if "Player" in body.name:
		body.die();
	queue_free();


func beat():
	pass;
	apply_impulse(Vector2(), shoot_dir*speed)
