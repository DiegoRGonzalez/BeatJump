extends KinematicBody2D

onready var smp = $StateMachinePlayer

var friction = 0.1;
var acceleration = 1;
var velocity = Vector2.ZERO
var gravity = Vector2.DOWN * 25.0
var wall_direction = 0;


func _ready():
	$WallRaycasts/LeftWallRaycasts/RayCast2D.add_exception(self)
	$WallRaycasts/LeftWallRaycasts/RayCast2D2.add_exception(self)
	$WallRaycasts/RightWallRaycasts/RayCast2D.add_exception(self)
	$WallRaycasts/RightWallRaycasts/RayCast2D2.add_exception(self)
	smp.connect("updated", self, "_on_StateMachinePlayer_updated")
	smp.connect("transited", self, "_on_StateMachine_transited")


func _physics_process(delta):
	_update_wall_direction();
	velocity += gravity
	$Sprite.flip_h = ((get_global_mouse_position() - get_global_position()).x < 0);
	match smp.current:
			"idle":
				velocity.x = lerp(velocity.x, 0, friction);
				$Sprite.rotation =-atan2(get_floor_normal().x, get_floor_normal().y)+PI;
			"jumping", "fall":
				smp.set_param("velocity_y", velocity.y)
				$Sprite.rotation = 0
			"wall_slide":
				velocity.x += wall_direction*9.8
				$Sprite.flip_h = (wall_direction == -1)
				if (velocity.y > 0):
					velocity += -0.7*gravity;
					velocity.y = min(velocity.y, 50)

	velocity = move_and_slide(velocity, Vector2.UP)
	smp.set_param("on_floor", is_on_floor())

func _unhandled_key_input(event):
#	if Input.is_action_just_pressed("ui_accept"):
#		smp.set_trigger("jump")
	pass;
		
func jump():
	var jump_pos = get_global_mouse_position() - get_global_position();
	var jump_dir = Vector2(jump_pos.x, jump_pos.y)
	
	if wall_direction != 0:
		if wall_direction == 1 and jump_dir.x > 0:
			return;
		if wall_direction == -1 and jump_dir.x < 0:
			return;
	
	velocity = jump_dir.normalized()*700  
	
func die():
	smp.set_trigger("die")

func _update_wall_direction():
	var is_near_wall_left = _check_is_valid_wall($WallRaycasts/LeftWallRaycasts)
	var is_near_wall_right = _check_is_valid_wall($WallRaycasts/RightWallRaycasts)
	
	if is_near_wall_left and is_near_wall_right:
		wall_direction = 1;
	else:
		wall_direction = -int(is_near_wall_left) + int(is_near_wall_right)
	smp.set_param("wall_direction", wall_direction)

func _check_is_valid_wall(wall_raycasts):
	
	for raycast in wall_raycasts.get_children():
		if raycast.is_colliding():
			var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
			if dot > PI*0.35 and dot < PI*0.55:
				return true;
	return false;
			


func _on_StateMachinePlayer_updated(state, delta):
	match state:
		"idle":
			$Sprite/AnimationPlayer.play("idle");
			pass
		"jump":    
			$Sprite/AnimationPlayer.play("jump");
			jump()
		"jumping":
			$Sprite/AnimationPlayer.play("jump");
			smp.set_param("velocity_y", velocity.y)
		"falling":
			$Sprite/AnimationPlayer.play("fall");
		"wall_slide":
			$Sprite/AnimationPlayer.play("wall_slide");
		"die":
			$Sprite/AnimationPlayer.play("die");

func _on_StateMachine_transited(from, to):
	match to:
		"die":
			velocity += Vector2.UP*20;
			get_parent()._fade_out();
	pass;


func _on_MixingDeskMusic_beat(beat):
	if beat % 4 == 3 || beat % 4 == 1:
		smp.set_trigger("jump")

