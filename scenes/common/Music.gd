extends Node

var volume = 1;
var curVolume = 1;
var muted = false;
var mutedVolume = -5000;

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.music = $MixingDeskMusic;
	pass # Replace with function body.

func _process(delta):
	if (curVolume != Global.volume):
		curVolume = Global.volume;
		Global.muted = false;
		muted = false;
		setVolume(Global.volume);
	if (muted != Global.muted):
		toggleMute();


func toggleMute():
	muted = !muted;
	if muted:
		setVolume(0);
	else:
		setVolume(curVolume);


func setVolume(vol):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear2db(vol))
