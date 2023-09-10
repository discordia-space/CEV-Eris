/datum/component/internal_wound/organic/brain
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_CLAMPING = FAILCHANCE_HARD)
	treatments_chem = list(CE_BRAINHEAL, 1)
	severity = 0
	severity_max = 5
	hal_damage = IWOUND_MEDIUM_DAMAGE

/datum/component/internal_wound/organic/brain/dissection
    name = "brain contusion"

/datum/component/internal_wound/organic/brain/hematoma
    name = "hematoma"

/datum/component/internal_wound/organic/brain/injury
    name = "traumatic brain injury"
