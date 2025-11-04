extends Node2D
class_name StandingArea

# Passengers that does not have a slot yet

# References
var mCurrentlyStanding : Array[Passenger]

# Only 1 instance of standing area
static var sStandingArea : StandingArea = null


func _init():
	if sStandingArea == null:
		sStandingArea = self
	else:
		sStandingArea.queue_free()

# func _process(delta):
# 	if Input.is_key_pressed(KEY_0):
# 		print(mCurrentlyStanding)


func AddPassenger(_passenger : Passenger):
	mCurrentlyStanding.append(_passenger)
	EventMgr.OnPassengerAddedToStandingArea.emit(_passenger)

func RemovePassenger(_passenger : Passenger):
	mCurrentlyStanding.erase(_passenger)
	EventMgr.OnPassengerRemovedFromStandingArea.emit(_passenger)


# Evaluate happiness for people in the standing area
func EvaluateHappiness():
	for passenger in mCurrentlyStanding:
		match passenger.mPassengerType:
			Passenger.PassengerType.CHILDREN:
				# no change in score
				pass
			Passenger.PassengerType.TEENAGER:
				# no change in score
				pass
			Passenger.PassengerType.ADULT:
				# no change in score
				pass
			Passenger.PassengerType.ADULT_WITH_BAGS:
				# If standing, causes others to be unhappy, -1 per standing passenger
				GameManager.sInstance.mOverallHappiness -= (len(mCurrentlyStanding) - 1)
				pass
			Passenger.PassengerType.ADULT_WITH_BABY:
				# If standing, -1 happiness
				GameManager.sInstance.mOverallHappiness -= 1
				pass
			Passenger.PassengerType.PREGNANT:
				# If standing, -1 happiness
				GameManager.sInstance.mOverallHappiness -= 1
				pass
			Passenger.PassengerType.ELDERLY:
				# If standing, -2 happiness
				GameManager.sInstance.mOverallHappiness -= 2
				pass
			Passenger.PassengerType.INJURED:
				# If standing, -2 happiness
				GameManager.sInstance.mOverallHappiness -= 2
				pass
			Passenger.PassengerType.HEMORRHOID:
				# no change in score
				pass
			Passenger.PassengerType.WHEELCHAIR_BOUND:
				# If standing, causes others to be unhappy, -1 per standing passenger
				GameManager.sInstance.mOverallHappiness -= (len(mCurrentlyStanding) - 1)
				pass


func _exit_tree():
	sStandingArea = null