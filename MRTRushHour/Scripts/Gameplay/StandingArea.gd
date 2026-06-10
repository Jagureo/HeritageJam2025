class_name StandingArea

# Passengers that does not have a slot yet

# References
var mCurrentlyStanding : Array[Passenger]


func AddPassenger(_passenger : Passenger):
	mCurrentlyStanding.append(_passenger)


func RemovePassenger(_passenger : Passenger):
	mCurrentlyStanding.erase(_passenger)

# Evaluate happiness for people in the standing area
func EvaluateHappiness() -> int:

	var sectionScore : int = 0

	# Set the score of all the passengers
	for passenger in mCurrentlyStanding:
		# Reset passenger's score
		passenger.mScore = 0

		match passenger.mPassengerType:
			Passenger.PassengerType.CHILDREN:
				passenger.mScore = Constant.CHILD_SCORE[0]
			
			Passenger.PassengerType.TEENAGER:
				passenger.mScore = Constant.TEENAGER_SCORE[0]
			
			Passenger.PassengerType.ADULT:
				passenger.mScore = Constant.ADULT_SCORE[0]
			
			Passenger.PassengerType.ADULT_WITH_BAGS:
				if len(mCurrentlyStanding) - 1 > Constant.ADULT_WITH_BAG_SCORE[3]:
					passenger.mScore = Constant.ADULT_WITH_BAG_SCORE[2]
				else:
					passenger.mScore = Constant.ADULT_WITH_BAG_SCORE[0]
				# passenger.mScore = Constant.ADULT_WITH_BAG_SCORE[0] + (len(mCurrentlyStanding) - 1) * Constant.ADULT_WITH_BAG_SCORE[2]
			
			Passenger.PassengerType.ADULT_WITH_BABY:
				passenger.mScore = Constant.ADULT_WITH_BABY_SCORE[0]
			
			Passenger.PassengerType.PREGNANT:
				passenger.mScore = Constant.PREGNANT_SCORE[0]
			
			Passenger.PassengerType.ELDERLY:
				passenger.mScore = Constant.ELDERLY_SCORE[0]
			
			Passenger.PassengerType.INJURED:
				passenger.mScore = Constant.INJURIED_SCORE[0]
			
			Passenger.PassengerType.HEMORRHOID:
				passenger.mScore = Constant.HEMORRHOID_SCORE[0]
			
			Passenger.PassengerType.WHEELCHAIR_BOUND:
				passenger.mScore = Constant.WHEELCHAIR_BOUND_SCORE[0]

		sectionScore += passenger.mScore
		passenger.mPassengerScorePopup.SetScore(passenger.mScore)
		passenger.mPassengerScorePopup.show()

	return sectionScore
