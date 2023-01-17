/obj/item/organ/internal/brain
	name = "brain"
	health = 400 //They need to live awhile longer than other organs. Is this even used by organ code anymore?
	desc = "A piece of juicy meat found in a person's head."
	organ_efficiency = list(BP_BRAIN = 100)
	parent_organ_base = BP_HEAD
	unique_tag = BP_BRAIN
	vital = 1
	icon_state = "brain2"
	force = 1
	w_class = ITEM_SIZE_SMALL
	specific_organ_size = 2
	throwforce = 1
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_BIO = 3)
	attack_verb = list("attacked", "slapped", "whacked")
	price_tag = 900
	blood_req = 8
	max_blood_storage = 80
	oxygen_req = 8
	nutriment_req = 6
	var/mob/living/carbon/brain/brainmob = null

/obj/item/organ/internal/brain/New()
	..()
	health = config.default_brain_health
	spawn(5)
		if(brainmob && brainmob.client)
			brainmob.client.screen.len = null //clear the hud

/obj/item/organ/internal/brain/Destroy()
	if(brainmob)
		qdel(brainmob)
		brainmob = null
	. = ..()

/obj/item/organ/internal/brain/proc/transfer_identity(mob/living/carbon/H)
	name = "\the [H]'s [initial(src.name)]"
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.b_type = H.b_type
	brainmob.dna_trace = H.dna_trace
	brainmob.fingers_trace = H.fingers_trace
	brainmob.timeofhostdeath = H.timeofdeath
	if(H.mind)
		H.mind.transfer_to(brainmob)

	to_chat(brainmob, SPAN_NOTICE("You feel slightly disoriented. That's normal when you're just a [initial(src.name)]."))
	callHook("debrain", list(brainmob))

/obj/item/organ/internal/brain/examine(mob/user) // -- TLE
	..(user)
	if(brainmob && brainmob.client)//if thar be a brain inside... the brain.
		to_chat(user, "You can feel the small spark of life still left in this one.")
	else
		to_chat(user, "This one seems particularly lifeless. Perhaps it will regain some of its luster later..")

/obj/item/organ/internal/brain/removed_mob(mob/living/user)
	name = "[owner.real_name]'s brain"

	if(!(owner.status_flags & REBUILDING_ORGANS))
		var/mob/living/simple_animal/borer/borer = owner.get_brain_worms()
		if(borer)
			borer.detatch() //Should remove borer if the brain is removed - RR

		var/obj/item/organ/internal/carrion/core/C = owner.random_organ_by_process(BP_SPCORE)
		if(C)
			C.removed()
			qdel(src)
			return

		transfer_identity(owner)

	..()

/obj/item/organ/internal/brain/replaced_mob(mob/living/carbon/target)
	..()
	if(owner.key && !(owner.status_flags & REBUILDING_ORGANS))
		owner.ghostize()

	if(brainmob)
		if(brainmob.mind)
			brainmob.mind.transfer_to(owner)
		else
			owner.key = brainmob.key

/obj/item/organ/internal/brain/slime
	name = "slime core"
	desc = "A complex, organic knot of jelly and crystalline particles."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "green slime extract"

/obj/item/organ/internal/brain/golem
	name = "chem"
	desc = "A tightly furled roll of paper, covered with indecipherable runes."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll"
