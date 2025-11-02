extends Area2D
class_name Seat

# A single seat in a SeatRow

# Seat type
enum SeatType {
	NORMAL,
	PRIORITY,
	WHEELCHAIR,
}

@export var mSeatType : SeatType
var mCurrentlySeatedBy : Passenger
var mSeatIndex : int