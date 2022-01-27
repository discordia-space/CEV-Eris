//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!
#define HUMAN_MAX_OXYLOSS 1 //Defines how69uch oxyloss humans can get per tick. A tile with69o air at all (such as space) applies this69alue, otherwise it's a percentage of it.
#define HUMAN_CRIT_MAX_OXYLOSS ( 2 / 6) //The amount of damage you'll get when in critical condition. We want this to be a 569inute deal = 300s. There are 50HP to get through, so (1/6)*last_tick_duration per second. Breaths however only happen every 4 ticks. last_tick_duration = ~2.0 on average

#define HEAT_DAMAGE_LEVEL_1 2 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 4 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 8 //Amount of damage applied when your body temperature passes the 1000K point

#define COLD_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 3 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

#define FIRE_ALERT_NONE 0 //No fire alert
#define FIRE_ALERT_COLD 1 //Frostbite
#define FIRE_ALERT_HOT 2 //Real fire

#define RADIATION_SPEED_COEFFICIENT 0.1

/mob/living/carbon/human
	var/oxygen_alert = 0
	var/plasma_alert = 0
	var/co2_alert = 0
	var/fire_alert = FIRE_ALERT_NONE
	var/pressure_alert = 0
	var/temperature_alert = 0
	var/in_stasis = FALSE
	var/stasis_timeofdeath = 0
	var/pulse = PULSE_NORM
	var/global/list/overlays_cache =69ull
	var/dodge_time = 0 // will be set to timeofgame on dodging

/mob/living/carbon/human/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	if(in_stasis && (stat == DEAD))
		timeofdeath = world.time - stasis_timeofdeath

	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return

	fire_alert = FIRE_ALERT_NONE //Reset this here, because both breathe() and handle_environment() have a chance to set it.

	//TODO: seperate this out
	// update the current life tick, can be used to e.g. only do something every 4 ticks
	life_tick++

	// This is69ot an ideal place for this but it will do for69ow.
	if(wearing_rig && wearing_rig.offline)
		wearing_rig =69ull

	. = ..()

	if(life_tick%30==15)
		hud_updateflag = 1022

	voice = GetVoice()

	//No69eed to update all of these procs if the guy is dead.
	if(. && !in_stasis)

		//Organs and blood
		handle_organs()
		process_internal_ograns()
		handle_blood()
		stabilize_body_temperature() //Body temperature adjusts itself (self-regulation)

		handle_shock()

		handle_pain()

		handle_medical_side_effects()

		if (life_tick % 4 == 1 && (get_game_time() >= dodge_time + 5 SECONDS))
			if (confidence == FALSE)
				to_chat(src, SPAN_NOTICE("You feel confident again."))
				confidence = TRUE
			regen_slickness()

		if(life_tick % 2)	//Upadated every 2 life ticks, lots of for loops in this,69eeds to feel smother in the UI
			for(var/obj/item/organ/external/E in organs)
				E.update_limb_efficiency()
			total_blood_req = 0
			total_oxygen_req = 0
			total_nutriment_req = 0
			for(var/obj/item/organ/internal/I in internal_organs)
				if(BP_IS_ROBOTIC(I))
					continue
				total_blood_req += I.blood_req
				total_oxygen_req += I.oxygen_req
				total_nutriment_req += (I.nutriment_req / 1000)
			total_oxygen_req =69in(total_oxygen_req, 100)

		if(!client)
			species.handle_npc(src)

	if(!handle_some_updates())
		return											//We go ahead and process them 5 times for HUD images and other stuff though.

	//Update our69ame based on whether our face is obscured/disfigured
	name = get_visible_name()

/mob/living/carbon/human/proc/handle_some_updates()
	if(life_tick > 5 && timeofdeath && (timeofdeath < 5 || world.time - timeofdeath > 6000))	//We are long dead, or we're junk69obs spawned like the clowns on the clown shuttle
		return FALSE
	return TRUE

/mob/living/carbon/human/breathe()
	if(!in_stasis)
		..()

// Calculate how69ulnerable the human is to under- and overpressure.
// Returns 0 (equals 0 %) if sealed in an undamaged suit, 1 if unprotected (equals 100%).
// Suitdamage can69odifiy this in 10% steps.
/mob/living/carbon/human/proc/get_pressure_weakness()

	var/pressure_adjustment_coefficient = 1 // Assume69o protection at first.

	if(wear_suit && (wear_suit.item_flags & STOPPRESSUREDAMAGE) && head && (head.item_flags & STOPPRESSUREDAMAGE)) // Complete set of pressure-proof suit worn, assume fully sealed.
		pressure_adjustment_coefficient = 0

		// Handles breaches in your space suit. 10 suit damage equals a 100% loss of pressure protection.
		if(istype(wear_suit,/obj/item/clothing/suit/space))
			var/obj/item/clothing/suit/space/S = wear_suit
			if(S.can_breach && S.damage)
				pressure_adjustment_coefficient += S.damage * 0.1

	pressure_adjustment_coefficient =69in(1,max(pressure_adjustment_coefficient,0)) // So it isn't less than 0 or larger than 1.

	return pressure_adjustment_coefficient

// Calculate how69uch of the enviroment pressure-difference affects the human.
/mob/living/carbon/human/calculate_affecting_pressure(var/pressure)
	var/pressure_difference

	// First get the absolute pressure difference.
	if(pressure < ONE_ATMOSPHERE) // We are in an underpressure.
		pressure_difference = ONE_ATMOSPHERE - pressure

	else //We are in an overpressure or standard atmosphere.
		pressure_difference = pressure - ONE_ATMOSPHERE

	if(pressure_difference < 5) // If the difference is small, don't bother calculating the fraction.
		pressure_difference = 0

	else
		// Otherwise calculate how69uch of that absolute pressure difference affects us, can be 0 to 1 (equals 0% to 100%).
		// This is our relative difference.
		pressure_difference *= get_pressure_weakness()

	// The difference is always positive to avoid extra calculations.
	// Apply the relative difference on a standard atmosphere to get the final result.
	// The return69alue will be the adjusted_pressure of the human that is the basis of pressure warnings and damage.
	if(pressure < ONE_ATMOSPHERE)
		return ONE_ATMOSPHERE - pressure_difference
	else
		return ONE_ATMOSPHERE + pressure_difference

/mob/living/carbon/human/handle_disabilities()
	..()
	//Vision
	var/obj/item/organ/vision
	if(species.vision_organ)
		vision = random_organ_by_process(species.vision_organ)	//You can't really have 269ision organs that see at the same time, so this is emulated by switching between the eyes.

	if(!species.vision_organ) // Presumably if a species has69o69ision organs, they see69ia some other69eans.
		eye_blind = 0
		blinded = FALSE
		eye_blurry = 0
	else if(!vision || (vision &&69ision.is_broken()))   //69ision organs cut out or broken? Permablind.
		eye_blind = 1
		blinded = TRUE
		eye_blurry = 1
	else
		//blindness
		if(!(sdisabilities & BLIND))
			if(equipment_tint_total >= TINT_BLIND)	// Covered eyes, heal faster
				eye_blurry =69ax(eye_blurry-2, 0)

	if (disabilities & EPILEPSY)
		if ((prob(1) && paralysis < 1))
			to_chat(src, "\red You have a seizure!")
			for(var/mob/O in69iewers(src,69ull))
				if(O == src)
					continue
				O.show_message(text(SPAN_DANGER("69src69 starts having a seizure!")), 1)
			Paralyse(10)
			make_jittery(1000)
	if (disabilities & COUGHING)
		if ((prob(5) && paralysis <= 1))
			drop_item()
			spawn( 0 )
				emote("cough")
				return
	if (disabilities & TOURETTES)
		speech_problem_flag = 1
		if ((prob(10) && paralysis <= 1))
			Stun(10)
			spawn( 0 )
				switch(rand(1, 3))
					if(1)
						emote("twitch")
					if(2 to 3)
						say("69prob(50) ? ";" : ""6969pick("SHIT", "PISS", "FUCK", "CUNT", "COCKSUCKER", "MOTHERFUCKER", "TITS")69")
				make_jittery(100)
				return
	if (disabilities &69ERVOUS)
		speech_problem_flag = 1
		if (prob(10))
			stuttering =69ax(10, stuttering)

	if(stat != DEAD)
		var/rn = rand(0, 200)
		if(getBrainLoss() >= 5)
			if(0 <= rn && rn <= 3)
				custom_pain("Your head feels69umb and painful.")
		if(getBrainLoss() >= 15)
			if(4 <= rn && rn <= 6) if(eye_blurry <= 0)
				to_chat(src, SPAN_WARNING("It becomes hard to see for some reason."))
				eye_blurry = 10
		if(getBrainLoss() >= 35)
			if(7 <= rn && rn <= 9) if(get_active_hand())
				to_chat(src, SPAN_DANGER("Your hand won't respond properly, you drop what you're holding!"))
				drop_item()
		if(getBrainLoss() >= 45)
			if(10 <= rn && rn <= 12)
				if(prob(50))
					to_chat(src, SPAN_DANGER("You suddenly black out!"))
					Paralyse(10)
				else if(!lying)
					to_chat(src, SPAN_DANGER("Your legs won't respond properly, you fall down!"))
					Weaken(10)



/mob/living/carbon/human/handle_mutations_and_radiation()
	if(in_stasis)
		return

	if(getFireLoss())
		if((COLD_RESISTANCE in69utations) || (prob(1)))
			heal_organ_damage(0,1)

	// DNA2 - Gene processing.
	// The HULK stuff that was here is69ow in the hulk gene.
	for(var/datum/dna/gene/gene in dna_genes)
		if(!gene.block)
			continue
		if(gene.is_active(src))
			speech_problem_flag = 1
			gene.OnMobLife(src)

	radiation = CLAMP(radiation,0,100)

	if (radiation)
		var/damage = 0
		radiation -= 1 * RADIATION_SPEED_COEFFICIENT
		if(prob(25))
			damage = 1

		if (radiation > 50)
			damage = 1
			radiation -= 1 * RADIATION_SPEED_COEFFICIENT
			if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT))
				radiation -= 5 * RADIATION_SPEED_COEFFICIENT
				to_chat(src, SPAN_WARNING("You feel weak."))
				Weaken(3)
				if(!lying)
					emote("collapse")
			if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT) && species.get_bodytype() == SPECIES_HUMAN) //apes go bald
				if((h_style != "Bald" || f_style != "Shaved" ))
					to_chat(src, SPAN_WARNING("Your hair falls out."))
					h_style = "Bald"
					f_style = "Shaved"
					update_hair()

		if (radiation > 75)
			radiation -= 1 * RADIATION_SPEED_COEFFICIENT
			damage = 3
			if(prob(5))
				take_overall_damage(0, 5 * RADIATION_SPEED_COEFFICIENT, used_weapon = "Radiation Burns")
			if(prob(1))
				to_chat(src, SPAN_WARNING("You feel strange!"))
				adjustCloneLoss(5 * RADIATION_SPEED_COEFFICIENT)
				emote("gasp")

		if(damage)
			damage *= species.radiation_mod
			adjustToxLoss(damage * RADIATION_SPEED_COEFFICIENT)
			updatehealth()
			if(organs.len)
				var/obj/item/organ/external/O = pick(organs)
				if(istype(O)) O.add_autopsy_data("Radiation Poisoning", damage)

	/** breathing **/

/mob/living/carbon/human/handle_chemical_smoke(var/datum/gas_mixture/environment)
	if(wear_mask && (wear_mask.item_flags & BLOCK_GAS_SMOKE_EFFECT & AIRTIGHT))
		return
	if(head && (head.item_flags & BLOCK_GAS_SMOKE_EFFECT & AIRTIGHT))
		return
	..()

/mob/living/carbon/human/handle_post_breath(datum/gas_mixture/breath)
	..()
	//spread some69iruses while we are at it
	if(breath &&69irus2.len > 0 && prob(10))
		for(var/mob/living/carbon/M in69iew(1,src))
			src.spread_disease_to(M)


/mob/living/carbon/human/get_breath_from_internal(volume_needed=BREATH_VOLUME)
	if(internal)

		var/obj/item/tank/rig_supply
		if(istype(back,/obj/item/rig))
			var/obj/item/rig/rig = back
			if(!rig.offline && (rig.air_supply && internal == rig.air_supply))
				rig_supply = rig.air_supply

		if (!rig_supply && (!contents.Find(internal) || !((wear_mask && (wear_mask.item_flags & AIRTIGHT)) || (head && (head.item_flags & AIRTIGHT)))))
			internal =69ull

		if(internal)
			return internal.remove_air_volume(volume_needed)
		else if(HUDneed.Find("internal"))
			var/obj/screen/HUDelm = HUDneed69"internal"69
			HUDelm.update_icon()
	return69ull

/mob/living/carbon/human/get_breath_modulo()
	var/breath_modulo_total
	for(var/obj/item/organ/internal/lungs/L in organ_list_by_process(OP_LUNGS))
		breath_modulo_total += L.breath_modulo
	if(!isnull(breath_modulo_total))
		return breath_modulo_total
	return ..()

/mob/living/carbon/human/handle_breath(datum/gas_mixture/breath)
	if(status_flags & GODMODE)
		return

	//check if we actually69eed to process breath
	if(!breath || (breath.total_moles == 0))
		failed_last_breath = 1
		if(prob(20))
			emote("gasp")
		if(health > HEALTH_THRESHOLD_CRIT)
			adjustOxyLoss(HUMAN_MAX_OXYLOSS)
		else
			adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)

		oxygen_alert =69ax(oxygen_alert, 1)
		return 0

	if(get_organ_efficiency(OP_LUNGS) > 1)
		failed_last_breath = !handle_breath_lungs(breath)
	else
		failed_last_breath = 1
	return 1

/mob/living/carbon/human/proc/handle_breath_lungs(datum/gas_mixture/breath)
	if(!breath)
		return FALSE
	//vars - feel free to69odulate if you want69ore effects that are69ot gained with efficiency
	var/breath_type = species.breath_type ? species.breath_type : "oxygen"
	var/poison_type = species.poison_type ? species.poison_type : "plasma"
	var/exhale_type = species.exhale_type ? species.exhale_type : 0

	var/min_breath_pressure = species.breath_pressure

	var/safe_exhaled_max = 10
	var/safe_toxins_max = 0.2
	var/SA_para_min = 1
	var/SA_sleep_min = 5

	var/lung_efficiency = get_organ_efficiency(OP_LUNGS)

	var/safe_pressure_min =69in_breath_pressure //69inimum safe partial pressure of breathable gas in kPa
	// Lung damage increases the69inimum safe pressure.
	if(lung_efficiency < 50)
		safe_pressure_min *= 1.5
	else if(lung_efficiency < 80)
		safe_pressure_min *= 1.25

	var/breath_pressure = (breath.total_moles*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

	var/failed_inhale = 0
	var/failed_exhale = 0

	var/inhaling = breath.gas69breath_type69
	var/poison = breath.gas69poison_type69
	var/exhaling = exhale_type ? breath.gas69exhale_type69 : 0

	var/inhale_pp = (inhaling/breath.total_moles)*breath_pressure
	var/toxins_pp = (poison/breath.total_moles)*breath_pressure
	var/exhaled_pp = (exhaling/breath.total_moles)*breath_pressure

	//69ot enough to breathe
	if(inhale_pp < safe_pressure_min)
		if(prob(20))
			emote("gasp")

		var/ratio = inhale_pp/safe_pressure_min
		// Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS after all!)
		adjustOxyLoss(max(HUMAN_MAX_OXYLOSS*(1-ratio), 0))
		failed_inhale = 1

	oxygen_alert = failed_inhale

	var/inhaled_gas_used = inhaling/6
	breath.adjust_gas(breath_type, -inhaled_gas_used, update = 0) //update afterwards

	if(exhale_type)
		breath.adjust_gas_temp(exhale_type, inhaled_gas_used, bodytemperature, update = 0) //update afterwards
		// Too69uch exhaled gas in the air
		var/word
		var/warn_prob
		var/oxyloss
		var/alert
		if(exhaled_pp > safe_exhaled_max)
			word = pick("extremely dizzy","short of breath","faint","confused")
			warn_prob = 15
			oxyloss = HUMAN_MAX_OXYLOSS
			alert = 1
			failed_exhale = 1
		else if(exhaled_pp > safe_exhaled_max * 0.7)
			word = pick("dizzy","short of breath","faint","momentarily confused")
			warn_prob = 1
			alert = 1
			failed_exhale = 1
			var/ratio = 1 - (safe_exhaled_max - exhaled_pp)/(safe_exhaled_max*0.3)
			if (getOxyLoss() < 50*ratio)
				oxyloss = HUMAN_MAX_OXYLOSS
		else if(exhaled_pp > safe_exhaled_max * 0.6)
			word = pick("a little dizzy","short of breath")
			warn_prob = 1
		else
			co2_alert = 0

		if(!co2_alert && word && prob(warn_prob))
			to_chat(src, SPAN_WARNING("You feel 69word69."))
			adjustOxyLoss(oxyloss)
			co2_alert = alert

	// Too69uch poison in the air.

	if(toxins_pp > safe_toxins_max)
		var/ratio = (poison/safe_toxins_max) * 10
		reagents.add_reagent("toxin", CLAMP(ratio,69IN_TOXIN_DAMAGE,69AX_TOXIN_DAMAGE))
		breath.adjust_gas(poison_type, -poison/6, update = 0) //update after
		plasma_alert = 1
	else
		plasma_alert = 0

	// If there's some other shit in the air lets deal with it here.
	if(breath.gas69"sleeping_agent"69)
		var/SA_pp = (breath.gas69"sleeping_agent"69 / breath.total_moles) * breath_pressure
		if(SA_pp > SA_para_min)		// Enough to69ake us paralysed for a bit
			Paralyse(3)	// 3 gives them one second to wake up and run away a bit!
			if(SA_pp > SA_sleep_min)	// Enough to69ake us sleep as well
				Sleeping(5)
		else if(SA_pp > 0.15)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
			if(prob(20))
				emote(pick("giggle", "laugh"))

		breath.adjust_gas("sleeping_agent", -breath.gas69"sleeping_agent"69/6, update = 0) //update after

	// Were we able to breathe?
	var/failed_breath = failed_inhale || failed_exhale
	if (!failed_breath)
		adjustOxyLoss(-5)

	handle_temperature_effects(breath)

	breath.update_values()
	return !failed_breath

/mob/living/carbon/human/proc/handle_temperature_effects(datum/gas_mixture/breath)
	if(!species)
		return
	// Hot air hurts :( :(
	if((breath.temperature < species.cold_level_1 || breath.temperature > species.heat_level_1) && !(COLD_RESISTANCE in69utations))
		var/damage = 0
		if(breath.temperature <= species.cold_level_1)
			if(prob(20))
				to_chat(src, SPAN_DANGER("You feel your face freezing and icicles forming in your lungs!"))

			switch(breath.temperature)
				if(species.cold_level_3 to species.cold_level_2)
					damage = COLD_GAS_DAMAGE_LEVEL_3
				if(species.cold_level_2 to species.cold_level_1)
					damage = COLD_GAS_DAMAGE_LEVEL_2
				else
					damage = COLD_GAS_DAMAGE_LEVEL_1

			apply_damage(damage, BURN, BP_HEAD, used_weapon = "Excessive Cold")
			fire_alert = FIRE_ALERT_COLD
		else if(breath.temperature >= species.heat_level_1)
			if(prob(20))
				to_chat(src, SPAN_DANGER("You feel your face burning and a searing heat in your lungs!"))

			switch(breath.temperature)
				if(species.heat_level_1 to species.heat_level_2)
					damage = HEAT_GAS_DAMAGE_LEVEL_1
				if(species.heat_level_2 to species.heat_level_3)
					damage = HEAT_GAS_DAMAGE_LEVEL_2
				else
					damage = HEAT_GAS_DAMAGE_LEVEL_3

			apply_damage(damage, BURN, BP_HEAD, used_weapon = "Excessive Heat")
			fire_alert = FIRE_ALERT_HOT

		//breathing in hot/cold air also heats/cools you a bit
		var/temp_adj = breath.temperature - bodytemperature
		if (temp_adj < 0)
			temp_adj /= (BODYTEMP_COLD_DIVISOR * 5)	//don't raise temperature as69uch as if we were directly exposed
		else
			temp_adj /= (BODYTEMP_HEAT_DIVISOR * 5)	//don't raise temperature as69uch as if we were directly exposed

		var/relative_density = breath.total_moles / (MOLES_CELLSTANDARD * BREATH_PERCENTAGE)
		temp_adj *= relative_density

		if (temp_adj > BODYTEMP_HEATING_MAX) temp_adj = BODYTEMP_HEATING_MAX
		if (temp_adj < BODYTEMP_COOLING_MAX) temp_adj = BODYTEMP_COOLING_MAX
		//world << "Breath: 69breath.temperature69, 69src69: 69bodytemperature69, Adjusting: 69temp_adj69"
		bodytemperature += temp_adj

	else if(breath.temperature >= species.heat_discomfort_level)
		species.get_environment_discomfort(src,"heat")
	else if(breath.temperature <= species.cold_discomfort_level)
		species.get_environment_discomfort(src,"cold")


/mob/living/carbon/human/handle_environment(datum/gas_mixture/environment)
	if(!environment)
		return

	//Stuff like the xenomorph's plasma regen happens here.
	species.handle_environment_special(src)

	//Moved pressure calculations here for use in skip-processing check.
	var/pressure = environment.return_pressure()
	var/adjusted_pressure = calculate_affecting_pressure(pressure)

	//Check for contaminants before anything else because we don't want to skip it.
	for(var/g in environment.gas)
		if(gas_data.flags69g69 & XGM_GAS_CONTAMINANT && environment.gas69g69 > gas_data.overlay_limit69g69 + 1)
			pl_effects()
			break

	if(istype(get_turf(src), /turf/space))
		//Don't bother if the temperature drop is less than 0.1 anyways. Hopefully BYOND is smart enough to turn this constant expression into a constant
		if(bodytemperature > (0.1 * HUMAN_HEAT_CAPACITY/(HUMAN_EXPOSED_SURFACE_AREA*STEFAN_BOLTZMANN_CONSTANT))**(1/4) + COSMIC_RADIATION_TEMPERATURE)
			//Thermal radiation into space
			var/heat_loss = HUMAN_EXPOSED_SURFACE_AREA * STEFAN_BOLTZMANN_CONSTANT * ((bodytemperature - COSMIC_RADIATION_TEMPERATURE)**4)
			var/temperature_loss = heat_loss/HUMAN_HEAT_CAPACITY
			bodytemperature -= temperature_loss
	else
		var/loc_temp = T0C
		if(istype(loc, /mob/living/exosuit))
			var/mob/living/exosuit/M = loc
			loc_temp = 69.return_temperature()
		else if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
			var/obj/machinery/atmospherics/unary/cryo_cell/M = loc
			loc_temp =69.air_contents.temperature
		else
			loc_temp = environment.temperature

		if(adjusted_pressure < species.warning_high_pressure && adjusted_pressure > species.warning_low_pressure && abs(loc_temp - bodytemperature) < 20 && bodytemperature < species.heat_level_1 && bodytemperature > species.cold_level_1)
			pressure_alert = 0
			return // Temperatures are within69ormal ranges, fuck all this processing. ~Ccomp

		//Body temperature adjusts depending on surrounding atmosphere based on your thermal protection (convection)
		var/temp_adj = 0
		if(loc_temp < bodytemperature)			//Place is colder than we are
			var/thermal_protection = get_cold_protection(loc_temp) //This returns a 0 - 169alue, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_COLD_DIVISOR)	//this will be69egative
		else if (loc_temp > bodytemperature)			//Place is hotter than we are
			var/thermal_protection = get_heat_protection(loc_temp) //This returns a 0 - 169alue, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR)

		//Use heat transfer as proportional to the gas density. However, we only care about the relative density69s standard 101 kPa/20 C air. Therefore we can use69ole ratios
		var/relative_density = environment.total_moles /69OLES_CELLSTANDARD
		bodytemperature += between(BODYTEMP_COOLING_MAX, temp_adj*relative_density, BODYTEMP_HEATING_MAX)

	// +/- 50 degrees from 310.15K is the 'safe' zone, where69o damage is dealt.
	if(bodytemperature >= species.heat_level_1)
		//Body temperature is too hot.
		fire_alert =69ax(fire_alert, FIRE_ALERT_COLD)
		if(status_flags & GODMODE)	return 1	//godmode
		var/burn_dam = 0
		switch(bodytemperature)
			if(species.heat_level_1 to species.heat_level_2)
				burn_dam = HEAT_DAMAGE_LEVEL_1
			if(species.heat_level_2 to species.heat_level_3)
				burn_dam = HEAT_DAMAGE_LEVEL_2
			if(species.heat_level_3 to INFINITY)
				burn_dam = HEAT_DAMAGE_LEVEL_3
		take_overall_damage(burn=burn_dam, used_weapon = "High Body Temperature")
		fire_alert =69ax(fire_alert, FIRE_ALERT_HOT)

	else if(bodytemperature <= species.cold_level_1)
		fire_alert =69ax(fire_alert, FIRE_ALERT_COLD)
		if(status_flags & GODMODE)	return 1	//godmode

		if(!istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
			var/burn_dam = 0
			switch(bodytemperature)
				if(-INFINITY to species.cold_level_3)
					burn_dam = COLD_DAMAGE_LEVEL_1
				if(species.cold_level_3 to species.cold_level_2)
					burn_dam = COLD_DAMAGE_LEVEL_2
				if(species.cold_level_2 to species.cold_level_1)
					burn_dam = COLD_DAMAGE_LEVEL_3
			take_overall_damage(burn=burn_dam, used_weapon = "Low Body Temperature")
			fire_alert =69ax(fire_alert, FIRE_ALERT_COLD)

	// Account for69assive pressure differences.  Done by Polymorph
	//69ade it possible to actually have something that can protect against high pressure... Done by Errorage. Polymorph69ow has an axe sticking from his head for his previous hardcoded69onsense!
	if(status_flags & GODMODE)	return 1	//godmode

	if(adjusted_pressure >= species.hazard_high_pressure)
		var/pressure_damage =69in( ( (adjusted_pressure / species.hazard_high_pressure) -1 )*PRESSURE_DAMAGE_COEFFICIENT ,69AX_HIGH_PRESSURE_DAMAGE)
		take_overall_damage(brute=pressure_damage, used_weapon = "High Pressure")
		pressure_alert = 2
	else if(adjusted_pressure >= species.warning_high_pressure)
		pressure_alert = 1
	else if(adjusted_pressure >= species.warning_low_pressure)
		pressure_alert = 0
	else if(adjusted_pressure >= species.hazard_low_pressure)
		pressure_alert = -1
	else
		if( !(COLD_RESISTANCE in69utations))
			take_overall_damage(brute=LOW_PRESSURE_DAMAGE, used_weapon = "Low Pressure")
			if(getOxyLoss() < 55) // 11 OxyLoss per 4 ticks when wearing internals;    unconsciousness in 16 ticks, roughly half a69inute
				adjustOxyLoss(4)  // 16 OxyLoss per 4 ticks when69o internals present; unconsciousness in 13 ticks, roughly twenty seconds
			pressure_alert = -2
		else
			pressure_alert = -1

	return

/*
/mob/living/carbon/human/proc/adjust_body_temperature(current, loc_temp, boost)
	var/temperature = current
	var/difference = abs(current-loc_temp)	//get difference
	var/increments// = difference/10			//find how69any increments apart they are
	if(difference > 50)
		increments = difference/5
	else
		increments = difference/10
	var/change = increments*boost	// Get the amount to change by (x per increment)
	var/temp_change
	if(current < loc_temp)
		temperature =69in(loc_temp, temperature+change)
	else if(current > loc_temp)
		temperature =69ax(loc_temp, temperature-change)
	temp_change = (temperature - current)
	return temp_change
*/

/mob/living/carbon/human/proc/stabilize_body_temperature()
	if (species.passive_temp_gain) // We produce heat69aturally.
		bodytemperature += species.passive_temp_gain
	if (species.body_temperature ==69ull)
		return //this species doesn't have69etabolic thermoregulation

	var/body_temperature_difference = species.body_temperature - bodytemperature

	if (abs(body_temperature_difference) < 0.5)
		return //fuck this precision
	if (on_fire)
		return //too busy for pesky69etabolic regulation

	if(bodytemperature < species.cold_level_1) //260.15 is 310.15 - 50, the temperature where you start to feel effects.
		if(nutrition >= 2) //If we are69ery,69ery cold we'll use up quite a bit of69utriment to heat us up.
			adjustNutrition(-2)
		var/recovery_amt =69ax((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)
		//world << "Cold. Difference = 69body_temperature_difference69. Recovering 69recovery_amt69"
//				log_debug("Cold. Difference = 69body_temperature_difference69. Recovering 69recovery_amt69")
		bodytemperature += recovery_amt
	else if(species.cold_level_1 <= bodytemperature && bodytemperature <= species.heat_level_1)
		var/recovery_amt = body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR
		//world << "Norm. Difference = 69body_temperature_difference69. Recovering 69recovery_amt69"
//				log_debug("Norm. Difference = 69body_temperature_difference69. Recovering 69recovery_amt69")
		bodytemperature += recovery_amt
	else if(bodytemperature > species.heat_level_1) //360.15 is 310.15 + 50, the temperature where you start to feel effects.
		//We totally69eed a sweat system cause it totally69akes sense...~
		var/recovery_amt =69in((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)	//We're dealing with69egative69umbers
		//world << "Hot. Difference = 69body_temperature_difference69. Recovering 69recovery_amt69"
//				log_debug("Hot. Difference = 69body_temperature_difference69. Recovering 69recovery_amt69")
		bodytemperature += recovery_amt

	//This proc returns a69umber69ade up of the flags for body parts which you are protected on. (such as HEAD, UPPER_TORSO, LOWER_TORSO, etc. See setup.dm for the full list)
/mob/living/carbon/human/proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
	. = 0
	//Handle69ormal clothing
	for(var/obj/item/clothing/C in list(head,wear_suit,w_uniform,shoes,gloves,wear_mask))
		if(C)
			if(C.max_heat_protection_temperature && C.max_heat_protection_temperature >= temperature)
				. |= C.heat_protection

//See proc/get_heat_protection_flags(temperature) for the description of this proc.
/mob/living/carbon/human/proc/get_cold_protection_flags(temperature)
	. = 0
	//Handle69ormal clothing
	for(var/obj/item/clothing/C in list(head,wear_suit,w_uniform,shoes,gloves,wear_mask))
		if(C)
			if(C.min_cold_protection_temperature && C.min_cold_protection_temperature <= temperature)
				. |= C.cold_protection

/mob/living/carbon/human/get_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = get_heat_protection_flags(temperature)
	return get_thermal_protection(thermal_protection_flags)

/mob/living/carbon/human/get_cold_protection(temperature)
	if(COLD_RESISTANCE in69utations)
		return 1 //Fully protected from the cold.

	temperature =69ax(temperature, 2.7) //There is an occasional bug where the temperature is69iscalculated in ares with a small amount of gas on them, so this is69ecessary to ensure that that bug does69ot affect this calculation. Space's temperature is 2.7K and69ost suits that are intended to protect against any cold, protect down to 2.0K.
	var/thermal_protection_flags = get_cold_protection_flags(temperature)
	return get_thermal_protection(thermal_protection_flags)

/mob/living/carbon/human/proc/get_thermal_protection(var/flags)
	.=0
	if(flags)
		if(flags & HEAD)
			. += THERMAL_PROTECTION_HEAD
		if(flags & UPPER_TORSO)
			. += THERMAL_PROTECTION_UPPER_TORSO
		if(flags & LOWER_TORSO)
			. += THERMAL_PROTECTION_LOWER_TORSO
		if(flags & LEG_LEFT)
			. += THERMAL_PROTECTION_LEG_LEFT
		if(flags & LEG_RIGHT)
			. += THERMAL_PROTECTION_LEG_RIGHT
		if(flags & ARM_LEFT)
			. += THERMAL_PROTECTION_ARM_LEFT
		if(flags & ARM_RIGHT)
			. += THERMAL_PROTECTION_ARM_RIGHT
	return69in(1,.)

/mob/living/carbon/human/handle_chemicals_in_body()
	if(in_stasis)
		return

	if(reagents)
		chem_effects.Cut()
		analgesic = 0

		if(touching) touching.metabolize()
		if(ingested) ingested.metabolize()
		if(bloodstr) bloodstr.metabolize()
		metabolism_effects.process()

		if(CE_PAINKILLER in chem_effects)
			analgesic = chem_effects69CE_PAINKILLER69
		if(!(CE_ALCOHOL in chem_effects))
			if(stats.getPerk(/datum/perk/inspiration))
				stats.removePerk(/datum/perk/active_inspiration)
			if(stats.getPerk(PERK_ALCOHOLIC))
				stats.removePerk(PERK_ALCOHOLIC_ACTIVE)

		var/total_plasmaloss = 0
		for(var/obj/item/I in src)
			if(I.contaminated)
				total_plasmaloss +=69sc.plc.CONTAMINATION_LOSS
		if(!(status_flags & GODMODE)) adjustToxLoss(total_plasmaloss)

	if(status_flags & GODMODE)	return 0	//godmode

	if(species.light_dam)
		var/light_amount = 0
		if(isturf(loc))
			var/turf/T = loc
			light_amount = round((T.get_lumcount()*10)-5)

		if(light_amount > species.light_dam) //if there's enough light, start dying
			take_overall_damage(1,1)
		else //heal in the dark
			heal_overall_damage(1,1)

	// TODO: stomach and bloodstream organ.
	handle_trace_chems()

	updatehealth()

	return //TODO: DEFERRED

/mob/living/carbon/human/handle_regular_status_updates()
	if(!handle_some_updates())
		return 0

	if(status_flags & GODMODE)	return 0

	//SSD check, if a logged player is awake put them back to sleep!
	if(species.show_ssd && !client && !teleop)
		Sleeping(2)
	if(stat == DEAD)	//DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
		blinded = TRUE
		silent = 0
	else				//ALIVE. LIGHTS ARE ON
		updatehealth()	//TODO

		if(species.has_process69BP_BRAIN69 && !has_brain()) //No brain = death
			death()
			blinded = TRUE
			silent = 0
			return 1
		if(health <= HEALTH_THRESHOLD_DEAD) //No health = death
			if(stats.getPerk(PERK_UNFINISHED_DELIVERY) && prob(33)) //Unless you have this perk
				heal_organ_damage(20, 20)
				adjustOxyLoss(-100)
				adjustToxLoss(-20)
				AdjustSleeping(rand(20,30))
				updatehealth()
				stats.removePerk(PERK_UNFINISHED_DELIVERY)
			else
				death()
				blinded = TRUE
				silent = 0
				return 1

		//UNCONSCIOUS.69O-ONE IS HOME
		if(getOxyLoss() > (species.total_health/2))
			Paralyse(3)

		if(hallucination_power)
			handle_hallucinations()

		if(paralysis || sleeping)
			blinded = TRUE
			stat = UNCONSCIOUS
			adjustHalLoss(-3)

		if(paralysis)
			AdjustParalysis(-1)

		else if(sleeping)
			speech_problem_flag = 1
			handle_dreams()
			if (mind)
				//Are they SSD? If so we'll keep them asleep but work off some of that sleep69ar in case of stoxin or similar.
				if(client || sleeping > 3)
					AdjustSleeping(-1)
			if( prob(2) && health)
				spawn(0)
					emote("snore")
		//CONSCIOUS
		else
			stat = CONSCIOUS

		// Check everything else.

		//Periodically double-check embedded_flag
		if(embedded_flag && !(life_tick % 10))
			if(!embedded_needs_process())
				embedded_flag = 0

		//Ears
		if(sdisabilities & DEAF)	//disabled-deaf, doesn't get better on its own
			ear_deaf =69ax(ear_deaf, 1)
		else if(ear_deaf)			//deafness, heals slowly over time
			adjustEarDamage(0,-1)
		else if(istype(l_ear, /obj/item/clothing/ears/earmuffs) || istype(r_ear, /obj/item/clothing/ears/earmuffs))	//resting your ears with earmuffs heals ear damage faster
			adjustEarDamage(-0.15)
			ear_deaf =69ax(ear_deaf, 1)
		else if(ear_damage < 25)	//ear damage heals slowly under this threshold. otherwise you'll69eed earmuffs
			adjustEarDamage(-0.05)

		//Resting
		if(resting)
			dizziness =69ax(0, dizziness - 15)
			jitteriness =69ax(0, jitteriness - 15)
			adjustHalLoss(-3)
		else
			dizziness =69ax(0, dizziness - 3)
			jitteriness =69ax(0, jitteriness - 3)
			adjustHalLoss(-1)

		//Other
		handle_statuses()

		if (drowsyness)
			drowsyness--
			eye_blurry =69ax(2, eye_blurry)
			if (prob(5))
				sleeping += 1
				Paralyse(5)

		confused =69ax(0, confused - 1)

		// If you're dirty, your gloves will become dirty, too.
		if(gloves && germ_level > gloves.germ_level && prob(10))
			gloves.germ_level += 1

	return 1

/mob/living/carbon/human/handle_regular_hud_updates()
	. = ..()
	for (var/obj/screen/H in HUDprocess)
//		var/obj/screen/B = H
		H.Process()
	if(!overlays_cache)
		overlays_cache = list()
		overlays_cache.len = 23
		overlays_cache69169 = image('icons/mob/screen1_full.dmi', "icon_state" = "passage1")
		overlays_cache69269 = image('icons/mob/screen1_full.dmi', "icon_state" = "passage2")
		overlays_cache69369 = image('icons/mob/screen1_full.dmi', "icon_state" = "passage3")
		overlays_cache69469 = image('icons/mob/screen1_full.dmi', "icon_state" = "passage4")
		overlays_cache69569 = image('icons/mob/screen1_full.dmi', "icon_state" = "passage5")
		overlays_cache69669 = image('icons/mob/screen1_full.dmi', "icon_state" = "passage6")
		overlays_cache69769 = image('icons/mob/screen1_full.dmi', "icon_state" = "passage7")
		overlays_cache69869 = image('icons/mob/screen1_full.dmi', "icon_state" = "passage8")
		overlays_cache69969 = image('icons/mob/screen1_full.dmi', "icon_state" = "passage9")
		overlays_cache691069 = image('icons/mob/screen1_full.dmi', "icon_state" = "passage10")
		overlays_cache691169 = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay1")
		overlays_cache691269 = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay2")
		overlays_cache691369 = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay3")
		overlays_cache691469 = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay4")
		overlays_cache691569 = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay5")
		overlays_cache691669 = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay6")
		overlays_cache691769 = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay7")
		overlays_cache691869 = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay1")
		overlays_cache691969 = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay2")
		overlays_cache692069 = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay3")
		overlays_cache692169 = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay4")
		overlays_cache692269 = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay5")
		overlays_cache692369 = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay6")

	if(hud_updateflag) // update our69ob's hud overlays, AKA what others see flaoting above our head
		handle_hud_list()

	//69ow handle what we see on our screen

	var/obj/item/implant/core_implant/cruciform/C = get_core_implant(/obj/item/implant/core_implant/cruciform)
	if(C)
		var/datum/core_module/cruciform/neotheologyhud/NT_hud = C.get_module(/datum/core_module/cruciform/neotheologyhud)
		if(NT_hud)
			NT_hud.update_crucihud()

	if(!.)
		return

	return 1

/mob/living/carbon/human/handle_random_events()
	if(in_stasis)
		return

	// Puke if toxloss is too high
	if(!stat)
		if (getToxLoss() >= 45 &&69utrition > 20)
			vomit()

	//0.1% chance of playing a scary sound to someone who's in complete darkness
	if(isturf(loc) && rand(1,1000) == 1)
		var/turf/T = loc
		if(T.get_lumcount() == 0)
			playsound_local(src,pick(scarySounds),50, 1, -1)

/*
	Called by life(), instead of having the individual hud items update icons each tick and check for status changes
	we only set those statuses and icons upon changes.  Then those HUD items will simply add those pre-made images.
	This proc below is only called when those HUD elements69eed to change as determined by the69obs hud_updateflag.
*/


/mob/living/carbon/human/proc/handle_hud_list()
	if (BITTEST(hud_updateflag, HEALTH_HUD))
		var/image/holder = hud_list69HEALTH_HUD69
		if(stat == DEAD)
			holder.icon_state = "hudhealth-100" 	// X_X
		else
			var/percentage_health = RoundHealth((health-HEALTH_THRESHOLD_CRIT)/(maxHealth-HEALTH_THRESHOLD_CRIT)*100)
			holder.icon_state = "hud69percentage_health69"
		hud_list69HEALTH_HUD69 = holder

	if (BITTEST(hud_updateflag, LIFE_HUD))
		var/image/holder = hud_list69LIFE_HUD69
		if(stat == DEAD)
			holder.icon_state = "huddead"
		else
			holder.icon_state = "hudhealthy"
		hud_list69LIFE_HUD69 = holder

	if (BITTEST(hud_updateflag, STATUS_HUD))
		var/foundVirus = 0
		for (var/ID in69irus2)
			if (ID in69irusDB)
				foundVirus = 1
				break

		var/image/holder = hud_list69STATUS_HUD69
		if(stat == DEAD)
			holder.icon_state = "huddead"
		else if(foundVirus)
			holder.icon_state = "hudill"
		else if(has_brain_worms())
			var/mob/living/simple_animal/borer/B = has_brain_worms()
			if(B.controlling)
				holder.icon_state = "hudbrainworm"
			else
				holder.icon_state = "hudhealthy"
		else
			holder.icon_state = "hudhealthy"

		var/image/holder2 = hud_list69STATUS_HUD_OOC69
		if(stat == DEAD)
			holder2.icon_state = "huddead"
		else if(has_brain_worms())
			holder2.icon_state = "hudbrainworm"
		else if(virus2.len)
			holder2.icon_state = "hudill"
		else
			holder2.icon_state = "hudhealthy"

		hud_list69STATUS_HUD69 = holder
		hud_list69STATUS_HUD_OOC69 = holder2

	if (BITTEST(hud_updateflag, ID_HUD))
		var/image/holder = hud_list69ID_HUD69
		if(wear_id)
			var/obj/item/card/id/I = wear_id.GetIdCard()
			if(I)
				holder.icon_state = "hud69ckey(I.GetJobName())69"
			else
				holder.icon_state = "hudunknown"
		else
			holder.icon_state = "hudunknown"


		hud_list69ID_HUD69 = holder

	if (BITTEST(hud_updateflag, WANTED_HUD))
		var/image/holder = hud_list69WANTED_HUD69
		holder.icon_state = "hudblank"
		var/perpname = get_id_name(name)

		var/datum/computer_file/report/crew_record/R = get_crewmember_record(perpname)
		if(R)
			switch(R.get_criminalStatus())
				if("*Arrest*")
					holder.icon_state = "hudwanted"
				if("Incarcerated")
					holder.icon_state = "hudprisoner"
				if("Parolled")
					holder.icon_state = "hudparolled"
				if("Released")
					holder.icon_state = "hudreleased"
		hud_list69WANTED_HUD69 = holder

	if (BITTEST(hud_updateflag,  IMPCHEM_HUD) || BITTEST(hud_updateflag, IMPTRACK_HUD))

		var/image/holder1 = hud_list69IMPTRACK_HUD69
		var/image/holder2 = hud_list69IMPCHEM_HUD69

		holder1.icon_state = "hudblank"
		holder2.icon_state = "hudblank"

		for(var/obj/item/implant/I in src)
			if(I.implanted)
				if(istype(I,/obj/item/implant/tracking))
					holder1.icon_state = "hud_imp_tracking"
				if(istype(I,/obj/item/implant/chem))
					holder2.icon_state = "hud_imp_chem"

		hud_list69IMPTRACK_HUD69 = holder1
		hud_list69IMPCHEM_HUD69  = holder2

	if (BITTEST(hud_updateflag, SPECIALROLE_HUD))
		var/image/holder = hud_list69SPECIALROLE_HUD69
		holder.icon_state = "hudblank"
		if(mind &&69ind.antagonist.len != 0)
			var/datum/antagonist/antag =69ind.antagonist69169	//only display the first antagonist role
			if(hud_icon_reference69antag.role_text69)
				holder.icon_state = hud_icon_reference69antag.role_text69
			else
				holder.icon_state = "hudsyndicate"
			hud_list69SPECIALROLE_HUD69 = holder

	if (BITTEST(hud_updateflag, EXCELSIOR_HUD))
		var/image/holder = hud_list69EXCELSIOR_HUD69
		holder.icon_state = "hudblank"
		if(is_excelsior(src))
			holder.icon_state = "hudexcelsior"
		hud_list69EXCELSIOR_HUD69 = holder

	hud_updateflag = 0

/mob/living/carbon/human/handle_silent()
	if(..())
		speech_problem_flag = 1
	return silent

/mob/living/carbon/human/handle_slurring()
	if(..())
		speech_problem_flag = 1
	return slurring

/mob/living/carbon/human/handle_stunned()
	if(species.flags &69O_PAIN)
		stunned = 0
		return 0
	if(..())
		speech_problem_flag = 1
	return stunned

/mob/living/carbon/human/handle_stuttering()
	if(..())
		speech_problem_flag = 1
	return stuttering

/mob/living/carbon/human/handle_fire()
	if(..())
		return

	var/burn_temperature = fire_burn_temperature()
	var/thermal_protection = get_heat_protection(burn_temperature)

	if (thermal_protection < 1 && bodytemperature < burn_temperature)
		bodytemperature += round(BODYTEMP_HEATING_MAX*(1-thermal_protection), 1)

/mob/living/carbon/human/rejuvenate()
	sanity.setLevel(sanity.max_level)
	timeofdeath = 0
	restore_blood()
	..()

/mob/living/carbon/human/handle_vision()
	if(client)
		client.screen.Remove(global_hud.blurry, global_hud.druggy, global_hud.vimpaired, global_hud.darkMask, global_hud.lightMask, global_hud.nvg, global_hud.thermal, global_hud.meson, global_hud.science)
	if(machine)
		var/viewflags =69achine.check_eye(src)
		if(viewflags < 0)
			reset_view(null, 0)
		else if(viewflags)
			sight |=69iewflags
	else if(eyeobj)
		if(eyeobj.owner != src)
			reset_view(null)
	else
		var/isRemoteObserve = FALSE
		if(shadow && client.eye == shadow && !is_physically_disabled())
			isRemoteObserve = TRUE
		else if(client.eye && istype(client.eye,/mob/observer/eye/god))
			isRemoteObserve = TRUE
		else if(client.eye && istype(client.eye,/obj/item/implant/carrion_spider/observer))
			isRemoteObserve = TRUE
		else if(client.eye && istype(client.eye,/obj/structure/multiz))
			isRemoteObserve = TRUE
		else if(((mRemote in69utations) || remoteviewer) && remoteview_target)
			if(remoteview_target.stat == CONSCIOUS)
				isRemoteObserve = TRUE
		if(!isRemoteObserve && client && !client.adminobs)
			remoteview_target =69ull
			reset_view(null, FALSE)

	update_equipment_vision()
	species.handle_vision(src)

/mob/living/carbon/human/update_sight()
	..()
	if(stat == DEAD)
		return
	if(XRAY in69utations)
		sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS

/mob/living/carbon/human/proc/regen_slickness(var/source_modifier = 1)
	var/slick = TRUE
	if (slickness == style*10) // is slickness at the69aximum?
		slick = FALSE
	slickness =69ax(min(slickness + 1 * source_modifier * style, style*10), 0)
	if (slick && slickness == style*10 && style > 0) // if slickness was69ot at the69aximum and69ow is
		to_chat(src, SPAN_NOTICE("You feel slick!")) //69otify of slickness entering69aximum

/mob/living/carbon/human/proc/EnterStasis()
	in_stasis = TRUE
	stasis_timeofdeath = world.time - timeofdeath


/mob/living/carbon/human/proc/ExitStasis()
	in_stasis = FALSE
	stasis_timeofdeath = 0
