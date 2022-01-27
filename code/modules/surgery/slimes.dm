//////////////////////////////////////////////////////////////////
//				SLIME CORE EXTRACTION							//
//////////////////////////////////////////////////////////////////

/datum/old_surgery_step/slime/is_valid_target(mob/living/carbon/slime/target)
	return istype(target, /mob/living/carbon/slime)

/datum/old_surgery_step/slime/can_use(mob/living/user,69ob/living/carbon/slime/target, target_zone, obj/item/tool)
	return target.stat == 2

/datum/old_surgery_step/slime/cut_flesh
	re69uired_tool_69uality = 69UALITY_CUTTING

	duration = 40

/datum/old_surgery_step/slime/cut_flesh/can_use(mob/living/user,69ob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && istype(target) && target.core_removal_stage == 0

/datum/old_surgery_step/slime/cut_flesh/begin_step(mob/user,69ob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("69user69 starts cutting through 69target69's flesh with \the 69tool69.", \
	"You start cutting through 69target69's flesh with \the 69tool69.")

/datum/old_surgery_step/slime/cut_flesh/end_step(mob/living/user,69ob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("\blue 69user69 cuts through 69target69's flesh with \the 69tool69.",	\
	"\blue You cut through 69target69's flesh with \the 69tool69, revealing its silky innards.")
	target.core_removal_stage = 1

/datum/old_surgery_step/slime/cut_flesh/fail_step(mob/living/user,69ob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("\red 69user69's hand slips, tearing 69target69's flesh with \the 69tool69!", \
	"\red Your hand slips, tearing 69target69's flesh with \the 69tool69!")

/datum/old_surgery_step/slime/cut_innards
	re69uired_tool_69uality = 69UALITY_CUTTING

	duration = 40

/datum/old_surgery_step/slime/cut_innards/can_use(mob/living/user,69ob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && istype(target) && target.core_removal_stage == 1

/datum/old_surgery_step/slime/cut_innards/begin_step(mob/user,69ob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("69user69 starts cutting 69target69's silky innards apart with \the 69tool69.", \
	"You start cutting 69target69's silky innards apart with \the 69tool69.")

/datum/old_surgery_step/slime/cut_innards/end_step(mob/living/user,69ob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("\blue 69user69 cuts 69target69's innards apart with \the 69tool69, exposing the cores.",	\
	"\blue You cut 69target69's innards apart with \the 69tool69, exposing the cores.")
	target.core_removal_stage = 2

/datum/old_surgery_step/slime/cut_innards/fail_step(mob/living/user,69ob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("\red 69user69's hand slips, tearing 69target69's innards with \the 69tool69!", \
	"\red Your hand slips, tearing 69target69's innards with \the 69tool69!")

/datum/old_surgery_step/slime/saw_core
	re69uired_tool_69uality = 69UALITY_SAWING

	duration = 60

/datum/old_surgery_step/slime/saw_core/can_use(mob/living/user,69ob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && (istype(target) && target.core_removal_stage == 2 && target.cores > 0) //This is being passed a human as target, unsure why.

/datum/old_surgery_step/slime/saw_core/begin_step(mob/user,69ob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("69user69 starts cutting out one of 69target69's cores with \the 69tool69.", \
	"You start cutting out one of 69target69's cores with \the 69tool69.")

/datum/old_surgery_step/slime/saw_core/end_step(mob/living/user,69ob/living/carbon/slime/target, target_zone, obj/item/tool)
	target.cores--
	user.visible_message("\blue 69user69 cuts out one of 69target69's cores with \the 69tool69.",,	\
	"\blue You cut out one of 69target69's cores with \the 69tool69. 69target.cores69 cores left.")

	if(target.cores >= 0)
		new target.coretype(target.loc)
	if(target.cores <= 0)
		target.icon_state = "69target.colour69 baby slime dead-nocore"


/datum/old_surgery_step/slime/saw_core/fail_step(mob/living/user,69ob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("\red 69user69's hand slips, causing \him to69iss the core!", \
	"\red Your hand slips, causing you to69iss the core!")