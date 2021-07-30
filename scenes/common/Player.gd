extends KinematicBody2D

onready var smp = $StateMachinePlayer

var friction = 0.8;
var wall_friction = 0.8
var acceleration = 1;
var velocity = Vector2.ZERO
var gravity = Vector2.DOWN * 25.0
var wall_direction = 0;
var wall_velocity = Vector2.ZERO;
var jump_mag;
var jump_dir;
var falling_count = 0;
var floor_normal = Vector2.UP;
var talking = false;

var end = false;

var using_joystick = false;
var last_jump_time = OS.get_system_time_msecs()

var last_mouse = Vector2.ZERO;

func _ready():
	Global.camera = $Camera2D
	Global.player = self;
	$Sprite.position = Vector2.ZERO;
	$Sprite.z_index = 0;
	$WallRaycasts/LeftWallRaycasts/RayCast2D.add_exception(self)
	$WallRaycasts/LeftWallRaycasts/RayCast2D2.add_exception(self)
	$WallRaycasts/RightWallRaycasts/RayCast2D.add_exception(self)
	$WallRaycasts/RightWallRaycasts/RayCast2D2.add_exception(self)
	$FloorRaycasts/RayCast2D.add_exception(self)
	$FloorRaycasts/RayCast2D2.add_exception(self)
	smp.connect("updated", self, "_on_StateMachinePlayer_updated")
	smp.connect("transited", self, "_on_StateMachine_transited")
	Global.music.connect("beat", self, "_on_Music_beat")
	
	if(get_parent().last_scene):
		$JumpDotLong.visible = false;
		$Sprite.flip_h = false;


func _physics_process(delta):
	_update_wall_direction();
	_update_jump_direction();
	smp.set_param("end", end);
	if(!get_parent().last_scene):
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
				$Sprite.flip_h = (wall_direction == -1)
				# Wall Friction
				if (velocity.y > 0 && OS.get_system_time_msecs() - last_jump_time > 60):
					velocity.y = lerp(velocity.y, 0, wall_friction)
					position += wall_velocity*delta
					velocity.x += wall_direction*5
			"die":
				velocity = Vector2.ZERO;
	var going_down = velocity.y > 0;
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if(get_floor_velocity().length() > 0):
		position += get_floor_velocity()*delta;
	
	# Floor Friction
	if _check_is_valid_floor($FloorRaycasts) && going_down:
		velocity.x = lerp(velocity.x, 0, friction);
	
	# On Floor
	smp.set_param("on_floor", _check_is_valid_floor($FloorRaycasts))
		


func _unhandled_key_input(event):
	pass;
#	jump();

		
func jump(mod=1):
	if Global.paused:
		return;
	last_jump_time = OS.get_system_time_msecs()
	velocity = Vector2.ZERO;
	print("Jump: " + str(OS.get_system_time_msecs()))
	if wall_direction != 0:
		if !_check_is_valid_wall($WallRaycasts/TopWallRaycasts):
			print("boostin")
		elif (wall_direction == 1 and jump_dir.x > 0) or (wall_direction == -1 and jump_dir.x < 0):
			jump_dir.x *= -1

	var angle = abs(round(rad2deg(jump_dir.angle_to(Vector2.UP))))
	
	var jump_speed = 700*mod;
	var jump_vel = jump_dir*jump_speed;
	
	if smp.get_param("on_floor") and angle > 90:
		jump_vel *= -0.5;
		jump_dir *=  -1;
	
	if (angle == 180 || angle == 0) and wall_direction != 0:
		jump_vel += -wall_direction*Vector2.RIGHT*50
		jump_dir = jump_vel.normalized();

	if jump_vel.y > 0:
		jump_vel.y *= 0.5;
#	jump_vel.x *= 1.3
	velocity += jump_vel
	position += jump_dir.normalized();
	if(get_floor_velocity().y < 0 || smp.get_param("on_floor")):
		position.y -= 20
	
func die():
	smp.set_trigger("die")
	$Sprite.z_index = 10;
	var songname = "Song1";
	if get_parent().level_num >= 7:
		songname = "Song2";
	Global.music.stop(songname)
	Global.music_box.playsound("Death")
func talk_crow():
	talking = true;
	velocity = Vector2.ZERO;

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
	if (!using_joystick):
		jump_dir = get_global_mouse_position() - get_global_position();
	last_mouse = (get_global_mouse_position() - get_global_position())
	jump_mag = jump_dir.length()
	jump_dir = jump_dir.normalized();
	jump_dir = _clamp_8bit(jump_dir)
	$JumpDotLong.position = jump_dir*70
#	if abs(1-Vector2.UP.dot(jump_dir)) < 0.01:
#		jump_dir = Vector2.UP;
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
	
	if ((wall_direction == 0 && old_wall_direction != 0) and OS.get_system_time_msecs() - last_jump_time > 60):
		velocity.x += old_wall_direction*20;
	
	if (wall_direction != 0 && !_check_is_valid_wall($WallRaycasts/TopWallRaycasts)):
		print("near top")
		if(velocity.y < 5):
			velocity += Vector2.UP*30
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
			
			
func dialog_end(signal_type):
	talking = false;

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
			velocity = Vector2.ZERO;
			velocity += Vector2.UP*20;
		"end":
			$Sprite/AnimationPlayer.play("sigh");
	pass;

func _on_Music_beat(beat):
	if beat % 4 == 3 || beat % 4 == 1:
		smp.set_trigger("jump")
		if smp.current == "falling" or smp.current == "jumping":
			jump(0.5)
		$JumpDotLong.scale = Vector2(1,1);
		$Sprite/Beat.play("Beat")

func _clamp_8bit(vec):
	var clamp_vectors = _generate_vectors();
	vec = vec.normalized();
	var curDegree = rad2deg(vec.angle_to(Vector2.UP));
	var closestDiff
	var closestVec
	for clamp_vec in clamp_vectors:
		var diff = abs(curDegree - rad2deg(clamp_vec.angle_to(Vector2.UP)));
		if not closestVec:
			closestDiff = diff
			closestVec = clamp_vec;
		else:
			if diff < closestDiff:
				closestDiff = diff
				closestVec = clamp_vec;
	return closestVec;
	
func _generate_vectors(angle=5):
	if talking:
		return [Vector2.UP];
	var vectors = [];
	var curDegree = 0;
	while curDegree < 360:

		var vector_to_add = Vector2.UP.rotated(deg2rad(curDegree));
		vectors.push_front(vector_to_add);
		curDegree += angle
	return vectors;
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "die"):
		get_parent()._fade_out();
	pass # Replace with function body.
	
	
	
# Dialog events:
func _turn_left():
	$Sprite.flip_h = true;

func _turn_right():
	$Sprite.flip_h = false;
	
	
func _float_up():
	gravity *= -0.2;
