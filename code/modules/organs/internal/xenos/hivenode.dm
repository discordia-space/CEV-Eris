/obj/item/organ/internal/xenos/hivenode
	name = "hive node"
	parent_organ = BP_CHEST
	icon_state = "xgibmid2"
	organ_tag = BP_HIVE

/obj/item/organ/internal/xenos/hivenode/removed(var/mob/living/user)
	if(owner && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		to_chat(H, "<span class='alium'>You feel your connection to the hivemind fray and fade away...</span>")
		H.remove_language(LANGUAGE_HIVEMIND)
	..(user)

/obj/item/organ/internal/xenos/hivenode/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)
	..(target, affected)
	if(owner && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.add_language(LANGUAGE_HIVEMIND)
