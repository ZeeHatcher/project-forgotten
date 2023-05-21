extends AudioStreamPlayer


onready var _timer = $Timer


func _ready():
	_timer.start()


func _on_Timer_timeout():
	if not playing:
		play()


func _on_MusicPlayer_finished():
	_timer.start()
