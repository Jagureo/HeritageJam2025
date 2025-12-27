extends Node

# Variables
@export var mPositionScalar : float = 0

# References
@onready var mBGSprite : Sprite2D = $StationBGSprite
@onready var mAnimationPlayer : AnimationPlayer = $AnimationPlayer
@onready var mStationNameSign : Label = $StationBGSprite/Sign/StationSignContainer/StationName
@onready var mStationCodeSign : Label = $StationBGSprite/Sign/StationSignContainer/StationBubble/StationCode
@onready var mStationCodeBubble : Panel = $StationBGSprite/Sign/StationSignContainer/StationBubble

var mEntryPos : float = -2500
var mStationPos : float = 10
var mExitPos : float = 2500
var mIsEntry : int = 0



func _ready():
	mBGSprite.position.x = mStationPos
	mStationCodeBubble.get_theme_stylebox("panel").bg_color = LevelMgr.mLevelData.mLineColour
	mStationCodeSign.add_theme_color_override("font_color", LevelMgr.mLevelData.mLineTextColour)
	mStationNameSign.text = LevelMgr.mLevelData.mStations[GameManager.sInstance.current_station_index].mName
	mStationCodeSign.text = LevelMgr.mLevelData.mStations[GameManager.sInstance.current_station_index].mCode


func _process(_delta):
	if mIsEntry == 1:
		mBGSprite.position.x = lerpf(mEntryPos, mStationPos, mPositionScalar)
	elif mIsEntry == -1:
		mBGSprite.position.x = lerpf(mStationPos, mExitPos, mPositionScalar)


func NextStationReaching():
	mIsEntry = 1
	mPositionScalar = 0
	mAnimationPlayer.play("EnteringStation")
	mStationNameSign.text = LevelMgr.mLevelData.mStations[GameManager.sInstance.current_station_index + 1].mName
	mStationCodeSign.text = LevelMgr.mLevelData.mStations[GameManager.sInstance.current_station_index + 1].mCode

func StationLeaving():
	await get_tree().create_timer(2.4).timeout
	mIsEntry = -1
	mPositionScalar = 0
	mAnimationPlayer.play("LeavingStation")


func _enter_tree():
	EventMgr.OnNextStationReaching.connect(NextStationReaching)
	EventMgr.OnNextStationPressed.connect(StationLeaving)


func _exit_tree():
	EventMgr.OnNextStationReaching.disconnect(NextStationReaching)
	EventMgr.OnNextStationPressed.disconnect(StationLeaving)
