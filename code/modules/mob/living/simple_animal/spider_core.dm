/mob/living/simple_animal/spider_core
	name = "spider core"
	desc = "A horrifying face on spider-like legs."
	speak_emote = list("creaks")
	response_help  = "pokes"
	response_disarm = "prods"
	response_harm   = "stomps on"
	icon_state = "spider_core"

	health = 60
	maxHealth = 60 //Same as post69erf blitz hp

	speed = -1
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	a_intent = I_HURT
	stop_automated_movement = 1
	status_flags = CANPUSH
	attacktext = "stabed"
	friendly = "punched"
	harm_intent_damage = 1
	wander = 0
	hunger_enabled = FALSE
	pass_flags = PASSTABLE
	universal_understand = 1
	density = TRUE //Should be 0, but then these things would be a69ightmare to kill.
	faction = "spiders"

/mob/living/simple_animal/spider_core/New()
	. = ..()
	verbs |= /mob/living/proc/ventcrawl
	verbs |= /mob/living/proc/hide
	verbs |= /mob/living/simple_animal/spider_core/proc/generate_body

/mob/living/simple_animal/spider_core/death()
	gibs(loc,69ull, /obj/effect/gibspawner/generic, "#666600", "#666600")
	qdel(src)
	

/mob/living/simple_animal/spider_core/proc/generate_body()
	set69ame = "Build a Body"
	set desc = "Build a69ew body for you to inhabit."
	set category = "Abilities"

	to_chat(src, SPAN_NOTICE("You start building a body"))

	if(!do_after(src, 169INUTES, src))
		to_chat(src, SPAN_NOTICE("The69ew body is69ot ready yet, it takes a69inute to69ake one. You have to stand still."))
		return

	var/mob/living/carbon/human/H =69ew /mob/living/carbon/human(loc)
	visible_message(SPAN_DANGER("69src6969orphs into a human body!"))
	gibs(loc,69ull)
	var/obj/item/organ/internal/carrion/core/core = locate(/obj/item/organ/internal/carrion/core) in contents
	
	var/list/powers_to_buy = list()

	H.faction = "spiders"
	if(core)
		core.spiderlist.Cut()
		core.geneticpoints = round(core.geneticpoints / 2)
		for(var/datum/power/carrion/P in core.purchasedpowers)
			if(P.genomecost) //Free powers are bought automaticaly
				if(prob(50))
					powers_to_buy += P.name
			else
				powers_to_buy += P.name

		core.purchasedpowers.Cut()
		if(!powerinstances.len)
			for(var/P in powers)
				powerinstances +=69ew P()

		var/obj/item/organ/external/chest/chest = H.get_organ(BP_CHEST) // get_organ with69o arguments defaults to BP_CHEST, but it69akes it less readable
		core.replaced(chest)
		for(var/item in core.active_spiders)
			var/obj/item/implant/carrion_spider/CS = item
			if(istype(CS))
				CS.update_owner_mob()

		usr.mind.transfer_to(H)
		for(var/CP in powers_to_buy)
			core.purchasePower(CP, TRUE)

		core.associated_spider =69ull

	qdel(src)
