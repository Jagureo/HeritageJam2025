extends Area2D
class_name Passenger

enum PassengerType {
	CHILDREN,				# Prefers to sit down
	TEENAGER,				# Does not want to sit with someone opposite gender
	ADULT,					# Prefers to sit down
	ADULT_WITH_BAGS,		# Prefers to sit down, if standing, makes standing passengers angry
	ADULT_WITH_BABY,		# Prefers to sit down, bonus if sit on priority seat	
	PREGNANT,				# Prefers to sit down, bonus if sit on priority seat
	ELDERLY,				# Must sit down, bonus if sit on priority seat
	INJURED,				# Must sit down, bonus if sit on priority seat
	HEMORRHOID,				# Must stand up
	WHEELCHAIR_BOUND,		# Must use wheelchair slot, otherwise makes standing passengers angry
	LAST,
	
	# DLC Passengers
	# DURIAN_LOVER,
	# TEENAGER_WITH_BAGS,
	# SLEEPY_TEENAGER,
	# NOISY_CHILD,

}

enum GenderType {
	MALE,
	FEMALE,
	LAST
}

# Reference
@onready var mPassengerSprite : AnimatedSprite2D = $PassengerSprite
# @onready var mScorePopupLabel : Label = $ScorePopupPanel/ScorePopupLabel
# @onready var mScorePopupPanel : Panel = $ScorePopupPanel
# @onready var mScorePopupTimer : Timer = $ScorePopupTimer

# Passenger details
var mPassengerType : PassengerType
var mGenderType    : GenderType

# Seat that this passenger is sitting on
var mSittingOn : Seat = null

# Number of stations to stay
var mAlightingIn : int = 0

static var sMalePassengerTextures : Dictionary[PassengerType, SpriteFrames] = {
	Passenger.PassengerType.CHILDREN :           preload("res://Animations/MaleChild.tres") as SpriteFrames,
	Passenger.PassengerType.TEENAGER :           preload("res://Animations/MaleTeen.tres") as SpriteFrames,
	Passenger.PassengerType.ADULT :              preload("res://Animations/MaleAdult.tres") as SpriteFrames,
	Passenger.PassengerType.ADULT_WITH_BAGS :    preload("res://Animations/MaleAdultBag.tres") as SpriteFrames,
	Passenger.PassengerType.ADULT_WITH_BABY :    preload("res://Animations/MaleAdultWithBaby.tres") as SpriteFrames,
	Passenger.PassengerType.PREGNANT :           null,
	Passenger.PassengerType.ELDERLY :            preload("res://Animations/MaleElderly.tres") as SpriteFrames,
	Passenger.PassengerType.INJURED :            preload("res://Animations/MaleInjured.tres") as SpriteFrames,
	Passenger.PassengerType.HEMORRHOID :         preload("res://Animations/MaleAdult.tres") as SpriteFrames,
	Passenger.PassengerType.WHEELCHAIR_BOUND :   preload("res://Animations/MaleWheelchair.tres") as SpriteFrames,
	# DLC Passengers
	# Passenger.PassengerType.DURIAN_LOVER :       preload("res://Animations/MaleAdult.tres") as SpriteFrames,
	# Passenger.PassengerType.TEENAGER_WITH_BAGS : preload("res://Animations/MaleTeen.tres") as SpriteFrames,
	# Passenger.PassengerType.SLEEPY_TEENAGER :    preload("res://Animations/MaleTeen.tres") as SpriteFrames,
	# Passenger.PassengerType.NOISY_CHILD :        preload("res://Animations/MaleChild.tres") as SpriteFrames,
}

static var sFemalePassengerTextures : Dictionary[PassengerType, SpriteFrames] = {
	Passenger.PassengerType.CHILDREN :           preload("res://Animations/FemaleChild.tres") as SpriteFrames,
	Passenger.PassengerType.TEENAGER :           preload("res://Animations/FemaleTeen.tres") as SpriteFrames,
	Passenger.PassengerType.ADULT :              preload("res://Animations/FemaleAdult.tres") as SpriteFrames,
	Passenger.PassengerType.ADULT_WITH_BAGS :    preload("res://Animations/FemaleAdultBag.tres") as SpriteFrames,
	Passenger.PassengerType.ADULT_WITH_BABY :    preload("res://Animations/FemaleAdultWithBaby.tres") as SpriteFrames,
	Passenger.PassengerType.PREGNANT :           preload("res://Animations/FemalePregnant.tres") as SpriteFrames,
	Passenger.PassengerType.ELDERLY :            preload("res://Animations/FemaleElderly.tres") as SpriteFrames,
	Passenger.PassengerType.INJURED :            preload("res://Animations/FemaleInjured.tres") as SpriteFrames,
	Passenger.PassengerType.HEMORRHOID :         preload("res://Animations/FemaleAdult.tres") as SpriteFrames,
	Passenger.PassengerType.WHEELCHAIR_BOUND :   preload("res://Animations/FemaleWheelchair.tres") as SpriteFrames,
	# DLC Passengers
	# Passenger.PassengerType.DURIAN_LOVER :       preload("res://Animations/FemaleAdult.tres") as SpriteFrames,
	# Passenger.PassengerType.TEENAGER_WITH_BAGS : preload("res://Animations/FemaleTeen.tres") as SpriteFrames,
	# Passenger.PassengerType.SLEEPY_TEENAGER :    preload("res://Animations/FemaleTeen.tres") as SpriteFrames,
	# Passenger.PassengerType.NOISY_CHILD :        preload("res://Animations/FemaleChild.tres") as SpriteFrames,
}

func _ready():
	mPassengerSprite.material = mPassengerSprite.material.duplicate()

	mAlightingIn = randi_range(Constant.MIN_NUMBER_OF_STATIONS_TO_STAY, Constant.MAX_NUMBER_OF_STATIONS_TO_STAY)
	mPassengerType = PassengerManager.sInstance.GetRandomSpawnablePassenger()

	# Only female can be pregnant
	if mPassengerType == PassengerType.PREGNANT:
		mGenderType = GenderType.FEMALE
	else:
		mGenderType = randi() % GenderType.LAST as GenderType
	
	mPassengerSprite.sprite_frames = sMalePassengerTextures[mPassengerType] if mGenderType == GenderType.MALE else sFemalePassengerTextures[mPassengerType]
	mPassengerSprite.play("Idle")



func OnDragStart():
	AudioManager.sInstance.play_pickup_sound()

	# If passenger was sitting on a seat then unassign this seat
	if mSittingOn:
		mSittingOn.RemovePassenger()
		mSittingOn = null
		StandingArea.sStandingArea.AddPassenger(self)


func OnDragUpdate():
	global_position = (get_global_mouse_position() - SelectionManager.sInstance.mClickPos).clamp(
		Vector2(Constant.LEFT_DRAG_LIMIT, Constant.TOP_DRAG_LIMIT),
		Vector2(Constant.RIGHT_DRAG_LIMIT, Constant.BOTTOM_DRAG_LIMIT)
	)
		

func OnDragEnd():
	if Seat.sSelectedSeat and not Seat.sSelectedSeat.HasPassenger():
		if Seat.sSelectedSeat.AddPassenger(self):
			global_position = Seat.sSelectedSeat.global_position
			mSittingOn = Seat.sSelectedSeat
			StandingArea.sStandingArea.RemovePassenger(self)


func OnHoverStart():
	mPassengerSprite.material.set_shader_parameter("tintFactor", -0.15)
	mPassengerSprite.material.set_shader_parameter("outlineWidth", 10)


func OnHoverEnd():
	mPassengerSprite.material.set_shader_parameter("tintFactor", 0)
	mPassengerSprite.material.set_shader_parameter("outlineWidth", 0)



# func show_evaluated_score_popup(score : int) -> void:
# 	if score < 0:
# 		mScorePopupLabel.add_theme_color_override("font_color", Color.RED)
# 		mScorePopupLabel.text = "%d" % score
# 	else:
# 		if score > 0:
# 			mScorePopupLabel.add_theme_color_override("font_color", Color.GREEN)
# 		else:
# 			mScorePopupLabel.add_theme_color_override("font_color", Color.WHITE)
# 		mScorePopupLabel.text = "+%d" % score
# 	mScorePopupTimer.start(3)
# 	mScorePopupPanel.visible = true
	

# func hide_evaluated_score_popup() -> void:
# 	mScorePopupTimer.stop()
# 	mScorePopupPanel.hide()
	

func alight_passenger() -> void:
	await get_tree().create_timer(randf_range(1, 2)).timeout

	if mSittingOn != null:
		mSittingOn.RemovePassenger()

	StandingArea.sStandingArea.RemovePassenger(self)
	queue_free()
