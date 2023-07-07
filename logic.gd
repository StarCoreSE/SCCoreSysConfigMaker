extends Control

var sliderBaseDamage: HSlider
var sliderMaxTrajectory: HSlider
var sliderDesiredSpeed: HSlider

var labelBaseDamage: Label
var labelMaxTrajectory: Label
var labelDesiredSpeed: Label

var importButton: Button
var saveButton: Button
var fileDialog: FileDialog

var loadedFilePath: String

var colorPreview: ColorRect
var redInput: LineEdit
var greenInput: LineEdit
var blueInput: LineEdit




func _ready():
	sliderBaseDamage = HSlider.new()
	sliderMaxTrajectory = HSlider.new()
	sliderDesiredSpeed = HSlider.new()

	sliderBaseDamage.rect_min_size = Vector2(300, 30)
	sliderMaxTrajectory.rect_min_size = Vector2(300, 30)
	sliderDesiredSpeed.rect_min_size = Vector2(300, 30)

	sliderBaseDamage.min_value = 1
	sliderMaxTrajectory.min_value = 1
	sliderDesiredSpeed.min_value = 1

	sliderBaseDamage.max_value = 10000
	sliderMaxTrajectory.max_value = 10000
	sliderDesiredSpeed.max_value = 10000

	add_child(sliderBaseDamage)
	add_child(sliderMaxTrajectory)
	add_child(sliderDesiredSpeed)

	sliderBaseDamage.rect_position = Vector2(100, 50)
	sliderMaxTrajectory.rect_position = Vector2(100, 100)
	sliderDesiredSpeed.rect_position = Vector2(100, 150)

	labelBaseDamage = Label.new()
	labelMaxTrajectory = Label.new()
	labelDesiredSpeed = Label.new()

	labelBaseDamage.rect_min_size = Vector2(100, 20)
	labelMaxTrajectory.rect_min_size = Vector2(100, 20)
	labelDesiredSpeed.rect_min_size = Vector2(100, 20)

	labelBaseDamage.align = Label.ALIGN_CENTER
	labelMaxTrajectory.align = Label.ALIGN_CENTER
	labelDesiredSpeed.align = Label.ALIGN_CENTER

	labelBaseDamage.valign = Label.VALIGN_CENTER
	labelMaxTrajectory.valign = Label.VALIGN_CENTER
	labelDesiredSpeed.valign = Label.VALIGN_CENTER

	labelBaseDamage.text = "BaseDamage: " + str(sliderBaseDamage.value)
	labelMaxTrajectory.text = "MaxTrajectory: " + str(sliderMaxTrajectory.value)
	labelDesiredSpeed.text = "DesiredSpeed: " + str(sliderDesiredSpeed.value)

	add_child(labelBaseDamage)
	add_child(labelMaxTrajectory)
	add_child(labelDesiredSpeed)

	labelBaseDamage.rect_position = Vector2(10, 50)
	labelMaxTrajectory.rect_position = Vector2(10, 100)
	labelDesiredSpeed.rect_position = Vector2(10, 150)

	sliderBaseDamage.connect("value_changed", self, "_on_slider_value_changed", [labelBaseDamage])
	sliderMaxTrajectory.connect("value_changed", self, "_on_slider_value_changed", [labelMaxTrajectory])
	sliderDesiredSpeed.connect("value_changed", self, "_on_slider_value_changed", [labelDesiredSpeed])

	importButton = Button.new()
	importButton.text = "Import"
	importButton.rect_min_size = Vector2(120, 30)
	add_child(importButton)

	saveButton = Button.new()
	saveButton.text = "Save"
	saveButton.rect_min_size = Vector2(120, 30)
	saveButton.rect_position = Vector2(150, 0)
	add_child(saveButton)

	fileDialog = FileDialog.new()
	fileDialog.mode = FileDialog.MODE_OPEN_FILE
	fileDialog.access = FileDialog.ACCESS_FILESYSTEM
	fileDialog.set_resizable(true)
	fileDialog.filters = ["*.cs"]
	fileDialog.rect_min_size = Vector2(400, 400)  # Adjust the size as needed
	add_child(fileDialog)

	importButton.connect("pressed", self, "_on_import_button_pressed")
	saveButton.connect("pressed", self, "_on_save_button_pressed")
	fileDialog.connect("file_selected", self, "_on_file_selected")
	
	colorPreview = ColorRect.new()
	colorPreview.rect_min_size = Vector2(100, 100)
	colorPreview.rect_position = Vector2(550, 50)
	add_child(colorPreview)

	redInput = LineEdit.new()
	redInput.rect_min_size = Vector2(50, 20)
	redInput.rect_position = Vector2(670, 50)
	redInput.text = "255"  # Default value
	add_child(redInput)

	greenInput = LineEdit.new()
	greenInput.rect_min_size = Vector2(50, 20)
	greenInput.rect_position = Vector2(670, 80)
	greenInput.text = "255"  # Default value
	add_child(greenInput)

	blueInput = LineEdit.new()
	blueInput.rect_min_size = Vector2(50, 20)
	blueInput.rect_position = Vector2(670, 110)
	blueInput.text = "255"  # Default value
	add_child(blueInput)

	redInput.connect("text_changed", self, "_on_color_input_changed")
	greenInput.connect("text_changed", self, "_on_color_input_changed")
	blueInput.connect("text_changed", self, "_on_color_input_changed")
	

func _on_color_input_changed(newText: String) -> void:
	var red = int(redInput.text)
	var green = int(greenInput.text)
	var blue = int(blueInput.text)

	var color = Color(red / 255.0, green / 255.0, blue / 255.0)
	colorPreview.color = color


func _on_slider_value_changed(value: float, label: Label) -> void:
	if label == labelBaseDamage:
		label.text = "BaseDamage: " + str(value)
		var desiredSpeedValue = 10001 - value
		sliderDesiredSpeed.set_value(desiredSpeedValue)
		labelDesiredSpeed.text = "DesiredSpeed: " + str(desiredSpeedValue)
	elif label == labelMaxTrajectory:
		label.text = "MaxTrajectory: " + str(value)
	elif label == labelDesiredSpeed:
		label.text = "DesiredSpeed: " + str(value)
		var baseDamageValue = 10001 - value
		sliderBaseDamage.set_value(baseDamageValue)
		labelBaseDamage.text = "BaseDamage: " + str(baseDamageValue)


func _on_save_button_pressed() -> void:
	if loadedFilePath != "":
		var file = File.new()
		if file.open(loadedFilePath, File.READ) == OK:
			var lines = []
			while !file.eof_reached():
				lines.append(file.get_line())

			file.close()

			var updatedLines = []

			for line in lines:
				if line.find("BaseDamage =") != -1:
					line = "BaseDamage = " + str(int(sliderBaseDamage.value)) + ","
				if line.find("MaxTrajectory =") != -1:
					line = "MaxTrajectory = " + str(int(sliderMaxTrajectory.value)) + ","
				if line.find("DesiredSpeed =") != -1:
					line = "DesiredSpeed = " + str(int(sliderDesiredSpeed.value)) + ","
				if line.find("Color = Color(red:") != -1:
					# Extract the color values
					var red = int(redInput.text)
					var green = int(greenInput.text)
					var blue = int(blueInput.text)

					# Construct the updated color line
					line = "Color = Color(red: " + str(red) + ", green: " + str(green) + ", blue: " + str(blue) + ", alpha: 1),"

				updatedLines.append(line)

			if file.open(loadedFilePath, File.WRITE) == OK:
				for updatedLine in updatedLines:
					file.store_string(updatedLine + "\n")
				file.close()
				print("Saved values to file:", loadedFilePath)
			else:
				print("Failed to open file for writing:", loadedFilePath)
		else:
			print("Failed to open file for reading:", loadedFilePath)
	else:
		print("No file is loaded. Please import a .cs file.")



func _on_import_button_pressed() -> void:
	fileDialog.popup_centered()

func _on_file_selected(path: String) -> void:
	print("Selected file:", path)
	loadedFilePath = path

	var file = File.new()
	if file.open(path, File.READ) == OK:
		while !file.eof_reached():
			var line = file.get_line()
			if line.find("BaseDamage =") != -1:
				var base_damage_str = line.replace("BaseDamage =", "").strip_edges()
				var base_damage = base_damage_str.to_int()
				print("BaseDamage:", base_damage)
				sliderBaseDamage.set_value(base_damage)

			if line.find("MaxTrajectory =") != -1:
				var max_trajectory_str = line.replace("MaxTrajectory =", "").strip_edges()
				var max_trajectory = max_trajectory_str.to_int()
				print("MaxTrajectory:", max_trajectory)
				sliderMaxTrajectory.set_value(max_trajectory)

			if line.find("DesiredSpeed =") != -1:
				var desired_speed_str = line.replace("DesiredSpeed =", "").strip_edges()
				var desired_speed = desired_speed_str.to_int()
				print("DesiredSpeed:", desired_speed)
				sliderDesiredSpeed.set_value(desired_speed)

			if line.find("Color = Color(") != -1:
				# Extract the numbers from the Color format
				var color_start_index = line.find("Color(") + "Color(".length()
				var color_end_index = line.find(")", color_start_index)
				var color_values_str = line.substr(color_start_index, color_end_index - color_start_index)
				var color_values = color_values_str.split(",")

				# Extract only the numbers from color values
				var red = 0
				var green = 0
				var blue = 0
				if color_values.size() >= 3:
					red = color_values[0].to_int()
					green = color_values[1].to_int()
					blue = color_values[2].to_int()

				# Update color values
				redInput.text = str(red)
				greenInput.text = str(green)
				blueInput.text = str(blue)

	file.close()


