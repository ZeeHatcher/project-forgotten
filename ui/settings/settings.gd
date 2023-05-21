extends Control


func _ready() -> void:
	$"%SFXSlider".value = db2linear(AudioServer.get_bus_volume_db(1))
	$"%MusicSlider".value = db2linear(AudioServer.get_bus_volume_db(2))


func _on_SFXSlider_value_changed(value):
	var volume = linear2db(value)
	AudioServer.set_bus_volume_db(1, volume)


func _on_MusicSlider_value_changed(value):
	var volume = linear2db(value)
	AudioServer.set_bus_volume_db(2, volume)
