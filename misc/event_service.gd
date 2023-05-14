class_name EventService
extends Node


export(NodePath) var player
export(NodePath) var board

var _flags: Dictionary

onready var _player: Player = get_node(player)
onready var _board: EventBoard = get_node(board)


func _ready() -> void:
	_board.are_conditions_met_handler = funcref(self, "are_conditions_met")


func start_event(event_name: String):
	if not _board:
		return
	
	get_tree().paused = true
	_board.event = EventRepository.get_event(event_name)
	_board.show()


func end_event():
	get_tree().paused = false


func apply_outcome(outcome: Event.State) -> void:
	for item in outcome.items:
		pass
	
	for flag in outcome.global:
		_flags[flag] = outcome.global[flag]
	
	for stat in outcome.stats:
		pass


func are_conditions_met(conditions: Event.State) -> bool:
	for item in conditions.items:
		pass
	
	if not _are_flags_valid(conditions.global):
		return false
	
	for stat in conditions.stats:
		pass
		
	return true


func _are_flags_valid(flags: Dictionary) -> bool:
	for flag in flags:
		var desired: bool = flags[flag]
		var existing: bool = _flags.get(flag, false)
		if existing != desired:
			return false
	return true
