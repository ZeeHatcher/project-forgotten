class_name Player
extends Node2D


signal moved(new_pos)
signal event_triggered(event_name)
signal dead
signal temperature_updated(temp_percentage)

const INPUTS = {
	"move_up": Vector2.UP,
	"move_down": Vector2.DOWN,
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
}


export(Resource) var health
export(Resource) var food
export(Resource) var inventory
export(Resource) var temperature

onready var _ray := $CollisionRay
onready var _tween := $Tween
onready var _tick_timer := $TickTimer


func _ready() -> void:
	food.connect("depleted", self, "_on_food_depleted")
	health.connect("depleted", self, "_on_health_depleted")
	temperature.connect("take_cold_damage", self, "_on_temperature_take_cold_damage")


func _unhandled_input(event: InputEvent) -> void:
	for action in INPUTS.keys():
		if event.is_action_pressed(action):
			var dir: Vector2 = INPUTS[action]
			if not _tween.is_active() and not _will_collide(dir):
				move(dir)


func move(dir: Vector2) -> void:
	var move_dir := GridTranslator.step_isometric(dir)
	_animate_movement(move_dir)
	emit_signal("moved", position + move_dir)
	_tick_timer.start()


func _will_collide(dir: Vector2) -> bool:
	_ray.cast_to = GridTranslator.step_isometric(dir)
	_ray.force_raycast_update()
	return _ray.is_colliding()


func _animate_movement(dir: Vector2) -> void:
	_tween.interpolate_property(self, "position",
		position, position + dir,
		0.1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	_tween.start()


func _on_EventDetector_body_entered(body: Node) -> void:
	if body as EventTiles:
		body.trigger_event_at(global_position)


func _on_Player_moved(_new_pos: Vector2) -> void:
	food.consume()
	temperature.reset()
	emit_signal("temperature_updated", temperature.percentage)


func _on_food_depleted() -> void:
	health.value -= 1


func _on_health_depleted() -> void:
	emit_signal("dead")


func _on_temperature_take_cold_damage() -> void:
	health.value -=1


func _on_TickTimer_timeout():
	temperature.tick()
	emit_signal("temperature_updated", temperature.percentage)
