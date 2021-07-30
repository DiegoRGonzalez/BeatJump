extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.music.connect("beat", self, "_on_Music_beat")	


func _process(delta):
	scale.x -= 0.001
	scale.y -= 0.001;
	
	scale.x = max(1, scale.x)
	scale.y = max(1, scale.y)
	pass
	
func _on_Music_beat(beat):
	if beat%4 == 1 || beat%4 == 3:
		scale = Vector2(1.3,1.3)


func _on_EndArea_body_entered(body):
	if not ("Player" in body.name):
		return;
	var songname = "Song1";
	if get_parent().level_num >= 5:
		songname = "Song2";
	Global.player.velocity = Vector2.ZERO;
	Global.music.stop(songname)
	Global.player.end = true;
	Global.music_box.playsound("sigh")
	get_parent().slow_fadeout();
	var platforms = get_parent().get_node("FloatingGrounds").get_children();
	for plat in platforms:
		plat.falling = true;
	pass # Replace with function body.
