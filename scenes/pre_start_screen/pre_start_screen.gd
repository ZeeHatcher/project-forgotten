extends Control


func _ready() -> void:
	$AnimationPlayer.play("fade")


func _on_AnimationPlayer_animation_finished(anim_name) -> void:
	get_tree().change_scene("res://scenes/start_screen/start_screen.tscn")
