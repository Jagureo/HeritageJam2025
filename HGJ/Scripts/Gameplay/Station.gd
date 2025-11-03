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
	Station.new("Joo Koon", 1, 2),
	Station.new("Pioneer", 1, 3),
	Station.new("Boon Lay", 2, 3),
	Station.new("Lakeside", 2, 4),
	Station.new("Chinese Garden", 2, 3),
	Station.new("Jurong East", 3, 6),
	Station.new("Clementi", 2, 4),
	Station.new("Dover", 2, 4),
	Station.new("Buona Vista", 1, 4),
	Station.new("Commonwealth", 1, 4),
	Station.new("Queenstown", 1, 4),
	Station.new("Redhill", 1, 3),
	Station.new("Tiong Bahru", 1, 4),
	Station.new("Outram Park", 1, 4),
	Station.new("Tanjong Pagar", 3, 5),
	Station.new("Raffles Place", 3, 7),
	Station.new("City Hall", 2, 8),
	Station.new("Bugis", 3, 5),
	Station.new("Lavender", 2, 4),
	Station.new("Kallang", 2, 4),
	Station.new("Aljunied", 2, 4),
	Station.new("Paya Lebar", 1, 5),
	Station.new("Eunos", 1, 5),
	Station.new("Kembangan", 1, 4),
	Station.new("Bedok", 1, 5),
	Station.new("Tanah Merah", 2, 5),
	Station.new("Simei", 2, 4),
	Station.new("Tampines", 3, 6),
	Station.new("Pasir Ris", 0, 0)
]
