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
	for i in range(len(mSeats)):
		if not (mSeats[i] as Seat).HasPassenger():
			continue

		var passenger : Passenger = (mSeats[i] as Seat).mCurrentlySeatedBy

		match passenger.mPassengerType:
			Passenger.PassengerType.CHILDREN:
				pass
			Passenger.PassengerType.TEENAGER:
				pass
			Passenger.PassengerType.ADULT:
				pass
			Passenger.PassengerType.ADULT_WITH_BAGS:
				pass
			Passenger.PassengerType.ADULT_WITH_BABY:
				pass
			Passenger.PassengerType.PREGNANT:
				pass
			Passenger.PassengerType.ELDERLY:
				pass
			Passenger.PassengerType.INJURED:
				pass
			Passenger.PassengerType.HEMORRHOID:
				pass
			Passenger.PassengerType.WHEELCHAIR_BOUND:
				pass