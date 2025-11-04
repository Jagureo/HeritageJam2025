extends Node2D
class_name StandingArea

# Passengers that does not have a slot yet

# References
var mCurrentlyStanding : Array[Passenger]

# Only 1 instance of standing area
static var sStandingArea : StandingArea = null


func _init():
	if sStandingArea == null:
		sStandingArea = self
	else:
		sStandingArea.queue_free()

# func _process(delta):
# 	if Input.is_key_pressed(KEY_0):
# 		print(mCurrentlyStanding)


func AddPassenger(_passenger : Passenger):
	mCurrentlyStanding.append(_passenger)
	EventMgr.OnPassengerAddedToStandingArea.emit(_passenger)

func RemovePassenger(_passenger : Passenger):
	mCurrentlyStanding.erase(_passenger)
	EventMgr.OnPassengerRemovedFromStandingArea.emit(_passenger)


func _exit_tree():
	sStandingArea = null