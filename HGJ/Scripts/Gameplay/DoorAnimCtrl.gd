extends AnimationPlayer



func OpenDoor():
	play("DoorOpen")


func CloseDoor():
	play("DoorClose")


func _ready():
	play("DoorOpen")


func _enter_tree():
	EventMgr.OnNextStationPressed.connect(CloseDoor)
	EventMgr.OnNextstationReached.connect(OpenDoor)


func _exit_tree():
	EventMgr.OnNextStationPressed.disconnect(CloseDoor)
	EventMgr.OnNextstationReached.disconnect(OpenDoor)


