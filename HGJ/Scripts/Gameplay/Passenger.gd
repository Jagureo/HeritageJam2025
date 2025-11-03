extends Area2D
class_name Passenger

enum PassengerType {
	CHILDREN,				# Prefers to sit down
	TEENAGER,				# Does not want to sit with someone opposite gender
	ADULT,					# No special property
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
	FAMILY,		# Prefers to sit with other family members
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
var mHappinessLevel : float
var mSeated : bool 


