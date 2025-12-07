class_name Constant

# Defines the Passenger Draggable area
static var TOP_DRAG_LIMIT : int = 450
static var BOTTOM_DRAG_LIMIT : int = 1080 - 150
static var LEFT_DRAG_LIMIT : int = 100
static var RIGHT_DRAG_LIMIT : int = 1920 - 100


static var MAX_PASSENGERS_IN_TRAIN : int = 16

static var TIME_TO_NEXT_STATION : float = 5
static var EVALUATE_SCORE_BEFORE_REACHING_NEXT_STATION : float = 1.5

static var GAME_OVER_SCORE : int = -25


# Scoring - [0] is Standing Score, [1] is Sitting Score, [2+] are additional modifiers
static var CHILD_SCORE := [0, 5]
static var TEENAGER_SCORE := [0, 5, -4]					# -4 if sitting adjacent to opposite gender
static var ADULT_SCORE := [0, 3]	
static var ADULT_WITH_BAG_SCORE := [0, 3, -2]			# -2 score per standing passenger
static var ADULT_WITH_BABY_SCORE := [0, 5, 3]			# +3 if sitting on priority seat
static var PREGNANT_SCORE := [0, 5, 3]					# +3 if sitting on priority seat
static var ELDERLY_SCORE := [-5, 5, 3]					# +3 if sitting on priority seat
static var INJURIED_SCORE := [-5, 5, 3]					# +3 if sitting on priority seat
static var HEMORRHOID_SCORE := [5, -10]
static var WHEELCHAIR_BOUND_SCORE := [0, 5, -5]			# -5 per standing passenger
static var DURIAN_LOVER_SCORE := [10, 13, -1]			# -1 per standing/sitting passenger
static var TEENAGER_WITH_BAG_SCORE := [0, 5, -1, -4]	# -1 per standing passenger, -4 if sitting adjacent to opp gender
static var OBESE_ADULT_SCORE := [0, 5, -4]				# -4 to adjacent passenger
static var SLEEPY_TEENAGER_SCORE := [-3, 5]
static var NOISY_CHILD_SCORE := [0, 5, -2, -4]			# -2 per standing passenger, -4 to adjacent passenger
