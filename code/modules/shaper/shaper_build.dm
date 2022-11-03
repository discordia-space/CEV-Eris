#define CRUCIFORM_TYPE obj/item/implant/core_implant/cruciform

GLOBAL_LIST_INIT(shaper_blueprints, init_shaper_blueprints())

/proc/init_nt_blueprints()
	var/list/list = list()
	for(var/blueprint_type in typesof(/datum/nt_blueprint))
		if(blueprint_type == /datum/nt_blueprint)
			continue
		if(blueprint_type == /datum/nt_blueprint/machinery)
			continue
		var/datum/nt_blueprint/pb = new blueprint_type()
		list[pb.name] = pb
	return list

/datum/ritual/cruciform/priest/acolyte/blueprint_check
	name = "Divine Guidance"
	phrase = "Dirige me in veritate tua, et doce me, quia tu es Deus salvator meus, et te sustinui tota die."
	desc = "Building needs mainly faith but resources as well. Find out what it takes."
	power = 5

/datum/ritual/cruciform/priest/acolyte/blueprint_check/perform(mob/living/carbon/human/user, obj/item/implant/core_implant/C, list/targets)
	var/construction_key = input("Select construction", "") as null|anything in GLOB.nt_blueprints
	var/datum/nt_blueprint/blueprint = GLOB.nt_blueprints[construction_key]
	var/list/listed_components = list()
	for(var/requirement in blueprint.materials)
		var/atom/placeholder = requirement
		if(!ispath(placeholder))
			continue
		listed_components += list("[blueprint.materials[placeholder]] [initial(placeholder.name)]")
	to_chat(user, SPAN_NOTICE("[blueprint.name] requires: [english_list(listed_components)]."))

/datum/ritual/cruciform/priest/acolyte/construction
	name = "Manifestation"
	phrase = "Omnia autem quae arguuntur a lumine manifestantur omne enim quod manifestatur lumen est."
	desc = "Build and expand. Shape your faith in something more sensible."
	power = 40

/datum/ritual/cruciform/priest/acolyte/construction/perform(mob/living/carbon/human/user, obj/item/implant/core_implant/C, list/targets)
	var/construction_key = input("Select construction", "") as null|anything in GLOB.nt_blueprints
	var/datum/nt_blueprint/blueprint = GLOB.nt_blueprints[construction_key]
	var/turf/target_turf = get_step(user,user.dir)
	if(!blueprint)
		fail("You decided not to test your faith.",user,C,targets)
		return
	if(!items_check(user, target_turf, blueprint))
		fail("Something is missing.",user,C,targets)
		return

	user.visible_message(SPAN_NOTICE("You see as [user] passes his hands over something."),SPAN_NOTICE("You see your faith take physical form as you concentrate on [blueprint.name] image"))

	var/obj/effect/overlay/nt_construction/effect = new(target_turf, blueprint.build_time)

	if(!do_after(user, blueprint.build_time, target_turf))
		fail("You feel something is judging you upon your impatience",user,C,targets)
		effect.failure()
		return
	if(!items_check(user, target_turf, blueprint))
		fail("Something got stolen!",user,C,targets)
		effect.failure()
		return
	//magic has to be a bit innacurate

	for(var/item_type in blueprint.materials)
		var/t = locate(item_type) in target_turf.contents
		if(istype(t, /obj/item/stack))
			var/obj/item/stack/S = t
			S.use(blueprint.materials[item_type])
		else
			qdel(t)

	effect.success()
	user.visible_message(SPAN_NOTICE("You hear a soft humming sound as [user] finishes his ritual."),SPAN_NOTICE("You take a deep breath as the divine manifestation finishes."))
	var/build_path = blueprint.build_path
	new build_path(target_turf)


/datum/ritual/cruciform/priest/acolyte/construction/proc/items_check(mob/user,turf/target, datum/nt_blueprint/blueprint)
	var/list/turf_contents = target.contents

	for(var/item_type in blueprint.materials)
		var/located_raw = locate(item_type) in turf_contents
		//single item check is handled there, rest of func is for stacked items or items with containers
		if(!located_raw)
			return FALSE

		var/required_amount = blueprint.materials[item_type]
        // I hope it is fast enough
        // could have initialized it in glob
		if(item_type in typesof(/obj/item/stack/))
			var/obj/item/stack/stacked = located_raw
			if(stacked.amount < required_amount)
				return FALSE
	return TRUE
