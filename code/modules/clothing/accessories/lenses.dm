/obj/item/clothing/glasses/attachable_lenses
	name = "Thermal lenses"
	desc = "lenses for glasses, you can see red people through walls with them."
	icon_state = "thermal_lens"
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
		origin_tech = initial(origin_tech)
		overlay = saved_last_overlay
		saved_last_overlay = FALSE
		to_chat(usr, "You detach \the [have_lenses] from \the [src]");
		usr.put_in_hands(have_lenses)
		SEND_SIGNAL(src, COMSIG_GLASS_LENSES_REMOVED, usr, src)

	else
		to_chat(usr, "You haven't got any lenses in \the [src]");


/obj/item/clothing/glasses/attachable_lenses/proc/handle_insertion(obj/item/clothing/glasses/target, mob/living/carbon/human/inserter)
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
	if(origin_tech)
		target.origin_tech.Add(origin_tech)
	to_chat(inserter, "You attached \the [src] to \the [target]")
	target.have_lenses = src
	inserter.drop_item(src)
	forceMove(target)

/obj/item/clothing/glasses/attachable_lenses/explosive
	name = "Explosive lenses"
	desc = "lenses for glasses, these ones explode when someone wears goggles containing them. Awful."
	icon_state = "thermal_lens"
	vision_flags = FALSE
	flash_protection = FALSE
	origin_tech = list(TECH_COVERT = 3, TECH_COMBAT = 2 , TECH_ENGINEERING = 5)
	var/charge_exploded = FALSE

/obj/item/clothing/glasses/attachable_lenses/explosive/handle_insertion(obj/item/clothing/glasses/target, mob/living/carbon/human/inserter)
	..()
	RegisterSignal(target, COMSIG_CLOTH_EQUIPPED, .proc/handle_boom)
	RegisterSignal(target, COMSIG_GLASS_LENSES_REMOVED, .proc/handle_removal)

/obj/item/clothing/glasses/attachable_lenses/explosive/proc/handle_boom(mob/living/carbon/human/unfortunate_man)
	visible_message(SPAN_DANGER("You feel a jet of molten slag pierce your skull as \the [loc] explodes"),
	SPAN_DANGER("[unfortunate_man]'s skull is blown apart as a jet of molten slag pierces through his eye from
[loc]"), SPAN_DANGER("You hear a small explosion than the violent fizzle of flesh"))
	playsound()
	unfortunate_man.adjustBrainLoss(200)
	for(var/obj/organ/internal/organ in unfortunate_man.head)
		organ.take_damage(200)
	// F
	handle_removal()

/obj/item/clothing/glasses/attachable_lenses/explosive/proc/handle_removal()
	var/obj/item/clothing/glasses/current_loc = loc
	UnregisterSignal(current_loc, COMSIG_CLOTH_EQUIPPED)
	UnregisterSignal(current_loc, COMSIG_GLASS_LENSES_REMOVED)




