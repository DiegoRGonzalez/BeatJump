extends Node2D


# Declare member variables here. Examples:
# var a = 2
export(String) var dialog = "FirstMeeting"
var started = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func start():
	started = true;
	var new_dialog = Dialogic.start(dialog)
	get_parent().add_child(new_dialog)
	new_dialog.connect("timeline_end", Global.player, "dialog_end")
	Global.player.talk_crow();

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	print("Player in crow")
	if "Player" in body.name and not started:
		start();
