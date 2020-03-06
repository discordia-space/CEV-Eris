/obj/item/organ/internal/xenos/hivenode
	name = "hive node"
	parent_organ = BP_CHEST
	icon_state = "xgibmid2"
	organ_tag = BP_HIVE

/obj/item/organ/internal/xenos/hivenode/removed_mob(mob/living/user)
	to_chat(owner, "<span class='alium'>You feel your connection to the hivemind fray and fade away...</span>")
	owner.remove_language(LANGUAGE_HIVEMIND)
	..()

/obj/item/organ/internal/xenos/hivenode/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)
	..(target, affected)
	if(owner && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.add_language(LANGUAGE_HIVEMIND)
