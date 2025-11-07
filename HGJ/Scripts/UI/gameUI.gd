extends CanvasLayer

@onready var station_label = $MainScreen/Sign/Station_Label
@onready var happiness_label = $MainScreen/Sign2/Happniess_Level
@onready var nextStationButton = $MainScreen/NextStationButton
@onready var timerDisplay = $MainScreen/Sign3/Time_Left

@onready var gameover_panel = $MainScreen/GameOverPanel
@onready var gameover_happiness = $MainScreen/GameOverPanel/Happniess_Level
@onready var gameover_stations = $MainScreen/GameOverPanel/StationCount_Label
@onready var gameover_score = $MainScreen/GameOverPanel/Score_Label
@onready var playAgainButton : Button = $MainScreen/GameOverPanel/PlayAgain
@onready var mainMenuButton : Button = $MainScreen/GameOverPanel/MainMenu

@export_file("*.tscn") var mMainMenuScene : String

func set_station(msg: String) -> void:
	station_label.text = msg

func next_station() -> void:
	if GameManager.sInstance.current_station_index < Station.EWStations.size() - 1 :
		EventMgr.OnNextStationPressed.emit()
		AudioManager.sInstance.mClickSound.play()

func set_happiness_level(value: int) -> void:
	happiness_label.text = "Happiness Level: %d" % value

func DisableButton(val : bool):
	nextStationButton.disabled = val

func showGameOverPanel(show : bool):
	if show:
		gameover_happiness.text = happiness_label.text
		gameover_stations.text = "Stations Travelled: %d" % GameManager.sInstance.current_station_index
		gameover_score.text = "Score: %d" % GameManager.sInstance.mScore
		
		nextStationButton.hide()
		gameover_panel.show()
		GameManager.sInstance.mStationWaitingTimer.stop()
		
	else:
		gameover_panel.hide()

func OnPlayAgainButtonPressed() -> void:
	AudioManager.sInstance.mClickSound.play()
	get_tree().reload_current_scene()

func OnMainMenuButtonPressed() -> void:
	AudioManager.sInstance.mClickSound.play()
	get_tree().change_scene_to_file(mMainMenuScene)
	
func _process(delta: float) -> void:
	timerDisplay.text = "Time Remaining: %.1f" % GameManager.sInstance.mStationWaitingTimer.time_left
