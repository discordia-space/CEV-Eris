/obj/item/organ_module/eyes/nv
	name = "nightvision eyes"
	desc = "A pair of synthetic eyes connected together by wiring and artificial nerve tissue. Meant to be inserted into the head, this cybernetic augmentation grants perfect vision in low light."
	allowed_organs = list(BP_EYES)
	icon_state = "eyes-prosthetic"

/obj/item/organ_module/armor/onInstall(obj/item/organ/external/E)
	E.darkness_view += 7
	E.see_invisible += SEE_INVISIBLE_NOLIGHTING



/obj/item/organ_module/armor/onRemove(obj/item/organ/external/E)
	E.darkness_view -= 7
	E.see_invisible -= SEE_INVISIBLE_NOLIGHTING

