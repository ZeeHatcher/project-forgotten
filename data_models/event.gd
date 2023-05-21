class_name Event
extends Resource


const event_images := {
	"Bunker_inside.png": "res://assets/events/Bunker_inside.png",
	"Bunker_outside.png": "res://assets/events/Bunker_outside.png",
	"Car_close.png": "res://assets/events/Car_close.png",
	"Car_far.png": "res://assets/events/Car_far.png",
	"Heli_crash.png": "res://assets/events/Heli_crash.png",
	"pickup.png": "res://assets/events/pickup.png",
	"Watchtower.png": "res://assets/events/Watchtower.png"
}

var id: String
var title: String
var pages: Array
var journal_entry: String


func populate_from_json(json: Dictionary) -> void:
	title = json.get("title", "")
	
	for raw_page in json.get("pages", []):
		var page := Page.new()
		page.populate_from_json(raw_page)
		pages.append(page)
		
	journal_entry = json.get("journal_entry", "")


class Page:
	var description: String
	var choices: Array
	var image: Texture
	
	
	func populate_from_json(json: Dictionary) -> void:
		description = json.get("description", "")
		var image_file_name = json.get("image", "")
		if not image_file_name.empty():
			var image_file = event_images[image_file_name]
			image = load(image_file)
	
		for raw_choice in json.get("choices", []):
			var choice := Choice.new()
			choice.populate_from_json(raw_choice)
			choices.append(choice)


class Choice:
	var description: String
	var outcome: State
	var next_page: int
	var conditions: State
	var help_text: String
	var complete: bool
	
	
	func _init(
			desc := "", outcome_: State = null, next := -1,
			conditions_: State = null, help := "", complete_ := false
	) -> void:
		description = desc
		outcome = outcome_ if not outcome_ == null else State.new()
		next_page = next
		conditions = conditions_ if not conditions_ == null else State.new() 
		help_text = help
		complete = complete_
	
	
	func populate_from_json(json: Dictionary) -> void:
		description = json.get("description", "")
		next_page = json.get("next_page", -1)
		outcome = State.new()
		outcome.populate_from_json(json.get("outcome", {}))
		conditions = State.new()
		conditions.populate_from_json(json.get("conditions", {}))
		help_text = json.get("help_text", "")
		complete = json.get("complete", false)


class State:
	var items: Dictionary
	var stats: Dictionary
	var global: Dictionary
	var actions: Dictionary
	var call: Dictionary
	
	
	func populate_from_json(json: Dictionary) -> void:
		items = json.get("items", {})
		stats = json.get("stats", {})
		global = json.get("global", {})
		actions = json.get("actions", {})
		call = json.get("call", {})
