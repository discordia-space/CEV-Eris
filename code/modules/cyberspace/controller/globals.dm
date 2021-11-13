GLOBAL_LIST_EMPTY(CyberSpaceAtoms)
GLOBAL_LIST_EMPTY(CyberSpaceViewers)

/proc/AddToViewers(mob/Target)
	GLOB.CyberSpaceViewers |= Target

/proc/RemoveFromViewers(mob/Target)
	GLOB.CyberSpaceViewers.Remove(Target)

/proc/AddToAtoms(atom/Target)
	GLOB.CyberSpaceAtoms |= Target

/proc/RemoveFromAtoms(atom/Target)
	GLOB.CyberSpaceAtoms.Remove(Target)
