/****************************************************
				EXTERNAL ORGANS
****************************************************/

//These control the damage thresholds for the various ways of removing limbs
#define DROPLIMB_THRESHOLD_EDGE 2
#define DROPLIMB_THRESHOLD_TEAROFF 2.25
#define DROPLIMB_THRESHOLD_DESTROY 2.5

/obj/item/organ/external
	name = "external"
	min_broken_damage = 40
	max_damage = 0
	dir = SOUTH
	layer = BELOW_MOB_LAYER
	organ_tag = "limb"
	bad_type = /obj/item/organ/external
	spawn_tags = SPAWN_TAG_ORGAN_EXTERNAL
	var/tally = 0

	// Strings
	var/damage_state = "00"				// Modifier used for generating the on-mob damage overlay for this limb.
	var/damage_msg = "\red You feel an intense pain"

	// Damage vars.
	var/brute_mod = 1                  // Multiplier for incoming brute damage.
	var/burn_mod = 1                   // As above for burn.
	var/brute_dam = 0                  // Actual current brute damage.
	var/burn_dam = 0                   // Actual current burn damage.
	var/last_dam = -1                  // used in healing/processing calculations.
	var/perma_injury = 0

	// Appearance vars.
	var/body_part               // Part flag
	var/icon_position = 0              // Used in mob overlay layering calculations.
	var/model                          // Used when caching robolimb icons.

	var/force_icon			// Used to force override of species-specific limb icons (for prosthetics).
	var/icon/mob_icon                  // Cached icon for use in mob overlays.
	var/skin_tone			// Skin tone.
	var/skin_col			// skin colour
	var/hair_col

	// Wound and structural data.
	var/wound_update_accuracy = 1		// how often wounds should be updated, a higher number means less often
	var/list/wounds = list()			// External wound datum list.
	var/number_wounds = 0				// Number of external wounds, which is NOT wounds.len!
	var/number_internal_wounds = 0		// Number of internal wounds
	var/severity_internal_wounds = 0	// Total damage from internal wounds
	var/total_internal_health = 0		// Total max health of internal organs
	var/internal_wound_hal_dam = 0		// Total pain from internal wounds
	var/list/children = list()			// Sub-limbs.
	var/list/internal_organs = list()	// Internal organs of this body part
	var/default_bone_type
	var/list/implants = list()			// Currently implanted objects.
	var/list/embedded = list()			// Currently implanted objects that can be pulled out
	var/max_size = 0

	var/limb_efficiency = 100			// Limb efficiency modified by limbs internal organs

	var/list/drop_on_remove

	var/obj/item/organ_module/active/module

	// Joint/state stuff.
	var/functions = NONE	// Functions performed by body part. Bitflag, see _defines/damage_organs.dm for possible values.

	var/disfigured = FALSE	// Scarred/burned beyond recognition.
	var/cannot_amputate		// Impossible to amputate.
	var/cannot_break		// Impossible to fracture.
	var/joint = "joint"		// Descriptive string used in dislocation.
	var/amputation_point	// Descriptive string used in amputation.
	var/nerve_struck = 0	// If you target a joint, you can strike the limb's nerve, impairing it's usefulness and causing pain for 10 seconds
	var/encased				// Needs to be opened with a saw to access certain organs.

	var/cavity_name = "cavity"				// Name of body part's cavity, displayed during cavity implant surgery
	var/max_volume = ITEM_SIZE_SMALL	// Max volumeClass of cavity implanted items

	// Surgery vars.
	var/open = 0
	var/diagnosed = FALSE
	var/stage = 0
	var/cavity = 0
	var/atom/selected_internal_object = null

	// Used for spawned robotic organs
	var/default_description

	// Generation behavior
	var/generation_flags = ORGAN_HAS_BONES | ORGAN_HAS_BLOOD_VESSELS | ORGAN_HAS_MUSCLES | ORGAN_HAS_NERVES

/obj/item/organ/external/New(mob/living/carbon/human/holder, datum/organ_description/OD)
	if(OD)
		set_description(OD)
	else if(default_description)
		set_description(new default_description)

	make_base_internal_organs()

	..(holder)

	if(!species && iscarbon(holder))
		species = holder.species

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
	src.nerve_struck = desc.nerve_struck
	src.vital = desc.vital
	src.cannot_amputate = desc.cannot_amputate

	src.volumeClass = desc.volumeClass
	src.max_volume = desc.max_volume

	src.amputation_point = desc.amputation_point
	src.joint = desc.joint
	src.encased = desc.encased
	src.cavity_name = desc.cavity_name

	src.functions = desc.functions
	if(desc.drop_on_remove)
		src.drop_on_remove = desc.drop_on_remove.Copy()

/obj/item/organ/external/insert(obj/item/organ/external/affected)
	..()
	parent.children |= src

	//Remove all stump wounds since limb is not missing anymore
	for(var/datum/wound/lost_limb/W in parent.wounds)
		parent.wounds -= W
		qdel(W)
	parent.update_damages()

/obj/item/organ/external/mob_update(mob/living/carbon/human/target)
	..()
	owner.organs_by_name[organ_tag] = src
	owner.organs |= src
	for(var/obj/item/organ/O in children + internal_organs)
		O.mob_update(owner)

	if(module)
		module.organ_installed(src, owner)

/obj/item/organ/external/removed(mob/living/user, redraw_mob = TRUE)
	if(parent)
		parent.children -= src

	var/mob/living/carbon/human/victim = owner

	. = ..()

	if(redraw_mob && victim)
		victim.update_body()


/obj/item/organ/external/removed_mob(mob/living/user)
	owner.organs -= src
	owner.organs_by_name -= src.organ_tag
	owner.bad_external_organs -= src

	for(var/atom/movable/implant in implants)
		//large items and non-item objs fall to the floor, everything else stays
		var/obj/item/I = implant
		if(istype(I, /obj/item/implant))
			var/obj/item/implant/Imp = I
			Imp.uninstall()
			continue
		if(istype(I) && I.volumeClass < ITEM_SIZE_NORMAL)
			implant.forceMove(get_turf(owner))
		else
			implant.forceMove(src)
	implants.Cut()

	if(module)
		module.organ_removed(src, owner)

	if(!(owner.status_flags & REBUILDING_ORGANS))
		release_restraints()

		var/obj/item/dropped = null
		for(var/slot in drop_on_remove)
			dropped = owner.get_equipped_item(slot)
			owner.drop_from_inventory(dropped)

	for(var/obj/item/organ/organ in children + internal_organs)
		organ.removed_mob(user)

	..()
	SSnano.update_uis(src)

//// THE ISSUE!!!!
/obj/item/organ/external/proc/make_base_internal_organs()
	if(is_stump(src))
		return
	/// these 4 god damn things cause issues with weight !!!!
	if(generation_flags & ORGAN_HAS_BONES)
		make_bones()
	if(generation_flags & ORGAN_HAS_NERVES)
		make_nerves()
	if(generation_flags & ORGAN_HAS_MUSCLES)
		make_muscles()
	if(generation_flags & ORGAN_HAS_BLOOD_VESSELS)
		make_blood_vessels()

/obj/item/organ/external/proc/make_bones()
	if(default_bone_type)
		var/obj/item/organ/internal/bone/bone
		if(nature < MODIFICATION_SILICON)
			bone = new default_bone_type
		else
			var/mecha_bone = text2path("[default_bone_type]/robotic")
			bone = new mecha_bone
		bone?.insert(src)

/obj/item/organ/external/proc/make_nerves()
	var/obj/item/organ/internal/nerve/nerve
	if(nature < MODIFICATION_SILICON)
		nerve = new /obj/item/organ/internal/nerve
	else
		nerve = new /obj/item/organ/internal/nerve/robotic

	nerve?.insert(src)

/obj/item/organ/external/proc/make_muscles()
	var/obj/item/organ/internal/muscle/muscle
	if(nature < MODIFICATION_SILICON)
		muscle = new /obj/item/organ/internal/muscle
	else
		muscle = new /obj/item/organ/internal/muscle/robotic

	muscle?.insert(src)

/obj/item/organ/external/proc/make_blood_vessels()
	var/obj/item/organ/internal/blood_vessel/blood_vessel
	if(nature < MODIFICATION_SILICON)	//No robotic blood vesseles
		blood_vessel = new /obj/item/organ/internal/blood_vessel

	blood_vessel?.insert(src)

/obj/item/organ/external/proc/update_limb_efficiency()
	limb_efficiency = 0
	limb_efficiency += owner.get_specific_organ_efficiency(OP_NERVE, organ_tag) + owner.get_specific_organ_efficiency(OP_MUSCLE, organ_tag)
	if(BP_IS_ROBOTIC(src))
		limb_efficiency = limb_efficiency / 2
		return
	limb_efficiency = (limb_efficiency + owner.get_specific_organ_efficiency(OP_BLOOD_VESSEL, organ_tag)) / 3
	if(status & ORGAN_MUTATED)
		limb_efficiency /= 2

/obj/item/organ/external/proc/update_bionics_hud()
	switch(organ_tag)
		if(BP_L_ARM)
			var/obj/item/organ/external/organ = owner?.HUDneed["left arm bionics"]
			organ?.update_icon()
		if(BP_R_ARM)
			var/obj/item/organ/external/organ = owner?.HUDneed["right arm bionics"]
			organ?.update_icon()

/obj/item/organ/external/proc/update_cyberdeck_hud(obj/item/implant/cyberinterface/cyberdeck)
	var/obj/screen/toggle_cyberdeck/cyberToggle = owner?.HUDneed["toggle_cyberdeck"]
	if(cyberToggle)
		if(cyberdeck)
			cyberToggle.invisibility = 0
			cyberToggle.hasInterface = TRUE
		else
			cyberToggle.invisibility = 101
			cyberToggle.hasInterface = FALSE

	var/loopChoice = cyberdeck ? length(cyberdeck.slots) : 6
	for(var/i = 1, i <= loopChoice, i++)
		var/obj/screen/cyberdeck_slot/cyberSlot = owner?.HUDneed["cyberdeck[i]"]
		if(cyberSlot)
			if(cyberdeck)
				cyberSlot.interface = cyberdeck
			else
				cyberSlot.interface = null
			cyberSlot.update_icon()

/obj/item/organ/external/proc/activate_module()
	set name = "Activate module"
	set category = "Cybernetics" //changed this to be in line with excelsior's cyber implants and such
	set src in usr

	if(module)
		module.activate(owner, src)

/obj/item/organ/external/emp_act(severity)
	if(!BP_IS_ROBOTIC(src))
		return
	switch (severity)
		if(1)
			take_damage(20, BURN)
		if(2)
			take_damage(10, BURN)
		if(3)
			take_damage(5, BURN)

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
		I.forceMove(get_turf(user)) //just in case something was embedded that is not an item
		if(istype(I))
			user.put_in_hands(I)
		user.visible_message(SPAN_DANGER("\The [user] rips \the [I] out of \the [src]!"))
		return //no eating the limb until everything's been removed
	return ..()

/obj/item/organ/external/examine(user, afterDesc)
	var/description = "[afterDesc] \n"
	if(in_range(usr, src) || isghost(usr))
		for(var/obj/item/I in contents)
			if(istype(I, /obj/item/organ))
				continue
			description += SPAN_DANGER("There is \a [I] sticking out of it.")
	..(user, afterDesc = description)

#define MAX_MUSCLE_SPEED -0.5

/obj/item/organ/external/proc/get_tally()
	if(is_broken() && !(status & ORGAN_SPLINTED))
		. += 3
	else if(status & (ORGAN_MUTATED|ORGAN_DEAD))
		. += 3
	// malfunctioning only happens intermittently so treat it as a broken limb when it procs
	if(is_malfunctioning())
		if(prob(10))
			owner.visible_message("\The [owner]'s [name] [pick("twitches", "shudders")] and sparks!")
			var/datum/effect/effect/system/spark_spread/spark_system = new ()
			spark_system.set_up(5, 0, owner)
			spark_system.attach(owner)
			spark_system.start()
			spawn(10)
				qdel(spark_system)
		. += 2
	if(is_nerve_struck())
		. += 1
	if(status & ORGAN_SPLINTED)
		. += 0.5

	var/muscle_eff = max(owner.get_specific_organ_efficiency(OP_MUSCLE, organ_tag), 50)
	var/nerve_eff = max(owner.get_specific_organ_efficiency(OP_NERVE, organ_tag), 100)
	muscle_eff = (muscle_eff/100) - (muscle_eff/nerve_eff) //Need more nerves to control those new muscles
	if(muscle_eff)
		. -= 0.6 * muscle_eff / (muscle_eff + 0.4) // Diminishing returns with a hard cap of 0.6 and soft cap of 0.5
	. += tally

/obj/item/organ/external/proc/is_nerve_struck()
	if(nerve_struck == 2)
		return TRUE
	if(parent)
		return parent.is_nerve_struck()
	return FALSE

/obj/item/organ/external/proc/nerve_strike_add(var/primary)
	if(nerve_struck != -1)
		if(primary)
			nerve_struck = 2
		else
			nerve_struck = 1

	if(children && children.len)
		for(var/obj/item/organ/external/child in children)
			child.nerve_strike_add()

	spawn(100)
		nerve_strike_remove()

/obj/item/organ/external/proc/nerve_strike_remove()
	if(nerve_struck != -1)
		nerve_struck = 0
	if(children && children.len)
		for(var/obj/item/organ/external/child in children)
			if(child.nerve_struck == 1)
				child.nerve_strike_remove()
	if(owner)
		owner.shock_stage += 20
		for(var/obj/item/organ/external/limb in owner.organs)
			if(limb.nerve_struck == 2)
				return

/obj/item/organ/external/proc/setBleeding()
	if(BP_IS_ROBOTIC(src) || !owner || (owner.species.flags & NO_BLOOD))
		return FALSE
	status |= ORGAN_BLEEDING
	return TRUE

/obj/item/organ/external/proc/stopBleeding()
	status &= ~ORGAN_BLEEDING


/obj/item/organ/external/update_health()
	damage = min(max_damage, (brute_dam + burn_dam))


/*
This function completely restores a damaged organ to perfect condition.
*/
/obj/item/organ/external/rejuvenate()
	damage_state = "00"
	status = 0
	perma_injury = 0
	brute_dam = 0
	burn_dam = 0
	wounds.Cut()
	number_wounds = 0

	// handle internal organs
	for(var/obj/item/organ/internal/current_organ in internal_organs)
		current_organ.rejuvenate()

	// remove embedded objects and drop them on the floor
	for(var/obj/implanted_object in implants)
		if(!istype(implanted_object,/obj/item/implant))	// We don't want to remove REAL implants. Just shrapnel etc.
			implanted_object.forceMove(get_turf(src))
			implants -= implanted_object

	SSnano.update_uis(src)
	owner.updatehealth()


/obj/item/organ/external/proc/createwound(type = CUT, damage)
	if(damage == 0)
		return

	// first check whether we can widen an existing wound
	if(wounds.len > 0 && prob(max(50+(number_wounds-1)*10,90)))
		if((type == CUT || type == BRUISE) && damage >= 5)
			//we need to make sure that the wound we are going to worsen is compatible with the type of damage...
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
							SPAN_DANGER("The damage to [owner.name]'s [name] worsens."),
							SPAN_DANGER("The damage to your [name] worsens."),
							SPAN_DANGER("You hear the screech of abused metal.")
						)
					else
						owner.visible_message(
							SPAN_DANGER("The wound on [owner.name]'s [name] widens with a nasty ripping noise."),
							SPAN_DANGER("The wound on your [name] widens with a nasty ripping noise."),
							SPAN_DANGER("You hear a nasty ripping noise, as if flesh is being torn apart.")
						)
				return

	//Creating wound
	var/wound_type = get_wound_type(type, damage)

	if(wound_type)
		var/datum/wound/W = new wound_type(damage)

		//Check whether we can add the wound to an existing wound
		for(var/datum/wound/other in wounds)
			if(other.can_merge(W))
				other.merge_wound(W)
				W = null // to signify that the wound was added
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

//Determines if we even need to process this organ.
/obj/item/organ/external/proc/need_process()
	if(status & (ORGAN_CUT_AWAY|ORGAN_BLEEDING|ORGAN_BROKEN|ORGAN_DESTROYED|ORGAN_SPLINTED|ORGAN_DEAD|ORGAN_MUTATED|ORGAN_INFECTED|ORGAN_WOUNDED))
		return TRUE
	if((brute_dam || burn_dam) && !BP_IS_ROBOTIC(src)) //Robot limbs don't autoheal and thus don't need to process when damaged
		return TRUE
	if(last_dam != brute_dam + burn_dam) // Process when we are fully healed up.
		last_dam = brute_dam + burn_dam
		return TRUE
	else
		last_dam = brute_dam + burn_dam
	return FALSE

/obj/item/organ/external/Process()
	if(owner)
		// Process wounds, doing healing etc. Only do this every few ticks to save processing power
		if(owner.life_tick % wound_update_accuracy == 0)
			update_wounds()

			// Infection side effects
			if(status & ORGAN_INFECTED)
				// Altered temp calcs from bay infection
				if(owner.species.heat_level_1 < INFINITY)
					var/fever_temperature = owner.species.heat_level_1 - 5
					owner.bodytemperature += between(0, (fever_temperature - T20C)/BODYTEMP_COLD_DIVISOR + 1, fever_temperature - owner.bodytemperature)

		//Chem traces slowly vanish
		if(owner.life_tick % 10 == 0)
			for(var/chemID in trace_chemicals)
				trace_chemicals[chemID] = trace_chemicals[chemID] - 1
				if(trace_chemicals[chemID] <= 0)
					trace_chemicals.Remove(chemID)
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
			owner?.gib() //In theory if droplimb is succesfull, the organ will have no owner and gib() should only get called if droplimb fails(Like on the upper body)

/// Handles internal and external wound effects
/obj/item/organ/external/proc/update_wounds()
	// Internal wound handling
	number_internal_wounds = 0
	severity_internal_wounds = 0
	total_internal_health = 0
	internal_wound_hal_dam = 0

	SEND_SIGNAL(src, COMSIG_IORGAN_REFRESH_PARENT)
	SEND_SIGNAL(src, COMSIG_IORGAN_APPLY)
	SEND_SIGNAL(src, COMSIG_IORGAN_WOUND_COUNT)

	// External wound handling
	if(BP_IS_ROBOTIC(src)) //Robotic limbs don't heal or get worse.
		for(var/datum/wound/W in wounds) //Repaired wounds disappear though
			if(W.damage <= 0)        //and they disappear right away
				wounds -= W      //TODO: robot wounds for robot limbs
		return

	for(var/datum/wound/W in wounds)
		// wounds can disappear after 10 minutes at the earliest
		if(W.damage <= 0 && W.created + 10 * 10 * 60 <= world.time)
			wounds -= W
			continue
			// let the GC handle the deletion of the wound

		// slow healing
		var/heal_amt = 0

		// if damage >= 50 AFTER treatment then it's probably too severe to heal within the timeframe of a round.
		if (W.can_autoheal() && W.wound_damage() < 50)
			heal_amt += 0.5

		//we only update wounds once in [wound_update_accuracy] ticks so have to emulate realtime
		heal_amt = heal_amt * wound_update_accuracy
		//configurable regen speed woo, no-regen hardcore or instaheal hugbox, choose your destiny
		heal_amt = heal_amt * ORGAN_REGENERATION_MULTIPLIER
		// amount of healing is spread over all the wounds
		heal_amt = heal_amt / (wounds.len + 1)
		//treated wounds heal faster
		if(W.is_treated())
			heal_amt = heal_amt * 1.3
		// bloodcloting promotes natural healing
		var/bloodclotting = LAZYACCESS(owner.chem_effects, CE_BLOODCLOT)
		if(bloodclotting)
			heal_amt *= 1 + bloodclotting
		// making it look prettier on scanners
		heal_amt = round(heal_amt,0.1)
		W.heal_damage(heal_amt)

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

	SSnano.update_uis(src)

//Returns 1 if damage_state changed
/obj/item/organ/external/proc/update_damstate()
	var/n_is = damage_state_text()
	if (n_is != damage_state)
		damage_state = n_is
		return TRUE
	return FALSE

// new damage icon system
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
	return "[tbrute][tburn]"

/****************************************************
			   HELPERS
****************************************************/

/obj/item/organ/external/proc/is_stump()
	return FALSE

/obj/item/organ/external/proc/release_restraints(var/mob/living/carbon/human/holder)
	if(!holder)
		holder = owner
	if(!holder)
		return
	if (holder.handcuffed && (body_part in list(ARM_LEFT, ARM_RIGHT)))
		holder.visible_message(\
			"\The [holder.handcuffed.name] falls off of [holder.name].",\
			"\The [holder.handcuffed.name] falls off you.")
		holder.drop_from_inventory(holder.handcuffed)
	if (holder.legcuffed && (body_part in list(LEG_LEFT, LEG_RIGHT)))
		holder.visible_message(\
			"\The [holder.legcuffed.name] falls off of [holder.name].",\
			"\The [holder.legcuffed.name] falls off you.")
		holder.drop_from_inventory(holder.legcuffed)

// checks if all wounds on the organ are bandaged
/obj/item/organ/external/proc/is_bandaged()
	for(var/datum/wound/W in wounds)
		if(!W.bandaged)
			return FALSE
	return TRUE

// checks if all wounds on the organ are salved
/obj/item/organ/external/proc/is_salved()
	for(var/datum/wound/W in wounds)
		if(!W.salved)
			return FALSE
	return TRUE

/obj/item/organ/external/proc/bandage()
	var/rval = 0
	stopBleeding()
	for(var/datum/wound/W in wounds)
		rval |= !W.bandaged
		W.bandaged = 1
	return rval

/obj/item/organ/external/proc/salve()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		rval |= !W.salved
		W.salved = 1
	return rval

/obj/item/organ/external/proc/clamp_wounds()
	var/rval = FALSE

	src.stopBleeding()
	for(var/datum/wound/W in wounds)
		rval |= !W.clamped
		W.clamped = TRUE
	return rval

// Checks if the limb should get fractured by now
/obj/item/organ/external/proc/should_fracture()
	if((status & ORGAN_BROKEN) || cannot_break)
		return FALSE
	if(owner)
		var/bone_efficiency = owner.get_specific_organ_efficiency(OP_BONE, organ_tag)
		return brute_dam > ((min_broken_damage * ORGAN_HEALTH_MULTIPLIER) * (bone_efficiency / 100))

// Fracture the bone in the limb
/obj/item/organ/external/proc/fracture()
	if((status & ORGAN_BROKEN) || cannot_break)
		return
	var/obj/item/organ/internal/bone = get_bone()
	if(bone)
		bone.fracture()

/obj/item/organ/external/proc/mend_fracture()
	var/list/list_of_bones = list()
	if(owner)
		list_of_bones = owner.internal_organs_by_efficiency[OP_BONE] & internal_organs
	else
		list_of_bones = internal_organs
	for(var/obj/item/organ/internal/bone in list_of_bones)
		if(bone.organ_efficiency[OP_BONE])
			bone.mend()
	return TRUE

/obj/item/organ/external/proc/get_bone()
	var/list/list_of_bones = list()
	if(owner)
		list_of_bones = owner.internal_organs_by_efficiency[OP_BONE] & internal_organs
	else
		list_of_bones = internal_organs
	if(LAZYLEN(list_of_bones))
		list_of_bones = shuffle(list_of_bones)
		for(var/obj/item/organ/internal/bone in list_of_bones)
			if(bone.organ_efficiency[OP_BONE])
				return bone
	return FALSE

/obj/item/organ/external/proc/mutate()
	if(BP_IS_ROBOTIC(src) || !LAZYLEN(internal_organs))
		return
	var/obj/item/organ/internal/I = pick(internal_organs)
	if(I)
		I.take_damage(8, CLONE, silent = TRUE)
	if(owner)
		owner.update_body()

/obj/item/organ/external/proc/unmutate()
	if(BP_IS_ROBOTIC(src))
		return
	for(var/obj/item/organ/internal/I in internal_organs)
		I.unmutate()
	if(owner)
		owner.update_body()

/obj/item/organ/external/proc/get_damage()	//returns total damage
	return max(brute_dam + burn_dam - perma_injury, perma_injury)	//could use max_damage?

// Robotic limbs malfunction - handled by subtype
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
		owner.visible_message("<span class='danger'>\The [W] sticks in the wound!</span>")
	implants += W

	if(!istype(W, /obj/item/material/shard/shrapnel))
		embedded += W
		owner.verbs += /mob/proc/yank_out_object

	owner.embedded_flag = 1
	W.on_embed(owner)
	if(!((W.flags & NOBLOODY)||(W.item_flags & NOBLOODY)))
		W.add_blood(owner)
	W.forceMove(owner)

/obj/item/organ/external/proc/disfigure(var/type = "brute")
	if(disfigured)
		return
	if(owner)
		if(type == "brute")
			owner.visible_message(
				"<span class='danger'>You hear a sickening cracking sound coming from \the [owner]'s [name].</span>",
				"<span class='danger'>Your [name] becomes a mangled mess!</span>",
				"<span class='danger'>You hear a sickening crack.</span>"
			)
		else
			owner.visible_message(
				"<span class='danger'>\The [owner]'s [name] melts away, turning into mangled mess!</span>",
				"<span class='danger'>Your [name] melts away!</span>",
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
					descriptors += pick("a lot of burns","severe melting")
		if(open)
			descriptors += "an open panel"

		return english_list(descriptors)

	//Normal organic organ damage
	var/list/wound_descriptors = list()
	if(open > 1)
		wound_descriptors["an open incision"] = 1
	else if (open)
		wound_descriptors["an incision"] = 1
	for(var/datum/wound/W in wounds)
		var/this_wound_desc = W.desc

		if(W.damage_type == BURN && W.salved)
			this_wound_desc = "salved [this_wound_desc]"

		if(W.bleeding())
			this_wound_desc = "bleeding [this_wound_desc]"
		else if(W.bandaged)
			this_wound_desc = "bandaged [this_wound_desc]"

		if(wound_descriptors[this_wound_desc])
			wound_descriptors[this_wound_desc] += W.amount
		else
			wound_descriptors[this_wound_desc] = W.amount

	if(wound_descriptors.len)
		var/list/flavor_text = list()
		var/list/no_exclude = list("gaping wound", "big gaping wound", "massive wound", "large bruise",\
		"huge bruise", "massive bruise", "severe burn", "large burn", "deep burn", "carbonised area") //note to self make this more robust
		for(var/wound in wound_descriptors)
			switch(wound_descriptors[wound])
				if(1)
					flavor_text += "[prob(10) && !(wound in no_exclude) ? "what might be " : ""]a [wound]"
				if(2)
					flavor_text += "[prob(10) && !(wound in no_exclude) ? "what might be " : ""]a pair of [wound]s"
				if(3 to 5)
					flavor_text += "several [wound]s"
				if(6 to INFINITY)
					flavor_text += "a ton of [wound]\s"
		return english_list(flavor_text)

/obj/item/organ/external/is_usable()
	return !is_nerve_struck() && !(status & (ORGAN_DEAD))

/obj/item/organ/external/drop_location()
	if(owner)
		return owner.drop_location()
	else
		return ..()

// Is body part open for most surgerical operations?
/obj/item/organ/external/is_open()
	// Robotic body parts only have to be screwed open. Organic ones need to have skin retracted too.
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

/obj/item/organ/external/attackby(obj/item/A, mob/user, params)
	if(A.has_quality(QUALITY_CUTTING))
		if(!(user.a_intent == I_HURT))
			return ..()
		user.visible_message(SPAN_WARNING("[user] begins butchering \the [src]"), SPAN_WARNING("You begin butchering \the [src]"), SPAN_NOTICE("You hear meat being cut apart"), 5)
		if(A.use_tool(user, src, WORKTIME_FAST, QUALITY_CUTTING, FAILCHANCE_EASY, required_stat = STAT_BIO))
			on_butcher(A, user, get_turf(src))

/obj/item/organ/external/proc/on_butcher(obj/item/A, mob/living/carbon/human/user, location_meat)
	for(var/obj/item/organ/internal/muscle/placeholder in internal_organs)
		var/meat = species?.meat_type // One day someone will make a species with no meat type.
		if(!meat)
			break
		new meat(location_meat)
		if(user.species == species)
			user.sanity_damage += 5*((user.nutrition ? user.nutrition : 1)/user.max_nutrition)
			to_chat(user, SPAN_NOTICE("You feel your [species.name]ity dismantling as you butcher the [src]")) // Human-ity , Monkey-ity , Slime-Ity
	qdel(src)
