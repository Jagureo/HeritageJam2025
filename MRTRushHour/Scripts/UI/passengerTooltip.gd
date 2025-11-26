extends Node
class_name PassengerTooltip

@onready var mGenderIcon : TextureRect = $GenderIcon
@onready var mPassengerText : Label = $PassengerType
@onready var mStandingDesc : RichTextLabel = $StandingDesc
@onready var mSittingDesc : RichTextLabel = $SittingDesc



func SetTooltip(_passenger : Passenger):
	GetPassengerName(_passenger.mPassengerType)
	GetPassengerStandingDesc(_passenger.mPassengerType)
	GetPassengerSittingDesc(_passenger.mPassengerType)
	GetPassengerGenderSprite(_passenger.mGenderType)


static func GetPassengerName(_passengerType : Passenger.PassengerType) -> String:
	return ""


static func GetPassengerStandingDesc(_passengerType : Passenger.PassengerType) -> String:
	return ""


static func GetPassengerSittingDesc(_passengerType : Passenger.PassengerType) -> String:
	return ""


static func GetPassengerGenderSprite(_passengerGender : Passenger.GenderType) -> Texture2D:
	return null


static func ColouriseScore(_score : int) -> String:
	if _score > 0:
		return "[color=green]+{0} Happiness[/color]".format([_score])
	elif _score < 0:
		return "[color=red]{0} Happiness[/color]".format([_score])
	else:
		return "[color=gray]+{0} Happiness[/color]".format([_score])