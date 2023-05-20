extends ItemList


export(Resource) var player_inventory


func _ready():
	update_items({})
	player_inventory.connect("quantity_changed", self, "_on_player_inventory_changed")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		visible = !visible


func update_items(items: Dictionary):
	clear()
	for item in items:
		add_item(item)


func _on_InventoryButton_pressed():
	visible = !visible


func _on_player_inventory_changed():
	update_items(player_inventory.get_all())
