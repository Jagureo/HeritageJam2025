extends Area2D
class_name StandingArea


# References
var mCurrentlyStanding : Array[Passenger]

func AddPassenger(_passenger : Passenger):
	mCurrentlyStanding.append(_passenger)
	EventMgr.OnPassengerAddedToStandingArea.emit(_passenger)

func RemovePassenger(_passenger : Passenger):
	mCurrentlyStanding.erase(_passenger)
	EventMgr.OnPassengerRemovedFromStandingArea.emit(_passenger)