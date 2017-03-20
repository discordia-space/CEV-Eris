/obj/item/weapon/implant/loyalty
	name = "loyalty implant"
	desc = "Makes you loyal or such."
	origin_tech = list(TECH_MATERIAL=2, TECH_BIO=4, TECH_DATA=4)

/obj/item/weapon/implant/loyalty/get_data()
	var/data = {"
		<b>Implant Specifications:</b><BR>
		<b>Name:</b> [company_name] Employee Management Implant<BR>
		<b>Life:</b> Ten years.<BR>
		<b>Important Notes:</b> Personnel injected with this device tend to be much more loyal to the company.<BR>
		<HR>
		<b>Implant Details:</b><BR>
		<b>Function:</b> Contains a small pod of nanobots that manipulate the host's mental functions.<BR>
		<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
		<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}
	return data


/obj/item/weapon/implant/loyalty/implant(mob/M)
	if(!istype(M, /mob/living/carbon/human))	return 0
	var/mob/living/carbon/human/H = M
	var/datum/antagonist/antag_data = get_antag_data(H.mind.special_role)
	if(antag_data && (antag_data.flags & ANTAG_IMPLANT_IMMUNE))
		H.visible_message("[H] seems to resist the implant!", "You feel the corporate tendrils of [company_name] try to invade your mind!")
		return 0
	else
		clear_antag_roles(H.mind, 1)
		H << "<span class='notice'>You feel a surge of loyalty towards [company_name].</span>"
	return 1


/obj/item/weapon/implantcase/loyalty
	name = "glass case - 'loyalty'"
	desc = "A case containing a loyalty implant."
	icon_state = "implantcase-r"
	implant_type = /obj/item/weapon/implant/loyalty


/obj/item/weapon/implanter/loyalty
	name = "implanter-loyalty"
	implant_type = /obj/item/weapon/implant/loyalty
