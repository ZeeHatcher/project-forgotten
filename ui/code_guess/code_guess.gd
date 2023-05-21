extends Control


signal completed(success)

const VALID_CODES := ["papa", "indiana", "november", "echo"]

onready var _codes := $Codes


func _on_Guess_pressed():
	var score := _calculate_score()
	var success := score == VALID_CODES.size()
	emit_signal("completed", success)


func reset():
	for code in _codes.get_children():
		code.selected = false


func _calculate_score() -> int:
	var score := 0
	
	for code in _codes.get_children():
		if not code.selected:
			continue
		
		if code.text.to_lower() in VALID_CODES:
			score += 1
		else:
			score -= 1
	
	return score
