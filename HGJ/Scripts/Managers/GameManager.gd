extends Node

@onready var game_ui = $GameUi

var passengers_in_train : int = 0
var current_station_index : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	EventMgr.OnNextStationPressed.connect(next_station)
	passengers_in_train = Station.EWStations[current_station_index].get_passenger_count()
	_update_station_display()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func next_station() -> void:
	if current_station_index < Station.EWStations.size() - 1:
		current_station_index += 1
		passengers_in_train += Station.EWStations[current_station_index].get_passenger_count()
		_update_station_display()

func _update_station_display() -> void:
	game_ui.set_station(Station.EWStations[current_station_index].name)
	game_ui.set_passenger_count(passengers_in_train)
