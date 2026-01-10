extends Node
class_name LevelManager

# static var sInstance : LevelManager = null

# All the levels that are available
enum MRTLine {
	EWL = 0,
	NSL,
	NEL,
	CCL,
	DTL,
	TEL,
}

var mSelectedLine : MRTLine
var mLevelData : LevelData
var mReversed : bool = false

# func _enter_tree():
# 	if sInstance != null:
# 		self.queue_free()
# 		return
# 	sInstance = self


# func _exit_tree():
# 	if sInstance == self:
# 		sInstance = null


func SetLevel(_line : MRTLine):
	mSelectedLine = _line
	
	match(_line):
		MRTLine.EWL:
			LoadLevel("res://Data/DevLine.json")
			# LoadLevel("res://Data/EWL.json")
		MRTLine.NSL:
			LoadLevel("res://Data/NSL.json")
		_:
			printerr("Unknown Line Level loaded: ", str(_line))


func LoadLevel(_levelDataFile : String):
	var file = FileAccess.open(_levelDataFile, FileAccess.READ)
	if file == null:
		print("JSON Error: ", FileAccess.get_open_error())
		return

	var content = file.get_as_text()
	var json = JSON.new()
	var results = JSON.parse_string(content)

	if results is not Dictionary:
		printerr("JSON Parse Error: ", json.get_error_message(), "at line ", json.get_error_line())
		return

	mLevelData = LevelData.new()

	# Load the name of the line
	mLevelData.mLineName = results["lineName"]

	# Load the line's background colour
	mLevelData.mLineColour.r = results["lineColour"]["r"] / 255.0
	mLevelData.mLineColour.g = results["lineColour"]["g"] / 255.0
	mLevelData.mLineColour.b = results["lineColour"]["b"] / 255.0
	mLevelData.mLineColour.a = 1

	# Load the line's text colour
	if results["lineTextColour"] == "black":
		mLevelData.mLineTextColour = Color.BLACK
	else:
		mLevelData.mLineTextColour = Color.WHITE

	# Load all the stations
	for station in results["stations"]:
		var s : LevelData.Station = LevelData.Station.new()
		s.mCode = station["code"]
		s.mName = station["name"]
		s.mIsUnderground = station["isUnderground"]
		mLevelData.mStations.push_back(s)

	# 50% chance to reverse the stations
	mReversed = (randi_range(0, 1) == 0)
	if mReversed:
		print("Station List is reversed")
		mLevelData.mStations.reverse()

	# Load target score and max passengers
	for station in results["stationDetails"]:
		var sd : LevelData.StationDetail = LevelData.StationDetail.new()
		sd.mTargetScore = station["targetScore"]
		sd.mMinPassengers = station["minPassengersToSpawn"]
		sd.mMaxPassengers = station["maxPassengersToSpawn"]
		mLevelData.mStationDetails.push_back(sd)

	# Load passenger spawn weight and max spawn
	for passengerSpawn in results["passengersSpawn"]:
		var passengerDetail : LevelData.PassengerWeight = LevelData.PassengerWeight.new()
		passengerDetail.mSpawnWeight = passengerSpawn["weight"]
		passengerDetail.mSpawnMax = passengerSpawn["max"]
		var passengerTypeString : String = passengerSpawn["type"]
		var passengerType : Passenger.PassengerType
		
		match passengerTypeString:
			"Child": 
				passengerType = Passenger.PassengerType.CHILDREN
			"Teenager": 
				passengerType = Passenger.PassengerType.TEENAGER
			"Adult": 
				passengerType = Passenger.PassengerType.ADULT
			"AdultWithBag": 
				passengerType = Passenger.PassengerType.ADULT_WITH_BAGS
			"AdultWithBaby": 
				passengerType = Passenger.PassengerType.ADULT_WITH_BABY
			"Elderly": 
				passengerType = Passenger.PassengerType.ELDERLY
			"Injured": 
				passengerType = Passenger.PassengerType.INJURED
			"Pregnant": 
				passengerType = Passenger.PassengerType.PREGNANT
			"Hemorrhoid": 
				passengerType = Passenger.PassengerType.HEMORRHOID
			"Wheelchair": 
				passengerType = Passenger.PassengerType.WHEELCHAIR_BOUND
			# DLC Passengers
			# "DurianLover": 
			# 	passengerType = Passenger.PassengerType.DURIAN_LOVER
			# "TeenagerWithBag": 
			# 	passengerType = Passenger.PassengerType.TEENAGER_WITH_BAGS
			# "SleepyTeenager": 
			# 	passengerType = Passenger.PassengerType.SLEEPY_TEENAGER
			# "NoisyChild": 
			# 	passengerType = Passenger.PassengerType.NOISY_CHILD
			_:
				printerr("Unknown passenger parsed: ", passengerTypeString)
				assert(false, "Unknown passenger parsed")
				return
		mLevelData.mPassengerSpawn[passengerType] = passengerDetail

	# Some assertion checks for the level like mStations length and mStationDetails length must be the same
	mLevelData.ValidateLevel()



func ClearData():
	mLevelData.free()
