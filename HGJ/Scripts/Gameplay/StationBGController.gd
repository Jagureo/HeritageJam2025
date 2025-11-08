extends Node

# Variables
var mBackgroundPosition : float = 0

# References
@onready var mBGSprite : Sprite2D = $StationBGSprite
@onready var mAnimationPlayer : AnimationPlayer = $AnimationPlayer

var lastAnim : String

func _ready():
	mAnimationPlayer.play("Start")

func _process(_delta):
	mBGSprite.position.x = mBackgroundPosition
	

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
