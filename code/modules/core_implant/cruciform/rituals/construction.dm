#define CRUCIFORM_TYPE obj/item/weapon/implant/core_implant/cruciform

/datum/ritual/cruciform/priest/construction
	name = "Manifestation"
	phrase = "Omnia autem quae arguuntur a lumine manifestantur omne enim quod manifestatur lumen est" //! todo: replace it
	desc = "Build things by faith"
	power = 40
	var/list/blueprints = list("Obelisk" = new /datum/nt_blueprint/machinery/obelisk())

/datum/ritual/cruciform/priest/construction/perform(mob/living/carbon/human/user, obj/item/weapon/implant/core_implant/C, list/targets)
	var/construction_key = input("Select construction", "") as null|anything in blueprints
	var/datum/nt_blueprint/blueprint = blueprints[construction_key]
	var/turf/target_turf = get_step(user,user.dir)
	if(!blueprint)
		fail("You decided not to test your faith.",user,C,targets)
		return
	if(!items_check(user, target_turf, blueprint))
		fail("Something is missing.",user,C,targets)
		return
	//TODO: add a nice overlay effect on turf
	user.visible_message(SPAN_NOTICE("You see as [user] passes his hands over something."),SPAN_NOTICE("You see things are moving as you concentrate on [blueprint.name] image"))
	if(!do_after(user, 5 SECONDS, target_turf))
		fail("You feel something is judging you upon your impatience",user,C,targets)
		return
	if(!items_check(user, target_turf, blueprint))
		fail("Something got stolen!",user,C,targets)
		return
	//magic has to be a bit innacurate

	for(var/item_type in blueprint.materials)
		var/t = locate(item_type) in target_turf.contents
		qdel(t)
		
	user.visible_message(SPAN_NOTICE("You hear a soft humming sound as [user] finishes his ritual."),SPAN_NOTICE("You take a deep breath as items finished forming your construction."))
	var/result_type = blueprint.result_type
	new result_type(target_turf) //haha very dynamic	

/datum/ritual/cruciform/priest/construction/proc/items_check(mob/user,turf/target, datum/nt_blueprint/blueprint)
	var/list/turf_contents = target.contents
	
	for(var/item_type in blueprint.materials)
		var/located_raw = locate(item_type) in turf_contents
		//single item check is handled there, rest of func is for stacked items or items with containers
		if(!located_raw)
			return FALSE

		var/required_amount = blueprint.materials[item_type]
        // I hope it is fast enough
        // could have initialized it in glob
		if(item_type in typesof(/obj/item/stack/material))
			var/obj/item/stack/material/material_stack = located_raw
			if(material_stack.amount < required_amount)
				return FALSE
			//todo: containers check. blood, aid-kits and such.
	return TRUE

/datum/nt_blueprint
	var/name
	var/result_type
	var/list/materials
//lets think about turf and object construction in future
/datum/nt_blueprint/machinery
/datum/nt_blueprint/machinery/obelisk
	name = "Obelisk"
	result_type = /obj/machinery/power/nt_obelisk
	materials = list(/obj/item/stack/material/plasteel = 10, /obj/item/stack/material/gold = 5, /CRUCIFORM_TYPE = 1)