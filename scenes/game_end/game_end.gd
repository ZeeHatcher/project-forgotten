extends Control


onready var _cutscene := $Cutscene
onready var _animation_player := $AnimationPlayer


func _ready() -> void:
	_cutscene.play()
	_animation_player.play("fade_in")


func _on_Cutscene_end():
	_animation_player.play("end")


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"end":
			get_tree().change_scene("res://scenes/start_screen/start_screen.tscn")
