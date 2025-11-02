extends Area2D
class_name Seat

# A single seat in a SeatRow

# Seat type
enum SeatType {
	NORMAL,
	PRIORITY,
	WHEELCHAIR,
}

# Seat details
@export var mSeatType : SeatType
var mCurrentlySeatedBy : Passenger
var mSeatIndex : int

# References
@onready var mSeatSprite : Sprite2D = $SeatSprite


func AddPassenger(_passenger : Passenger):
	mCurrentlySeatedBy = _passenger
	EventMgr.OnPassengerAddedToSeat.emit(_passenger, mSeatIndex)

func RemovePassenger():
	EventMgr.OnPassengerRemovedFromSeat.emit(mCurrentlySeatedBy, mSeatIndex)
	mCurrentlySeatedBy = null

