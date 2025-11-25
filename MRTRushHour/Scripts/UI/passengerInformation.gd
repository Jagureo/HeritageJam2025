extends Node
class_name PassengerInformation

@onready var passenger_type_label : Label = $Panel/BasicDetails/Passenger_Type
@onready var passenger_trait_label : Label = $Panel/BasicDetails/Passenger_Trait
@onready var passenger_gender_label : Label = $Panel/BasicDetails/Passenger_Gender

@onready var passenger_description : Label = $Panel/Description

func show_display(passenger: Passenger):
	passenger_type_label.text = passenger.GetPassengerTypeString()
	passenger_trait_label.text = passenger.GetPassengerTraitString()
	passenger_gender_label.text = passenger.GetPassengerGenderString()
	
	passenger_description.text = passenger.GetPassengerDescription()
