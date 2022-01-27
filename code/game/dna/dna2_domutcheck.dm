// (Re-)Apply69utations.
// TODO: Turn into a /mob proc, change inj to a bitflag for69arious forms of differing behavior.
//69:69ob to69ess with
// connected:69achine we're in, type unchecked so I doubt it's used beyond69onkeying
// flags: See below, bitfield.
#define69UTCHK_FORCED        1
/proc/domutcheck(var/mob/living/M,69ar/connected=null,69ar/flags=0)
	for(var/datum/dna/gene/gene in dna_genes)
		if(!M || !M.dna)
			return
		if(!gene.block)
			continue

		// Sanity checks, don't skip.
		if(!gene.can_activate(M,flags))
			//testing("69M69 - Failed to activate 69gene.name69 (can_activate fail).")
			continue

		// Current state
		var/gene_active = (gene.flags & GENE_ALWAYS_ACTIVATE)
		if(!gene_active)
			gene_active =69.dna.GetSEState(gene.block)

		// Prior state
		var/gene_prior_status = (gene.type in69.active_genes)
		var/changed = gene_active != gene_prior_status || (gene.flags & GENE_ALWAYS_ACTIVATE)

		// If gene state has changed:
		if(changed)
			// Gene active (or ALWAYS ACTIVATE)
			if(gene_active || (gene.flags & GENE_ALWAYS_ACTIVATE))
				testing("69gene.name69 activated!")
				gene.activate(M,connected,flags)
				if(M)
					M.active_genes |= gene.type
					M.update_icon = 1
			// If Gene is NOT active:
			else
				testing("69gene.name69 deactivated!")
				gene.deactivate(M,connected,flags)
				if(M)
					M.active_genes -= gene.type
					M.update_icon = 1
