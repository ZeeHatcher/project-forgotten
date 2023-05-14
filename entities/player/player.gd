class_name Player
extends Node2D


signal moved(new_pos)
signal event_triggered(event_name)

const INPUTS = {
	"move_up": Vector2.UP,
	"move_down": Vector2.DOWN,
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
}

onready var _ray := $CollisionRay
onready var _tween := $Tween


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


func _will_collide(dir: Vector2) -> bool:
	_ray.cast_to = GridTranslator.step_isometric(dir)
	_ray.force_raycast_update()
	return _ray.is_colliding()


func _animate_movement(dir: Vector2) -> void:
	_tween.interpolate_property(self, "position",
		position, position + dir,
		0.1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	_tween.start()


func _on_EventDetector_body_entered(body):
	if body as EventTiles:
		body.trigger_event_at(global_position)
