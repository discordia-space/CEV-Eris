/datum/controller/process/evac/setup()
	name = "evacuation"
	schedule_interval = 20 // every 2 seconds

	if(!evacuation_controller)
		evacuation_controller = new /datum/evacuation_controller/starship()
		evacuation_controller.set_up()

/datum/controller/process/evac/doWork()
	evacuation_controller.Process()
