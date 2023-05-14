class_name EventService
extends Node


export(NodePath) var player
export(NodePath) var board

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


func are_conditions_met(conditions) -> bool:
	print(conditions)
	return true
