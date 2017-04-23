var/list/christians = list()

/obj/item/weapon/implant/cruciform
	name = "cruciform"
	icon_state = "cruciform_red"
	w_class = 2
	origin_tech = list(TECH_MATERIAL=2, TECH_BIO=7, TECH_DATA=5)
	var/datum/dna2/record/data = null
	var/power = 50
	var/max_power = 50
	var/success_modifier = 1
	var/active = FALSE
	var/list/allowed_rituals = list(/datum/ritual/relief, /datum/ritual/soul_hunger, /datum/ritual/entreaty)

/obj/item/weapon/implant/cruciform/proc/use_power(var/value)
	power = max(0, power - value)

/obj/item/weapon/implant/cruciform/proc/restore_power(var/value)
	power = min(max_power, power + value)

/obj/item/weapon/implant/cruciform/install(mob/living/carbon/human/H)
	..(H, "chest")

/obj/item/weapon/implant/cruciform/get_mob_overlay(gender, body_build)
	gender = (gender == MALE) ? "m" : "f"
	return image('icons/mob/human_races/cyberlimbs/neotheology.dmi', "[icon_state]_[gender][body_build]")

/obj/item/weapon/implant/cruciform/activate()
	active = TRUE
	update_data()
	processing_objects.Add(src)
	christians.Add(wearer)

/obj/item/weapon/implant/cruciform/proc/update_data()
	if(!wearer)
		return

	data = new /datum/dna2/record()
	data.dna = wearer.dna
	data.ckey = wearer.ckey
	data.mind = wearer.mind
	data.id = copytext(md5(wearer.real_name), 2, 6)
	data.name = data.dna.real_name
	data.types = DNA2_BUF_UI | DNA2_BUF_UE | DNA2_BUF_SE
	data.languages = wearer.languages
	data.flavor = wearer.flavor_text

/obj/item/weapon/implant/cruciform/process()
	if((!implanted && !wearer) || !active)
		return
	restore_power(0.5)

/obj/item/weapon/implant/cruciform/Destroy()
	processing_objects.Remove(src)
	..()

/obj/item/weapon/implant/cruciform/hear_talk(mob/living/carbon/human/H, message)
	if(!active)
		return

	if(wearer != H)
		return

	message = replace_characters(message, list("." = ""))
	for(var/datum/ritual/R in allowed_rituals)
		if(R.phrase == message)
			if(R.power > src.power)
				H << "<span class='danger'></span>"
				return
			R.perform(H, src)
			return


/obj/item/weapon/implant/cruciform/priest
	icon_state = "cruciform_green"
	power = 100
	max_power = 100
	success_modifier = 3
