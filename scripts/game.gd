extends Control

@onready var sfx_book: AudioStreamPlayer = $sfx_book
@onready var sfx_button: AudioStreamPlayer = $sfx_button
@onready var sfx_win: AudioStreamPlayer = $sfx_win

# GRINDERS
@onready var grinder_buttons := [
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder1,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder2,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder3,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder4,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder5,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder6,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder7,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder8
]

@onready var grinder_income_labels := [
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder1/HBoxContainer/Income,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder2/HBoxContainer/Income,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder3/HBoxContainer/Income,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder4/HBoxContainer/Income,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder5/HBoxContainer/Income,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder6/HBoxContainer/Income,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder7/HBoxContainer/Income,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder8/HBoxContainer/Income
]

@onready var grinder_count_labels := [
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder1/HBoxContainer/Count,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder2/HBoxContainer/Count,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder3/HBoxContainer/Count,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder4/HBoxContainer/Count,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder5/HBoxContainer/Count,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder6/HBoxContainer/Count,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder7/HBoxContainer/Count,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder8/HBoxContainer/Count
]

@onready var grinder_cost_labels := [
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder1/HBoxContainer/Cost,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder2/HBoxContainer/Cost,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder3/HBoxContainer/Cost,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder4/HBoxContainer/Cost,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder5/HBoxContainer/Cost,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder6/HBoxContainer/Cost,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder7/HBoxContainer/Cost,
	$RightPanel/VBoxContainer/TabContainer/GrinderTab/UpgradeList/Grinder8/HBoxContainer/Cost
]

var grinder_counts := [0,0,0,0,0,0,0,0]
var grinder_costs := [15.0,100.0,1.2e3,13e3,140e3,1.5e6,18e6,210e6]
var grinder_base_costs := [15.0,100.0,1.2e3,13e3,140e3,1.5e6,18e6,210e6]
var grinder_income := [0.1,1.0,8.0,48.0,192.0,1.44e3,7.92e3,39.6e3]

var books: float = 0.0
var books_per_second: float = 0.0
var amount_per_click: float = 1.0

# UPGRADES
@onready var upgrade_buttons := $RightPanel/VBoxContainer/TabContainer/UpgradeTab/UpgradeList.get_children()

var upgrade_costs := []
var upgrade_unlocked := []

var upgrade_effects := [
	{"type":"click","mult":3},{"type":"click","mult":6},{"type":"click","mult":10},
	{"type":"grinder","id":0,"mult":4},{"type":"grinder","id":0,"mult":7},{"type":"grinder","id":0,"mult":10},
	{"type":"grinder","id":1,"mult":4},{"type":"grinder","id":1,"mult":7},{"type":"grinder","id":1,"mult":10},
	{"type":"grinder","id":2,"mult":4},{"type":"grinder","id":2,"mult":7},{"type":"grinder","id":2,"mult":10},
	{"type":"grinder","id":3,"mult":4},{"type":"grinder","id":3,"mult":7},{"type":"grinder","id":3,"mult":10},
	{"type":"grinder","id":4,"mult":4},{"type":"grinder","id":4,"mult":7},{"type":"grinder","id":4,"mult":10},
	{"type":"grinder","id":5,"mult":4},{"type":"grinder","id":5,"mult":7},{"type":"grinder","id":5,"mult":10},
	{"type":"grinder","id":6,"mult":4},{"type":"grinder","id":6,"mult":7},{"type":"grinder","id":6,"mult":10},
	{"type":"grinder","id":7,"mult":4},{"type":"grinder","id":7,"mult":7},{"type":"grinder","id":7,"mult":47}
]

# WIN
@onready var win_button: Button = $RightPanel/VBoxContainer/TabContainer/WinTab/UpgradeList/WinButton
@onready var win_label = $RightPanel/VBoxContainer/TabContainer/WinTab/UpgradeList/WinLabel
var win_cost: float = 250e9

const save_path = "user://userdata.save"

signal books_changed
signal books_per_second_changed
signal book_clicked

# READY
func _ready():
	load_data()
	
	# Grinder upgrade costs
	upgrade_costs.append_array([250.0, 25e3, 5e6])
	for i in range(grinder_base_costs.size()):
		var base = grinder_base_costs[i]
		upgrade_costs.append(base * 30)
		upgrade_costs.append(base * 80)
		upgrade_costs.append(base * 200)

	# Init unlocks
	upgrade_unlocked.resize(upgrade_costs.size())
	for i in range(upgrade_unlocked.size()):
		if upgrade_unlocked[i] == null:
			upgrade_unlocked[i] = false

	# Connect buttons
	for i in range(grinder_buttons.size()):
		grinder_buttons[i].pressed.connect(func(): _buy_grinder(i))
		grinder_buttons[i].pressed.connect(_on_any_button_pressed)

	for i in range(upgrade_buttons.size()):
		if upgrade_buttons[i] is Button:
			upgrade_buttons[i].pressed.connect(func(): _buy_upgrade(i))
			upgrade_buttons[i].pressed.connect(_on_any_button_pressed)
	
	recalculate_books_per_second()
	emit_signal("books_changed", books)
	emit_signal("books_per_second_changed", books_per_second)

# PROCESS
func _process(delta):
	update_grinders()
	update_upgrades()
	books += books_per_second * delta
	emit_signal("books_changed", books)
	emit_signal("books_per_second_changed", books_per_second)

# GRINDERS
func _buy_grinder(i):
	if books < grinder_costs[i]:
		return

	books -= grinder_costs[i]
	grinder_counts[i] += 1
	grinder_costs[i] = ceil(grinder_costs[i] * 1.15)

	books_per_second += grinder_income[i]

	emit_signal("books_changed", books)
	emit_signal("books_per_second_changed", books_per_second)


func update_grinders():
	for i in range(grinder_buttons.size()):
		grinder_buttons[i].disabled = books < grinder_costs[i]
		grinder_count_labels[i].text = "(" + str(grinder_counts[i]) + ")"
		grinder_income_labels[i].text = "(+" + str(grinder_income[i]) + ") -"
		grinder_cost_labels[i].text = format_number(grinder_costs[i])

# UPGRADES
func _buy_upgrade(i):
	if upgrade_unlocked[i]:
		return

	books -= upgrade_costs[i]
	upgrade_unlocked[i] = true

	upgrade_buttons[i].disabled = true
	var cost_label = upgrade_buttons[i].get_node("HBoxContainer/Cost")
	if cost_label:
		cost_label.text = "✓"

	apply_upgrade(i)

	emit_signal("books_changed", books)
	emit_signal("books_per_second_changed", books_per_second)

func apply_upgrade(i):
	var effect = upgrade_effects[i]

	if effect.type == "click":
		amount_per_click *= effect.mult
	elif effect.type == "grinder":
		grinder_income[effect.id] *= effect.mult

	recalculate_books_per_second()

func update_upgrades():
	for i in range(min(upgrade_buttons.size(), upgrade_costs.size())):
		if upgrade_buttons[i] is Button:
			if upgrade_unlocked[i]:
				upgrade_buttons[i].disabled = true
				var cost_label = upgrade_buttons[i].get_node("HBoxContainer/Cost")
				if cost_label:
					cost_label.text = "✓"
			else:
				upgrade_buttons[i].disabled = books < upgrade_costs[i]
	win_button.disabled = books < win_cost

func recalculate_books_per_second():
	books_per_second = 0
	for i in range(grinder_counts.size()):
		books_per_second += grinder_counts[i] * grinder_income[i]

func format_number(n: float) -> String:
	var value: float
	var suffix: String
	
	if n < 1e3:
		return str(int(n))
	if n < 1e6:
		value = n / 1e3
		suffix = "k"
	elif n < 1e9:
		value = n / 1e6
		suffix = "M"
	elif n < 1e12:
		value = n / 1e9
		suffix = "B"
	else:
		value = n / 1e12
		suffix = "T"
	
	var formatted = "%.2f" % value
	# Remove trailing 0s
	formatted = formatted.rstrip("0").rstrip(".")
	
	return formatted + suffix

# CLICK (THE BOOKIE)
func _on_click_button_button_down():
	books += amount_per_click
	sfx_book.stop()
	sfx_book.play()

	emit_signal("books_changed", books)
	emit_signal("book_clicked", amount_per_click)

func _on_any_button_pressed():
	sfx_button.stop()
	sfx_button.play()

func _on_win_button_pressed():
	books -= win_cost
	emit_signal("books_changed", books)
	win_label.text = "Congratulations!\nYou have won\nthe game!"
	sfx_win.play()

# SAVE/LOAD
func save_data():
	var data = {
		"books": books,
		"books_per_second": books_per_second,
		"grinder_counts": grinder_counts,
		"grinder_costs": grinder_costs,
		"grinder_income": grinder_income,
		"upgrade_unlocked": upgrade_unlocked,
		"amount_per_click": amount_per_click
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = file.get_var()

		if typeof(data) == TYPE_DICTIONARY:
			books = data.get("books", 0.0)
			books_per_second = data.get("books_per_second", 0.0)
			grinder_counts = data.get("grinder_counts", grinder_counts)
			grinder_costs = data.get("grinder_costs", grinder_costs)
			grinder_income = data.get("grinder_income", grinder_income)
			upgrade_unlocked = data.get("upgrade_unlocked", upgrade_unlocked)
			amount_per_click = data.get("amount_per_click", amount_per_click)
	recalculate_books_per_second()

func _on_save_pressed() -> void:
	save_data()

func _on_load_pressed() -> void:
	load_data()

func _on_reset_pressed() -> void:
	# Reset all stats
	books = 0.0
	books_per_second = 0.0
	amount_per_click = 1.0
	grinder_counts = [0,0,0,0,0,0,0,0]
	grinder_costs = grinder_base_costs.duplicate()
	grinder_income = [0.1,1.0,8.0,48.0,192.0,1.44e3,7.92e3,39.6e3]

	# Reset upgrades
	for i in range(upgrade_unlocked.size()):
		upgrade_unlocked[i] = false

	# Enable buttons & restore cost to base
	for i in range(upgrade_buttons.size()):
		if upgrade_buttons[i] is Button:
			upgrade_buttons[i].disabled = false
			var cost_label = upgrade_buttons[i].get_node("HBoxContainer/Cost")
			if cost_label:
				cost_label.text = format_number(upgrade_costs[i])

	recalculate_books_per_second()
	update_grinders()
	update_upgrades()
	emit_signal("books_changed", books)
	emit_signal("books_per_second_changed", books_per_second)
	save_data()
