extends Control


onready var _cutscene := $Cutscene
onready var _animation_player := $AnimationPlayer
onready var _audio := $AudioStreamPlayer


func _ready() -> void:
	_cutscene.play()
	_animation_player.play("fade_in")


func _on_Cutscene_end():
	get_tree().change_scene("res://scenes/heli_crash/heli_crash.tscn")
