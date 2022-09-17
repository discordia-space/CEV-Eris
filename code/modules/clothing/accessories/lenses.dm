/obj/item/clothing/glasses/attachable_lenses
	name = "thermal lenses"
	desc = "Lenses for glasses, you can see red people through walls with them."
	icon_state = "thermal_lens"
	description_antag = "These let you see through walls, but make you highly susceptible to flashbangs."
	body_parts_covered = FALSE
	slot_flags = FALSE
	see_invisible = FALSE
	vision_flags = SEE_MOBS
	flash_protection = FLASH_PROTECTION_REDUCED
	origin_tech = list(TECH_COVERT = 3)
	/// Saves the overlay of the last goggles converted , just for the sake of not deleting it
	var/saved_last_overlay = FALSE

	spawn_blacklisted = TRUE
// Yep , we have to do it in new , because global.
/obj/item/clothing/glasses/attachable_lenses/New()
	..()
	overlay = global_hud.thermal

/obj/item/clothing/glasses/verb/detach_lenses()
	set name = "Detach lenses"
	set category = "Object"
	set src in view(1)

	if (have_lenses)
		flash_protection = initial(protection)
		see_invisible = initial(see_invisible)
		vision_flags = initial(vision_flags)
		var/obj/item/clothing/glasses/attachable_lenses/lenses = have_lenses
		overlay = lenses.saved_last_overlay
		lenses.saved_last_overlay = FALSE
		to_chat(usr, "You detach \the [have_lenses] from \the [src]");
		usr.put_in_hands(have_lenses)
		SEND_SIGNAL(src, COMSIG_GLASS_LENSES_REMOVED, usr, src)
		have_lenses = FALSE
		if(ishuman(usr))
			var/mob/living/carbon/human/beingofeyes = usr
			beingofeyes.update_equipment_vision()
	else
		to_chat(usr, "You haven't got any lenses in \the [src]");


/obj/item/clothing/glasses/attachable_lenses/proc/handle_insertion(obj/item/clothing/glasses/target, mob/living/carbon/human/inserter)
	if(target.have_lenses)
		to_chat(inserter, "You already have lenses in \the [target]")
		return FALSE
	if(overlay)
		saved_last_overlay = target.overlay
		target.overlay = overlay
	if(vision_flags) // Don/t override if we don't have it set.
		target.vision_flags = vision_flags
	if(see_invisible)
		target.see_invisible = see_invisible
	if(flash_protection)
		target.protection = flash_protection
		target.flash_protection = flash_protection
	to_chat(inserter, "You attached \the [src] to \the [target]")
	target.have_lenses = src
	inserter.drop_item(src)
	forceMove(target)


/*
 Good example of how to make a subtype of googles that handles everything.

/obj/item/clothing/glasses/attachable_lenses/explosive
	name = "explosive lenses"
	desc = "Lenses for glasses, these ones explode when someone wears goggles containing them. Awful."
	icon_state = "thermal_lens"
	vision_flags = FALSE
	flash_protection = FALSE
	origin_tech = list(TECH_COVERT = 3, TECH_COMBAT = 2 , TECH_ENGINEERING = 5)
	var/charge_exploded = FALSE

/obj/item/clothing/glasses/attachable_lenses/explosive/New()
	..()
	overlay = null

/obj/item/clothing/glasses/attachable_lenses/explosive/handle_insertion(obj/item/clothing/glasses/target, mob/living/carbon/human/inserter)
	..()
	RegisterSignal(target, COMSIG_CLOTH_EQUIPPED, .proc/handle_boom)
	RegisterSignal(target, COMSIG_GLASS_LENSES_REMOVED, .proc/handle_removal)
	if(target.is_worn()) // Sucks to be you.
		handle_boom(inserter)

/obj/item/clothing/glasses/attachable_lenses/explosive/proc/handle_boom(mob/living/carbon/human/unfortunate_man)
	if(charge_exploded)
		return FALSE
	var/obj/item/clothing/glasses/our_glasses = loc
	if(!our_glasses.is_worn()) // We aren't worn
		return FALSE
	visible_message(SPAN_DANGER("[unfortunate_man]'s skull gets pierced by a jet of molten slag as he puts \the [loc] on his eyes"),
					SPAN_DANGER("You hear the sound of a skull cracking and meat sizzling"), 6)
	playsound(get_turf(loc), 'sound/effects/bangtaper.ogg' ,50, 1)
	spawn(1 SECONDS)
		playsound(get_turf(loc), 'sound/effects/flare.ogg', 100, 1)
	unfortunate_man.adjustBrainLoss(200)
	for(var/obj/item/organ/internal/organ in unfortunate_man.get_organ(BP_HEAD).contents)
		organ.take_damage(200)
	charge_exploded = TRUE
	// F
	handle_removal()

/obj/item/clothing/glasses/attachable_lenses/explosive/proc/handle_removal(mob/living/carbon/human/remover, obj/item/clothing/glasses/holder)
	UnregisterSignal(holder, COMSIG_CLOTH_EQUIPPED)
	UnregisterSignal(holder, COMSIG_GLASS_LENSES_REMOVED)

*/




