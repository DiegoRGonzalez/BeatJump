extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.music.connect("beat", self, "_on_Music_beat")	
	pass # Replace with function body.

func _process(delta):
	if Global.show_beat:
		$Beat.visible = true;
		$Frame.visible = true;
		$FrameBG.visible = true;
		for child in get_children():
			if "beatball" in child:
				child.visible = true;
	else:
		$Beat.visible = false;
		$Frame.visible = false;
		$FrameBG.visible = false;
		for child in get_children():
			if "beatball" in child:
				child.visible = false;

func _on_Music_beat(beat):
	if (beat%4!=1 && beat%4!=3):
		return;
	var minDiff;
	var minBeatBall;
	for child in get_children():
		if "beatball" in child:
			var diff = abs(child.position.x - get_viewport().get_visible_rect().size.x/3);
			if (not minDiff) or diff < minDiff:
				minDiff = diff;
				minBeatBall = child;
	if minBeatBall:
		minBeatBall.scale = Vector2(4,4);
