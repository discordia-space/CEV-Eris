/obj/item/organ/internal/xenos/hivenode
	name = "hive node"
	parent_organ = BP_CHEST
	icon_state = "xgibmid2"
	organ_tag = BP_HIVE

/obj/item/organ/internal/xenos/hivenode/removed_mob(mob/living/user)
	to_chat(owner, "<span class='alium'>You feel your connection to the hivemind fray and fade away...</span>")
	owner.remove_language(LANGUAGE_HIVEMIND)
	..()

/obj/item/organ/internal/xenos/hivenode/replaced_mob(mob/living/carbon/human/target)
	..()
	owner.add_language(LANGUAGE_HIVEMIND)
