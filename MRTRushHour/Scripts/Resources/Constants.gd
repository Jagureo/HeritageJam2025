class_name Constant

# Defines the Passenger Draggable area
static var TOP_DRAG_LIMIT : int = 450
static var BOTTOM_DRAG_LIMIT : int = 1080 - 150
static var LEFT_DRAG_LIMIT : int = 100
static var RIGHT_DRAG_LIMIT : int = 1920 - 100

# Defines passenger constants
static var MAX_PASSENGERS_IN_TRAIN : int = 30
static var MIN_NUMBER_OF_STATIONS_TO_STAY : int = 1
static var MAX_NUMBER_OF_STATIONS_TO_STAY : int = 10
static var PASSENGER_BOTTOM_SPAWN_PADDING : int = 200
static var PASSENGER_TOP_SPAWN_PADDING : int = 100

# Scoring - [0] is Standing Score, [1] is Sitting Score, [2+] are additional modifiers
static var CHILD_SCORE := [1, 4]
static var TEENAGER_SCORE := [1, 6, -3]
static var ADULT_SCORE := [1, 3]	
static var ADULT_WITH_BAG_SCORE := [0, 5, -3, 5]
static var ADULT_WITH_BABY_SCORE := [-2, 5, 3]
static var PREGNANT_SCORE := [-2, 5, 3]
static var ELDERLY_SCORE := [-5, 5, 3]
static var INJURIED_SCORE := [-5, 5, 3]
static var HEMORRHOID_SCORE := [5, -10]
static var WHEELCHAIR_BOUND_SCORE := [-10, 5]
# DLC passengers
# static var DURIAN_LOVER_SCORE := [10, 13, -1]			# -1 per standing/sitting passenger
# static var TEENAGER_WITH_BAG_SCORE := [0, 5, -1, -4]	# -1 per standing passenger, -4 if sitting adjacent to opp gender
# static var SLEEPY_TEENAGER_SCORE := [-3, 5]
# static var NOISY_CHILD_SCORE := [0, 5, -2, -4]			# -2 per standing passenger, -4 to adjacent passenger


# Timers
static var AT_STATION_BASE_TIMER := 5.0
static var AT_STATION_TIME_PER_PASSENGER := 2.0
static var LEAVING_STATE_TIMER := 2.5
static var MOVING_STATE_TIMER := 3.0
# static var REACHING_STATE_TIMER := 3.0
static var ALIGHT_PASSENGER_TIMER := 0.5
static var BOARD_PASSENGER_TIMER := 0.5