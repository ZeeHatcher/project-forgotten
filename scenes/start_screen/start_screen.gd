extends Node


enum SCREENS {
	TITLE,
	MAIN,
	OPTION,
	CREDIT,
}

var cursor_index = 0
var current_screen = SCREENS.TITLE 

onready var _animation_player := $AnimationPlayer
onready var screens = {
	SCREENS.TITLE: $CanvasLayer/StartMenu/TitleCard,
	SCREENS.MAIN: $CanvasLayer/StartMenu/MarginContainer/MainMenu,
	SCREENS.OPTION: $CanvasLayer/StartMenu/MarginContainer/OptionsMenu,
	SCREENS.CREDIT: $CanvasLayer/StartMenu/MarginContainer/CreditsMenu,
}


func _ready():
	load_title()


func load_title():
	_animation_player.play("title_card_start")
	_animation_player.queue("title_card_idle")


func _input(event):
	event.is_action_pressed("ui_cancel")
	
	match current_screen:
		SCREENS.TITLE:
			_process_title_screen(event)
		SCREENS.MAIN:
			_process_main_screen(event)
		SCREENS.OPTION:
			_process_main_screen(event)
		SCREENS.CREDIT:
			_process_main_screen(event)


func _process_title_screen(event: InputEvent):
	if event.is_pressed():
		if _animation_player.current_animation == "title_card_start":
			_animation_player.advance(10)
		else:
			load_menu(SCREENS.MAIN)


func _process_main_screen(event):
	if event.is_action_pressed("ui_cancel"):
		load_menu(SCREENS.TITLE)
		load_title()


func load_menu(selected_screen):
	for screen in screens:
		screens[screen].visible = false
	
	current_screen = selected_screen
	screens[current_screen].visible = true


func _on_Exit_pressed():
	load_menu(SCREENS.TITLE)
	load_title()


func _on_Start_pressed():
	get_tree().change_scene("res://main.tscn")


func _on_Credits_pressed():
	load_menu(SCREENS.CREDIT)
