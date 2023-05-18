extends TextureProgress


export var animationDuration: float = 1.0

var target_value

onready var tween := $Tween


func _on_Player_temperature_updated(temp_percentage):
	var temperature = temp_percentage * max_value 
	tween.interpolate_property(self, "value", value, temperature, animationDuration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
