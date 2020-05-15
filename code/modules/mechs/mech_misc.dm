/obj/item/device/radio/exosuit
	name = "exosuit radio"

/obj/item/device/radio/exosuit/get_cell()
	. = ..()
	if(!.)
		var/mob/living/exosuit/E = loc
		if(istype(E)) return E.get_cell()

/obj/item/device/radio/exosuit/nano_host()
	var/mob/living/exosuit/E = loc
	if(istype(E))
		return E
	return null

/obj/item/device/radio/exosuit/attack_self(var/mob/user)
	var/mob/living/exosuit/exosuit = loc
	if(istype(exosuit) && exosuit.head && exosuit.head.radio && exosuit.head.radio.is_functional())
		user.set_machine(src)
		interact(user)
	else
		to_chat(user, SPAN_WARNING("The radio is too damaged to function."))

/obj/item/device/radio/exosuit/CanUseTopic()
	. = ..()
	if(.)
		var/mob/living/exosuit/exosuit = loc
		if(istype(exosuit) && exosuit.head && exosuit.head.radio && exosuit.head.radio.is_functional())
			return ..()

/obj/item/device/radio/exosuit/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.mech_state)
	. = ..()

/obj/item/weapon/cell/exosuit
	name = "exosuit power cell"
	desc = "A special power cell designed for heavy-duty use in industrial exosuits."
	origin_tech = list(TECH_POWER = 3)
	icon_state = "hcell"
	maxcharge = 1500
	matter = list(MATERIAL_STEEL = 700, MATERIAL_GLASS = 70, MATERIAL_ALUMINIUM = 20)


///mob/living/exosuit/make_old()
//	. = ..()

//	// Mech log is clean. No one knows when was this mech manufactured, or what happened to it before it was found.
//	log = list()

//	if (.)
//		//Now we determine the exosuit's condition
//		switch (rand(0,100))
//			if (0 to 3)
//			//Perfect condition, it was well cared for and put into storage in a pristine state
//			//Nothing is done to it.
//			if (4 to 10)
//			//Poorly maintained.
//			//The internal airtank and power cell will be somewhat depleted, otherwise intact
//				var/P = rand(0,50) / 100
//				if (cell)//Set the cell to a random charge below 50%
//					cell.charge =  cell.maxcharge * P

//				P = rand(50,100) / 100
//				if(internal_tank)//remove 50-100% of airtank contents
//					internal_tank.air_contents.remove(internal_tank.air_contents.total_moles * P)


//			if (11 to 20)
//			//Wear and tear
//			//Hull has light to moderate damage, tank and cell are depleted
//			//Any equipment will have a 25% chance to be lost
//				var/P = rand(0,30) / 100
//				if (cell)//Set the cell to a random charge below 50%
//					cell.charge =  cell.maxcharge * P

//				P = rand(70,100) / 100
//				if(internal_tank)//remove 50-100% of airtank contents
//					internal_tank.air_contents.remove(internal_tank.air_contents.total_moles * P)

//				lose_equipment(25)//Lose modules

//				P = rand(10,100) / 100 //Set hull integrity
//				health = initial(health)*P


//			if (21 to 40)
//			//Severe damage
//			//Power cell has 50% chance to be missing or is otherwise low
//			//Significant chance for internal damage
//			//Hull integrity less than half
//			//Each module has a 50% loss chance
//			//Systems may be misconfigured
//				var/P

//				if (prob(50))//Remove cell
//					cell = null
//				else
//					P = rand(0,20) / 100 //or deplete it
//					if (cell)//Set the cell to a random charge below 50%
//						cell.charge = cell.maxcharge * P

//				P = rand(80,100) / 100 //Deplete tank
//				if(internal_tank)//remove 50-100% of airtank contents
//					internal_tank.air_contents.remove(internal_tank.air_contents.total_moles * P)

//				lose_equipment(50)//Lose modules
//				random_internal_damage(15)//Internal damage

//				P = rand(5,50) / 100 //Set hull integrity
//				health = initial(health)*P
//				misconfigure_systems(15)


//			if (41 to 80)
//			//Decomissioned
//			//The exosuit is a writeoff, it was tossed into storage for later scrapping.
//			//Wasnt considered worth repairing, but you still can
//			//Power cell missing, internal tank completely drained or ruptured/
//			//65% chance for each type of internal damage
//			//90% chance to lose each equipment
//			//System settings will be randomly configured
//				var/P
//				if (prob(15))
//					cell.rigged = 1//Powercell will explode if you use it
//				else if (prob(50))//Remove cell
//					QDEL_NULL(cell)

//				if (cell)
//					P = rand(0,20) / 100 //or deplete it
//					cell.charge =  cell.maxcharge * P

//				lose_equipment(90)//Lose modules
//				random_internal_damage(50)//Internal damage

//				if (!hasInternalDamage(MECHA_INT_TANK_BREACH))//If the tank isn't breaches
//					qdel(internal_tank)//Then delete it
//					internal_tank = null

//				P = rand(5,50)/ 100 //Set hull integrity
//				health = initial(health)*P
//				misconfigure_systems(45)


//			if (81 to 100)
//			//Salvage
//			//The exosuit is wrecked. Spawns a wreckage object instead of a suit
//				//Set the noexplode var so it doesn't explode, then just qdel it
//				//The destroy proc handles wreckage generation
//				noexplode = 1
//				qdel(src)

//		//Finally, so that the exosuit seems like it's been in storage for a while
//		//We will take any malfunctions to their logical conclusion, and set the error states high

//		//If the tank has a breach, then there will be no air left
//		if (hasInternalDamage(MECHA_INT_TANK_BREACH) && internal_tank)
//			internal_tank.air_contents.remove(internal_tank.air_contents.total_moles)

//		//If there's an electrical fault, the cell will be complerely drained
//		if (hasInternalDamage(MECHA_INT_SHORT_CIRCUIT) && cell)
//			cell.charge = 0


//		//Code for interacting with damage+power warnings, an unported aurora feature
//		/*
//		process_warnings()//Trigger them first, if they'll happen

//		if (power_alert_status)
//			last_power_warning = -99999999
//			//Make it go into infrequent warning state instantly
//			power_warning_delay = 99999999
//			//and set the delay between warnings to a functionally infinite value
//			//so that it will shut up

//		if (damage_alert_status)
//			last_damage_warning = -99999999
//			damage_warning_delay = 99999999

//		process_warnings()
//		*/
