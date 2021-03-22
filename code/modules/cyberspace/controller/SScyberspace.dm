SUBSYSTEM_DEF(cyberspace)
	name = "Character Setup"
	init_order = INIT_ORDER_CYBERSPACE
	flags = SS_NO_FIRE && SS_BACKGROUND

	var/list/CyberSpaceAtoms = list()
	var/list/CyberSpaceViewers = list()

	var/list/RegistredAtoms = list()

	var/IsCyberspaceInitialized = FALSE

/datum/controller/subsystem/cyberspace/proc/InitCyberspace()
	if(!IsCyberspaceInitialized)
		for(var/atom/Atom in RegistredAtoms)
			InitRegistredAtom(Atom)
		IsCyberspaceInitialized = TRUE

/datum/controller/subsystem/cyberspace/proc/RegisterInitialization(atom/target, _color)
	if(istype(target) && !QDELETED(target))
		if(IsCyberspaceInitialized) //check Initialization state
			InitAtom(target, _color)
		else
			RegistredAtoms[target] = _color

/datum/controller/subsystem/cyberspace/proc/InitRegistredAtom(atom/Atom)
	var/_color
	if(RegistredAtoms.Find(Atom))
		_color = RegistredAtoms[Atom]
	InitAtom(Atom, _color)

/datum/controller/subsystem/cyberspace/proc/InitAtom(atom/target, _color)
	target.CreateCA(_color)

/datum/controller/subsystem/cyberspace/proc/AddToViewers(mob/Target)
	CyberSpaceViewers |= Target

/datum/controller/subsystem/cyberspace/proc/RemoveFromViewers(mob/Target)
	CyberSpaceViewers.Remove(Target)

/datum/controller/subsystem/cyberspace/proc/AddToAtoms(atom/Target)
	SScyberspace.CyberSpaceAtoms |= Target

/datum/controller/subsystem/cyberspace/proc/RemoveFromAtoms(atom/Target)
	SScyberspace.CyberSpaceAtoms -= Target
