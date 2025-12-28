extends AnimationPlayer



func OpenDoor():
	play("DoorOpen")


func CloseDoor():
	AudioManager.sInstance.mDoorClosingSound.play()
	await get_tree().create_timer(2.3).timeout
	play("DoorClose")


func _ready():
	play("DoorOpen")


func _enter_tree():
	EventMgr.OnAboutToLeave.connect(CloseDoor)
	EventMgr.OnPassengerAlighting.connect(OpenDoor)


func _exit_tree():
	EventMgr.OnAboutToLeave.disconnect(CloseDoor)
	EventMgr.OnPassengerAlighting.disconnect(OpenDoor)
