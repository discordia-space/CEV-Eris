/////////////////////////
// (mostly) DNA2 SETUP
/////////////////////////

// Randomize block, assign a reference name, and optionally define difficulty (by69aking activation zone smaller or bigger)
// The name is used on /vg/ for species with predefined genetic traits,
//  and for the DNA panel in the player panel.
/proc/getAssignedBlock(name, list/blocksLeft, activity_bounds=DNA_DEFAULT_BOUNDS)
	if(!blocksLeft.len)
		warning("69name69: No69ore blocks left to assign!")
		return 0
	var/assigned = pick(blocksLeft)
	blocksLeft.Remove(assigned)
	assigned_blocks69assigned69 = name
	dna_activity_bounds69assigned69 = activity_bounds
	return assigned

/proc/setup_genetics()

	if(prob(50))
		// Currently unused.  Will revisit. - N3X
		BLOCKADD = rand(-300,300)
	if(prob(75))
		DIFFMUT = rand(0,20)

	var/list/numsToAssign = new()
	for(var/i = 1; i < DNA_SE_LENGTH; i++)
		numsToAssign += i

	// Standard69uts, imported from older code above.
	BLINDBLOCK         = getAssignedBlock("BLIND",         numsToAssign)
	DEAFBLOCK          = getAssignedBlock("DEAF",          numsToAssign)
	HULKBLOCK          = getAssignedBlock("HULK",          numsToAssign, DNA_HARD_BOUNDS)
	TELEBLOCK          = getAssignedBlock("TELE",          numsToAssign, DNA_HARD_BOUNDS)
	FIREBLOCK          = getAssignedBlock("FIRE",          numsToAssign, DNA_HARDER_BOUNDS)
	XRAYBLOCK          = getAssignedBlock("XRAY",          numsToAssign, DNA_HARDER_BOUNDS)
	CLUMSYBLOCK        = getAssignedBlock("CLUMSY",        numsToAssign)
	FAKEBLOCK          = getAssignedBlock("FAKE",          numsToAssign)
	REMOTETALKBLOCK    = getAssignedBlock("REMOTETALK",    numsToAssign, DNA_HARDER_BOUNDS)
	MONKEYBLOCK = DNA_SE_LENGTH

	// And the genes that actually do the work. (domutcheck improvements)
	var/list/blocks_assigned69DNA_SE_LENGTH69
	for(var/gene_type in typesof(/datum/dna/gene))
		var/datum/dna/gene/G = new gene_type
		if(G.block)
			if(G.block in blocks_assigned)
				warning("DNA2: Gene 69G.name69 trying to use already-assigned block 69G.block69 (used by 69english_list(blocks_assigned69G.block69)69)")
			dna_genes.Add(G)
			var/list/assignedToBlock69069
			if(blocks_assigned69G.block69)
				assignedToBlock = blocks_assigned69G.block69
			assignedToBlock.Add(G.name)
			blocks_assigned69G.block69 = assignedToBlock
