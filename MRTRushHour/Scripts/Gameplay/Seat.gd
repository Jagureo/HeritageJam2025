extends Area2D
class_name Seat

# A single seat in a SeatRow

# Seat type
enum SeatType {
	NORMAL,
	PRIORITY,
	WHEELCHAIR,
}

# Seat details
@export var mSeatType : SeatType
@export var mIsBackFacing : bool = false
var mCurrentlySeatedBy : Passenger
var mSeatIndex : int

# References
@onready var mSeatSprite : Sprite2D = $SeatSprite

@onready var mChildSitPos : Node2D = $ChildSitPos
@onready var mTeenSitPos : Node2D = $TeenSitPos



# Determine which Seat is hovered
static var sSelectedSeat : Seat = null


func _ready():
	mSeatSprite.material = mSeatSprite.material.duplicate()

func AddPassenger(_passenger : Passenger) -> bool:
	if _passenger.mPassengerType == Passenger.PassengerType.WHEELCHAIR_BOUND:
		if mSeatType != SeatType.WHEELCHAIR:
			AudioMgr.sInstance.mInvalidSound.play()
			return false
	mCurrentlySeatedBy = _passenger
	# Lighter glow to indicate seat is occupied
	mSeatSprite.material.set_shader_parameter("tintFactor", -0.25)
	return true

func RemovePassenger(_isAlighting : bool = false):
	mCurrentlySeatedBy = null
	# Remove the tint that showed this seat is occupied
	if _isAlighting:
		mSeatSprite.material.set_shader_parameter("tintFactor", 0)

func HasPassenger() -> bool:
	return mCurrentlySeatedBy != null


func OnMouseEntered():
	# Only show outline when dragging a passenger
	if SelectionManager.sInstance.mDraggedPassenger == null:
		return

	sSelectedSeat = self
	
	# If seat has passenger then don't show highlight
	if HasPassenger():
		return

	mSeatSprite.material.set_shader_parameter("tintFactor", -0.25)
	mSeatSprite.material.set_shader_parameter("outlineWidth", 4)
	if mIsBackFacing:
		z_index = 3
	else:
		z_index = 0


func OnMouseExited():
	if sSelectedSeat == self:
		sSelectedSeat = null

	# If got passenger sitting, then don't change the tint
	if mCurrentlySeatedBy == null:
		mSeatSprite.material.set_shader_parameter("tintFactor", 0)
	
	mSeatSprite.material.set_shader_parameter("outlineWidth", 0)
	if mIsBackFacing:
		z_index = 2
	else:
		z_index = -1


func _exit_tree():
	if sSelectedSeat == self:
		sSelectedSeat = null
