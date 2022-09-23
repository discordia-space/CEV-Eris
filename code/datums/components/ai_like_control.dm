// gives the equivalent of basic AI shortcut control to a human.
// also checks if they have acces to do it.
/datum/component/ai_like_control
	var/mob/living/carbon/human/owner
	dupe_mode = COMPONENT_DUPE_UNIQUE
	can_transfer = FALSE

/datum/component/ai_like_control/Initialize()
	. = ..()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	RegisterSignal(owner,COMSIG_SHIFTCLICK, .proc/ShiftClicked )
	RegisterSignal(owner,COMSIG_ALTCLICK, .proc/AltClicked )
	RegisterSignal(owner,COMSIG_CTRLCLICK, .proc/CtrlClicked )

/datum/component/ai_like_control/RemoveComponent()
	UnregisterSignal(owner, COMSIG_SHIFTCLICK)
	UnregisterSignal(owner, COMSIG_ALTCLICK)
	UnregisterSignal(owner, COMSIG_CTRLCLICK)
	owner = null
	..()

/datum/component/ai_like_control/proc/ShiftClicked(atom/target)
	var/obj/machinery/door/airlock/le_door
	if(isturf(target))
		le_door = locate(/obj/machinery/door/airlock) in target.contents

	if(istype(target, /obj/machinery/door/airlock))
		le_door = target
	if(le_door)
		if(!le_door.allowed(owner))
			return
		if(le_door.can_open())
			le_door.open()
		else
			le_door.close()
	if(istype(target,/obj/machinery/power/apc))
		var/obj/machinery/power/apc/le_apc = target
		if(!le_apc.allowed(owner))
			return
		le_apc.toggle_breaker()
		to_chat(owner, "You toggle the [le_apc]'s power")

/datum/component/ai_like_control/proc/AltClicked(atom/target)
	var/obj/machinery/door/airlock/le_door
	if(isturf(target))
		le_door = locate(/obj/machinery/door/airlock) in target.contents
	if(istype(target, /obj/machinery/door/airlock))
		le_door = target
	if(le_door)
		if(!le_door.allowed(owner))
			return
		if(le_door.isElectrified())
			le_door.electrified_until = 0
			to_chat(owner, "You unelectrify the [le_door]")
		else
			to_chat(owner, "You electrify the [le_door]")
			le_door.electrify(-1, FALSE)
	if(istype(target,/obj/machinery/power/apc))
		var/obj/machinery/power/apc/le_apc = target
		if(!le_apc.allowed(owner))
			return
		le_apc.toggle_lock(owner)
		to_chat(owner, "You toggle the [le_apc]'s lock")

/datum/component/ai_like_control/proc/CtrlClicked(atom/target)
	var/obj/machinery/door/airlock/le_door
	if(isturf(target))
		le_door = locate(/obj/machinery/door/airlock) in target.contents
	if(istype(target, /obj/machinery/door/airlock))
		le_door = target
	if(le_door)
		if(!le_door.check_access(owner))
			return
		if(le_door.locked)
			to_chat(owner, "You unbolt the [le_door]")
			le_door.unlock()
		else
			to_chat(owner, "You bolt the [le_door]")
			le_door.lock()
	if(istype(target, /obj/machinery/alarm))
		var/obj/machinery/alarm/atmos = target
		if(!atmos.allowed(owner))
			return
		if(atmos.mode ==  AALARM_MODE_PANIC)
			atmos.apply_mode(AALARM_MODE_FIRST)
			to_chat(owner, "You toggle the [atmos]'s mode to normal")
		else
			atmos.apply_mode(AALARM_MODE_PANIC)
			to_chat(owner, "You toggle the [atmos]'s mode to panic siphon")
