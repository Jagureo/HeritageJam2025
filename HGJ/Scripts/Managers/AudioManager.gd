extends Node
class_name AudioManager

static var sInstance : AudioManager

@onready var mBGMMusic : AudioStreamPlayer = $BackgroundMusic
@onready var mClickSound : AudioStreamPlayer = $ClickSound
@onready var mDoorClosingSound : AudioStreamPlayer = $DoorClosingSound

func _init():
	if sInstance != null:
		self.queue_free()
		return
	sInstance = self
