extends Node

var music
var player
var furthestCompleted = 0;
var muted = false;
var volume = 1;
var paused = false;
var camera;
var music_box;

func save():
	var save_dict = {
		"furthestCompleted" : furthestCompleted,
		"volume" : volume,
		"muted" : muted,
	}
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE);
	save_game.store_line(to_json(save_dict))
	
func load():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		if "furthestCompleted" in node_data:
			furthestCompleted = node_data["furthestCompleted"]
		if "volume" in node_data:
			volume = node_data["volume"]
		if "muted" in node_data:
			muted = node_data["muted"]
