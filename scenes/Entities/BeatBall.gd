extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var start_x;
var beatball = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	start_x = position.x;
	Global.music.connect("beat", self, "_on_Music_beat")	
	pass # Replace with function body.


func _physics_process(delta):
	scale.x -= 0.1;
	scale.y -= 0.1;
	scale.x = max(1,scale.x)
	scale.y = max(1, scale.y)
	position.x += 10;
	if start_x - position.x > get_viewport().size.x:
		queue_free()
	pass

func _on_Music_beat(beat):
	if (beat%4 == 1 && beat%4 == 1):
		if ( (start_x - position.x) > get_viewport_rect().size.x/2 - 120 && (start_x - position.x) < get_viewport_rect().size.x/2 + 120):
			scale = Vector2(2,2)
