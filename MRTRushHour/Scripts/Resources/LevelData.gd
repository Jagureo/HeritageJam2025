class_name LevelData

class Station:
	var mCode : String
	var mName : String
	var mIsUnderground : bool
	
class StationDetail:
	var mTargetScore : int
	var mMinPassengers : int
	var mMaxPassengers : int

class PassengerWeight:
	var mSpawnWeight : int
	var mSpawnMax : int

# Level data
var mLineName : String = ""
var mLineColour : Color = Color.WHITE
var mLineTextColour : Color = Color.WHITE
var mStations : Array[Station]
var mStationDetails : Array[StationDetail] 
var mPassengerSpawn : Dictionary[Passenger.PassengerType, PassengerWeight]


func ValidateLevel():
	assert(len(mStations) == len(mStationDetails), "mStations and mStationDetails must have same length")

