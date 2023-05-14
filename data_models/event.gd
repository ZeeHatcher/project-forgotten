extends Node
class_name Event


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
	var outcome: Outcome
	var next_page: int
	
	
	func _init(desc := "", outcome_: Outcome = null, next := -1) -> void:
		description = desc
		outcome = outcome_ if not outcome_ == null else Outcome.new()
		next_page = next
	
	
	func populate_from_json(json: Dictionary) -> void:
		description = json.get("description", "")
		next_page = json.get("next_page", -1)
		outcome = Outcome.new()
		outcome.populate_from_json(json.get("outcome", {}))


class Outcome:
	var items: Dictionary
	var stats: Dictionary
	var global: Dictionary
	
	
	func populate_from_json(json: Dictionary) -> void:
		items = json.get("items", {})
		stats = json.get("stats", {})
		global = json.get("global", {})
