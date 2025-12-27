extends Node
class_name GameManager

@onready var game_ui : CanvasLayer = %GameUi
@onready var passenger_prefab = preload("res://Scenes/Prefabs/Passenger.tscn")
@onready var passenger_container : Node2D = %AllPassengers
@onready var passenger_information : PassengerTooltip = $PassengerTooltip 
@onready var mStationTransitionTimer : Timer = $StationTransitionTimer
@onready var mStationWaitingTimer : Timer = $StationStayTimer


var mScore : int = 0
var current_station_index : int = 0
var mOverallHappiness : int = 0:
	get:
		return mOverallHappiness
	set(newValue):
		mOverallHappiness = newValue
		update_happiness_level(newValue)
		if newValue < LevelMgr.mLevelData.mStationDetails[current_station_index].mTargetScore:
			game_ui.showGameOverPanel(true)
		
# var passenger_hover_queue : Array[Passenger] = []
var mReachingNextStation : bool = true


static var sInstance : GameManager = null


enum LevelState {
	AT_STATION,		# Train is at the station, passengers will alight, players can drag drop the passenger
	MOVING,			# Train is moving, show the moving animation
	REACHING_NEXT,	# Train is about to reach, happiness will be evaluated at this stage
}

var mCurrLevelState : LevelState = LevelState.AT_STATION

func _enter_tree():
	if sInstance != null:
		queue_free()
		return

	sInstance = self
	EventMgr.OnNextStationPressed.connect(next_station)

func _exit_tree():
	if sInstance == self:
		sInstance = null
		EventMgr.OnNextStationPressed.disconnect(next_station)


# Called when the node enters the scene tree for the first time.
func _ready():
	# get_viewport().physics_object_picking_sort = true

	UpdateStationDisplay()
	update_happiness_level(0)
	SpawnPassengers()
		
	passenger_information.hide()


func _process(_delta):
	# If time to next station left 1s, then fire off station approaching signal
	if not mReachingNextStation and mStationTransitionTimer.time_left <= Constant.EVALUATE_SCORE_BEFORE_REACHING_NEXT_STATION:
		mReachingNextStation = true
		EventMgr.OnNextStationReaching.emit()
		mCurrLevelState = LevelState.REACHING_NEXT

		# Evaluate happiness
		mScore += mOverallHappiness


func _input(event): 
	if event.is_action_pressed("ui_cancel"): 
		game_ui.showGameOverPanel(true)


func next_station() -> void:
	mStationWaitingTimer.stop()
	
	# Disable the button
	game_ui.DisableButton(true)
	await get_tree().create_timer(2.5).timeout

	mCurrLevelState = LevelState.MOVING
	SelectionManager.sInstance.EndDrag()
	mReachingNextStation = false
	
	# Start the timer
	if not game_ui.gameover_panel.visible:
		mStationTransitionTimer.start(Constant.TIME_TO_NEXT_STATION)


func ReachedNextStation():
	if current_station_index < LevelMgr.mLevelData.mStations.size() - 1:
		UpdateStationDisplay()

		# var new_passengers = Station.EWStations[current_station_index].get_passenger_count()
		var new_passengers = 0
		var passengers_in_train = passenger_container.get_child_count() + new_passengers
		var passengers_to_kick_min = (passengers_in_train - Constant.MAX_PASSENGERS_IN_TRAIN) if passengers_in_train > Constant.MAX_PASSENGERS_IN_TRAIN else 0
		var passengers_to_kick_max = (passenger_container.get_child_count() - 1) if passenger_container.get_child_count() > 1 else 0
		var passengers_to_kick = randi_range(passengers_to_kick_min, passengers_to_kick_max)
		for i in range(passengers_to_kick):
			var random_passenger = passenger_container.get_child(randi() % passenger_container.get_child_count())

			# Passenger not seated, remove it from sitting area
			if (random_passenger as Passenger).mSittingOn != null:
				(random_passenger as Passenger).mSittingOn.RemovePassenger()

			StandingArea.sStandingArea.RemovePassenger(random_passenger)
			random_passenger.alight_passenger()
		
		SpawnPassengers()

		# Update the next station sign
		current_station_index += 1
		UpdateStationDisplay()
		EventMgr.OnNextstationReached.emit()
		mStationWaitingTimer.start((new_passengers * lerp(2, 4, float(LevelMgr.mLevelData.mStations.size() - current_station_index) / float(LevelMgr.mLevelData.mStations.size()))) + 1)
		
	if current_station_index == LevelMgr.mLevelData.mStations.size() - 1:
		game_ui.showGameOverPanel(true)

	# Reached station
	mCurrLevelState = LevelState.AT_STATION

	# Next station button can be pressed
	game_ui.DisableButton(false)



func UpdateStationDisplay() -> void:
	game_ui.set_station(LevelMgr.mLevelData.mStations[current_station_index].mName)


func SpawnPassengers() -> void:
	# choose how many passengers to spawn
	var numToSpawn := randi_range(LevelMgr.mLevelData.mStationDetails[current_station_index].mMinPassengers,
								  LevelMgr.mLevelData.mStationDetails[current_station_index].mMaxPassengers)
	
	for i in numToSpawn:
		var passenger = passenger_prefab.instantiate()
		passenger_container.add_child(passenger)
		passenger.position = Vector2(randi_range(Constant.LEFT_DRAG_LIMIT, Constant.RIGHT_DRAG_LIMIT), randi_range(Constant.BOTTOM_DRAG_LIMIT, Constant.TOP_DRAG_LIMIT))
		StandingArea.sStandingArea.AddPassenger(passenger)


func update_happiness_level(value: int) -> void:
	game_ui.set_happiness_level(value)


func ShowPassengerTooltip(_passenger : Passenger):
	passenger_information.SetTooltip(_passenger)
	passenger_information.show()
	# Cap at X position at [250, 1670] so the tooltip won't go over the screen
	passenger_information.position = Vector2(clamp(_passenger.global_position.x, 250, 1670), _passenger.global_position.y)  + Vector2(0, -275)


func HidePassengerTooltip():
	passenger_information.hide()


func IsPassengerTooltipVisible() -> bool:
	return passenger_information.visible



func StationStayTimerTimeout():
	if current_station_index < LevelMgr.mLevelData.mStations.size() - 1 and mOverallHappiness >= LevelMgr.mLevelData.mStationDetails[current_station_index].mTargetScore:
		EventMgr.OnNextStationPressed.emit()
