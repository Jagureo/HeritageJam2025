extends Node
class_name GameManager

@onready var game_ui : CanvasLayer = %GameUi
@onready var passenger_prefab = preload("res://Scenes/Prefabs/Passenger.tscn")
@onready var passenger_container : Node2D = %AllPassengers
@onready var passenger_information : PassengerInformation = $PassengerInformation
@onready var mStationTransitionTimer : Timer = $StationTransitionTimer

var mScore : int = 0
var current_station_index : int = 0
var mOverallHappiness : int = 0:
	get:
		return mOverallHappiness
	set(newValue):
		mOverallHappiness = newValue
		update_happiness_level(newValue)
		if newValue < -5:
			game_ui.showGameOverPanel(true)
		
var passenger_hover_queue : Array[Passenger] = []

static var sInstance : GameManager = null


enum LevelState {
	AT_STATION,		# Train is at the station, passengers will alight, players can drag drop the passenger
	MOVING,			# Train is moving, show the moving animation
	REACHING_NEXT,	# Train is about to reach, happiness will be evaluated at this stage
}

var mCurrLevelState : LevelState = LevelState.AT_STATION

var hasWheelchairPassenger : bool = false

func _enter_tree():
	EventMgr.OnNextStationPressed.connect(next_station)
	EventMgr.OnPassengerHoverStart.connect(on_passenger_hover_start)
	EventMgr.OnPassengerHoverEnd.connect(on_passenger_hover_end)

func _exit_tree():
	EventMgr.OnNextStationPressed.disconnect(next_station)
	EventMgr.OnPassengerHoverStart.disconnect(on_passenger_hover_start)
	EventMgr.OnPassengerHoverEnd.disconnect(on_passenger_hover_end)
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
		
	passenger_information.hide()


func next_station() -> void:
	mCurrLevelState = LevelState.MOVING
	# Disable the button
	game_ui.DisableButton(true)
	# Start the timer
	mStationTransitionTimer.start(Constant.TIME_TO_NEXT_STATION)



func ReachedNextStation():
	mCurrLevelState = LevelState.REACHING_NEXT

	# Evaluate happiness
	EventMgr.OnNextStationReaching.emit()
	mScore += mOverallHappiness

	if current_station_index < Station.EWStations.size() - 1:
		
		_update_station_display()

		var new_passengers = Station.EWStations[current_station_index].get_passenger_count()
		var passengers_in_train = passenger_container.get_child_count() + new_passengers
		var passengers_to_kick_min = (passengers_in_train - Constant.MAX_PASSENGERS_IN_TRAIN) if passengers_in_train > Constant.MAX_PASSENGERS_IN_TRAIN else 0
		var passengers_to_kick_max = (passenger_container.get_child_count() - 1) if passenger_container.get_child_count() > 1 else 0
		var passengers_to_kick = randi_range(passengers_to_kick_min, passengers_to_kick_max)
		for i in range(passengers_to_kick):
			var random_passenger = passenger_container.get_child(randi() % passenger_container.get_child_count())
			if random_passenger.mPassengerType == Passenger.PassengerType.WHEELCHAIR_BOUND:
				hasWheelchairPassenger = false

			# Passenger not seated, remove it from sitting area
			if (random_passenger as Passenger).mSittingOn == null:
				StandingArea.sStandingArea.RemovePassenger(random_passenger)
			# Passenger is seated
			else:
				(random_passenger as Passenger).mSittingOn.RemovePassenger()

			random_passenger.queue_free()
		for i in range(new_passengers):
			_spawn_passenger()

		# Update the next station sign
		current_station_index += 1
		_update_station_display()
		
	if current_station_index == Station.EWStations.size() - 1:
		game_ui.showGameOverPanel(true)

	# Reached station
	mCurrLevelState = LevelState.AT_STATION

	# Next station button can be pressed
	game_ui.DisableButton(false)



func _update_station_display() -> void:
	game_ui.set_station(Station.EWStations[current_station_index].name)

func _spawn_passenger() -> void:
	var passenger = passenger_prefab.instantiate()
	passenger_container.add_child(passenger)
	passenger.position = Vector2(randf() * 200 + (100 if randi() % 2 == 0 else 1600), randf() * 300 + 400)
	StandingArea.sStandingArea.AddPassenger(passenger)
	if passenger.mPassengerType == Passenger.PassengerType.WHEELCHAIR_BOUND:
		hasWheelchairPassenger = true

func update_happiness_level(value: int) -> void:
	game_ui.set_happiness_level(value)

func on_passenger_hover_start(passenger : Passenger):
	passenger_information.show()
	passenger_hover_queue.append(passenger)
	while passenger_hover_queue.size() > 0 and not is_instance_valid(passenger_hover_queue.front()):
		passenger_hover_queue.pop_front()
	if passenger_hover_queue.size() > 0:
		passenger_information.show_display(passenger_hover_queue.front())
	else:
		passenger_information.hide()

func on_passenger_hover_end(passenger : Passenger):
	passenger_hover_queue.erase(passenger)
	while passenger_hover_queue.size() > 0 and not is_instance_valid(passenger_hover_queue.front()):
		passenger_hover_queue.pop_front()
	if passenger_hover_queue.size() > 0:
		passenger_information.show_display(passenger_hover_queue.front())
	else:
		passenger_information.hide()

func _input(event): 
	if event.is_action_pressed("ui_cancel"): 
		game_ui.showGameOverPanel(true)
