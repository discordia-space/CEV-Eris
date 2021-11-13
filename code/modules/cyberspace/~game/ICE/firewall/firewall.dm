GLOBAL_LIST_EMPTY(APCAccessCodes)
/obj/machinery/power/apc
	var/CyberAccessCode

/obj/machinery/power/apc/proc/GenerateUniqueCode()
	var/tryes = 0
	do
		CyberAccessCode = "[z]:[x]:[y]=[rand(1000, 9999)]-[rand(1000, 9999)]"
		tryes += 1
	while(tryes < 10 && GLOB.APCAccessCodes.Find(CyberAccessCode) != 0)
	if(tryes >= 10)
		CRASH("Somehow [type]>\ref[src] have got repeatable CyberAccessCode ([CyberAccessCode]) for [tryes] times.")
	GLOB.APCAccessCodes[CyberAccessCode] = src

/obj/machinery/power/apc/proc/CheckCyberAccess(mob/observer/cyber_entity/cyberspace_eye/user)
	. = user.CheckAccess(src)

/mob/observer/cyber_entity/cyberspace_eye
	var/list/AccessCodes = list()

/mob/observer/cyber_entity/proc/CheckAccess(obj/machinery/power/apc/A)

/mob/observer/cyber_entity/cyberspace_eye/CheckAccess(obj/machinery/power/apc/A)
	. = !length(A.CyberAccessCode) || (A.CyberAccessCode in AccessCodes)
	var/mob/H = owner.get_user()
	if(H)
		var/obj/item/card/id/I = H.GetIdCard()
		. = . || A.check_access(I)

/obj/machinery/power/apc/Initialize()
	. = ..()
	GenerateUniqueCode()

/datum/CyberSpaceAvatar/interactable/AbleToInteract(mob/observer/cyber_entity/cyberspace_eye/user)
	. = ..()
	if(RequireAreaAccessToInteract)
		var/area/A = get_area(Owner)
		var/obj/machinery/power/apc/Apc = A.get_apc()
		if(istype(Apc))
			. = . && Apc.CheckCyberAccess(user)
