extends Node
class_name SelectionManager

static var sInstance : SelectionManager = null

var mHoveredPassenger : Passenger = null
var mDraggedPassenger  : Passenger = null
var mClickPos : Vector2 = Vector2.ZERO



func _enter_tree():
	if sInstance != null:
		self.queue_free()
		return
	sInstance = self


func _exit_tree():
	if sInstance == self:
		sInstance = null


func GetFrontmostPassenger() -> Passenger:
	if get_tree().root.get_world_2d() == null:
		return null

	var parameters := PhysicsPointQueryParameters2D.new()
	parameters.position = get_viewport().get_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1 	# Passenger Layer

	var objSelected = get_tree().root.get_world_2d().direct_space_state.intersect_point(parameters)
	var frontMostPassenger : Passenger = null
	var frontMostPassengerY := -INF

	for r in objSelected:
		var p := r.collider as Passenger
		if p and p.position.y > frontMostPassengerY:
			frontMostPassenger = p
			frontMostPassengerY = p.position.y

	return frontMostPassenger



func _unhandled_input(event):
	if event.is_action_pressed("Click"):
		TryStartDrag()
	elif event.is_action_released("Click"):
		EndDrag()


func TryStartDrag():
	# Should not be able to drag another passenger
	if mDraggedPassenger != null:
		return

	var picked := GetFrontmostPassenger()
	if picked and CanDrag():
		mClickPos = picked.get_local_mouse_position()
		mDraggedPassenger = picked
		picked.OnDragStart()
		GameManager.sInstance.HidePassengerTooltip()


func EndDrag():
	if mDraggedPassenger:
		mDraggedPassenger.OnDragEnd()
		mDraggedPassenger = null
		


# Hovering logic
func _process(_delta):
	UpdateHover()
	UpdateDrag()


func UpdateHover():
	# Don't evaluate hover if a passenger is being dragged
	if mDraggedPassenger:
		return

	var picked := GetFrontmostPassenger()

	if picked == mHoveredPassenger:
		# This is required so if players were to click and release without exiting the Area2D,
		# Then the tooltip will show again
		if mHoveredPassenger != null and not GameManager.sInstance.IsPassengerTooltipVisible():
			GameManager.sInstance.ShowPassengerTooltip(mHoveredPassenger)
		return

	# If there's a change in who is hovering then undo white outline for old one
	if mHoveredPassenger:
		mHoveredPassenger.OnHoverEnd()
		GameManager.sInstance.HidePassengerTooltip()

	mHoveredPassenger = picked

	# Add white outline for newly picked one
	if mHoveredPassenger:
		mHoveredPassenger.OnHoverStart()
		GameManager.sInstance.ShowPassengerTooltip(mHoveredPassenger)


func UpdateDrag():
	# Don't need to do anything if no pasengers are being dragged
	if mDraggedPassenger == null:
		return

	# Stop drag immediately if no longer allowed
	if not CanDrag():
		EndDrag()
		return

	# Only update position if drag is valid
	mDraggedPassenger.OnDragUpdate()


func CanDrag() -> bool:
	return GameManager.sInstance.mCurrLevelState == GameManager.LevelState.AT_STATION