class_name Event
extends Resource


var title: String
var pages: Array


func populate_from_json(json: Dictionary) -> void:
	title = json.get("title", "")
	
	for raw_page in json.get("pages", []):
		var page := Page.new()
		page.populate_from_json(raw_page)
		pages.append(page)


class Page:
	var description: String
	var choices: Array
	
	
	func populate_from_json(json: Dictionary) -> void:
		description = json.get("description", "")
	
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
	
	
	func _init(
			desc := "", outcome_: State = null, next := -1,
			conditions_: State = null, help := ""
	) -> void:
		description = desc
		outcome = outcome_ if not outcome_ == null else State.new()
		next_page = next
		conditions = conditions_ if not conditions_ == null else State.new() 
		help_text = help
	
	
	func populate_from_json(json: Dictionary) -> void:
		description = json.get("description", "")
		next_page = json.get("next_page", -1)
		outcome = State.new()
		outcome.populate_from_json(json.get("outcome", {}))
		conditions = State.new()
		conditions.populate_from_json(json.get("conditions", {}))
		help_text = json.get("help_text", "")


class State:
	var items: Dictionary
	var stats: Dictionary
	var global: Dictionary
	
	
	func populate_from_json(json: Dictionary) -> void:
		items = json.get("items", {})
		stats = json.get("stats", {})
		global = json.get("global", {})