extends Node
class_name GameManager

# UI refs
@onready var mGameUI : CanvasLayer = %GameUi
@onready var mPassengerTooltip : PassengerTooltip = $PassengerTooltip 

# Passengers refs
@onready var mPassengerContainer : Node2D = %AllPassengers
var mPassengerPrefab = preload("res://Scenes/Prefabs/Passenger.tscn")

# Score poups refs
@onready var mScorePopupContainer : Control = %AllScorePopups
var mScorePopupPrefab = preload("res://Scenes/UI/score_popup_panel.tscn")

# Timer refs
@onready var mTimer : Timer = $Timer

var mGameOver := false

var mScore : int = 0
var mCurrStationIdx : int = 0
var mOverallHappiness : int = 0
	# get:
	# 	return mOverallHappiness
	# set(newValue):
	# 	mOverallHappiness = newValue
		
		
var mNumberOfNewPassengersSpawned := 0

static var sInstance : GameManager = null


enum LevelState {
	AT_STATION,			# Train is at the station, passengers will alight, players can drag drop the passenger
	ABOUT_TO_LEAVE,		# Train is at the station and is about to leave, plays the announcement, can still drag drop passengers
	MOVING,				# Train is moving, show the moving animation
	REACHING_NEXT,		# Train is about to reach, happiness will be evaluated at this stage, change station signs also
	ALIGHT_PASSENGER,	# Alight passengers
	BOARD_PASSENGER,	# Board passengers
	LAST,
}

var mCurrLevelState : LevelState = LevelState.AT_STATION

func _enter_tree():
	if sInstance != null:
		queue_free()
		return

	sInstance = self
	EventMgr.OnNextStationPressed.connect(NextStation)
	EventMgr.OnPassengersFinishedAlighting.connect(StartBoardingPassengers)
	EventMgr.OnPassengersFinishedBoarding.connect(FinishedBoardingPassengers)

func _exit_tree():
	if sInstance == self:
		sInstance = null
		EventMgr.OnNextStationPressed.disconnect(NextStation)
		EventMgr.OnPassengersFinishedAlighting.disconnect(StartBoardingPassengers)
		EventMgr.OnPassengersFinishedBoarding.disconnect(FinishedBoardingPassengers)


# Called when the node enters the scene tree for the first time.
func _ready():

	# UpdateStationDisplay()
	SetHappinessLevel(0)
	mPassengerTooltip.hide()

	# Spawn as many score Popup and passenger Prefabs as there are max passengers
	for i in range(Constant.MAX_PASSENGERS_IN_TRAIN):
		var passenger = mPassengerPrefab.instantiate()
		(passenger as Node2D).hide()
		mPassengerContainer.add_child(passenger)
		PassengerManager.sInstance.RegisterPassenger(passenger)

		var scorepopup = mScorePopupPrefab.instantiate()
		(scorepopup as Control).hide()
		mScorePopupContainer.add_child(scorepopup)

	PassengerManager.sInstance.SpawnPassengers()


func _input(event): 
	if event.is_action_pressed("ui_cancel"): 
		mGameUI.ShowGameOverPanel(true)


# Can be triggered by pressing button
func NextStation():
	mTimer.stop()
	mGameUI.DisableButton(true)
	mCurrLevelState = LevelState.ABOUT_TO_LEAVE
	mTimer.start(Constant.LEAVING_STATE_TIMER)
	EventMgr.OnAboutToLeave.emit()


func ReachedStation():
	mCurrLevelState = LevelState.ALIGHT_PASSENGER
	EventMgr.OnPassengerAlighting.emit()
	print("Alight")


func StartBoardingPassengers():
	if mGameOver:
		return

	mCurrLevelState = LevelState.BOARD_PASSENGER
	EventMgr.OnPassengerBoarding.emit()
	print("Board")


func FinishedBoardingPassengers():
	# Don't count down on the first station
	if mCurrStationIdx == 0 or mCurrStationIdx == len(LevelMgr.mLevelData.mStations) - 1:
		return

	mCurrLevelState = LevelState.AT_STATION
	mGameUI.DisableButton(false)
	mTimer.start(Constant.AT_STATION_BASE_TIMER + mNumberOfNewPassengersSpawned * Constant.AT_STATION_TIME_PER_PASSENGER)
	EventMgr.OnNextstationReached.emit()
	print("At station")


# Triggered by timer
func OnTimerTimeout():
	mCurrLevelState += 1
	if mCurrLevelState >= LevelState.LAST:
		mCurrLevelState = LevelState.AT_STATION

	match mCurrLevelState:
		LevelState.ABOUT_TO_LEAVE:	# About to leave
			mGameUI.DisableButton(true)
			mTimer.start(Constant.LEAVING_STATE_TIMER)
			EventMgr.OnAboutToLeave.emit()
			print("about to leave")

		LevelState.MOVING:
			SelectionManager.sInstance.EndDrag()	# Stop all dragging
			mTimer.start(Constant.MOVING_STATE_TIMER)
			EventMgr.OnStationLeft.emit()
			print("moving")

		LevelState.REACHING_NEXT:
			mCurrStationIdx += 1
			# mTimer.start(Constant.REACHING_STATE_TIMER)
			EventMgr.OnNextStationReaching.emit()
			print("reaching next station")



func SetHappinessLevel(value: int) -> void:
	mOverallHappiness = value
	mGameUI.SetHappinessLevel(mOverallHappiness)

	print("Target score: ", LevelMgr.mLevelData.mStationDetails[GameManager.sInstance.mCurrStationIdx].mTargetScore)
	print("Current score: ", mOverallHappiness)

	if GameManager.sInstance.mCurrStationIdx > 0 and mOverallHappiness < LevelMgr.mLevelData.mStationDetails[GameManager.sInstance.mCurrStationIdx].mTargetScore:
		mGameUI.ShowGameOverPanel(true)
		mGameOver = true
		mPassengerTooltip.hide()


func ShowPassengerTooltip(_passenger : Passenger):
	mPassengerTooltip.SetTooltip(_passenger)
	mPassengerTooltip.show()
	# Cap at X position at [250, 1670] so the tooltip won't go over the screen
	mPassengerTooltip.position = Vector2(clamp(_passenger.global_position.x, 250, 1670), _passenger.global_position.y)  + Vector2(0, -275)


func HidePassengerTooltip():
	mPassengerTooltip.hide()


func IsPassengerTooltipVisible() -> bool:
	return mPassengerTooltip.visible



# func StationStayTimerTimeout():
# 	if mCurrStationIdx < LevelMgr.mLevelData.mStations.size() - 1 and mOverallHappiness >= LevelMgr.mLevelData.mStationDetails[mCurrStationIdx].mTargetScore:
# 		EventMgr.OnNextStationPressed.emit()
