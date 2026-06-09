extends CanvasLayer

# UI at the bottom
@onready var mNextStationButton : Button = $MainScreen/NextStationButton
@onready var mTimerProgBar : ProgressBar = $MainScreen/TimeIcon/TimeProgressBar
@onready var mTimerLabel : Label = $MainScreen/TimeIcon/TimeProgressBar/TimeLabel
@onready var mHappinessLabel : Label = $MainScreen/HappinessIcon/HappinessPanel/HappinessLabel
@onready var mTargetLabel : Label = $MainScreen/TargetIcon/TargetPanel/TargetLabel
@onready var mRemainingStationsLabel : Label = $MainScreen/RemainingIcon/RemainingPanel/RemainingLabel
@onready var mNextStationLabel : Label = $MainScreen/NextStationIcon/NextStationPanel/NextStationLabel
@onready var mPauseButton : Button = $MainScreen/PauseButton

# Game over panel
@onready var gameover_panel = $MainScreen/GameOverPanel
@onready var gameover_title : Label = $MainScreen/GameOverPanel/GameOverText
@onready var gameover_happiness : Label = $MainScreen/GameOverPanel/HappinessLabel
@onready var gameover_stations : Label = $MainScreen/GameOverPanel/StationCountLabel
@onready var playAgainButton : Button = $MainScreen/GameOverPanel/PlayAgain
@onready var mainMenuButton : Button = $MainScreen/GameOverPanel/MainMenu

# Pause panel
@onready var pause_panel : Panel = $MainScreen/PausePanel

# Panel animation
@onready var mPanelAnimation : AnimationPlayer = $MainScreen/PanelAnimation

# Main menu scene
@export_file("*.tscn") var mMainMenuScene : String

# Progress bar colour
@export var mStartingFillColour : Color
@export var mStartingBorderColour : Color
@export var mEndingFillColour : Color
@export var mEndingBorderColour : Color

# Happiness label animation
@onready var mHappinessLabelAnim : AnimationPlayer = $MainScreen/HappinessIcon/HappinessPanel/HappinessLabel/HappinessLabelAnim
var mOldHappinessValue : int = 0
var mNewHappinessValue : int = 0
@export var mLerpPercent : float = 0


var mRoundTimer : float = 0 

# Next station Button
func NextStation() -> void:
	if GameManager.sInstance.mCurrStationIdx < LevelMgr.mLevelData.mStations.size() - 1:
		EventMgr.OnNextStationPressed.emit()
		AudioManager.sInstance.mClickSound.play()

func DisableButton(_value : bool):
	mNextStationButton.disabled = _value
	mPauseButton.disabled = _value


func SetHappiness(_oldValue : int, _value: int):
	mOldHappinessValue = _oldValue
	mNewHappinessValue = _value
	mHappinessLabelAnim.play("AnimateScore")


func SetTarget(_value : int):
	mTargetLabel.text = "{0}".format([_value])


func SetNextStation():
	mRemainingStationsLabel.text = "{0}/{1}".format([GameManager.sInstance.mCurrStationIdx + 1, len(LevelMgr.mLevelData.mStations)])
	if GameManager.sInstance.mCurrStationIdx == len(LevelMgr.mLevelData.mStations) - 1:
		mNextStationLabel.text = "Last Station"
	else:
		mNextStationLabel.text = LevelMgr.mLevelData.mStations[GameManager.sInstance.mCurrStationIdx + 1].mName



func SetTimeAvailableThisStation(_value : float):
	mTimerProgBar.max_value = _value


func _process(_showdelta: float) -> void:
	if GameManager.sInstance.mCurrLevelState == GameManager.LevelState.AT_STATION:
		mTimerLabel.text = "%.1fs" % GameManager.sInstance.mTimer.time_left
		mTimerProgBar.set_value_no_signal(GameManager.sInstance.mTimer.time_left)
		mTimerProgBar.get_theme_stylebox("fill").bg_color = lerp(mEndingFillColour, mStartingFillColour, mTimerProgBar.value / mTimerProgBar.max_value)
		mTimerProgBar.get_theme_stylebox("fill").border_color = lerp(mEndingBorderColour, mStartingBorderColour, mTimerProgBar.value / mTimerProgBar.max_value)

	if mHappinessLabelAnim.is_playing():
		mHappinessLabel.text = "{0}".format([floori(lerp(mOldHappinessValue, mNewHappinessValue, mLerpPercent))])


func ShowGameOverPanel(_show : bool, _isVictory : bool = false):
	if _show:
		if _isVictory:
			gameover_title.text = "VICTORY!"
			gameover_title.add_theme_color_override("font_color", Color(0.73, 1, 0, 1))
			AudioMgr.sInstance.mWinSound.play()
		else:
			gameover_title.text = "GAME OVER!"
			gameover_title.add_theme_color_override("font_color", Color(1, 0.89, 0, 1))
			AudioMgr.sInstance.mLoseSound.play()
			
		gameover_stations.text = "Stations Travelled: {0}".format([GameManager.sInstance.mCurrStationIdx + 1])
		gameover_happiness.text = "Overall Happiness: {0}".format([GameManager.sInstance.mOverallHappiness])
		DisableButton(true)
		mPanelAnimation.play("ShowGameoverPanel")
		GameManager.sInstance.mTimer.stop()
	else:
		mPanelAnimation.play("HideGameoverPanel")


func ShowPausePanel(_show : bool):
	AudioManager.sInstance.mClickSound.play()
	if _show:
		mPanelAnimation.play("ShowPausePanel")
		get_tree().paused = true
		DisableButton(true)
	else:
		mPanelAnimation.play("HidePausePanel")
		get_tree().paused = false
		DisableButton(false)


func OnPlayAgainButtonPressed() -> void:
	AudioManager.sInstance.mClickSound.play()
	get_tree().reload_current_scene()


func OnMainMenuButtonPressed() -> void:
	AudioManager.sInstance.mClickSound.play()
	get_tree().paused = false
	get_tree().change_scene_to_file(mMainMenuScene)
