extends Node2D
class_name SeatRow

# A row of seats

# References
var mSeats : Array

func _ready():
	mSeats = get_children() 

	for i in range(len(mSeats)):
		(mSeats[i] as Seat).mSeatIndex = i

	PassengerManager.sInstance.RegisterSeatRow(self)


# Evaluate happiness for people seated down
func EvaluateHappiness() -> int:
	var sectionScore : int = 0
	# var alightingPassengers : Array[Passenger] = []

	for i in range(len(mSeats)):
		if not (mSeats[i] as Seat).HasPassenger():
			continue

		var passenger : Passenger = (mSeats[i] as Seat).mCurrentlySeatedBy
		var leftPassenger : Passenger  = null if i == 0 else (mSeats[i-1] as Seat).mCurrentlySeatedBy
		var rightPassenger : Passenger = null if i == len(mSeats) - 1 else (mSeats[i+1] as Seat).mCurrentlySeatedBy
		# var passengerScore : int = 0

		# If current passenger is noisy, then -1 score for each non-noisy adjacent passenger
		# if passenger.mTraitType == Passenger.TraitTypes.NOISY:
		# 	if leftPassenger != null && leftPassenger.mTraitType != Passenger.TraitTypes.NOISY:
		# 		passengerScore -= 1
		# 	if rightPassenger != null && rightPassenger.mTraitType != Passenger.TraitTypes.NOISY:
		# 		passengerScore -= 1

		match passenger.mPassengerType:
			Passenger.PassengerType.CHILDREN:
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passenger.mScore = Constant.CHILD_SCORE[1]
			
			Passenger.PassengerType.TEENAGER:
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					# If seated with opp gender, score
					if leftPassenger != null && leftPassenger.mGenderType != passenger.mGenderType:
						passenger.mScore = Constant.TEENAGER_SCORE[2]
					elif rightPassenger != null && rightPassenger.mGenderType != passenger.mGenderType:
						passenger.mScore = Constant.TEENAGER_SCORE[2]
					else:
						passenger.mScore = Constant.TEENAGER_SCORE[1]

			Passenger.PassengerType.ADULT:
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passenger.mScore = Constant.ADULT_SCORE[1]
			
			Passenger.PassengerType.ADULT_WITH_BAGS:
				# If seated down, +1 happiness
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passenger.mScore = Constant.ADULT_WITH_BAG_SCORE[1]
			
			Passenger.PassengerType.ADULT_WITH_BABY:
				# If seated down, +happiness, bonus if sitting on priority seat
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passenger.mScore = Constant.ADULT_WITH_BABY_SCORE[1]
					if mSeats[i].mSeatType == Seat.SeatType.PRIORITY:
						passenger.mScore += Constant.ADULT_WITH_BABY_SCORE[2]
				# If occupying wheelchair slot, it's as if standing up
				else:
					passenger.mScore = Constant.ADULT_WITH_BABY_SCORE[0]
			
			Passenger.PassengerType.PREGNANT:
				# If seated down, +1 happiness, bonus if sitting on priority seat
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passenger.mScore = Constant.PREGNANT_SCORE[1]
					if mSeats[i].mSeatType == Seat.SeatType.PRIORITY:
						passenger.mScore += Constant.PREGNANT_SCORE[2]
				# If occupying wheelchair slot, it's as if standing up
				else:
					passenger.mScore = Constant.PREGNANT_SCORE[0]
			
			
			Passenger.PassengerType.ELDERLY:
				# If seated down, +1 happiness, bonus if sitting on priority seat
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passenger.mScore = Constant.ELDERLY_SCORE[1]
					if mSeats[i].mSeatType == Seat.SeatType.PRIORITY:
						passenger.mScore += Constant.ELDERLY_SCORE[2]
				# If occupying wheelchair slot, it's as if standing up
				else:
					passenger.mScore = Constant.ELDERLY_SCORE[0]
			
			Passenger.PassengerType.INJURED:
				# If seated down, +1 happiness, bonus if sitting on priority seat
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passenger.mScore = Constant.INJURIED_SCORE[1]
					if mSeats[i].mSeatType == Seat.SeatType.PRIORITY:
						passenger.mScore += Constant.INJURIED_SCORE[2]
				# If occupying wheelchair slot, it's as if standing up
				else:
					passenger.mScore = Constant.INJURIED_SCORE[0]
			
			Passenger.PassengerType.HEMORRHOID:
				if mSeats[i].mSeatType != Seat.SeatType.WHEELCHAIR:
					passenger.mScore = Constant.HEMORRHOID_SCORE[1]
			
			Passenger.PassengerType.WHEELCHAIR_BOUND:
				if mSeats[i].mSeatType == Seat.SeatType.WHEELCHAIR:
					passenger.mScore = Constant.WHEELCHAIR_BOUND_SCORE[1]
					
		sectionScore += passenger.mScore

	return sectionScore



func _enter_tree():
	EventMgr.OnNextStationReaching.connect(EvaluateHappiness)

func _exit_tree():
	EventMgr.OnNextStationReaching.disconnect(EvaluateHappiness)
