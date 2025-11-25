extends Node
class_name PassengerTooltip

@onready var mGenderIcon : TextureRect = $GenderIcon
@onready var mPassengerText : Label = $PassengerType
@onready var mStandingDesc : RichTextLabel = $StandingDesc
@onready var mSittingDesc : RichTextLabel = $SittingDesc



func SetTooltip(_passenger : Passenger):
	SetPassengerName(_passenger.mPassengerType)
	SetPassengerStandingDesc(_passenger.mPassengerType)
	SetPassengerSittingDesc(_passenger.mPassengerType)
	SetPassengerGenderSprite(_passenger.mGenderType)


func SetPassengerName(_passengerType : Passenger.PassengerType):
	pass


func SetPassengerStandingDesc(_passengerType : Passenger.PassengerType):
	pass


func SetPassengerSittingDesc(_passengerType : Passenger.PassengerType):
	pass


func SetPassengerGenderSprite(_passengerGender : Passenger.GenderType):
	pass


static func ColouriseScore(_score : int) -> String:
	if _score > 0:
		return "[color=green]+{0}[/color]".format([_score])
	elif _score < 0:
		return "[color=red]{0}[/color]".format([_score])
	else:
		return "[color=gray]+{0}[/color]".format([_score])