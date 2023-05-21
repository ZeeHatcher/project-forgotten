class_name EventService
extends Node


signal outcome_applied(outcome)
signal event_function_call(function_name)

export(NodePath) var player
export(NodePath) var board

var _flags: Dictionary
var _completed := {}

onready var _player: Player = get_node(player)
onready var _board: EventBoard = get_node(board)


func _ready() -> void:
	_board.are_conditions_met_handler = funcref(self, "are_conditions_met")


func is_event_completed(event: String) -> bool:
	return _completed.has(event)


func start_event(event_name: String):
	if not _board:
		return
	
	var event = EventRepository.get_event(event_name)
	if not event or _completed.has(event.title):
		return
	
	get_tree().paused = true
	_board.event = event
	_board.show()


func end_event(event: Event, complete: bool):
	if complete:
		_completed[event.title] = true
	get_tree().paused = false


func apply_outcome(outcome: Event.State) -> void:
	for item in outcome.items:
		var qty: int = outcome.items[item]
		_player.inventory.add(item, qty)
	
	for flag in outcome.global:
		_flags[flag] = outcome.global[flag]
	
	for stat in outcome.stats:
		var change: int = outcome.stats[stat]
		match stat:
			"health":
				_player.health.hit(change, "world")
			"food":
				_player.food.value += change
	
	for action in outcome.actions:
		match action:
			"move":
				var dir = Vector2(outcome.actions[action][0], outcome.actions[action][1])
				_player.force_move(dir)
			"call":
				emit_signal("event_function_call", outcome.actions[action])
	
	emit_signal("outcome_applied", outcome)


func are_conditions_met(conditions: Event.State) -> bool:
	if not _is_inventory_match(conditions.items):
		return false
	
	if not _are_flags_match(conditions.global):
		return false
	
	if not _are_stats_match(conditions.stats):
		return false
		
	return true


func _is_inventory_match(items: Dictionary) -> bool:
	for item in items:
		var tokens := _tokenize(items[item])
		var existing: int = _player.inventory.get(item)
		var valid := _evaluate_expression(
				existing,
				tokens["value"],
				tokens["operator"])
		print_debug("%s: %s %s %s (%s)" % [item, existing, tokens["operator"], tokens["value"], valid])
		if not valid:
			return false
	return true


func _are_flags_match(flags: Dictionary) -> bool:
	for flag in flags:
		var desired: bool = flags[flag]
		var existing: bool = _flags.get(flag, false)
		print_debug("%s: %s == %s" % [flag, existing, desired])
		if existing != desired:
			return false
	return true


func _are_stats_match(stats: Dictionary) -> bool:
	for stat in stats:
		var tokens := _tokenize(stats[stat])
		var existing := 0
		match stat:
			"health":
				existing = _player.health.value
			"food":
				existing = _player.food.value
		var valid := _evaluate_expression(
				existing,
				tokens["value"],
				tokens["operator"])
		print_debug("%s: %s %s %s (%s)" % [stat, existing, tokens["operator"], tokens["value"], valid])
		
		if not valid:
			return false
	return true


func _tokenize(expression: String) -> Dictionary:
	var regex = RegEx.new()
	regex.compile("\\d+")
	var result: RegExMatch = regex.search(expression)
	
	if not result:
		return { "operator": "", "value": 0 }
	
	var operator := expression.substr(0, result.get_start())
	var value := int(expression.substr(result.get_start(), -1))
	return { "operator": operator, "value": value }


func _evaluate_expression(existing: int, desired: int, operator: String) -> bool:
	match operator:
		"<":
			return existing < desired
		">":
			return existing > desired
		"<=":
			return existing <= desired
		">=":
			return existing >= desired
		_:
			return existing == desired
