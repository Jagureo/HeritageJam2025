extends Node

# Variables
@export_range(0,1) var mScrollSpeedScaler : float = 0
@export var mSkyScrollSpeed : float
@export var mHDBScrollSpeed : float
@export var mTreeScrollSpeed : float


# References
@onready var mSkySections : Array[Sprite2D] = [$SkySection1, $SkySection2, $SkySection3]
@onready var mHDBSections : Array[Sprite2D] = [$HDBSection1, $HDBSection2, $HDBSection3]
@onready var mTreeSections : Array[Sprite2D] = [$TreeSection1, $TreeSection2, $TreeSection3]
@onready var mAnimationPlayer : AnimationPlayer = $AnimationPlayer


func _process(delta):
	for sprite in mSkySections:
		(sprite as Node2D).position.x += (-mSkyScrollSpeed * mScrollSpeedScaler * delta)

	for sprite in mHDBSections:
		(sprite as Node2D).position.x += (-mHDBScrollSpeed * mScrollSpeedScaler * delta)
	
	for sprite in mTreeSections:
		(sprite as Node2D).position.x += (-mTreeScrollSpeed * mScrollSpeedScaler * delta)

	if mSkySections[0].position.x < -2000:
		mSkySections[0].position.x = mSkySections.back().position.x + 1920
		mSkySections.push_back(mSkySections[0])
		mSkySections.pop_front()

	if mHDBSections[0].position.x < -2000:
		mHDBSections[0].position.x = mHDBSections.back().position.x + 1920
		mHDBSections.push_back(mHDBSections[0])
		mHDBSections.pop_front()
	
	if mTreeSections[0].position.x < -2000:
		mTreeSections[0].position.x = mTreeSections.back().position.x + 1920
		mTreeSections.push_back(mTreeSections[0])
		mTreeSections.pop_front()




func NextStationReaching():
	mAnimationPlayer.play("EnteringStation")


func StationLeaving():
	await get_tree().create_timer(2.4).timeout
	mAnimationPlayer.play("LeavingStation")



func _enter_tree():
	EventMgr.OnNextStationReaching.connect(NextStationReaching)
	EventMgr.OnNextStationPressed.connect(StationLeaving)


func _exit_tree():
	EventMgr.OnNextStationReaching.disconnect(NextStationReaching)
	EventMgr.OnNextStationPressed.disconnect(StationLeaving)
