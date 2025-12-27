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

var mStandingPassengers : Array[Passenger] = []
var mSeatRows : Array[SeatRow] = []


func _enter_tree():
	if sInstance != null:
		queue_free()
		return

	sInstance = self

func _exit_tree():
	if sInstance == self:
		sInstance = null


func RegisterSeatRow(_seatRow : SeatRow):
	mSeatRows.append(_seatRow)



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
	pass
	# mCurrentPassengerCount[_passenger.mPassengerType] += 1


func DespawnPassengers():
	pass
	# mCurrentPassengerCount[_passenger.mPassengerType] -= 1


func EvaluateScore():
	pass


func OnStationReached():
	pass