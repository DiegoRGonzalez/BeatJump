extends Node

var music
var player
var furthestCompleted = 0;
var muted = false;
var volume = 1;

func save():
	var save_dict = {
		"furthestCompleted" : furthestCompleted,
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
		furthestCompleted = node_data["furthestCompleted"]
