extends Control

# References 
@onready var mScreenAnimation : AnimationPlayer = $ScreenAnimations
@onready var mEWLGlow : TextureRect = $LevelSelectScreen/TextWrapper/MapBackground/EWLGlow
@onready var mNSLGlow : TextureRect = $LevelSelectScreen/TextWrapper/MapBackground/NSLGlow
@onready var mNELGlow : TextureRect = $LevelSelectScreen/TextWrapper/MapBackground/NELGlow

@export_file("*.tscn") var mGameScene : String





func _ready():
	mScreenAnimation.play("RESET")


func OnPlayButtonPressed():
	AudioManager.sInstance.mClickSound.play()
	mScreenAnimation.play("FadeInLevelSelect")


func OnHowToPlayButtonPressed():
	AudioManager.sInstance.mClickSound.play()
	mScreenAnimation.play("FadeInH2P")


func OnSettingsButtonPressed():
	AudioManager.sInstance.mClickSound.play()
	mScreenAnimation.play("FadeInSettings")


	
func OnCreditsButtonPressed():
	AudioManager.sInstance.mClickSound.play()
	mScreenAnimation.play("FadeInCredits")



func OnBackButtonPressed(_lastScreen : String):
	AudioManager.sInstance.mClickSound.play()

	match _lastScreen:
		"credits":
			mScreenAnimation.play("FadeOutCredits")
		"howtoplay":
			mScreenAnimation.play("FadeOutH2P")
		"levelselect":
			mScreenAnimation.play("FadeOutLevelSelect")
		"settings":
			mScreenAnimation.play("FadeOutSettings")
		_:
			assert(false, "Unknown screen animation being played")


func OnLevelSelected(_line : LevelManager.MRTLine):
	AudioManager.sInstance.mClickSound.play()

	match _line:
		LevelManager.MRTLine.EWL:
			LevelMgr.SetLevel(LevelManager.MRTLine.EWL)
		LevelManager.MRTLine.NSL:
			LevelMgr.SetLevel(LevelManager.MRTLine.NSL)
		LevelManager.MRTLine.NEL:
			LevelMgr.SetLevel(LevelManager.MRTLine.NEL)
	
	get_tree().change_scene_to_file(mGameScene)



func OnLevelButtonHovered(_line : LevelManager.MRTLine):
	match _line:
		LevelManager.MRTLine.EWL:
			mEWLGlow.visible = true
		LevelManager.MRTLine.NSL:
			mNSLGlow.visible = true
		LevelManager.MRTLine.NEL:
			mNELGlow.visible = true

	# Todo: Set line description



func OnLevelButtonUnhovered(_line : LevelManager.MRTLine):
	match _line:
		LevelManager.MRTLine.EWL:
			mEWLGlow.visible = false
		LevelManager.MRTLine.NSL:
			mNSLGlow.visible = false
		LevelManager.MRTLine.NEL:
			mNELGlow.visible = false

	# Todo: clear line description

