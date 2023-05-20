extends Node


signal map_button_pressed
signal inventory_button_pressed
signal journal_button_pressed
signal inventory_unlocked
signal journal_unlocked


func hide_all():
	$"%MapButton".visible = false
	$"%JournalButton".visible = false
	$"%InventoryButton".visible = false
	$"%TemperatureBar".visible = false
	$"%FoodCounter".visible = false


func unlock_map():
	$"%MapButton".visible = true


func unlock_journal():
	$"%JournalButton".visible = true
	emit_signal("journal_unlocked")


func unlock_bag():
	$"%InventoryButton".visible = true
	emit_signal("inventory_unlocked")


func unlock_temperature():
	$"%TemperatureBar".visible = true


func unlock_food():
	$"%FoodCounter".visible = true


func _on_MapButton_pressed():
	emit_signal("map_button_pressed")


func _on_InventoryButton_pressed():
	emit_signal("inventory_button_pressed")


func _on_JournalButton_pressed():
	emit_signal("journal_button_pressed")
