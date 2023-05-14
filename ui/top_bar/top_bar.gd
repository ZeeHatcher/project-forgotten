extends PanelContainer


export(Resource) var player_health
export(Resource) var player_food

onready var _health_counter := $"%HealthCounter"
onready var _food_counter := $"%FoodCounter"


func _ready() -> void:
	_health_counter.max_value = player_health.max_value
	_health_counter.value = player_health.value
	player_health.connect("value_changed", self, "_on_player_health_changed")
	
	_food_counter.max_value = player_food.max_value
	_food_counter.value = player_food.value
	player_food.connect("value_changed", self, "_on_player_food_changed")


func _on_player_health_changed() -> void:
	_health_counter.value = player_health.value


func _on_player_food_changed() -> void:
	_food_counter.value = player_food.value
