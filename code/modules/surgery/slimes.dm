//////////////////////////////////////////////////////////////////
//				SLIME CORE EXTRACTION							//
//////////////////////////////////////////////////////////////////

/datum/old_surgery_step/slime/is_valid_target(mob/living/carbon/slime/target)
	return istype(target, /mob/living/carbon/slime)

/datum/old_surgery_step/slime/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return target.stat == 2

/datum/old_surgery_step/slime/cut_flesh
	required_tool_quality = QUALITY_CUTTING

	duration = 40

/datum/old_surgery_step/slime/cut_flesh/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && istype(target) && target.core_removal_stage == 0

/datum/old_surgery_step/slime/cut_flesh/begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting through [target]'s flesh with \the [tool].", \
	"You start cutting through [target]'s flesh with \the [tool].")

/datum/old_surgery_step/slime/cut_flesh/end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("\blue [user] cuts through [target]'s flesh with \the [tool].",	\
	"\blue You cut through [target]'s flesh with \the [tool], revealing its silky innards.")
	target.core_removal_stage = 1

/datum/old_surgery_step/slime/cut_flesh/fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("\red [user]'s hand slips, tearing [target]'s flesh with \the [tool]!", \
	"\red Your hand slips, tearing [target]'s flesh with \the [tool]!")

/datum/old_surgery_step/slime/cut_innards
	required_tool_quality = QUALITY_CUTTING

	duration = 40

/datum/old_surgery_step/slime/cut_innards/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && istype(target) && target.core_removal_stage == 1

/datum/old_surgery_step/slime/cut_innards/begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting [target]'s silky innards apart with \the [tool].", \
	"You start cutting [target]'s silky innards apart with \the [tool].")

/datum/old_surgery_step/slime/cut_innards/end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("\blue [user] cuts [target]'s innards apart with \the [tool], exposing the cores.",	\
	"\blue You cut [target]'s innards apart with \the [tool], exposing the cores.")
	target.core_removal_stage = 2

/datum/old_surgery_step/slime/cut_innards/fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("\red [user]'s hand slips, tearing [target]'s innards with \the [tool]!", \
	"\red Your hand slips, tearing [target]'s innards with \the [tool]!")

/datum/old_surgery_step/slime/saw_core
	required_tool_quality = QUALITY_SAWING

	duration = 60

/datum/old_surgery_step/slime/saw_core/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && (istype(target) && target.core_removal_stage == 2 && target.cores > 0) //This is being passed a human as target, unsure why.

/datum/old_surgery_step/slime/saw_core/begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting out one of [target]'s cores with \the [tool].", \
	"You start cutting out one of [target]'s cores with \the [tool].")

/datum/old_surgery_step/slime/saw_core/end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	target.cores--
	user.visible_message("\blue [user] cuts out one of [target]'s cores with \the [tool].",,	\
	"\blue You cut out one of [target]'s cores with \the [tool]. [target.cores] cores left.")

	if(target.cores >= 0)
		new target.coretype(target.loc)
	if(target.cores <= 0)
		target.icon_state = "[target.colour] baby slime dead-nocore"


/datum/old_surgery_step/slime/saw_core/fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("\red [user]'s hand slips, causing \him to miss the core!", \
	"\red Your hand slips, causing you to miss the core!")