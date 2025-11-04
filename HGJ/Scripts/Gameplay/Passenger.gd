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
	FAT,					# Occupies 2 seats
}

enum TraitTypes {
	NORMAL,
	NOISY,		# Makes adjacent seated passengers angry
	# FAMILY,		# Prefers to sit with other family members
}

enum GenderType {
	MALE,
	FEMALE,
}

# Reference
@onready var mPassengerSprite : Sprite2D = $PassengerSprite

# Passenger details
var mPassengerType : PassengerType
var mTraitType     : TraitTypes
var mGenderType    : GenderType

# Passenger in-game stuff
# var mHappinessLevel : int
# var mSeated : bool 
var mIsAlighting : bool = false


# Determine which passenger is clicked
static var sSelectedPassenger : Passenger = null

# Seat that this passenger is sitting on
var mSittingOn : Seat = null

# func _ready():
# 	StandingArea.sStandingArea.AddPassenger(self)

func _process(_delta):
	if sSelectedPassenger == self:
		# Drag the passenger to the mouse's position
		# Clamp the mouse position to be within the screen
		self.position = get_global_mouse_position().clamp(Vector2(Constant.LEFT_DRAG_LIMIT, Constant.TOP_DRAG_LIMIT), 
														  Vector2(Constant.RIGHT_DRAG_LIMIT, Constant.BOTTOM_DRAG_LIMIT))

		# Release mouse
		if Input.is_action_just_released("Click"):
			# If passenger is dropped off at a selected seat, put it there
			if Seat.sSelectedSeat != null and not Seat.sSelectedSeat.HasPassenger():
				self.global_position = Seat.sSelectedSeat.global_position
				Seat.sSelectedSeat.AddPassenger(self)
				mSittingOn = Seat.sSelectedSeat
				StandingArea.sStandingArea.RemovePassenger(self)

			# print("Dropped off passenger: ", self.name)
			sSelectedPassenger = null

		
func OnMouseInputEvent(_viewport : Node, _event : InputEvent, _shape_idx : int):
	if Input.is_action_just_pressed("Click") and sSelectedPassenger == null:
		# print("Picked up passenger: ", self.name)
		sSelectedPassenger = self

		# If passenger is sitting on a seat
		if mSittingOn != null:
			mSittingOn.RemovePassenger()
			mSittingOn = null
			StandingArea.sStandingArea.AddPassenger(self)


func _exit_tree():
	if sSelectedPassenger == self:
		sSelectedPassenger = null