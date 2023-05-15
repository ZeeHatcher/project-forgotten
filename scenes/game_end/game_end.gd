extends Control


onready var _cutscene := $Cutscene

func _ready() -> void:
	_cutscene.play()


func _on_Cutscene_end():
	get_tree().change_scene("res://scenes/start_screen/start_screen.tscn")
