extends Area2D
class_name StandingArea

var mCurrentlyStanding : Array[Passenger]

func AddPassenger(_passenger : Passenger):
	mCurrentlyStanding.append(_passenger)

func RemovePassenger(_passenger : Passenger):
	mCurrentlyStanding.erase(_passenger)