extends Node
class_name Event

signal OnPassengerAddedToSeat(_passenger : Passenger, _seatIndex : int)
signal OnPassengerRemovedFromSeat(_passenger : Passenger, _seatIndex : int)

signal OnPassengerEnteredTrain(_passenger : Passenger)
signal OnPassengerExitedTrain(_passenger : Passenger)

signal OnPassengerAddedToStandingArea(_passenger : Passenger)
signal OnPassengerRemovedFromStandingArea(_passenger : Passenger)