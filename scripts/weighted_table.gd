class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum: int = 0


@warning_ignore_start("untyped_declaration")

func add_item (item, weight:int):
	items.append({"item": item, "weight": weight})
	weight_sum += weight


func remove_item(item_to_remove):
	items = items.filter(
		func (item):
			return item["item"] != item_to_remove
	)
	weight_sum = 0
	for item in items:
		weight_sum += item["weight"]


func pick_item(exclude_items: Array = []):
	var adjusted_items: Array[Dictionary] = items
	var adjusted_weight_sum: int = weight_sum

	# Checking Exclude items in array and packing up Adjusted Items array
	if exclude_items.size() > 0:
		adjusted_items = []
		adjusted_weight_sum = 0

		for item in items:
			if item["item"] in exclude_items:
				continue
			adjusted_items.append(item)
			adjusted_weight_sum += item["weight"]

	var chosen_weight: int = randi_range(1, adjusted_weight_sum)
	var iteration_sum: int = 0

	for item in adjusted_items:
		iteration_sum += item["weight"]
		if chosen_weight <= iteration_sum:
			return item["item"]


@warning_ignore_restore("untyped_declaration")
