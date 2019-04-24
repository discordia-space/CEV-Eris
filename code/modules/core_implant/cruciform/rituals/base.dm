/datum/ritual/cruciform/base
	name = "cruciform"
	phrase = null
	implant_type = /obj/item/weapon/implant/core_implant/cruciform
	success_message = "On the verge of audibility you hear pleasant music, your mind clears up and the spirit grows stronger. Your prayer was heard."
	fail_message = "The Cruciform feels cold against your chest."
	category = "Common"


/datum/ritual/targeted/cruciform/base
	name = "cruciform targeted"
	phrase = null
	implant_type = /obj/item/weapon/implant/core_implant/cruciform
	category = "Common"


/datum/ritual/cruciform/base/relief
	name = "Relief"
	phrase = "Et si ambulavero in medio umbrae mortis non timebo mala"
	desc = "Short litany to relieve pain of the afflicted."
	power = 50
	chance = 33

/datum/ritual/cruciform/base/relief/perform(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C)
	H.add_chemical_effect(CE_PAINKILLER, 10)
	return TRUE


/datum/ritual/cruciform/base/soul_hunger
	name = "Soul Hunger"
	phrase = "Panem nostrum cotidianum da nobis hodie"
	desc = "Litany of piligrims, helps better withstand hunger."
	power = 50
	chance = 33

/datum/ritual/cruciform/base/soul_hunger/perform(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C)
	H.nutrition += 100
	H.adjustToxLoss(5)
	return TRUE


/datum/ritual/cruciform/base/entreaty
	name = "Entreaty"
	phrase = "Deus meus ut quid dereliquisti me"
	desc = "Call for help, that other cruciform bearers can hear."
	power = 50
	chance = 60

/datum/ritual/cruciform/base/entreaty/perform(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C)
	for(var/mob/living/carbon/human/target in disciples)
		if(target == H)
			continue

		var/obj/item/weapon/implant/core_implant/cruciform/CI = target.get_core_implant()

		if((istype(CI) && CI.get_module(CRUCIFORM_PRIEST)) || prob(50))
			target << SPAN_DANGER("[H], faithful cruciform follower, cries for salvation!")
	return TRUE

/datum/ritual/cruciform/base/reveal
	name = "Reveal Adversaries"
	phrase = "Et fumus tormentorum eorum ascendet in saecula saeculorum: nec habent requiem die ac nocte, qui adoraverunt bestiam, et imaginem ejus, et si quis acceperit caracterem nominis ejus."
	desc = "Gain knowledge of your surroundings, to reveal evil in people and places. Can tell you about hostile creatures around you, rarely can help you spot traps, and sometimes let you sense a changeling."
	power = 35

/datum/ritual/cruciform/base/reveal/perform(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C)
	var/was_triggired = FALSE
	if(prob(20)) //Aditional fail chance that hidded from user
		H << SPAN_NOTICE("There is nothing there. You feel safe.")
		return TRUE
	for (var/mob/living/carbon/superior_animal/S in range(14, H))
		if (S.stat != DEAD)
			H << SPAN_WARNING("Adversaries are near. You can feel something nasty and hostile.")
			was_triggired = TRUE
			break

	if (!was_triggired)
		for (var/mob/living/simple_animal/hostile/S in range(14, H))
			if (S.stat != DEAD)
				H << SPAN_WARNING("Adversaries are near. You can feel something nasty and hostile.")
				was_triggired = TRUE
				break
	if (prob(80) && (locate(/obj/structure/wire_splicing) in view(7, H))) //Add more traps later
		H << SPAN_WARNING("Something wrong with this area. Tread carefully.")
		was_triggired = TRUE
	if (prob(20))
		for(var/mob/living/carbon/human/target in range(14, H))
			if(target.mind && target.mind.changeling)
				H << SPAN_DANGER("Something ire is upon you! Twisted and evil mind touches you for a moment, leaving you in cold sweat.")
				was_triggired = TRUE
	if (!was_triggired)
		H << SPAN_NOTICE("There is nothing there. You feel safe.")
	return TRUE



//BIOMATTER MANIPULATION MULTI MACHINES RITUALS

//biogenerator manipulation rite
/datum/ritual/cruciform/base/power_biogen_awake
	name = "Power biogenerator song"
	phrase = "Such wow, how meow, there's no banana, only nanaban"
	desc = "A ritual, that can activate or deactivate power biogenerator machine. You should be nearby its metrics screen."
	power = 10


/datum/ritual/cruciform/base/power_biogen_awake/perform(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C)
	var/obj/machinery/multistructure/biogenerator_part/console/biogen_screen = locate() in range(4, H)
	if(biogen_screen && biogen_screen.MS)
		var/datum/multistructure/biogenerator/biogenerator = biogen_screen.MS
		if(biogenerator.working)
			biogenerator.deactivate()
		else
			biogenerator.activate()
		return TRUE


//bioreactor pump solution ritual
/datum/ritual/cruciform/base/bioreactor_solution
	name = "Bioreactor solution pump's lullaby"
	phrase = "Cheeki-breeki i v damke op-pa-pa, vodka, balalaika, babushka, pushkin"
	desc = "This ritual pump in or pump out solution of bioreactor's chamber. You should stay nearby its screen."
	power = 10


/datum/ritual/cruciform/base/bioreactor_solution/perform(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C)
	var/obj/machinery/multistructure/bioreactor_part/console/bioreactor_screen = locate() in range(4, H)
	if(bioreactor_screen && bioreactor_screen.MS)
		var/datum/multistructure/bioreactor/bioreactor = bioreactor_screen.MS
		bioreactor.pump_solution()
		return TRUE


//bioreactor chamber opening ritual
/datum/ritual/cruciform/base/bioreactor_doors
	name = "Bioreactor chamber's words"
	phrase = "Sim-salabim, sizam-otkroysya, cheort vozmi"
	desc = "This ritual open or close bioreactor chamber. You should stay nearby its screen."
	power = 10


/datum/ritual/cruciform/base/bioreactor_doors/perform(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C)
	var/obj/machinery/multistructure/bioreactor_part/console/bioreactor_screen = locate() in range(4, H)
	if(bioreactor_screen && bioreactor_screen.MS)
		var/datum/multistructure/bioreactor/bioreactor = bioreactor_screen.MS
		bioreactor.toggle_platform_door()
		return TRUE