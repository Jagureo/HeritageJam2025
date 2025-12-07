class_name LevelData

class StationDetail:
	var mCode : String
	var mName : String
	var mIsUnderground : bool
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
var mPassengerSpawn : Dictionary[Passenger.PassengerType, PassengerWeight]

