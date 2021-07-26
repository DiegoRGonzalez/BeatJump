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
var falling_count = 0;
var floor_normal = Vector2.UP;

var using_joystick = false;

var last_mouse = Vector2.ZERO;

func _ready():
	$WallRaycasts/LeftWallRaycasts/RayCast2D.add_exception(self)
	$WallRaycasts/LeftWallRaycasts/RayCast2D2.add_exception(self)
	$WallRaycasts/RightWallRaycasts/RayCast2D.add_exception(self)
	$WallRaycasts/RightWallRaycasts/RayCast2D2.add_exception(self)
	$FloorRaycasts/RayCast2D.add_exception(self)
	$FloorRaycasts/RayCast2D2.add_exception(self)
	smp.connect("updated", self, "_on_StateMachinePlayer_updated")
	smp.connect("transited", self, "_on_StateMachine_transited")


func _physics_process(delta):
	_update_wall_direction();
	_update_jump_direction();
	$Sprite.flip_h = ((get_global_mouse_position() - get_global_position()).x < 0);
	velocity += gravity;
	match smp.current:
			"idle":
				if(get_floor_normal() != Vector2.ZERO):
					$Sprite.rotation =-atan2(get_floor_normal().x, get_floor_normal().y)+PI;
			"jumping", "fall":
				smp.set_param("velocity_y", velocity.y)
				$Sprite.rotation = 0
			"wall_slide":
				velocity.x += wall_direction*10
				$Sprite.flip_h = (wall_direction == -1)
				position += wall_velocity*delta
				if (velocity.y > 0):
					velocity += -0.2*gravity;
					velocity.y = min(velocity.y, 5)
	var going_down = velocity.y > 0;
	velocity = move_and_slide(velocity, Vector2.UP)
	if(get_floor_velocity().length() > 0):
		position += get_floor_velocity()*delta;
	if _check_is_valid_floor($FloorRaycasts) && going_down:
		velocity.x = lerp(velocity.x, 0, friction);
	smp.set_param("on_floor", _check_is_valid_floor($FloorRaycasts))
		


func _unhandled_key_input(event):
	pass;
#	jump();

		
func jump(mod=1):
	print("Jump: " + str(OS.get_system_time_msecs()))
	var jump_speed = 700*mod;
	var jump_vel = jump_dir*jump_speed;
	if wall_direction != 0:
		if wall_direction == 1 and jump_dir.x > 0:
			jump_vel *= -0.5;
			jump_dir  *= -1;
		elif wall_direction == -1 and jump_dir.x < 0:
			jump_vel *= -0.5;
			jump_dir  *= -1;
		else:
			jump_vel += Vector2.RIGHT*-1*wall_direction*200;
	if smp.get_param("on_floor") && jump_dir.y > 0:
		jump_vel *= -0.5;
		jump_dir  *= -1;
		
	if smp.current == "wall_slide":
		jump_vel += Vector2.RIGHT*-1*wall_direction*500;
	jump_vel.x *= 0.8


#	jump_vel.x *= 1.3
	velocity += jump_vel
	print(velocity.length());
	position += jump_dir.normalized();
	if(get_floor_velocity().y < 0):
		position.y -= 5
	
func die():
	smp.set_trigger("die")
	
func _update_jump_direction():
	var joystick;
	if Input.get_connected_joypads().size() > 0:
		joystick =  Vector2(Input.get_joy_axis(0, JOY_AXIS_0), Input.get_joy_axis(0, JOY_AXIS_1))
	if joystick and joystick.length() > 0.5:
		jump_dir = joystick;
		using_joystick = true;
	elif using_joystick && abs(1-(get_global_mouse_position() - get_global_position()).normalized().dot(last_mouse.normalized())) > 0.1:
		using_joystick = false
	else:
		jump_dir = Vector2.UP
	print(get_global_mouse_position().normalized().dot(last_mouse.normalized()));
	if (!using_joystick):
		jump_dir = get_global_mouse_position() - get_global_position();
	last_mouse = (get_global_mouse_position() - get_global_position())
	jump_mag = jump_dir.length()
	jump_dir = jump_dir.normalized();
	$JumpDotLong.position = jump_dir*70
	if abs(1-Vector2.UP.dot(jump_dir)) < 0.01:
		jump_dir = Vector2.UP;
	$JumpDotLong2.position = jump_dir*70
func _update_wall_direction():
	var wall_velocity = Vector2.ZERO
	var is_near_wall_left = _check_is_valid_wall($WallRaycasts/LeftWallRaycasts)
	var is_near_wall_right = _check_is_valid_wall($WallRaycasts/RightWallRaycasts)
	
	var old_wall_direction = wall_direction;
	if is_near_wall_left and is_near_wall_right:
		wall_direction = 1;
	else:
		wall_direction = -int(is_near_wall_left) + int(is_near_wall_right)
	smp.set_param("wall_direction", wall_direction)
	
	if (wall_direction == 0 && old_wall_direction != 0):
		velocity.x += old_wall_direction*100;
	
	if (wall_direction != 0 && !_check_is_valid_wall($WallRaycasts/TopWallRaycasts)):
		print("near top")
		if(velocity.y < 5):
			velocity += Vector2.UP*40
			velocity.y = min(velocity.y, 450)
			velocity.x = min(velocity.x, 300)

func _check_is_valid_wall(wall_raycasts):
	if _check_is_valid_floor():
		return false;
	for raycast in wall_raycasts.get_children():
		if raycast.is_colliding() && not "Missle" in raycast.get_collider().name:
			var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
			if dot > PI*0.35 and dot < PI*0.55:
				wall_velocity = raycast.get_collider().constant_linear_velocity;
				return true;
	return false;

func _check_is_valid_floor(floor_raycasts=$FloorRaycasts):
	for raycast in floor_raycasts.get_children():
		if raycast.is_colliding() && not "Missle" in raycast.get_collider().name:
			var dot = Vector2.UP.dot(raycast.get_collision_normal())
			if abs(1 - dot) < 0.3:
				floor_normal = raycast.get_collision_normal()
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
			smp.set_param("velocity_y", velocity.y)
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
		if smp.current == "falling" or smp.current == "jumping":
			if(velocity.y > 0):
				velocity.y *= 0.1
				velocity.x *= 0.5
			jump(0.5)
		$JumpDotLong.scale = Vector2(1,1);
		$Sprite/Beat.play("Beat")
