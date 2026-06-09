extends HSlider

@export var mAudioBusName : String
var mBusIndex : int

var mSFXTestPlayTime : float = 0.0
var mIsDragging : bool = false

func _ready():
	mBusIndex = AudioServer.get_bus_index(mAudioBusName)
	value = db_to_linear(AudioServer.get_bus_volume_db(mBusIndex))


func OnValueChanged(_newValue : float):
	AudioServer.set_bus_volume_db(mBusIndex, linear_to_db(_newValue))


func _process(_delta):
	if mIsDragging:
		mSFXTestPlayTime -= _delta
		if mSFXTestPlayTime <= 0.0:
			mSFXTestPlayTime = 0.25
			AudioMgr.sInstance.mClickSound.play()


func OnDragStarted():
	mIsDragging = true

func OnDragEnded(_val : float):
	mIsDragging = false