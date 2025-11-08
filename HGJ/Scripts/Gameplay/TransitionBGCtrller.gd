extends Node

# Variables
@export var mScrollSpeed : float = 0

# References
@onready var mSpriteSections : Array[Sprite2D] = [$Section1, $Section2, $Section3]
@onready var mAnimationPlayer : AnimationPlayer = $AnimationPlayer


func _process(delta):
	for sprite in mSpriteSections:
		(sprite as Node2D).position.x += (-mScrollSpeed * delta)

	if (mSpriteSections[0] as Node2D).position.x < -2000:
		(mSpriteSections[0] as Node2D).position.x = (mSpriteSections[len(mSpriteSections) - 1] as Node2D).position.x + 1920
		mSpriteSections.push_back(mSpriteSections[0])
		mSpriteSections.pop_front()

func NextStationReaching():
	mAnimationPlayer.play("EnteringStation")


func StationLeaving():
	mAnimationPlayer.play("LeavingStation")



func _enter_tree():
	EventMgr.OnNextStationReaching.connect(NextStationReaching)
	EventMgr.OnNextStationPressed.connect(StationLeaving)


func _exit_tree():
	EventMgr.OnNextStationReaching.disconnect(NextStationReaching)
	EventMgr.OnNextStationPressed.disconnect(StationLeaving)
