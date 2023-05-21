extends Node


enum SCREENS {
	TITLE,
	MAIN,
	CREDIT,
}

var cursor_index = 0
var current_screen = SCREENS.TITLE 

onready var _animation_player := $AnimationPlayer
onready var screens = {
	SCREENS.TITLE: $"%TitleCard",
	SCREENS.MAIN: $"%MainMenu",
	SCREENS.CREDIT: $"%CreditsMenu",
}


func _ready():
	load_title()


func load_title():
	_animation_player.play("title_card_start")
	_animation_player.queue("title_card_idle")


func _input(event):
	match current_screen:
		SCREENS.TITLE:
			_process_title_screen(event)


func _process_title_screen(event: InputEvent):
	if event.is_pressed():
		if _animation_player.current_animation == "title_card_start":
			_animation_player.advance(10)
		else:
			load_menu(SCREENS.MAIN)


func load_menu(selected_screen):
	for screen in screens:
		screens[screen].visible = false
	
	current_screen = selected_screen
	screens[current_screen].visible = true


func _on_Start_pressed():
	_animation_player.play("fade_out")


func _on_Credits_pressed():
	load_menu(SCREENS.CREDIT)


func _on_Back_pressed():
	load_menu(SCREENS.MAIN)


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fade_out":
			get_tree().change_scene("res://scenes/game_start/game_start.tscn")
