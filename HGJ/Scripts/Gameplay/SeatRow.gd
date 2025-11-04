extends Node2D
class_name SeatRow

# A row of seats

@export var mAffectedByAdjacencyRules : bool = true

# References
var mSeats : Array

func _ready():
	mSeats = get_children() 

	for i in range(len(mSeats)):
		(mSeats[i] as Seat).mSeatIndex = i
		


func EvaluateHappiness():
	pass