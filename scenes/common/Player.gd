extends KinematicBody2D

onready var smp = $StateMachinePlayer

var friction = 0.4;
var acceleration = 1;
var velocity = Vector2.ZERO
var gravity = Vector2.DOWN * 25.0
var wall_direction = 0;
var wall_velocity = Vector2.ZERO;
var jump_mag;
var jump_dir;

func _ready():
	$WallRaycasts/LeftWallRaycasts/RayCast2D.add_exception(self)
	$WallRaycasts/LeftWallRaycasts/RayCast2D2.add_exception(self)
	$WallRaycasts/RightWallRaycasts/RayCast2D.add_exception(self)
	$WallRaycasts/RightWallRaycasts/RayCast2D2.add_exception(self)
	smp.connect("updated", self, "_on_StateMachinePlayer_updated")
	smp.connect("transited", self, "_on_StateMachine_transited")


func _physics_process(delta):
	_update_wall_direction();
	_update_jump_direction();
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
				velocity.x += wall_direction*5
				$Sprite.flip_h = (wall_direction == -1)
				position += wall_velocity*delta
				if (velocity.y > 0):
					velocity += -0.2*gravity;
					velocity.y = min(velocity.y, 10)
	velocity = move_and_slide(velocity, Vector2.UP)
	smp.set_param("on_floor", is_on_floor())


func _unhandled_key_input(event):
	jump();

		
func jump():
	if wall_direction != 0:
		if wall_direction == 1 and jump_dir.x > 0:
			return;
		if wall_direction == -1 and jump_dir.x < 0:
			return;
	
	if(true):
		velocity += jump_dir*700
		if(get_floor_velocity().y < 0):
			position.y -= 5
			print("adjust")
#			velocity += 2*get_floor_velocity()
	else:
		velocity += jump_dir*300+get_floor_velocity()
	
func die():
	smp.set_trigger("die")
	
func _update_jump_direction():
	$JumpDotLong.visible = false;
	$JumpDotShort.visible = false;
	jump_dir = get_global_mouse_position() - get_global_position();
	jump_mag = jump_dir.length()
	jump_dir = jump_dir.normalized();
	if(true):
		$JumpDotLong.position = jump_dir*70
		$JumpDotLong.visible =true;
		$JumpDotShort.visible = false;
	else:
		$JumpDotShort.position = jump_dir*25
		$JumpDotShort.visible =true;
		$JumpDotLong.visible = false;

func _update_wall_direction():
	var wall_velocity = Vector2.ZERO
	var is_near_wall_left = _check_is_valid_wall($WallRaycasts/LeftWallRaycasts)
	var is_near_wall_right = _check_is_valid_wall($WallRaycasts/RightWallRaycasts)
	
	if is_near_wall_left and is_near_wall_right:
		wall_direction = 1;
	else:
		wall_direction = -int(is_near_wall_left) + int(is_near_wall_right)
	smp.set_param("wall_direction", wall_direction)
	print(wall_velocity)

func _check_is_valid_wall(wall_raycasts):
	
	for raycast in wall_raycasts.get_children():
		if raycast.is_colliding():
			var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
			if dot > PI*0.35 and dot < PI*0.55:
				wall_velocity = raycast.get_collider().constant_linear_velocity;
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

func _on_Music_beat(beat):
	if beat % 4 == 3 || beat % 4 == 1:
		smp.set_trigger("jump")
