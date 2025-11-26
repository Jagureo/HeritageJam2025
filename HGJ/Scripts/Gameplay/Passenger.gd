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
	
	# might not do due to technical difficulties
	# FAT,					# Occupies 2 seats
	LAST
}

enum TraitTypes {
	NORMAL,
	NOISY,		# Makes adjacent seated passengers angry
	# FAMILY,		# Prefers to sit with other family members
	LAST
}

enum GenderType {
	MALE,
	FEMALE,
	LAST
}

# Reference
@onready var mPassengerSprite : AnimatedSprite2D = $PassengerSprite
@onready var mScorePopupLabel : Label = $ScorePopupPanel/ScorePopupLabel
@onready var mScorePopupPanel : Panel = $ScorePopupPanel
@onready var mScorePopupTimer : Timer = $ScorePopupTimer
@onready var mNoiseParticles : Node2D = $Particles

# Passenger details
var mPassengerType : PassengerType
var mTraitType     : TraitTypes
var mGenderType    : GenderType

# Passenger in-game stuff
# var mHappinessLevel : int
# var mSeated : bool 
# var mIsAlighting : bool = false


# Determine which passenger is clicked
static var sSelectedPassenger : Passenger = null

# Seat that this passenger is sitting on
var mSittingOn : Seat = null


# # Passenger sprites
# static var sMalePassengerTextures : Dictionary[PassengerType, Texture2D] = {
# 	Passenger.PassengerType.CHILDREN :         preload("res://Sprites/Character/MaleChild.png") as Texture2D,
# 	Passenger.PassengerType.TEENAGER :         preload("res://Sprites/Character/MaleTeen.png") as Texture2D,
# 	Passenger.PassengerType.ADULT :            preload("res://Sprites/Character/MaleAdult.png") as Texture2D,
# 	Passenger.PassengerType.ADULT_WITH_BAGS :  preload("res://Sprites/Character/MaleBag.png") as Texture2D,
# 	Passenger.PassengerType.ADULT_WITH_BABY :  preload("res://Sprites/Character/MaleAdult.png") as Texture2D,
# 	Passenger.PassengerType.PREGNANT :         null,
# 	Passenger.PassengerType.ELDERLY :          preload("res://Sprites/Character/MaleElderly.png") as Texture2D,
# 	Passenger.PassengerType.INJURED :          preload("res://Sprites/Character/MaleInjured.png") as Texture2D,
# 	Passenger.PassengerType.HEMORRHOID :       preload("res://Sprites/Character/MaleAdult.png") as Texture2D,
# 	Passenger.PassengerType.WHEELCHAIR_BOUND : preload("res://Sprites/Character/MaleAdult.png") as Texture2D,
# }

# static var sFemalePassengerTextures : Dictionary[PassengerType, Texture2D] = {
# 	Passenger.PassengerType.CHILDREN :         preload("res://Sprites/Character/FemaleChild.png") as Texture2D,
# 	Passenger.PassengerType.TEENAGER :         preload("res://Sprites/Character/FemaleTeen.png") as Texture2D,
# 	Passenger.PassengerType.ADULT :            preload("res://Sprites/Character/FemaleAdult.png") as Texture2D,
# 	Passenger.PassengerType.ADULT_WITH_BAGS :  preload("res://Sprites/Character/FemaleBag.png") as Texture2D,
# 	Passenger.PassengerType.ADULT_WITH_BABY :  preload("res://Sprites/Character/FemaleAdult.png") as Texture2D,
# 	Passenger.PassengerType.PREGNANT :         preload("res://Sprites/Character/FemalePregnant.png") as Texture2D,
# 	Passenger.PassengerType.ELDERLY :          preload("res://Sprites/Character/FemaleElderly.png") as Texture2D,
# 	Passenger.PassengerType.INJURED :          preload("res://Sprites/Character/FemaleInjured.png") as Texture2D,
# 	Passenger.PassengerType.HEMORRHOID :       preload("res://Sprites/Character/FemaleAdult.png") as Texture2D,
# 	Passenger.PassengerType.WHEELCHAIR_BOUND : preload("res://Sprites/Character/FemaleAdult.png") as Texture2D,
# }


static var sMalePassengerTextures : Dictionary[PassengerType, SpriteFrames] = {
	Passenger.PassengerType.CHILDREN :         preload("res://Animations/MaleChild.tres") as SpriteFrames,
	Passenger.PassengerType.TEENAGER :         preload("res://Animations/MaleTeen.tres") as SpriteFrames,
	Passenger.PassengerType.ADULT :            preload("res://Animations/MaleAdult.tres") as SpriteFrames,
	Passenger.PassengerType.ADULT_WITH_BAGS :  preload("res://Animations/MaleAdultBag.tres") as SpriteFrames,
	Passenger.PassengerType.ADULT_WITH_BABY :  preload("res://Animations/MaleAdultWithBaby.tres") as SpriteFrames,
	Passenger.PassengerType.PREGNANT :         null,
	Passenger.PassengerType.ELDERLY :          preload("res://Animations/MaleElderly.tres") as SpriteFrames,
	Passenger.PassengerType.INJURED :          preload("res://Animations/MaleInjured.tres") as SpriteFrames,
	Passenger.PassengerType.HEMORRHOID :       preload("res://Animations/MaleAdult.tres") as SpriteFrames,
	Passenger.PassengerType.WHEELCHAIR_BOUND : preload("res://Animations/MaleWheelchair.tres") as SpriteFrames,
}

static var sFemalePassengerTextures : Dictionary[PassengerType, SpriteFrames] = {
	Passenger.PassengerType.CHILDREN :         preload("res://Animations/FemaleChild.tres") as SpriteFrames,
	Passenger.PassengerType.TEENAGER :         preload("res://Animations/FemaleTeen.tres") as SpriteFrames,
	Passenger.PassengerType.ADULT :            preload("res://Animations/FemaleAdult.tres") as SpriteFrames,
	Passenger.PassengerType.ADULT_WITH_BAGS :  preload("res://Animations/FemaleAdultBag.tres") as SpriteFrames,
	Passenger.PassengerType.ADULT_WITH_BABY :  preload("res://Animations/FemaleAdultWithBaby.tres") as SpriteFrames,
	Passenger.PassengerType.PREGNANT :         preload("res://Animations/FemalePregnant.tres") as SpriteFrames,
	Passenger.PassengerType.ELDERLY :          preload("res://Animations/FemaleElderly.tres") as SpriteFrames,
	Passenger.PassengerType.INJURED :          preload("res://Animations/FemaleInjured.tres") as SpriteFrames,
	Passenger.PassengerType.HEMORRHOID :       preload("res://Animations/FemaleAdult.tres") as SpriteFrames,
	Passenger.PassengerType.WHEELCHAIR_BOUND : preload("res://Animations/FemaleWheelchair.tres") as SpriteFrames,
}

func _ready():
	mPassengerSprite.material = mPassengerSprite.material.duplicate()

	# 	StandingArea.sStandingArea.AddPassenger(self)
	if GameManager.sInstance.hasWheelchairPassenger == true:
		mPassengerType = randi() % PassengerType.WHEELCHAIR_BOUND as PassengerType
	else:
		mPassengerType = randi() % PassengerType.LAST as PassengerType
	
	mTraitType = randi() % TraitTypes.LAST as TraitTypes

	# Only female can be pregnant
	if mPassengerType == PassengerType.PREGNANT:
		mGenderType = GenderType.FEMALE
	else:
		mGenderType = randi() % GenderType.LAST as GenderType
	
	# mPassengerSprite.texture = sMalePassengerTextures[mPassengerType] if mGenderType == GenderType.MALE else sFemalePassengerTextures[mPassengerType]
	mPassengerSprite.sprite_frames = sMalePassengerTextures[mPassengerType] if mGenderType == GenderType.MALE else sFemalePassengerTextures[mPassengerType]
	mPassengerSprite.play("Idle")

	# Noisy particles
	if mTraitType == TraitTypes.NOISY:
		mNoiseParticles.visible = true

func _process(_delta):
	if sSelectedPassenger == self:
		# Drag the passenger to the mouse's position
		# Clamp the mouse position to be within the screen
		self.position = get_global_mouse_position().clamp(Vector2(Constant.LEFT_DRAG_LIMIT, Constant.TOP_DRAG_LIMIT), 
														  Vector2(Constant.RIGHT_DRAG_LIMIT, Constant.BOTTOM_DRAG_LIMIT))

		# Release mouse
		if Input.is_action_just_released("Click") or GameManager.sInstance.mCurrLevelState != GameManager.LevelState.AT_STATION:
			# If passenger is dropped off at a selected seat, put it there
			if Seat.sSelectedSeat != null and not Seat.sSelectedSeat.HasPassenger():
				if Seat.sSelectedSeat.AddPassenger(self):
					self.global_position = Seat.sSelectedSeat.global_position
					mSittingOn = Seat.sSelectedSeat
					StandingArea.sStandingArea.RemovePassenger(self)

			# print("Dropped off passenger: ", self.name)
			sSelectedPassenger = null

		
func OnMouseInputEvent(_viewport : Node, _event : InputEvent, _shape_idx : int):
	# Can only move while at station
	if Input.is_action_just_pressed("Click") and sSelectedPassenger == null and GameManager.sInstance.mCurrLevelState == GameManager.LevelState.AT_STATION:
		# print("Picked up passenger: ", self.name)
		sSelectedPassenger = self
		AudioManager.sInstance.play_pickup_sound()

		# If passenger is sitting on a seat
		if mSittingOn != null:
			mSittingOn.RemovePassenger()
			mSittingOn = null
			StandingArea.sStandingArea.AddPassenger(self)



func _enter_tree():
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	

func _exit_tree():
	disconnect("mouse_entered", Callable(self, "_on_mouse_entered"))
	disconnect("mouse_exited", Callable(self, "_on_mouse_exited"))
	if sSelectedPassenger == self:
		sSelectedPassenger = null


func get_passenger_type_string() -> String:
	match mPassengerType:
		PassengerType.CHILDREN:
			return "Child"
		PassengerType.TEENAGER:
			return "Teenager"
		PassengerType.ADULT:
			return "Adult"
		PassengerType.ADULT_WITH_BAGS:
			return "Adult with Bags"
		PassengerType.ADULT_WITH_BABY:
			return "Adult with Baby"
		PassengerType.PREGNANT:
			return "Pregnant"
		PassengerType.ELDERLY:
			return "Elderly"
		PassengerType.INJURED:
			return "Injured"
		PassengerType.HEMORRHOID:
			return "Hemorrhoid"
		PassengerType.WHEELCHAIR_BOUND:
			return "Wheelchair"
		_:
			return "Human"
			
func get_passenger_trait_string() -> String:
	match mTraitType:
		TraitTypes.NORMAL:
			return "Quiet"
		TraitTypes.NOISY:
			return "Noisy"
		_:
			return "Ghost"
			
func get_passenger_gender_string() -> String:
	match mGenderType:
		GenderType.MALE:
			return "Male"
		GenderType.FEMALE:
			return "Female"
		_:
			return "Questioning"
	
func _on_mouse_entered():
	EventMgr.OnPassengerHoverStart.emit(self)
	mPassengerSprite.material.set_shader_parameter("tintFactor", -0.15)
	mPassengerSprite.material.set_shader_parameter("outlineWidth", 10)
	

func _on_mouse_exited():
	EventMgr.OnPassengerHoverEnd.emit(self)
	mPassengerSprite.material.set_shader_parameter("tintFactor", 0)
	mPassengerSprite.material.set_shader_parameter("outlineWidth", 0)
	

func show_evaluated_score_popup(score : int) -> void:
	if score < 0:
		mScorePopupLabel.add_theme_color_override("font_color", Color.RED)
		mScorePopupLabel.text = "%d" % score
	else:
		if score > 0:
			mScorePopupLabel.add_theme_color_override("font_color", Color.GREEN)
		else:
			mScorePopupLabel.add_theme_color_override("font_color", Color.WHITE)
		mScorePopupLabel.text = "+%d" % score
	mScorePopupTimer.start(3)
	mScorePopupPanel.visible = true
	
func hide_evaluated_score_popup() -> void:
	mScorePopupTimer.stop()
	mScorePopupPanel.hide()
	
func alight_passenger() -> void:
	await get_tree().create_timer(randf_range(1, 2)).timeout

	if mSittingOn != null:
		mSittingOn.RemovePassenger()

	StandingArea.sStandingArea.RemovePassenger(self)
	queue_free()




func get_passenger_description() -> String:
	var description_text = ""
	
	match mPassengerType:
		PassengerType.CHILDREN:
			description_text = "Loves to sit."
			pass
		PassengerType.TEENAGER:
			if mGenderType == GenderType.MALE:
				description_text += "Prefers to sit, does not like sitting beside females."
			else:
				if mGenderType == GenderType.FEMALE:
					description_text += "Prefers to sit, does not like sitting beside males."
		PassengerType.ADULT:
			description_text +=  "Prefers to sit."
		PassengerType.ADULT_WITH_BAGS:
			description_text +=  "Prefers to sit. If standing, upsets Standing passengers."
		PassengerType.ADULT_WITH_BABY:
			description_text +=  "Needs to sit. Priority seat bonus"
		PassengerType.PREGNANT:
			description_text +=  "Needs to sit. Priority seat bonus."
		PassengerType.ELDERLY:
			description_text +=  "Must sit. Priority seat bonus."
		PassengerType.INJURED:
			description_text +=  "Must sit. Priority seat bonus."
		PassengerType.HEMORRHOID:
			description_text +=  "Must stand."
		PassengerType.WHEELCHAIR_BOUND:
			description_text +=  "Must be in wheelchair area, otherwise Standing passengers get angry."
			
	if mTraitType == Passenger.TraitTypes.NOISY:
		description_text += " Cannot be next to Quiet Passengers."

	return description_text
