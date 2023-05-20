extends Node


signal map_button_pressed
signal inventory_button_pressed
signal journal_button_pressed


func hide_all():
	$"%MapButton".visible = false
	$"%JournalButton".visible = false
	$"%InventoryButton".visible = false
	$"%TemperatureBar".visible = false


func unlock_map():
	$"%MapButton".visible = true


func unlock_journal():
	$"%JournalButton".visible = true


func unlock_bag():
	$"%InventoryButton".visible = true


func unlock_temperature():
	$"%TemperatureBar".visible = true


func _on_MapButton_pressed():
	emit_signal("map_button_pressed")


func _on_InventoryButton_pressed():
	emit_signal("inventory_button_pressed")


func _on_JournalButton_pressed():
	emit_signal("journal_button_pressed")
