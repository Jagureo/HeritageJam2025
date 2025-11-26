extends Control

# References 
@onready var mMainScreen : Control = $MainScreen
@onready var mHowToPlayScreen : Control = $HowToPlayScreen
@onready var mCreditsScreen : Control = $CreditsScreen
@export_file("*.tscn") var mGameScene : String


func OnPlayButtonPressed():
	AudioManager.sInstance.mClickSound.play()
	get_tree().change_scene_to_file(mGameScene)


func OnHowToPlayButtonPressed():
	AudioManager.sInstance.mClickSound.play()
	mMainScreen.visible = false
	mHowToPlayScreen.visible = true

	
func OnCreditsButtonPressed():
	AudioManager.sInstance.mClickSound.play()
	mMainScreen.visible = false
	mCreditsScreen.visible = true


func OnBackButtonPressed():
	AudioManager.sInstance.mClickSound.play()
	mMainScreen.visible = true
	mHowToPlayScreen.visible = false
	mCreditsScreen.visible = false
