extends ItemList


export(Resource) var player_inventory

onready var _audio_open := $AudioOpen
onready var _audio_close := $AudioClose


func _ready():
	update_items({})
	player_inventory.connect("quantity_changed", self, "_on_player_inventory_changed")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		_toggle_inventory()


func update_items(items: Dictionary):
	clear()
	for item in items:
		add_item(item)


func _toggle_inventory():
	visible = !visible
	if visible:
		_audio_open.play()
	else:
		_audio_close.play()


func _on_player_inventory_changed():
	update_items(player_inventory.get_all())


func _on_HUD_inventory_button_pressed():
	_toggle_inventory()
