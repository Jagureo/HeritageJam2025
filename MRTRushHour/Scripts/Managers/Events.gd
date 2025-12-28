extends Node
class_name Event

# signal OnPassengerAddedToSeat(_passenger : Passenger, _seatIndex : int)
# signal OnPassengerRemovedFromSeat(_passenger : Passenger, _seatIndex : int)

# signal OnPassengerEnteredTrain(_passenger : Passenger)
# signal OnPassengerExitedTrain(_passenger : Passenger)

# signal OnPassengerAddedToStandingArea(_passenger : Passenger)
# signal OnPassengerRemovedFromStandingArea(_passenger : Passenger)

signal OnNextStationPressed()
signal OnAboutToLeave()
signal OnStationLeft()
signal OnNextStationReaching()
signal OnPassengerAlighting()
signal OnPassengerBoarding()
signal OnNextstationReached()

signal OnPassengersFinishedAlighting()		# Finished alighting all the required passengers
signal OnPassengersFinishedBoarding()		# Finished boarding all the required passengers

signal OnPassengerHoverStart(_passenger : Passenger)
signal OnPassengerHoverEnd(_passenger : Passenger)

