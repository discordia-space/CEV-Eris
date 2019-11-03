/obj/item/organ/internal/xenos/eggsac
	name = "egg sac"
	parent_organ = BP_GROIN
	icon_state = "xgibmid1"
	organ_tag = BP_EGG
	owner_verbs = list(
		/obj/item/organ/internal/xenos/eggsac/proc/lay_egg,
		/obj/item/organ/internal/xenos/eggsac/proc/xeno_infest
	)

/obj/item/organ/internal/xenos/eggsac/proc/lay_egg()
	set name = "Lay Egg (75)"
	set desc = "Lay an egg to produce huggers to impregnate prey with."
	set category = "Abilities"

	if(!config.aliens_allowed)
		to_chat(owner, "You begin to lay an egg, but hesitate. You suspect it isn't allowed.")
		//verbs -= /obj/item/organ/internal/xenos/eggsac/proc/lay_egg
		return

	var/turf/target = get_turf(src)
	if(locate(/obj/structure/alien/egg) in target)
		to_chat(owner, "There's already an egg here.")
		return

	if(check_alien_ability(75, TRUE))
		owner.visible_message("<span class='alium'><B>[owner] has laid an egg!</B></span>")
		new /obj/structure/alien/egg(target)

/obj/item/organ/internal/xenos/eggsac/proc/xeno_infest(mob/living/carbon/human/M as mob in oview(1, owner))
	set name = "Infest (500)"
	set desc = "Link a victim to the hivemind."
	set category = "Abilities"

	if(!M.Adjacent(owner))
		to_chat(owner, SPAN_WARNING("They are too far away."))
		return

	if(!M.mind)
		to_chat(owner, SPAN_WARNING("This mindless flesh adds nothing to the hive."))
		return

	if(M.species.get_bodytype() == "Xenomorph" || !isnull(M.internal_organs_by_name[BP_HIVE]))
		to_chat(owner, SPAN_WARNING("They are already part of the hive."))
		return

	var/obj/item/organ/affecting = M.get_organ(BP_CHEST)
	if(!affecting || BP_IS_ROBOTIC(affecting))
		to_chat(owner, SPAN_WARNING("This form is not compatible with our physiology."))
		return

	src.visible_message(
		SPAN_DANGER("\The [owner] crouches over \the [M], extending a hideous protuberance from its head!")
	)

	if(!do_mob(owner, M, 150))
		return

	//TODO: instead affecting.robotic use M.isSyntetic()
	if(M.species.get_bodytype() == "Xenomorph" || !isnull(M.internal_organs_by_name[BP_HIVE]) || !affecting || BP_IS_ROBOTIC(affecting))
		return

	if(!check_alien_ability(500, TRUE))
		return

	M.visible_message(
		SPAN_DANGER("\The [owner] regurgitates something into \the [M]'s torso!"),
		SPAN_DANGER("A hideous lump of alien mass strains your ribcage as it settles within!")
	)
	var/obj/item/organ/internal/xenos/hivenode/node = new(affecting)
	node.replaced(M, affecting)

