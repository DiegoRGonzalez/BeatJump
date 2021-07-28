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
