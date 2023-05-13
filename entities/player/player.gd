extends Area2D


signal moved

const INPUTS = {
	"move_up": Vector2.UP,
	"move_down": Vector2.DOWN,
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
}

onready var _ray := $RayCast2D

func _unhandled_input(event: InputEvent) -> void:
	for action in INPUTS.keys():
		if event.is_action_pressed(action):
			var dir: Vector2 = INPUTS[action]
			if not _will_collide(dir):
				move(dir)


func move(dir: Vector2) -> void:
	position += GridTranslator.step_isometric(dir)
	emit_signal("moved")


func _will_collide(dir: Vector2) -> bool:
	_ray.cast_to = GridTranslator.step_isometric(dir)
	_ray.force_raycast_update()
	return _ray.is_colliding()
