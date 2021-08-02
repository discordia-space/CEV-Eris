/datum/CyberSpaceAvatar/ice/technomansers
	icon_file = 'icons/obj/cyberspace/ices/technomansers.dmi'
	color = CYBERSPACE_TECHNOMANSERS

/datum/CyberSpaceAvatar/ice/technomansers/copper_wall
	// -> Runner must pay 2 QP or will delete random installed program if able, else force jack out runner.
	// -> Runner must pay 4 QP or will suffer meat damage if able, else deal brain damage to runner and force jack out.
	icon_state = "barrier"

/datum/CyberSpaceAvatar/ice/technomansers/golem
	// -> Delete program in grip, runner must suffer 2 meat damage else runner become unable to access data storages on this run.
	// -> Delete installed program else force jack out.
	icon_state = "sentry"

/datum/CyberSpaceAvatar/ice/technomansers/sauron_eye
	// -> Gain -2 to all icebreakers for this run.
	// -> Suffer meat damage or chip else gain 2 brain damage and force jack out.
	icon_state = "gate"

