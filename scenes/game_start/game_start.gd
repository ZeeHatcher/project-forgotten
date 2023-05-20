extends Control


onready var _cutscene := $Cutscene

func _ready() -> void:
	print("tes")
	_cutscene.play()


func _on_Cutscene_end():
	get_tree().change_scene("res://scenes/tutorial/tutorial.tscn")
