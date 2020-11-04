/obj/spawner/medical
	name = "random medicine"
	icon_state = "meds-green"
	tags_to_spawn = list(SPAWN_MEDICAL)

/obj/spawner/medical/low_chance
	name = "low chance random medicine"
	icon_state = "meds-green-low"
	spawn_nothing_percentage = 60

/obj/spawner/medical_lowcost
	name = "random low tier medicine"
	icon_state = "meds-grey"
	tags_to_spawn = list(SPAWN_MEDICINE_COMMON)

/obj/spawner/medical_lowcost/low_chance
	name = "low chance random low tier medicine"
	icon_state = "meds-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/firstaid
	name = "random first aid kit"
	icon_state = "meds-red"
	tags_to_spawn = list(SPAWN_FIRSTAID)

/obj/spawner/firstaid/low_chance
	name = "low chance random first aid kit"
	icon_state = "meds-red-low"
	spawn_nothing_percentage = 60
