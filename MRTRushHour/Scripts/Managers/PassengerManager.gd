extends Node
class_name PassengerManager
# This class manages spawning and despawning of passengers

static var sInstance : PassengerManager = null

var mCurrentPassengerCount : Dictionary[Passenger.PassengerType, int] = {
	Passenger.PassengerType.CHILDREN :         0,
	Passenger.PassengerType.TEENAGER :         0,
	Passenger.PassengerType.ADULT :            0,
	Passenger.PassengerType.ADULT_WITH_BAGS :  0,
	Passenger.PassengerType.ADULT_WITH_BABY :  0,
	Passenger.PassengerType.PREGNANT :         0,
	Passenger.PassengerType.ELDERLY :          0,
	Passenger.PassengerType.INJURED :          0,
	Passenger.PassengerType.HEMORRHOID :       0,
	Passenger.PassengerType.WHEELCHAIR_BOUND : 0,
	# DLC Passengers
	# Passenger.PassengerType.DURIAN_LOVER :       0,
	# Passenger.PassengerType.TEENAGER_WITH_BAGS : 0,
	# Passenger.PassengerType.SLEEPY_TEENAGER :    0,
	# Passenger.PassengerType.NOISY_CHILD :        0,
}

var mStandingArea : StandingArea = null
var mSeatRows : Array[SeatRow] = []

var mPassengerPool : Array[Passenger] = []
var mNumberOfPassengersInUse : int = 0


func _enter_tree():
	if sInstance != null:
		queue_free()
		return

	sInstance = self
	mStandingArea = StandingArea.new()

	EventMgr.OnPassengerAlighting.connect(DespawnPassengers)
	EventMgr.OnPassengerBoarding.connect(SpawnPassengers)
	EventMgr.OnNextStationReaching.connect(EvaluateScore)

func _exit_tree():
	if sInstance != self:
		return

	sInstance = null
	EventMgr.OnPassengerAlighting.disconnect(DespawnPassengers)
	EventMgr.OnPassengerBoarding.disconnect(SpawnPassengers)
	EventMgr.OnNextStationReaching.disconnect(EvaluateScore)
	mStandingArea = null
	mSeatRows.clear()
	mPassengerPool.clear()


func RegisterSeatRow(_seatRow : SeatRow):
	mSeatRows.append(_seatRow)


func RegisterPassenger(_passenger : Passenger):
	mPassengerPool.append(_passenger)



func GetSpawnablePassengerPool():
	var pool = []
	for passengerType in LevelMgr.mLevelData.mPassengerSpawn.keys():
		if mCurrentPassengerCount[passengerType] < LevelMgr.mLevelData.mPassengerSpawn[passengerType].mSpawnMax:
			pool.append(passengerType)
	return pool


func GetRandomSpawnablePassenger() -> Passenger.PassengerType:
	# Exclude passengers that have already reached max quantity
	var validPool = GetSpawnablePassengerPool()

	# Just spawn an adult if passengers are all invalid
	if validPool.size() == 0:
		return Passenger.PassengerType.ADULT

	var totalWeight := 0
	for passengerType in validPool:
		totalWeight += LevelMgr.mLevelData.mPassengerSpawn[passengerType].mSpawnWeight

	var roll = randi_range(1, totalWeight)
	var accumulated := 0

	for passengerType in validPool:
		accumulated += LevelMgr.mLevelData.mPassengerSpawn[passengerType].mSpawnWeight
		if roll <= accumulated:
			return passengerType

	# Fallback to spawn adult
	return Passenger.PassengerType.ADULT






func SpawnPassengers():
	# choose how many passengers to spawn
	var numToSpawn := randi_range(LevelMgr.mLevelData.mStationDetails[GameManager.sInstance.mCurrStationIdx].mMinPassengers,
								  LevelMgr.mLevelData.mStationDetails[GameManager.sInstance.mCurrStationIdx].mMaxPassengers)
	GameManager.sInstance.mNumberOfNewPassengersSpawned = numToSpawn

	for i in numToSpawn:
		# Ran out of passengers in the pool
		if mPassengerPool.is_empty():
			break
		var passenger = mPassengerPool.back()

		mPassengerPool.pop_back()
		passenger.InitPassenger()
		mStandingArea.AddPassenger(passenger)
		mNumberOfPassengersInUse += 1
		mCurrentPassengerCount[passenger.mPassengerType] += 1
		await get_tree().create_timer(0.1).timeout

	EventMgr.OnPassengersFinishedBoarding.emit()


func DespawnPassengers():
	# Remove all standing passengers that have reached their destination
	var standingPassengersToRemove : Array[Passenger] = []
	for passenger in mStandingArea.mCurrentlyStanding:
		if (passenger.mAlightingIn <= 0):
			standingPassengersToRemove.push_back(passenger)

	for passenger in standingPassengersToRemove:
		mStandingArea.RemovePassenger(passenger)
		mPassengerPool.push_back(passenger)
		passenger.visible = false
		passenger.mPassengerScorePopup.Reset()
		mCurrentPassengerCount[passenger.mPassengerType] -= 1
		mNumberOfPassengersInUse -= 1
		
		await get_tree().create_timer(0.1).timeout
	
	# Remove all sitting passengers that have reached their destination
	for seatRow in mSeatRows:			# For each seat row
		for seat in seatRow.mSeats:		# For each seat
			if seat.HasPassenger() and seat.mCurrentlySeatedBy.mAlightingIn <= 0:
				var passenger = seat.mCurrentlySeatedBy
				mPassengerPool.push_back(passenger)
				passenger.visible = false
				passenger.mPassengerScorePopup.Reset()
				mCurrentPassengerCount[passenger.mPassengerType] -= 1
				mNumberOfPassengersInUse -= 1
				seat.RemovePassenger(true)
				passenger.mSittingOn = null
				await get_tree().create_timer(0.1).timeout
	
	EventMgr.OnPassengersFinishedAlighting.emit()


func EvaluateScore():
	var totalScore := 0
	totalScore += mStandingArea.EvaluateHappiness()

	for seatRow in mSeatRows:
		totalScore += seatRow.EvaluateHappiness()

	GameManager.sInstance.SetHappinessLevel(GameManager.sInstance.mOverallHappiness + totalScore)
	
