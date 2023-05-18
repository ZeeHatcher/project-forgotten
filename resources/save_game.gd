class_name SaveGame
extends Resource


const SAVE_GAME_BASE_PATH := "user://save"

export var version := 1


export var player_position := Vector2.ZERO
export(int) var player_health
export(int) var player_food
export(int) var player_temperature
export(Dictionary) var inventory_items
export(Dictionary) var terrain
export(Dictionary) var event_tiles
export(Dictionary) var event_flags
export(Dictionary) var event_completed


# For a safe alternative, see the function write/load_as_json() below.
func write_savegame(index: int) -> void:
	ResourceSaver.save(get_save_path(index), self)


static func save_exists(index: int) -> bool:
	return ResourceLoader.exists(get_save_path(index))


static func load_savegame(index: int) -> Resource:
	print_debug("loading save")
	var save_path := get_save_path(index)
	if ResourceLoader.has_cached(save_path):
		# Once the resource caching bug is fixed, you will only need this line of code to load the save game.
		print_debug("loading from cache")
		return ResourceLoader.load(save_path, "", true)

	var file := File.new()
	if file.open(save_path, File.READ) != OK:
		printerr("Couldn't read file " + save_path)
		return null
		
	print_debug("loading from file")
	var data := file.get_buffer(file.get_len())
	file.close()

	var tmp_file_path := make_random_path()
	while ResourceLoader.has_cached(tmp_file_path):
		tmp_file_path = make_random_path()

	if file.open(tmp_file_path, File.WRITE) != OK:
		printerr("Couldn't write file " + tmp_file_path)
		return null

	file.store_buffer(data)
	file.close()

	var save = ResourceLoader.load(tmp_file_path, "", true)
	save.take_over_path(save_path)

	var directory := Directory.new()
	directory.remove(tmp_file_path)
	return save


static func make_random_path() -> String:
	return "user://temp_file_" + str(randi()) + ".tres"


static func get_save_path(index: int) -> String:
	var extension := ".tres" if OS.is_debug_build() else ".res"
	return SAVE_GAME_BASE_PATH + str(index) + extension
