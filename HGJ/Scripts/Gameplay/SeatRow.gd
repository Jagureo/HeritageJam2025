extends Node2D
class_name SeatRow

# A row of seats

var mSeats : Array[Seat]


func _ready():
	mSeats = get_children() as Array[Seat]

	for i in range(len(mSeats)):
		mSeats[i].mSeatIndex = i
		