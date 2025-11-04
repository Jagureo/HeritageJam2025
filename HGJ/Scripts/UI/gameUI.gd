extends Control

@onready var station_label = $MainScreen/Sign/Station_Label
@onready var happiness_label = $MainScreen/Sign2/Happniess_Level

func set_station(msg: String) -> void:
	station_label.text = msg

func next_station() -> void:
	if GameManager.sInstance.current_station_index < Station.EWStations.size() - 1 :
		EventMgr.OnNextStationPressed.emit()
		AudioManager.sInstance.mClickSound.play()

func set_happiness_level(value: int) -> void:
	happiness_label.text = "Happiness Level: %d" % value
