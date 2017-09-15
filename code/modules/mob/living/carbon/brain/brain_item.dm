/obj/item/organ/internal/brain
	name = "brain"
	health = 400 //They need to live awhile longer than other organs.
	desc = "A piece of juicy meat found in a person's head."
	organ_tag = O_BRAIN
	parent_organ = BP_HEAD
	vital = 1
	icon_state = "brain2"
	force = 1.0
	w_class = 2
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_BIO = 3)
	attack_verb = list("attacked", "slapped", "whacked")
	var/mob/living/carbon/brain/brainmob = null

/obj/item/organ/internal/pariah_brain
	name = "brain remnants"
	desc = "Did someone tread on this? It looks useless for cloning or cyborgification."
	organ_tag = O_BRAIN
	parent_organ = BP_HEAD
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"
	vital = 1

/obj/item/organ/internal/brain/xeno
	name = "thinkpan"
	desc = "It looks kind of like an enormous wad of purple bubblegum."
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"

/obj/item/organ/internal/brain/New()
	..()
	health = config.default_brain_health
	spawn(5)
		create_reagents(10)
		if(brainmob && brainmob.client)
			brainmob.client.screen.len = null //clear the hud

/obj/item/organ/internal/brain/Destroy()
	if(brainmob)
		qdel(brainmob)
		brainmob = null
	..()

/obj/item/organ/internal/brain/proc/transfer_identity(var/mob/living/carbon/H)
	name = "\the [H]'s [initial(src.name)]"
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna.Clone()
	brainmob.timeofhostdeath = H.timeofdeath
	if(H.mind)
		H.mind.transfer_to(brainmob)

	brainmob << SPAN_NOTICE("You feel slightly disoriented. That's normal when you're just a [initial(src.name)].")
	callHook("debrain", list(brainmob))

	for(var/datum/language/L in H.languages)
		brainmob.add_language(L.name)

/obj/item/organ/internal/brain/examine(mob/user, return_dist) // -- TLE
	.=..(user)
	if(brainmob && brainmob.client)//if thar be a brain inside... the brain.
		user << "You can feel the small spark of life still left in this one."
	else
		user << "This one seems particularly lifeless. Perhaps it will regain some of its luster later.."

/obj/item/organ/internal/brain/removed(var/mob/living/user)

	name = "[owner.real_name]'s brain"

	var/mob/living/simple_animal/borer/borer = owner.has_brain_worms()

	if(borer)
		borer.detatch() //Should remove borer if the brain is removed - RR

	if(istype(owner))
		transfer_identity(owner)

	..()

/obj/item/organ/internal/brain/install(var/mob/living/target)

	if(brainmob)
		if(target.key)
			target.ghostize()
		if(brainmob.mind)
			brainmob.mind.transfer_to(target)
		else
			target.key = brainmob.key
	..()

/obj/item/organ/internal/brain/slime
	name = "slime core"
	desc = "A complex, organic knot of jelly and crystalline particles."
	robotic = 2
	icon = 'icons/mob/slimes.dmi'
	icon_state = "green slime extract"
	var/clonnig_process = 0
	var/attemps = 2

/obj/item/organ/internal/brain/slime/proc/slimeclone()

	if(attemps<=0) usr << "<span class = 'warning'>[src] is not react!</span>"
	if(clonnig_process) return 0
	clonnig_process = 1
	attemps--

	visible_message("<span class = 'notice'>It seems [src] start moving!</span>")
	if(!brainmob || !brainmob.mind)
		clonnig_process = 0
		return 0

	if(!brainmob.client)
		for(var/mob/observer/ghost in player_list)
			if(ghost.mind == brainmob.mind)
				ghost << "<b><font color = #330033><font size = 3>Someone is trying to regrown you from your brain. Return to your body if you want to be resurrected/cloned!</b> (Verbs -> Ghost -> Re-enter corpse)</font color>"
				break

		for(var/i = 0; i < 6; i++)
			sleep(100)
			visible_message("<span class = 'notice'>[src] moving slightly!</span>")
			if(brainmob.client) break

	if(!brainmob.client)
		visible_message("<span class = 'warning'>It seems \the [src] stop moving</span>")
		clonnig_process = 0
		return 0

	var/datum/mind/clonemind = brainmob.mind
	if(clonemind.current != brainmob)
		clonnig_process = 0
		return 0

	visible_message("<span class = 'warning'>\The [src] start growing!</span>")
	var/mob/living/carbon/slime/S = new(src.loc)
	brainmob.mind.transfer_to(S)
	S.dna = brainmob.dna
	S.a_intent = "hurt"
	S.add_language("Galactic Common")
	del(src)

/obj/item/organ/internal/brain/golem
	name = "chem"
	desc = "A tightly furled roll of paper, covered with indecipherable runes."
	robotic = 2
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll"
