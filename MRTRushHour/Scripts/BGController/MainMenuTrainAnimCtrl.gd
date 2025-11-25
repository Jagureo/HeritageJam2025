extends AnimationPlayer

@onready var mTimer : Timer = $NextSpawnTimer
var mLeftToRight = false

func _ready():
	mTimer.start(randf_range(5, 10))
	mLeftToRight = true if randi_range(0, 1) == 0 else false


func OnTimerExpires():
	if mLeftToRight:
		play("TrainMovesFromLeft")
	else:
		play("TrainMovesFromRight")


func OnAnimComplete(_name : StringName):
	_ready()