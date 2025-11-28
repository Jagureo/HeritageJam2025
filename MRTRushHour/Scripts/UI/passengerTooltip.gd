extends Panel
class_name PassengerTooltip

@onready var mGenderIcon : TextureRect = $GenderIcon
@onready var mPassengerText : Label = $PassengerType
@onready var mStandingDesc : RichTextLabel = $StandingDesc
@onready var mSittingDesc : RichTextLabel = $SittingDesc


static var sGenderSprite : Dictionary[Passenger.GenderType, Texture2D] = {
	Passenger.GenderType.MALE :   preload("res://Sprites/UI/Credits/icon.svg") as Texture2D,
	Passenger.GenderType.FEMALE : preload("res://Sprites/UI/Credits/icon.svg") as Texture2D,
}



func SetTooltip(_passenger : Passenger):
	mPassengerText.text = GetPassengerName(_passenger.mPassengerType)
	mStandingDesc.text = GetPassengerStandingDesc(_passenger.mPassengerType)
	mSittingDesc.text = GetPassengerSittingDesc(_passenger.mPassengerType, _passenger.mGenderType)
	mGenderIcon.texture = GetPassengerGenderSprite(_passenger.mGenderType)
	visible = true


static func GetPassengerName(_passengerType : Passenger.PassengerType) -> String:
	match _passengerType:
		Passenger.PassengerType.CHILDREN:
			return "Child"
		Passenger.PassengerType.TEENAGER:
			return "Teenager"
		Passenger.PassengerType.ADULT:
			return "Adult"
		Passenger.PassengerType.ADULT_WITH_BAGS:
			return "Adult with Bags"
		Passenger.PassengerType.ADULT_WITH_BABY:
			return "Adult with Baby"
		Passenger.PassengerType.PREGNANT:
			return "Pregnant"
		Passenger.PassengerType.ELDERLY:
			return "Elderly"
		Passenger.PassengerType.INJURED:
			return "Injured"
		Passenger.PassengerType.HEMORRHOID:
			return "Hemorrhoid"
		Passenger.PassengerType.WHEELCHAIR_BOUND:
			return "Wheelchair-Bound"
		Passenger.PassengerType.DURIAN_LOVER:
			return "Durian Lover"
		Passenger.PassengerType.TEENAGER_WITH_BAGS:
			return "Teenager with Bags"
		Passenger.PassengerType.OBESE_ADULT:
			return "Obese Adult"
		Passenger.PassengerType.SLEEPY_TEENAGER:
			return "Sleepy Teenager"
		Passenger.PassengerType.NOISY_CHILD:
			return "Noisy Child"
		_:
			return "Unknown"


static func GetPassengerStandingDesc(_passengerType : Passenger.PassengerType) -> String:
	match _passengerType:
		Passenger.PassengerType.CHILDREN:
			return ColourScore(Constant.CHILD_SCORE[0]) + "."
		Passenger.PassengerType.TEENAGER:
			return ColourScore(Constant.TEENAGER_SCORE[0]) + "."
		Passenger.PassengerType.ADULT:
			return ColourScore(Constant.ADULT_SCORE[0]) + "."
		Passenger.PassengerType.ADULT_WITH_BAGS:
			return "{0}. {1} per {2}.".format([ColourScore(Constant.ADULT_WITH_BAG_SCORE[0]), 
											   ColourScore(Constant.ADULT_WITH_BAG_SCORE[2]), 
											   ColourKeyword("Standing Passenger", "orange")])
		Passenger.PassengerType.ADULT_WITH_BABY:
			return ColourScore(Constant.ADULT_WITH_BABY_SCORE[0]) + "."
		Passenger.PassengerType.PREGNANT:
			return ColourScore(Constant.PREGNANT_SCORE[0]) + "."
		Passenger.PassengerType.ELDERLY:
			return ColourScore(Constant.ELDERLY_SCORE[0]) + "."
		Passenger.PassengerType.INJURED:
			return ColourScore(Constant.INJURIED_SCORE[0]) + "."
		Passenger.PassengerType.HEMORRHOID:
			return ColourScore(Constant.HEMORRHOID_SCORE[0]) + "."
		Passenger.PassengerType.WHEELCHAIR_BOUND:
			return "{0}. {1} per {2}.".format([ColourScore(Constant.WHEELCHAIR_BOUND_SCORE[0]), 
											   ColourScore(Constant.WHEELCHAIR_BOUND_SCORE[2]), 
											   ColourKeyword("Standing Passenger", "orange")])
		Passenger.PassengerType.DURIAN_LOVER:
			return "{0}. {1} per onboard passenger (Except another Durian Lover).".format([ColourScore(Constant.DURIAN_LOVER_SCORE[0]), 
																					 		ColourScore(Constant.DURIAN_LOVER_SCORE[2])])
		Passenger.PassengerType.TEENAGER_WITH_BAGS:
			return "{0}. {1} per {2}.".format([ColourScore(Constant.TEENAGER_WITH_BAG_SCORE[0]), 
											   ColourScore(Constant.TEENAGER_WITH_BAG_SCORE[2]), 
											   ColourKeyword("Standing Passenger", "orange")])
		Passenger.PassengerType.OBESE_ADULT:
			return ColourScore(Constant.OBESE_ADULT_SCORE[0]) + "."
		Passenger.PassengerType.SLEEPY_TEENAGER:
			return ColourScore(Constant.SLEEPY_TEENAGER_SCORE[0]) + "."
		Passenger.PassengerType.NOISY_CHILD:
			return "{0}. {1} per {2} (Except another Noisy Child).".format([ColourScore(Constant.NOISY_CHILD_SCORE[0]), 
																			ColourScore(Constant.NOISY_CHILD_SCORE[2]), 
																			ColourKeyword("Standing Passenger", "orange")])
		_:
			return "Unknown Description."


static func GetPassengerSittingDesc(_passengerType : Passenger.PassengerType, _genderType : Passenger.GenderType) -> String:
	match _passengerType:
		Passenger.PassengerType.CHILDREN:
			return ColourScore(Constant.CHILD_SCORE[1]) + "."
		Passenger.PassengerType.TEENAGER:
			if _genderType == Passenger.GenderType.MALE:
				return "{0}. {1} if sitting {2}.".format([ColourScore(Constant.TEENAGER_SCORE[1]),
														 ColourScore(Constant.TEENAGER_SCORE[2]),
														 ColourKeyword("adjacent to Female Passenger", "hotpink")]) 
			else:
				return "{0}. {1} if sitting {2}.".format([ColourScore(Constant.TEENAGER_SCORE[1]),
														 ColourScore(Constant.TEENAGER_SCORE[2]),
														 ColourKeyword("adjacent to Male Passenger", "hotpink")]) 
		Passenger.PassengerType.ADULT:
			return ColourScore(Constant.ADULT_SCORE[1]) + "."
		Passenger.PassengerType.ADULT_WITH_BAGS:
			return ColourScore(Constant.ADULT_WITH_BAG_SCORE[1]) + "."
		Passenger.PassengerType.ADULT_WITH_BABY:
			return "{0}. {1} if sitting on {2}.".format([ColourScore(Constant.ADULT_WITH_BABY_SCORE[1]),
													  	ColourScore(Constant.ADULT_WITH_BABY_SCORE[2]),
													  	ColourKeyword("Priority Seat", "aqua")]) 
		Passenger.PassengerType.PREGNANT:
			return "{0}. {1} if sitting on {2}.".format([ColourScore(Constant.PREGNANT_SCORE[1]),
													  	ColourScore(Constant.PREGNANT_SCORE[2]),
													  	ColourKeyword("Priority Seat", "aqua")]) 
		Passenger.PassengerType.ELDERLY:
			return "{0}. {1} if sitting on {2}.".format([ColourScore(Constant.ELDERLY_SCORE[1]),
													  	ColourScore(Constant.ELDERLY_SCORE[2]),
													  	ColourKeyword("Priority Seat", "aqua")]) 
		Passenger.PassengerType.INJURED:
			return "{0}. {1} if sitting on {2}.".format([ColourScore(Constant.INJURIED_SCORE[1]),
													  	ColourScore(Constant.INJURIED_SCORE[2]),
													  	ColourKeyword("Priority Seat", "aqua")]) 
		Passenger.PassengerType.HEMORRHOID:
			return ColourScore(Constant.HEMORRHOID_SCORE[1]) + "."
		Passenger.PassengerType.WHEELCHAIR_BOUND:
			return "{0}. Can only use {1}.".format([ColourScore(Constant.WHEELCHAIR_BOUND_SCORE[1]),
													ColourKeyword("Wheelchair Slot", "deepskyblue")])
		Passenger.PassengerType.DURIAN_LOVER:
			return "{0}. {1} per onboard passenger (Except another Durian Lover).".format([ColourScore(Constant.DURIAN_LOVER_SCORE[1]), 
																							ColourScore(Constant.DURIAN_LOVER_SCORE[2])])		
		Passenger.PassengerType.TEENAGER_WITH_BAGS:
			if _genderType == Passenger.GenderType.MALE:
				return "{0}. {1} if sitting {2}.".format([ColourScore(Constant.TEENAGER_WITH_BAG_SCORE[1]),
														 ColourScore(Constant.TEENAGER_WITH_BAG_SCORE[3]),
														 ColourKeyword("adjacent to Female Passenger", "hotpink")]) 
			else:
				return "{0}. {1} if sitting {2}.".format([ColourScore(Constant.TEENAGER_WITH_BAG_SCORE[1]),
														 ColourScore(Constant.TEENAGER_WITH_BAG_SCORE[3]),
														 ColourKeyword("adjacent to Male Passenger", "hotpink")]) 
		Passenger.PassengerType.OBESE_ADULT:
			return "{0}. {1} to {2}.".format([ColourScore(Constant.OBESE_ADULT_SCORE[1]),
											  ColourScore(Constant.OBESE_ADULT_SCORE[2]),
											  ColourKeyword("Adjacent Passengers", "hotpink")])
		Passenger.PassengerType.SLEEPY_TEENAGER:
			return "{0}. Once seated, cannot change seat.".format([ColourScore(Constant.SLEEPY_TEENAGER_SCORE[1])])
		Passenger.PassengerType.NOISY_CHILD:
			return "{0}. {1} to {2} (Except another Noisy Child).".format([ColourScore(Constant.NOISY_CHILD_SCORE[1]), 
																			ColourScore(Constant.NOISY_CHILD_SCORE[2]), 
																			ColourKeyword("Adjacent Passenger", "hotpink")])
		_:
			return "Unknown Description."


static func GetPassengerGenderSprite(_passengerGender : Passenger.GenderType) -> Texture2D:
	return sGenderSprite[_passengerGender]


static func ColourScore(_score : int) -> String:
	if _score > 0:
		return "[color=green]+{0} Happiness[/color]".format([_score])
	elif _score < 0:
		return "[color=red]{0} Happiness[/color]".format([_score])
	else:
		return "[color=gray]+{0} Happiness[/color]".format([_score])


static func ColourKeyword(_words : String, _colour : String) -> String:
	return "[color=" + _colour + "]" + _words + "[/color]"
