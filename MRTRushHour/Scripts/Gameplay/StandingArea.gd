class_name StandingArea

# Passengers that does not have a slot yet

# References
var mCurrentlyStanding : Array[Passenger]


func AddPassenger(_passenger : Passenger):
	mCurrentlyStanding.append(_passenger)


func RemovePassenger(_passenger : Passenger):
	mCurrentlyStanding.erase(_passenger)


# Evaluate happiness for people in the standing area
func EvaluateHappiness():
	var sectionScore : int = 0

	for passenger in mCurrentlyStanding:
		var passengerScore : int = 0
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
				# If standing, causes others to be unhappy, -1 happiness per standing passenger
				passengerScore -= len(mCurrentlyStanding) - 1
			
			Passenger.PassengerType.ADULT_WITH_BABY:
				# If standing, -1 happiness
				passengerScore -= 1
			
			Passenger.PassengerType.PREGNANT:
				# If standing, -1 happiness
				passengerScore -= 1
			
			Passenger.PassengerType.ELDERLY:
				# If standing, -2 happiness
				passengerScore -= 2
			
			Passenger.PassengerType.INJURED:
				# If standing, -2 happiness
				passengerScore -= 2
			
			Passenger.PassengerType.HEMORRHOID:
				# If standing, +1 happiness
				passengerScore += 1
			
			Passenger.PassengerType.WHEELCHAIR_BOUND:
				# If standing, causes others to be unhappy, -2 happiness per standing passenger
				passengerScore -= (len(mCurrentlyStanding) - 1) * 2

		sectionScore += passengerScore
		# TODO: Show score
		# passenger.show_evaluated_score_popup(passengerScore)

	GameManager.sInstance.mOverallHappiness += sectionScore

	# Remove passengers from the standing area if they are going to alight
	# for alightingPassenger in alightingPassengers:
	# 	RemovePassenger(alightingPassenger)		
	# alightingPassengers.clear()


