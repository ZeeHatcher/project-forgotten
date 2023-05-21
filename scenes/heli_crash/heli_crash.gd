extends Control


func _on_AudioStreamPlayer_finished():
	$AnimationPlayer.play("show_crash")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://scenes/tutorial/tutorial.tscn")
