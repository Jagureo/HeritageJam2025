extends Control

# References 
@onready var mMainScreen : Control = $MainScreen
@onready var mHowToPlayScreen : Control = $HowToPlayScreen
@onready var mCreditsScreen : Control = $CreditsScreen
@onready var mScreenAnimation : AnimationPlayer = $ScreenAnimations
@export_file("*.tscn") var mGameScene : String



func _ready():
	mScreenAnimation.play("RESET")


func OnPlayButtonPressed():
	AudioManager.sInstance.mClickSound.play()
	LevelMgr.SetLevel(LevelManager.MRTLine.NSL)
	get_tree().change_scene_to_file(mGameScene)


func OnHowToPlayButtonPressed():
	AudioManager.sInstance.mClickSound.play()
	mScreenAnimation.play("FadeInH2P")

	
func OnCreditsButtonPressed():
	AudioManager.sInstance.mClickSound.play()
	mScreenAnimation.play("FadeInCredits")


func OnBackButtonPressed():
	AudioManager.sInstance.mClickSound.play()
	mMainScreen.visible = true
	mHowToPlayScreen.visible = false
	mCreditsScreen.visible = false


func OnBackButtonPressed2(_lastScreen : String):
	AudioManager.sInstance.mClickSound.play()
	if _lastScreen == "credits":
		mScreenAnimation.play("FadeOutCredits")
	elif _lastScreen == "howtoplay":
		mScreenAnimation.play("FadeOutH2P")
	elif _lastScreen == "levelSelect":
		mScreenAnimation.play("FadeOutCredits")
	else:
		assert(false, "Unknown screen animation being played")