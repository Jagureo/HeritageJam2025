extends Resource
class_name Station

# --- Station Class Definition ---
var name : String
var min_passengers: int
var max_passengers: int
var passenger_count: int

func _init(_name: String, _min_passengers: int, _max_passengers: int) -> void:
	name = _name
	min_passengers = _min_passengers
	max_passengers = _max_passengers
	passenger_count = randi_range(min_passengers, max_passengers)

func get_passenger_count() -> int:
	return passenger_count

# --- Predefined Station Instances ---
# You can access these directly from other scripts, e.g. Station.EWStations
static var EWStations: Array[Station] = [
	Station.new("Joo Koon", 2, 4),
	Station.new("Pioneer", 2, 5),
	Station.new("Boon Lay", 3, 5),
	Station.new("Lakeside", 3, 6),
	Station.new("Chinese Garden", 4, 5),
	Station.new("Jurong East", 4, 8),
	Station.new("Clementi", 3, 6),
	Station.new("Dover", 3, 6),
	Station.new("Buona Vista", 2, 6),
	Station.new("Commonwealth", 2, 6),
	Station.new("Queenstown", 2, 6),
	Station.new("Redhill", 2, 5),
	Station.new("Tiong Bahru", 2, 6),
	Station.new("Outram Park", 2, 6),
	Station.new("Tanjong Pagar", 4, 7),
	Station.new("Raffles Place", 4, 9),
	Station.new("City Hall", 3, 10),
	Station.new("Bugis", 4, 7),
	Station.new("Lavender", 3, 6),
	Station.new("Kallang", 3, 6),
	Station.new("Aljunied", 3, 6),
	Station.new("Paya Lebar", 2, 7),
	Station.new("Eunos", 2, 7),
	Station.new("Kembangan", 2, 6),
	Station.new("Bedok", 2, 7),
	Station.new("Tanah Merah", 3, 7),
	Station.new("Simei", 3, 6),
	Station.new("Tampines", 0, 0),
	Station.new("Pasir Ris", 0, 0)
]
