extends Node


const EVENTS_DIR := "res://events/"
const IGNORE := "_template.json"

var _events: Dictionary


func _ready():
	_load_events_from_dir()


func get_event(event_name: String) -> Event:
	return _events.get(event_name)


func _load_events_from_dir() -> void:
	var dir := Directory.new()
	if dir.open(EVENTS_DIR) == OK:
		var err := dir.list_dir_begin()
		if err != OK:
			print_debug("An error occurred when trying to list '%s'." % EVENTS_DIR)
			return
		
		var file_name := dir.get_next()
		while file_name != "":
			var is_json_file := (
					not dir.current_is_dir()
					and file_name.ends_with(".json")
					and file_name != IGNORE)
			if is_json_file:
				var raw_data := _load_json_file(EVENTS_DIR + file_name)
				var event := _deserialize(raw_data)
				var event_name := _get_name_part(file_name)
				_events[event_name] = event
			
			file_name = dir.get_next()
	else:
		print_debug("An error occurred when trying to access the path.")


func _load_json_file(file_path: String) -> Dictionary:
	var string_content := _load_file(file_path)
	return parse_json(string_content)


func _load_file(file_path: String) -> String:
	var file := File.new()
	var err := file.open(file_path, File.READ)
	if err != OK:
		return ""
	
	var content = file.get_as_text()
	file.close()
	return content


func _get_name_part(file_name: String) -> String:
	var stop := file_name.find(".json")
	return file_name.substr(0, stop)


func _deserialize(json: Dictionary) -> Event:
	var event := Event.new()
	event.populate_from_json(json)
	return event
