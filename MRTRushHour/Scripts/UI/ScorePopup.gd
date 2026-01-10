extends Control

@onready var mScorePopupPanel : Panel = $ScorePopupPanel
@onready var mScorePopupText  : Label = $ScorePopupLabel
@onready var mScorePopupAnim  : AnimationPlayer = $ScorePopupAnim

var mSetScore : int = 0
@export var mLerpedScoreDisplayScalar : float = 0

func _ready():
	visible = false


func OnVisible():
	if visible:
		mScorePopupAnim.play("display")
	else:
		mScorePopupAnim.play("RESET")


func SetScore(_score : int):
	mSetScore = _score
	if _score < 0:
		mScorePopupText.add_theme_color_override("font_color", Color.RED)
	elif _score > 0:
		mScorePopupText.add_theme_color_override("font_color", Color.GREEN)
	else:
		mScorePopupText.add_theme_color_override("font_color", Color.WHITE)



func _process(_delta):
	mScorePopupText.text = ("+" if mSetScore >= 0 else "") + str(lerp(0, mSetScore, mLerpedScoreDisplayScalar))


