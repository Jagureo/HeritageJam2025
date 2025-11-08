extends Node2D
class_name SeatRow

# A row of seats

# References
var mSeats : Array

func _ready():
	mSeats = get_children() 

	for i in range(len(mSeats)):
		(mSeats[i] as Seat).mSeatIndex = i
		

# Evaluate happiness for people seated down
func EvaluateHappiness():
	var sectionScore : int = 0
	# var alightingPassengers : Array[Passenger] = []

	for i in range(len(mSeats)):
		if not (mSeats[i] as Seat).HasPassenger():
			continue

		var passenger : Passenger = (mSeats[i] as Seat).mCurrentlySeatedBy
		var leftPassenger : Passenger  = null if i == 0 else (mSeats[i-1] as Seat).mCurrentlySeatedBy
		var rightPassenger : Passenger = null if i == len(mSeats) - 1 else (mSeats[i+1] as Seat).mCurrentlySeatedBy
		var passengerScore : int = 0

		# If current passenger is noisy, then -1 score for each non-noisy adjacent passenger
		if passenger.mTraitType == Passenger.TraitTypes.NOISY:
			if leftPassenger != null && leftPassenger.mTraitType != Passenger.TraitTypes.NOISY:
				passengerScore -= 1
			if rightPassenger != null && rightPassenger.mTraitType != Passenger.TraitTypes.NOISY:
				passengerScore -= 1

		match passenger.mPassengerType:
			Passenger.PassengerType.CHILDREN:
				# if seated down, +2 happiness
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passengerScore += 2
			
			Passenger.PassengerType.TEENAGER:
				# If seated down, +1 happiness
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passengerScore += 1
				# If seated with opp gender, -1
				if leftPassenger != null && leftPassenger.mGenderType != passenger.mGenderType:
					passengerScore -= 1
				if rightPassenger != null && rightPassenger.mGenderType != passenger.mGenderType:
					passengerScore -= 1
			
			Passenger.PassengerType.ADULT:
				# if seated down, +1 happiness
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passengerScore += 1
			
			Passenger.PassengerType.ADULT_WITH_BAGS:
				# If seated down, +1 happiness
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passengerScore += 1
			
			Passenger.PassengerType.ADULT_WITH_BABY:
				# If seated down, +1 happiness, bonus if sitting on priority seat
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passengerScore += 1
					if mSeats[i].mSeatType == Seat.SeatType.PRIORITY:
						passengerScore += 1
				# If occupying wheelchair slot, it's as if standing up
				else:
					passengerScore -= 1
			
			Passenger.PassengerType.PREGNANT:
				# If seated down, +1 happiness, bonus if sitting on priority seat
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passengerScore += 1
					if mSeats[i].mSeatType == Seat.SeatType.PRIORITY:
						passengerScore += 1
				# If occupying wheelchair slot, it's as if standing up
				else:
					passengerScore -= 1
			
			Passenger.PassengerType.ELDERLY:
				# If seated down, +2 happiness, bonus if sitting on priority seat
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passengerScore += 2
					if mSeats[i].mSeatType == Seat.SeatType.PRIORITY:
						passengerScore += 1
				# If occupying wheelchair slot, it's as if standing up
				else:
					passengerScore -= 2
			
			Passenger.PassengerType.INJURED:
				# If seated down, +2 happiness, bonus if sitting on priority seat
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passengerScore += 2
					if mSeats[i].mSeatType == Seat.SeatType.PRIORITY:
						passengerScore += 1
				# If occupying wheelchair slot, it's as if standing up
				else:
					passengerScore -= 2
			
			Passenger.PassengerType.HEMORRHOID:
				# If seated down, -2 happiness
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passengerScore -= 2
			
			Passenger.PassengerType.WHEELCHAIR_BOUND:
				# If seated down at wheelchair slot, +1 happiness
				if mSeats[i].mSeatType == Seat.SeatType.WHEELCHAIR:
					passengerScore += 2
					
		sectionScore += passengerScore
		passenger.show_evaluated_score_popup(passengerScore)

	GameManager.sInstance.mOverallHappiness += sectionScore

	# Remove passengers from the standing area if they are going to alight
	# for alightingPassenger in alightingPassengers:
	# 	alightingPassenger.mSittingOn.RemovePassenger()		
	# alightingPassengers.clear()



func _enter_tree():
	EventMgr.OnNextStationReaching.connect(EvaluateHappiness)

func _exit_tree():
	EventMgr.OnNextStationReaching.disconnect(EvaluateHappiness)
