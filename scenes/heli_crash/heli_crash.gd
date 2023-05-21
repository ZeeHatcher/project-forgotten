extends Control


func _on_AudioStreamPlayer_finished():
	get_tree().change_scene("res://scenes/tutorial/tutorial.tscn")
