extends Node
class_name LevelManager

static var sInstance : LevelManager = null

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



func _enter_tree():
	if sInstance != null:
		self.queue_free()
		return
	sInstance = self


func _exit_tree():
	if sInstance == self:
		sInstance = null


func SetLevel(_line : MRTLine):
	mSelectedLine = _line
	
	match(_line):
		MRTLine.EWL:
			LoadLevel("res://Data/EWL.json")
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
	mLevelData.mLineName = results["lineName"]

	mLevelData.mLineColour.r = results["lineColor"]["r"]
	mLevelData.mLineColour.g = results["lineColor"]["g"]
	mLevelData.mLineColour.b = results["lineColor"]["b"]
	mLevelData.mLineColour.a = 1

	if results["lineTextColour"] == "black":
		mLevelData.mLineTextColour = Color.BLACK
	else:
		mLevelData.mLineTextColour = Color.WHITE

	for station in results["stations"]:
		var stationDetail : LevelData.StationDetail = LevelData.StationDetail.new()
		stationDetail.mCode = station["code"]
		stationDetail.mName = station["name"]
		stationDetail.mIsUnderground = station["isUnderground"]
		stationDetail.mTargetScore = station["targetScore"]
		stationDetail.mMinPassengers = station["minPassengers"]
		stationDetail.mMaxPassengers = station["maxPassengers"]
		mLevelData.mStations.push_back(stationDetail)

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
			"DurianLover": 
				passengerType = Passenger.PassengerType.DURIAN_LOVER
			"TeenagerWithBag": 
				passengerType = Passenger.PassengerType.TEENAGER_WITH_BAGS
			"SleepyTeenager": 
				passengerType = Passenger.PassengerType.SLEEPY_TEENAGER
			"NoisyChild": 
				passengerType = Passenger.PassengerType.NOISY_CHILD
			_:
				printerr("Unknown passenger parsed: ", passengerTypeString)
				return
		mLevelData.mPassengerSpawn[passengerType] = passengerDetail