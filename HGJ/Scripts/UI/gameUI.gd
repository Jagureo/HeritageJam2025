extends Control

@onready var station_label = $MainScreen/Station_Label
@onready var passenger_count_label = $MainScreen/Passenger_Count_Label

func set_station(msg: String) -> void:
	station_label.text = msg

func next_station() -> void:
	EventMgr.OnNextStationPressed.emit()

func set_passenger_count(value: int) -> void:
	passenger_count_label.text = "Passengers: %d" % value
