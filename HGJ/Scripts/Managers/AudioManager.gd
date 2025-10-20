extends Node
class_name AudioManager

static var sInstance : AudioManager

@onready var mClickSound : AudioStreamPlayer = $ClickSound




func _init():
	if sInstance != null:
		self.queue_free()
		return
	sInstance = self

