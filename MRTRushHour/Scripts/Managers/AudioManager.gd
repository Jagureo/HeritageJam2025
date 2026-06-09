extends Node
class_name AudioManager

static var sInstance : AudioManager = null

@onready var mBGMMusic : AudioStreamPlayer = $BackgroundMusic
@onready var mClickSound : AudioStreamPlayer = $ClickSound
@onready var mDoorClosingSound : AudioStreamPlayer = $DoorClosingSound
@onready var mPickupSound: AudioStreamPlayer = $PickupSound
@onready var mWinSound : AudioStreamPlayer = $WinSound
@onready var mLoseSound : AudioStreamPlayer = $LoseSound
@onready var mInvalidSound : AudioStreamPlayer = $InvalidSound
@onready var mPlaceSound : AudioStreamPlayer = $PlaceSound

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

func _enter_tree():
	if sInstance != null:
		queue_free()
		return
	sInstance = self
	

func _exit_tree():
	if sInstance == self:
		sInstance = null


func play_pickup_sound() -> void:
	mPickupSound.stream = sPassengerPickupSounds[randi_range(0, len(sPassengerPickupSounds) - 1)]
	mPickupSound.play()
