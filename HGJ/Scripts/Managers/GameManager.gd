extends Node
class_name GameManager

@onready var game_ui : Control = %GameUi
@onready var passenger_prefab = preload("res://Scenes/Prefabs/Passenger.tscn")
@onready var passenger_container : Node2D = %AllPassengers

var current_station_index : int = 0
var mOverallHappiness : int = 0:
	get:
		return mOverallHappiness
	set(newValue):
		mOverallHappiness = newValue
		update_happiness_level(newValue)

static var sInstance : GameManager = null


func _enter_tree():
	EventMgr.OnNextStationPressed.connect(next_station)

func _exit_tree():
	EventMgr.OnNextStationPressed.disconnect(next_station)
	sInstance = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if sInstance == null:
		sInstance = self
	else:
		queue_free()
		return

	_update_station_display()
	update_happiness_level(0)
	for i in range(Station.EWStations[current_station_index].get_passenger_count()):
		_spawn_passenger()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func next_station() -> void:
	if current_station_index < Station.EWStations.size() - 1:
		current_station_index += 1
		var new_passengers = Station.EWStations[current_station_index].get_passenger_count()
		var passengers_in_train = passenger_container.get_child_count() + new_passengers
		var passengers_to_kick_min = (passengers_in_train - Constant.MAX_PASSENGERS_IN_TRAIN) if passengers_in_train > Constant.MAX_PASSENGERS_IN_TRAIN else 0
		var passengers_to_kick_max = (passenger_container.get_child_count() - 1) if passenger_container.get_child_count() > 1 else 0
		print("passengers-max is %d" % passengers_to_kick_max)
		print("passengers-child count is %d" % passenger_container.get_child_count())
		var passengers_to_kick = randi_range(passengers_to_kick_min, passengers_to_kick_max)
		print("passengers-to-kick is %d" % passengers_to_kick)
		for i in range(passengers_to_kick):
			print("loop")
			var random_passenger = passenger_container.get_child(randi() % passenger_container.get_child_count())
			
			if random_passenger is Passenger:
				(random_passenger as Passenger).mIsAlighting = true
				# # Passenger not seated, remove it from sitting area
				# if (random_passenger as Passenger).mSittingOn == null:
				# 	StandingArea.sStandingArea.RemovePassenger(random_passenger)
				# # Passenger is seated
				# else:
				# 	(random_passenger as Passenger).mSittingOn.RemovePassenger()

			random_passenger.queue_free()
		for i in range(new_passengers):
			_spawn_passenger()
		_update_station_display()

func _update_station_display() -> void:
	game_ui.set_station(Station.EWStations[current_station_index].name)

func _spawn_passenger() -> void:
	var passenger = passenger_prefab.instantiate()
	passenger_container.add_child(passenger)
	passenger.position = Vector2(randf() * 200 + (100 if randi() % 2 == 0 else 1600), randf() * 300 + 400)
	StandingArea.sStandingArea.AddPassenger(passenger)

func update_happiness_level(value: int) -> void:
	game_ui.set_happiness_level(value)
