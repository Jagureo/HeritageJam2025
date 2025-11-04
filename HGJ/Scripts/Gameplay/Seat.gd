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


# Determine which Seat is hovered
static var sSelectedSeat : Seat = null


func AddPassenger(_passenger : Passenger) -> bool:
	if _passenger.mPassengerType == Passenger.PassengerType.WHEELCHAIR_BOUND:
		if mSeatType != SeatType.WHEELCHAIR:
			return false
	print(_passenger.mPassengerType)
	mCurrentlySeatedBy = _passenger
	EventMgr.OnPassengerAddedToSeat.emit(_passenger, mSeatIndex)
	return true

func RemovePassenger():
	EventMgr.OnPassengerRemovedFromSeat.emit(mCurrentlySeatedBy, mSeatIndex)
	mCurrentlySeatedBy = null


func HasPassenger() -> bool:
	return mCurrentlySeatedBy != null


func OnMouseEntered():
	sSelectedSeat = self
	# print("Selected Seat: ", self.name)

func OnMouseExited():
	if sSelectedSeat == self:
		sSelectedSeat = null
	# print("Deselected Seat: ", self.name)


func _exit_tree():
	if sSelectedSeat == self:
		sSelectedSeat = null
