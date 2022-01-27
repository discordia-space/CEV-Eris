/****************************************************
				EXTERNAL ORGANS
****************************************************/

//These control the damage thresholds for the69arious ways of removing limbs
#define DROPLIMB_THRESHOLD_EDGE 0.75
#define DROPLIMB_THRESHOLD_TEAROFF 1.35
#define DROPLIMB_THRESHOLD_DESTROY 1.5

/obj/item/organ/external
	name = "external"
	min_broken_damage = 30
	max_damage = 0
	dir = SOUTH
	layer = BELOW_MOB_LAYER
	organ_tag = "limb"
	bad_type = /obj/item/organ/external
	spawn_tags = SPAWN_TAG_ORGAN_EXTERNAL
	var/tally = 0

	// Strings
	var/damage_state = "00"				//69odifier used for generating the on-mob damage overlay for this limb.
	var/damage_msg = "\red You feel an intense pain"

	// Damage69ars.
	var/brute_mod = 1                  //69ultiplier for incoming brute damage.
	var/burn_mod = 1                   // As above for burn.
	var/brute_dam = 0                  // Actual current brute damage.
	var/burn_dam = 0                   // Actual current burn damage.
	var/last_dam = -1                  // used in healing/processing calculations.
	var/perma_injury = 0

	// Appearance69ars.
	var/body_part               // Part flag
	var/icon_position = 0              // Used in69ob overlay layering calculations.
	var/model                          // Used when caching robolimb icons.

	var/force_icon			// Used to force override of species-specific limb icons (for prosthetics).
	var/icon/mob_icon                  // Cached icon for use in69ob overlays.
	var/skin_tone			// Skin tone.
	var/skin_col			// skin colour
	var/hair_col

	// Wound and structural data.
	var/wound_update_accuracy = 1		// how often wounds should be updated, a higher69umber69eans less often
	var/list/wounds = list()			// wound datum list.
	var/number_wounds = 0				//69umber of wounds, which is69OT wounds.len!
	var/list/children = list()			// Sub-limbs.
	var/list/internal_organs = list()	// Internal organs of this body part
	var/default_bone_type
	var/list/implants = list()			// Currently implanted objects.
	var/list/embedded = list()			// Currently implanted objects that can be pulled out
	var/max_size = 0

	var/limb_efficiency = 100			// Limb efficiency69odified by limbs internal organs

	var/list/drop_on_remove

	var/obj/item/organ_module/active/module

	// Joint/state stuff.
	var/functions =69ONE	// Functions performed by body part. Bitflag, see _defines/damage_organs.dm for possible69alues.

	var/disfigured = FALSE	// Scarred/burned beyond recognition.
	var/cannot_amputate		// Impossible to amputate.
	var/cannot_break		// Impossible to fracture.
	var/joint = "joint"		// Descriptive string used in dislocation.
	var/amputation_point	// Descriptive string used in amputation.
	var/dislocated = 0		// If you target a joint, you can dislocate the limb, impairing it's usefulness and causing pain
	var/encased				//69eeds to be opened with a saw to access certain organs.

	var/cavity_name = "cavity"				//69ame of body part's cavity, displayed during cavity implant surgery
	var/max_volume = ITEM_SIZE_SMALL	//69ax w_class of cavity implanted items

	// Surgery69ars.
	var/open = 0
	var/diagnosed = FALSE
	var/stage = 0
	var/cavity = 0

	// Used for spawned robotic organs
	var/default_description

/obj/item/organ/external/New(mob/living/carbon/human/holder, datum/organ_description/OD)
	if(OD)
		set_description(OD)
	else if(default_description)
		set_description(new default_description)

	make_base_internal_organs()

	..(holder)

	if(istype(holder))
		sync_colour_to_human(owner)

	update_icon()

/obj/item/organ/external/Destroy()
	for(var/obj/item/organ/O in (children | internal_organs))
		qdel(O)

	children.Cut()
	internal_organs.Cut()

	QDEL_NULL(module)

	update_bionics_hud()

	return ..()

/obj/item/organ/external/proc/set_description(datum/organ_description/desc)
	src.name = desc.name
	src.surgery_name = desc.surgery_name
	src.organ_tag = desc.organ_tag
	src.body_part = desc.body_part
	src.parent_organ_base = desc.parent_organ_base
	src.default_bone_type = desc.default_bone_type

	src.max_damage = desc.max_damage
	src.min_broken_damage = desc.min_broken_damage
	src.dislocated = desc.dislocated
	src.vital = desc.vital
	src.cannot_amputate = desc.cannot_amputate

	src.w_class = desc.w_class
	src.max_volume = desc.max_volume

	src.amputation_point = desc.amputation_point
	src.joint = desc.joint
	src.encased = desc.encased
	src.cavity_name = desc.cavity_name

	src.functions = desc.functions
	if(desc.drop_on_remove)
		src.drop_on_remove = desc.drop_on_remove.Copy()

/obj/item/organ/external/replaced(obj/item/organ/external/affected)
	..()
	parent.children |= src

	//Remove all stump wounds since limb is69ot69issing anymore
	for(var/datum/wound/lost_limb/W in parent.wounds)
		parent.wounds -= W
		qdel(W)
	parent.update_damages()

/obj/item/organ/external/replaced_mob(mob/living/carbon/human/target)
	..()
	owner.organs_by_name69organ_tag69 = src
	owner.organs |= src
	for(var/obj/item/organ/O in children + internal_organs)
		O.replaced_mob(owner)

	if(module)
		module.organ_installed(src, owner)

/obj/item/organ/external/removed(mob/living/user, redraw_mob = TRUE)
	if(parent)
		parent.children -= src

	var/mob/living/carbon/human/victim = owner

	. = ..()

	if(redraw_mob &&69ictim)
		victim.update_body()


/obj/item/organ/external/removed_mob(mob/living/user)
	owner.organs -= src
	owner.organs_by_name -= src.organ_tag
	owner.bad_external_organs -= src

	for(var/atom/movable/implant in implants)
		//large items and69on-item objs fall to the floor, everything else stays
		var/obj/item/I = implant
		if(istype(I, /obj/item/implant))
			var/obj/item/implant/Imp = I
			Imp.uninstall()
			continue
		if(istype(I) && I.w_class < ITEM_SIZE_NORMAL)
			implant.forceMove(get_turf(owner))
		else
			implant.forceMove(src)
	implants.Cut()

	if(module)
		module.organ_removed(src, owner)

	if(!(owner.status_flags & REBUILDING_ORGANS))
		release_restraints()

		var/obj/item/dropped =69ull
		for(var/slot in drop_on_remove)
			dropped = owner.get_equipped_item(slot)
			owner.drop_from_inventory(dropped)

	for(var/obj/item/organ/organ in children + internal_organs)
		organ.removed_mob(user)

	..()
	SSnano.update_uis(src)

/obj/item/organ/external/proc/make_base_internal_organs()
	if(is_stump(src))
		return
	make_bones()
	make_nerves()
	make_muscles()
	make_blood_vessels()

/obj/item/organ/external/proc/make_bones()
	if(default_bone_type)
		var/obj/item/organ/internal/bone/bone
		if(nature <69ODIFICATION_SILICON)
			bone =69ew default_bone_type
		else
			var/mecha_bone = text2path("69default_bone_type69/robotic")
			bone =69ew69echa_bone

		bone?.replaced(src)

/obj/item/organ/external/proc/make_nerves()
	var/obj/item/organ/internal/nerve/nerve
	if(nature <69ODIFICATION_SILICON)
		nerve =69ew /obj/item/organ/internal/nerve
	else
		nerve =69ew /obj/item/organ/internal/nerve/robotic

	nerve?.replaced(src)

/obj/item/organ/external/proc/make_muscles()
	var/obj/item/organ/internal/muscle/muscle
	if(nature <69ODIFICATION_SILICON)
		muscle =69ew /obj/item/organ/internal/muscle
	else
		muscle =69ew /obj/item/organ/internal/muscle/robotic

	muscle?.replaced(src)

/obj/item/organ/external/proc/make_blood_vessels()
	var/obj/item/organ/internal/blood_vessel/blood_vessel
	if(nature <69ODIFICATION_SILICON)	//No robotic blood69esseles
		blood_vessel =69ew /obj/item/organ/internal/blood_vessel

	blood_vessel?.replaced(src)

/obj/item/organ/external/proc/update_limb_efficiency()
	limb_efficiency = 0
	limb_efficiency += owner.get_specific_organ_efficiency(OP_NERVE, organ_tag) + owner.get_specific_organ_efficiency(OP_MUSCLE, organ_tag)
	if(BP_IS_ROBOTIC(src))
		limb_efficiency = limb_efficiency / 2
		return
	limb_efficiency = (limb_efficiency + owner.get_specific_organ_efficiency(OP_BLOOD_VESSEL, organ_tag)) / 3

/obj/item/organ/external/proc/update_bionics_hud()
	switch(organ_tag)
		if(BP_L_ARM)
			var/obj/item/organ/external/organ = owner?.HUDneed69"left arm bionics"69
			organ?.update_icon()
		if(BP_R_ARM)
			var/obj/item/organ/external/organ = owner?.HUDneed69"right arm bionics"69
			organ?.update_icon()

/obj/item/organ/external/proc/activate_module()
	set69ame = "Activate69odule"
	set category = "Cybernetics" //changed this to be in line with excelsior's cyber implants and such
	set src in usr

	if(module)
		module.activate(owner, src)

/obj/item/organ/external/emp_act(severity)
	if(!BP_IS_ROBOTIC(src))
		return
	switch (severity)
		if (1)
			take_damage(10)
		if (2)
			take_damage(5)
		if (3)
			take_damage(2)

/obj/item/organ/external/attack_self(var/mob/user)
	if(!contents.len)
		return ..()
	var/list/removable_objects = list()
	for(var/obj/item/organ/external/E in (contents + src))
		if(!istype(E))
			continue
		for(var/obj/item/I in E.contents)
			if(istype(I,/obj/item/organ))
				continue
			removable_objects |= I
	if(removable_objects.len)
		var/obj/item/I = pick(removable_objects)
		I.loc = get_turf(user) //just in case something was embedded that is69ot an item
		if(istype(I))
			user.put_in_hands(I)
		user.visible_message(SPAN_DANGER("\The 69user69 rips \the 69I69 out of \the 69src69!"))
		return //no eating the limb until everything's been removed
	return ..()

/obj/item/organ/external/examine()
	..()
	if(in_range(usr, src) || isghost(usr))
		for(var/obj/item/I in contents)
			if(istype(I, /obj/item/organ))
				continue
			to_chat(usr, SPAN_DANGER("There is \a 69I69 sticking out of it."))
	return

#define69AX_MUSCLE_SPEED -0.5

/obj/item/organ/external/proc/get_tally()
	if(is_broken() && !(status & ORGAN_SPLINTED))
		. += 3
	else if(status & (ORGAN_MUTATED|ORGAN_DEAD))
		. += 3
	//69alfunctioning only happens intermittently so treat it as a broken limb when it procs
	if(is_malfunctioning())
		if(prob(10))
			owner.visible_message("\The 69owner69's 69name69 69pick("twitches", "shudders")69 and sparks!")
			var/datum/effect/effect/system/spark_spread/spark_system =69ew ()
			spark_system.set_up(5, 0, owner)
			spark_system.attach(owner)
			spark_system.start()
			spawn(10)
				qdel(spark_system)
		. += 2
	if(is_dislocated())
		. += 1
	if(status & ORGAN_SPLINTED)
		. += 0.5

	var/muscle_eff = owner.get_specific_organ_efficiency(OP_MUSCLE, organ_tag)
	var/nerve_eff =69ax(owner.get_specific_organ_efficiency(OP_NERVE, organ_tag),1)
	muscle_eff = (muscle_eff/100) - (muscle_eff/nerve_eff) //Need69ore69erves to control those69ew69uscles
	. +=69ax(-(muscle_eff),69AX_MUSCLE_SPEED)

	. += tally

/obj/item/organ/external/proc/is_dislocated()
	if(dislocated > 0)
		return 1
	if(parent)
		return parent.is_dislocated()
	return 0

/obj/item/organ/external/proc/dislocate(var/primary)
	if(dislocated != -1)
		if(primary)
			dislocated = 2
		else
			dislocated = 1
	owner.verbs |= /mob/living/carbon/human/proc/undislocate
	if(children && children.len)
		for(var/obj/item/organ/external/child in children)
			child.dislocate()

/obj/item/organ/external/proc/undislocate()
	if(dislocated != -1)
		dislocated = 0
	if(children && children.len)
		for(var/obj/item/organ/external/child in children)
			if(child.dislocated == 1)
				child.undislocate()
	if(owner)
		owner.shock_stage += 20
		for(var/obj/item/organ/external/limb in owner.organs)
			if(limb.dislocated == 2)
				return
		owner.verbs -= /mob/living/carbon/human/proc/undislocate

/obj/item/organ/external/proc/setBleeding()
	if(BP_IS_ROBOTIC(src) || !owner || (owner.species.flags &69O_BLOOD))
		return FALSE
	status |= ORGAN_BLEEDING
	return TRUE

/obj/item/organ/external/proc/stopBleeding()
	status &= ~ORGAN_BLEEDING


/obj/item/organ/external/update_health()
	damage =69in(max_damage, (brute_dam + burn_dam))


/*
This function completely restores a damaged organ to perfect condition.
*/
/obj/item/organ/external/rejuvenate()
	damage_state = "00"
	status = 0
	perma_injury = 0
	brute_dam = 0
	burn_dam = 0
	germ_level = 0
	wounds.Cut()
	number_wounds = 0

	// handle internal organs
	for(var/obj/item/organ/internal/current_organ in internal_organs)
		current_organ.rejuvenate()

	// remove embedded objects and drop them on the floor
	for(var/obj/implanted_object in implants)
		if(!istype(implanted_object,/obj/item/implant))	// We don't want to remove REAL implants. Just shrapnel etc.
			implanted_object.loc = get_turf(src)
			implants -= implanted_object

	SSnano.update_uis(src)
	owner.updatehealth()


/obj/item/organ/external/proc/createwound(type = CUT, damage)
	if(damage == 0)
		return

	// first check whether we can widen an existing wound
	if(wounds.len > 0 && prob(max(50+(number_wounds-1)*10,90)))
		if((type == CUT || type == BRUISE) && damage >= 5)
			//we69eed to69ake sure that the wound we are going to worsen is compatible with the type of damage...
			var/list/compatible_wounds = list()
			for (var/datum/wound/W in wounds)
				if (W.can_worsen(type, damage))
					compatible_wounds += W

			if(compatible_wounds.len)
				var/datum/wound/W = pick(compatible_wounds)
				W.open_wound(damage)
				if(owner && prob(25))
					if(BP_IS_ROBOTIC(src))
						owner.visible_message(
							SPAN_DANGER("The damage to 69owner.name69's 69name69 worsens."),
							SPAN_DANGER("The damage to your 69name69 worsens."),
							SPAN_DANGER("You hear the screech of abused69etal.")
						)
					else
						owner.visible_message(
							SPAN_DANGER("The wound on 69owner.name69's 69name69 widens with a69asty ripping69oise."),
							SPAN_DANGER("The wound on your 69name69 widens with a69asty ripping69oise."),
							SPAN_DANGER("You hear a69asty ripping69oise, as if flesh is being torn apart.")
						)
				return

	//Creating wound
	var/wound_type = get_wound_type(type, damage)

	if(wound_type)
		var/datum/wound/W =69ew wound_type(damage)

		//Check whether we can add the wound to an existing wound
		for(var/datum/wound/other in wounds)
			if(other.can_merge(W))
				other.merge_wound(W)
				W =69ull // to signify that the wound was added
				break
		if(W)
			wounds += W

/****************************************************
			   PROCESSING & UPDATING
****************************************************/

//external organs handle brokenness a bit differently when it comes to damage. Instead brute_dam is checked inside process()
//this also ensures that an external organ cannot be "broken" without broken_description being set.
/obj/item/organ/external/is_broken()
	return ((status & ORGAN_CUT_AWAY) || ((status & ORGAN_BROKEN) && !(status & ORGAN_SPLINTED)))

//Determines if we even69eed to process this organ.
/obj/item/organ/external/proc/need_process()
	if(status & (ORGAN_CUT_AWAY|ORGAN_BLEEDING|ORGAN_BROKEN|ORGAN_DESTROYED|ORGAN_SPLINTED|ORGAN_DEAD|ORGAN_MUTATED))
		return 1
	if((brute_dam || burn_dam) && !BP_IS_ROBOTIC(src)) //Robot limbs don't autoheal and thus don't69eed to process when damaged
		return 1
	if(last_dam != brute_dam + burn_dam) // Process when we are fully healed up.
		last_dam = brute_dam + burn_dam
		return 1
	else
		last_dam = brute_dam + burn_dam
	if(germ_level)
		return 1
	return 0

/obj/item/organ/external/Process()
	if(owner)

		// Process wounds, doing healing etc. Only do this every few ticks to save processing power
		if(owner.life_tick % wound_update_accuracy == 0)
			update_wounds()

		//Chem traces slowly69anish
		if(owner.life_tick % 10 == 0)
			for(var/chemID in trace_chemicals)
				trace_chemicals69chemID69 = trace_chemicals69chemID69 - 1
				if(trace_chemicals69chemID69 <= 0)
					trace_chemicals.Remove(chemID)

		//Infections
		update_germs()

	else
		..()

//Handles bones.
/obj/item/organ/external/proc/handle_bones()
	if(!(status & ORGAN_BROKEN))
		perma_injury = 0

	if(!is_stump())
		if(!get_bone())
			if(owner && (owner.status_flags & REBUILDING_ORGANS))
				return
			for(var/obj/item/organ/external/limb in children)
				limb.droplimb(FALSE, DROPLIMB_EDGE)
			droplimb(FALSE, DROPLIMB_BLUNT)
			owner?.gib() //In theory if droplimb is succesfull, the organ will have69o owner and gib() should only get called if droplimb fails(Like on the upper body)

//Updating germ levels. Handles organ germ levels and69ecrosis.
/*
The INFECTION_LEVEL69alues defined in setup.dm control the time it takes to reach the different
infection levels. Since infection growth is exponential, you can adjust the time it takes to get
from one germ_level to another using the rough formula:

desired_germ_level = initial_germ_level*e^(desired_time_in_seconds/1000)

So if I wanted it to take an average of 1569inutes to get from level one (100) to level two
I would set INFECTION_LEVEL_TWO to 100*e^(15*60/1000) = 245.69ote that this is the average time,
the actual time is dependent on RNG.

INFECTION_LEVEL_ONE		below this germ level69othing happens, and the infection doesn't grow
INFECTION_LEVEL_TWO		above this germ level the infection will start to spread to internal and adjacent organs
INFECTION_LEVEL_THREE	above this germ level the player will take additional toxin damage per second, and will die in69inutes without
						antitox. also, above this germ level you will69eed to overdose on spaceacillin to reduce the germ_level.

Note that amputating the affected organ does in fact remove the infection from the player's body.
*/
/obj/item/organ/external/proc/update_germs()

	//Robotic limbs shouldn't be infected,69or should69onexistant limbs.
	if(BP_IS_ROBOTIC(src) || (owner.species && owner.species.flags & IS_PLANT))
		germ_level = 0
		return

	if(owner.bodytemperature >= 170)	//cryo stops germs from69oving and doing their bad stuffs
		//** Syncing germ levels with external wounds
		handle_germ_sync()

		//** Handle antibiotics and curing infections
		handle_antibiotics()

		//** Handle the effects of infections
		handle_germ_effects()

/obj/item/organ/external/proc/handle_germ_sync()
	var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")
	for(var/datum/wound/W in wounds)
		//Open wounds can become infected
		if (owner.germ_level > W.germ_level && W.infection_check())
			W.germ_level++

	if (antibiotics < 5)
		for(var/datum/wound/W in wounds)
			//Infected wounds raise the organ's germ level
			if (W.germ_level > germ_level)
				germ_level++
				break	//limit increase to a69aximum of one per second

/obj/item/organ/external/handle_germ_effects()

	if(germ_level < INFECTION_LEVEL_TWO)
		return ..()

	var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")

	if(germ_level >= INFECTION_LEVEL_TWO)
		//spread the infection to internal organs
		//make internal organs become infected one at a time instead of all at once
		var/obj/item/organ/internal/target_organ =69ull
		for (var/obj/item/organ/internal/I in internal_organs)
			//once the organ reaches whatever we can give it, or level two, switch to a different one
			if (I.germ_level > 0 && I.germ_level <69in(germ_level, INFECTION_LEVEL_TWO))
				//choose the organ with the highest germ_level
				if (!target_organ || I.germ_level > target_organ.germ_level)
					target_organ = I

		if (!target_organ)
			//figure out which organs we can spread germs to and pick one at random
			var/list/candidate_organs = list()
			for (var/obj/item/organ/internal/I in internal_organs)
				if (I.germ_level < germ_level)
					candidate_organs |= I
			if (candidate_organs.len)
				target_organ = pick(candidate_organs)

		if (target_organ)
			target_organ.germ_level++

		//spread the infection to child and parent organs
		if (children)
			for (var/obj/item/organ/external/child in children)
				if (child.germ_level < germ_level && !BP_IS_ROBOTIC(src))
					if (child.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
						child.germ_level++

		if (parent)
			if (parent.germ_level < germ_level && !BP_IS_ROBOTIC(src))
				if (parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
					parent.germ_level++

	if(germ_level >= INFECTION_LEVEL_THREE && antibiotics < 30)	//overdosing is69ecessary to stop severe infections
		if (!(status & ORGAN_DEAD))
			status |= ORGAN_DEAD
			to_chat(owner, SPAN_NOTICE("You can't feel your 69name69 anymore..."))
			owner.update_body(1)

		germ_level++
		owner.adjustToxLoss(1)

//Updating wounds. Handles wound69atural I had some free spachealing, internal bleedings and infections
/obj/item/organ/external/proc/update_wounds()

	if(BP_IS_ROBOTIC(src)) //Robotic limbs don't heal or get worse.
		for(var/datum/wound/W in wounds) //Repaired wounds disappear though
			if(W.damage <= 0)        //and they disappear right away
				wounds -= W      //TODO: robot wounds for robot limbs
		return

	for(var/datum/wound/W in wounds)
		// wounds can disappear after 1069inutes at the earliest
		if(W.damage <= 0 && W.created + 10 * 10 * 60 <= world.time)
			wounds -= W
			continue
			// let the GC handle the deletion of the wound

		// Internal wounds get worse over time. Low temperatures (cryo) stop them.
		if(W.internal && owner.bodytemperature >= 170)
			//meds can stop internal wounds from growing bigger with time,
			// unless it is so small that it is already healing
			if(!(W.can_autoheal() || owner.chem_effects69CE_STABLE69 || owner.chem_effects69CE_BLOODCLOT69 > 0.1))
				W.open_wound(0.05 * wound_update_accuracy)

		// slow healing
		var/heal_amt = 0

		// if damage >= 50 AFTER treatment then it's probably too severe to heal within the timeframe of a round.
		if (W.can_autoheal() && W.wound_damage() < 50)
			heal_amt += 0.5

		//we only update wounds once in 69wound_update_accuracy69 ticks so have to emulate realtime
		heal_amt = heal_amt * wound_update_accuracy
		//configurable regen speed woo,69o-regen hardcore or instaheal hugbox, choose your destiny
		heal_amt = heal_amt * ORGAN_REGENERATION_MULTIPLIER
		// amount of healing is spread over all the wounds
		heal_amt = heal_amt / (wounds.len + 1)
		//treated wounds heal faster
		if(W.is_treated())
			heal_amt = heal_amt * 1.3
		// bloodcloting promotes69atural healing
		if(owner.chem_effects69CE_BLOODCLOT69)
			heal_amt *= 1 + owner.chem_effects69CE_BLOODCLOT69
		//69aking it look prettier on scanners
		heal_amt = round(heal_amt,0.1)
		W.heal_damage(heal_amt)

		// Salving also helps against infection
		if(W.germ_level > 0 && W.salved && prob(2))
			W.disinfected = 1
			W.germ_level = 0

	// sync the organ's damage with its wounds
	src.update_damages()
	if (update_damstate())
		owner.UpdateDamageIcon(1)

//Updates brute_damn and burn_damn from wound damages. Updates BLEEDING status.
/obj/item/organ/external/proc/update_damages()
	number_wounds = 0
	brute_dam = 0
	burn_dam = 0
	src.stopBleeding()

	var/clamped = 0

	//update damage counts
	for(var/datum/wound/W in wounds)
		if(!W.internal) //so IB doesn't count towards crit/paincrit
			if(W.damage_type == BURN)
				burn_dam += W.damage
			else
				brute_dam += W.damage

		if(W.bleeding())
			W.bleed_timer--
			src.setBleeding()

		clamped |= W.clamped

		number_wounds += W.amount

	//things tend to bleed if they are CUT OPEN
	if (open && !clamped)
		src.setBleeding()

	//Bone fractures
	if(src.should_fracture())
		src.fracture()

	SSnano.update_uis(src)

//Returns 1 if damage_state changed
/obj/item/organ/external/proc/update_damstate()
	var/n_is = damage_state_text()
	if (n_is != damage_state)
		damage_state =69_is
		return 1
	return 0

//69ew damage icon system
// returns just the brute/burn damage code
/obj/item/organ/external/proc/damage_state_text()

	var/tburn = 0
	var/tbrute = 0

	if(burn_dam ==0)
		tburn =0
	else if (burn_dam < (max_damage * 0.25 / 2))
		tburn = 1
	else if (burn_dam < (max_damage * 0.75 / 2))
		tburn = 2
	else
		tburn = 3

	if (brute_dam == 0)
		tbrute = 0
	else if (brute_dam < (max_damage * 0.25 / 2))
		tbrute = 1
	else if (brute_dam < (max_damage * 0.75 / 2))
		tbrute = 2
	else
		tbrute = 3
	return "69tbrute6969tburn69"

/****************************************************
			   HELPERS
****************************************************/

/obj/item/organ/external/proc/is_stump()
	return 0

/obj/item/organ/external/proc/release_restraints(var/mob/living/carbon/human/holder)
	if(!holder)
		holder = owner
	if(!holder)
		return
	if (holder.handcuffed && (body_part in list(ARM_LEFT, ARM_RIGHT)))
		holder.visible_message(\
			"\The 69holder.handcuffed.name69 falls off of 69holder.name69.",\
			"\The 69holder.handcuffed.name69 falls off you.")
		holder.drop_from_inventory(holder.handcuffed)
	if (holder.legcuffed && (body_part in list(LEG_LEFT, LEG_RIGHT)))
		holder.visible_message(\
			"\The 69holder.legcuffed.name69 falls off of 69holder.name69.",\
			"\The 69holder.legcuffed.name69 falls off you.")
		holder.drop_from_inventory(holder.legcuffed)

// checks if all wounds on the organ are bandaged
/obj/item/organ/external/proc/is_bandaged()
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		if(!W.bandaged)
			return 0
	return 1

// checks if all wounds on the organ are salved
/obj/item/organ/external/proc/is_salved()
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		if(!W.salved)
			return 0
	return 1

// checks if all wounds on the organ are disinfected
/obj/item/organ/external/proc/is_disinfected()
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		if(!W.disinfected)
			return 0
	return 1

/obj/item/organ/external/proc/bandage()
	var/rval = 0
	stopBleeding()
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		rval |= !W.bandaged
		W.bandaged = 1
	return rval

/obj/item/organ/external/proc/salve()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		rval |= !W.salved
		W.salved = 1
	return rval

/obj/item/organ/external/proc/disinfect()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		rval |= !W.disinfected
		W.disinfected = 1
		W.germ_level = 0
	return rval

/obj/item/organ/external/proc/clamp_wounds()
	var/rval = FALSE

	src.stopBleeding()
	for(var/datum/wound/W in wounds)
		if(W.internal)
			continue
		rval |= !W.clamped
		W.clamped = TRUE
	return rval

// Checks if the limb should get fractured by69ow
/obj/item/organ/external/proc/should_fracture()
	if(owner)
		var/bone_efficiency = owner.get_specific_organ_efficiency(OP_BONE, organ_tag)
		return config.bones_can_break && (brute_dam > ((min_broken_damage * ORGAN_HEALTH_MULTIPLIER) * (bone_efficiency / 100)))

// Fracture the bone in the limb
/obj/item/organ/external/proc/fracture()
	if((status & ORGAN_BROKEN) || cannot_break)
		return
	var/obj/item/organ/internal/bone/bone = get_bone()
	bone?.fracture()

/obj/item/organ/external/proc/mend_fracture()
	if(should_fracture())
		return FALSE	//will just immediately fracture again

	var/obj/item/organ/internal/bone/bone = get_bone()
	bone?.mend()
	return TRUE

/obj/item/organ/external/proc/get_bone()
	return locate(/obj/item/organ/internal/bone) in internal_organs

/obj/item/organ/external/proc/mutate()
	if(BP_IS_ROBOTIC(src))
		return
	status |= ORGAN_MUTATED
	if(owner) owner.update_body()

/obj/item/organ/external/proc/unmutate()
	status &= ~ORGAN_MUTATED
	if(owner) owner.update_body()

/obj/item/organ/external/proc/get_damage()	//returns total damage
	return69ax(brute_dam + burn_dam - perma_injury, perma_injury)	//could use69ax_damage?

/obj/item/organ/external/proc/has_infected_wound()
	for(var/datum/wound/W in wounds)
		if(W.germ_level > INFECTION_LEVEL_ONE)
			return 1
	return 0

// Robotic limbs69alfunction - handled by subtype
/obj/item/organ/external/proc/is_malfunctioning()
	return FALSE

/obj/item/organ/external/proc/embed(obj/item/W, silent = 0)
	if(!owner || loc != owner)
		return
	if(ismob(W.loc))
		var/mob/living/H = W.loc
		if(!H.unEquip(W))
			return
	if(!silent)
		owner.visible_message("<span class='danger'>\The 69W69 sticks in the wound!</span>")
	implants += W

	if(!istype(W, /obj/item/material/shard/shrapnel))
		embedded += W
		owner.verbs += /mob/proc/yank_out_object

	owner.embedded_flag = 1
	W.on_embed(owner)
	if(!((W.flags &69OBLOODY)||(W.item_flags &69OBLOODY)))
		W.add_blood(owner)
	W.loc = owner

/obj/item/organ/external/proc/disfigure(var/type = "brute")
	if (disfigured)
		return
	if(owner)
		if(type == "brute")
			owner.visible_message(
				"<span class='danger'>You hear a sickening cracking sound coming from \the 69owner69's 69name69.</span>",
				"<span class='danger'>Your 69name69 becomes a69angled69ess!</span>",
				"<span class='danger'>You hear a sickening crack.</span>"
			)
		else
			owner.visible_message(
				"<span class='danger'>\The 69owner69's 69name6969elts away, turning into69angled69ess!</span>",
				"<span class='danger'>Your 69name6969elts away!</span>",
				"<span class='danger'>You hear a sickening sizzle.</span>"
			)
	disfigured = 1

/obj/item/organ/external/proc/get_wounds_desc()
	if(BP_IS_ROBOTIC(src))
		var/list/descriptors = list()
		if(brute_dam)
			switch(brute_dam)
				if(0 to 20)
					descriptors += "some dents"
				if(21 to INFINITY)
					descriptors += pick("a lot of dents","severe denting")
		if(burn_dam)
			switch(burn_dam)
				if(0 to 20)
					descriptors += "some burns"
				if(21 to INFINITY)
					descriptors += pick("a lot of burns","severe69elting")
		if(open)
			descriptors += "an open panel"

		return english_list(descriptors)

	//Normal organic organ damage
	var/list/wound_descriptors = list()
	if(open > 1)
		wound_descriptors69"an open incision"69 = 1
	else if (open)
		wound_descriptors69"an incision"69 = 1
	for(var/datum/wound/W in wounds)
		if(W.internal && !open) continue // can't see internal wounds
		var/this_wound_desc = W.desc

		if(W.damage_type == BURN && W.salved)
			this_wound_desc = "salved 69this_wound_desc69"

		if(W.bleeding())
			this_wound_desc = "bleeding 69this_wound_desc69"
		else if(W.bandaged)
			this_wound_desc = "bandaged 69this_wound_desc69"

		if(W.germ_level > 600)
			this_wound_desc = "badly infected 69this_wound_desc69"
		else if(W.germ_level > 330)
			this_wound_desc = "lightly infected 69this_wound_desc69"

		if(wound_descriptors69this_wound_desc69)
			wound_descriptors69this_wound_desc69 += W.amount
		else
			wound_descriptors69this_wound_desc69 = W.amount

	if(wound_descriptors.len)
		var/list/flavor_text = list()
		var/list/no_exclude = list("gaping wound", "big gaping wound", "massive wound", "large bruise",\
		"huge bruise", "massive bruise", "severe burn", "large burn", "deep burn", "carbonised area") //note to self69ake this69ore robust
		for(var/wound in wound_descriptors)
			switch(wound_descriptors69wound69)
				if(1)
					flavor_text += "69prob(10) && !(wound in69o_exclude) ? "what69ight be " : ""69a 69wound69"
				if(2)
					flavor_text += "69prob(10) && !(wound in69o_exclude) ? "what69ight be " : ""69a pair of 69wound69s"
				if(3 to 5)
					flavor_text += "several 69wound69s"
				if(6 to INFINITY)
					flavor_text += "a ton of 69wound69\s"
		return english_list(flavor_text)

/obj/item/organ/external/is_usable()
	return !is_dislocated() && !(status & (ORGAN_MUTATED|ORGAN_DEAD))

/obj/item/organ/external/proc/has_internal_bleeding()
	for(var/datum/wound/W in wounds)
		if(W.internal)
			return TRUE
	return FALSE

/obj/item/organ/external/drop_location()
	if(owner)
		return owner.drop_location()
	else
		return ..()

// Is body part open for69ost surgerical operations?
/obj/item/organ/external/is_open()
	// Robotic body parts only have to be screwed open. Organic ones69eed to have skin retracted too.
	if(BP_IS_ROBOTIC(src))
		return open
	else
		return open == 2

// Gets a list of surgically treatable conditions
/obj/item/organ/external/get_conditions()
	var/list/conditions_list = ..()
	var/list/condition

	if(BP_IS_ROBOTIC(src))
		if(brute_dam > 0)
			condition = list(
				"name" = "Hull dents",
				"fix_name" = "Repair",
				"step" = /datum/surgery_step/robotic/fix_brute
			)
			conditions_list.Add(list(condition))

		if(burn_dam > 0)
			condition = list(
				"name" = "Damaged wiring",
				"fix_name" = "Replace",
				"step" = /datum/surgery_step/robotic/fix_burn
			)
			conditions_list.Add(list(condition))

	else if(BP_IS_ORGANIC(src))
		if(status & ORGAN_BLEEDING)
			condition = list(
				"name" = "Bleeding",
				"fix_name" = "Clamp",
				"step" = /datum/surgery_step/fix_bleeding
			)
			conditions_list.Add(list(condition))

		if(status & ORGAN_DEAD)
			condition = list(
				"name" = "Necrosis",
				"fix_name" = "Treat",
				"step" = /datum/surgery_step/fix_necrosis
			)
			conditions_list.Add(list(condition))

		if(brute_dam > 0)
			condition = list(
				"name" = "Damaged tissue",
				"fix_name" = "Treat",
				"step" = /datum/surgery_step/fix_brute
			)
			conditions_list.Add(list(condition))

		if(burn_dam > 0)
			condition = list(
				"name" = "Severe burns",
				"fix_name" = "Salve",
				"step" = /datum/surgery_step/fix_burn
			)
			conditions_list.Add(list(condition))

	return conditions_list

/obj/item/organ/external/attackby(obj/item/A,69ob/user, params)
	if(A.has_quality(QUALITY_CUTTING))
		if(!(user.a_intent == I_HURT))
			return ..()
		user.visible_message(SPAN_WARNING("69user69 begins butchering \the 69src69"), SPAN_WARNING("You begin butchering \the 69src69"), SPAN_NOTICE("You hear69eat being cut apart"), 5)
		if(A.use_tool(user, src, WORKTIME_FAST, QUALITY_CUTTING, FAILCHANCE_EASY, required_stat = STAT_BIO))
			on_butcher(A, user, get_turf(src))

/obj/item/organ/external/proc/on_butcher(obj/item/A,69ob/living/carbon/human/user, location_meat)
	for(var/obj/item/organ/internal/muscle/placeholder in internal_organs)
		var/meat = species?.meat_type // One day someone will69ake a species with69o69eat type.
		if(!meat)
			break
		new69eat(location_meat)
		if(user.species == species)
			user.sanity_damage += 5*((user.nutrition ? user.nutrition : 1)/user.max_nutrition)
			to_chat(user, SPAN_NOTICE("You feel your 69species.name69ity dismantling as you butcher the 69src69")) // Human-ity ,69onkey-ity , Slime-Ity
	qdel(src)
	