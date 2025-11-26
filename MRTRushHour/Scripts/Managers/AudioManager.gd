extends Node
class_name AudioManager

static var sInstance : AudioManager

@onready var mBGMMusic : AudioStreamPlayer = $BackgroundMusic
@onready var mClickSound : AudioStreamPlayer = $ClickSound
@onready var mDoorClosingSound : AudioStreamPlayer = $DoorClosingSound
@onready var mPickupSound: AudioStreamPlayer = $PickupSound

var sPassengerPickupSounds : Array[AudioStream] = [
	preload("res://Audio/Pickup/pickup1.mp3") as AudioStream,
	preload("res://Audio/Pickup/pickup2.mp3") as AudioStream,
	preload("res://Audio/Pickup/pickup3.mp3") as AudioStream,
	preload("res://Audio/Pickup/pickup4.mp3") as AudioStream,
	preload("res://Audio/Pickup/pickup5.mp3") as AudioStream,
	preload("res://Audio/Pickup/pickup6.mp3") as AudioStream,
	preload("res://Audio/Pickup/pickup7.mp3") as AudioStream,
	preload("res://Audio/Pickup/pickup8.mp3") as AudioStream,
	preload("res://Audio/Pickup/pickup9.mp3") as AudioStream,
]

func _init():
	if sInstance != null:
		self.queue_free()
		return
	sInstance = self

func play_pickup_sound() -> void:
	mPickupSound.stream = sPassengerPickupSounds[randi_range(0, len(sPassengerPickupSounds) - 1)]
	mPickupSound.play()
