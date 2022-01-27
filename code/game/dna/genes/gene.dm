/**
* Gene Datum
*
* domutcheck was getting pretty hairy.  This is the solution.
*
* All genes are stored in a global69ariable to cut down on69emory
* usage.
*
* @author N3X15 <nexisentertainment@gmail.com>
*/

/datum/dna/gene
	// Display name
	var/name="BASE GENE"

	// Probably won't get used but why the fuck not
	var/desc="Oh god who knows what this does."

	// Set in initialize()!
	//  What gene activates this?
	var/block=0

	// Any of a number of GENE_ flags.
	var/flags=0

/**
* Is the gene active in this69ob's DNA?
*/
/datum/dna/gene/proc/is_active(var/mob/M)
	return69.active_genes && (type in69.active_genes)

// Return 1 if we can activate.
// HANDLE69UTCHK_FORCED HERE!
/datum/dna/gene/proc/can_activate(var/mob/M,69ar/flags)
	return 0

// Called when the gene activates.  Do your69agic here.
/datum/dna/gene/proc/activate(mob/M,69ar/connected,69ar/flags)
	return

/**
* Called when the gene deactivates.  Undo your69agic here.
* Only called when the block is deactivated.
*/
/datum/dna/gene/proc/deactivate(mob/M,69ar/connected,69ar/flags)
	return

// This section inspired by goone's bioEffects.

/**
* Called in each life() tick.
*/
/datum/dna/gene/proc/OnMobLife(mob/M)
	return

/**
* Called when the69ob dies
*/
/datum/dna/gene/proc/OnMobDeath(mob/M)
	return

/**
* Called when the69ob says shit
*/
/datum/dna/gene/proc/OnSay(mob/M,69ar/message)
	return69essage

/**
* Called after the69ob runs update_icons.
*
* @params69 The subject.
* @params g Gender (m or f)
*/
/datum/dna/gene/proc/OnDrawUnderlays(var/mob/M,69ar/g)
	return 0


/////////////////////
// BASIC GENES
//
// These just chuck in a69utation and display a69essage.
//
// Gene is activated:
//  1. If69utation already exists in69ob
//  2. If the probability roll succeeds
//  3. Activation is forced (done in domutcheck)
/////////////////////


/datum/dna/gene/basic
	name="BASIC GENE"

	//69utation to give
	var/mutation=0

	// Activation probability
	var/activation_prob=45

	// Possible activation69essages
	var/list/activation_messages=list()

	// Possible deactivation69essages
	var/list/deactivation_messages=list()

/datum/dna/gene/basic/can_activate(mob/M,var/flags)
	if(flags &69UTCHK_FORCED)
		return 1
	// Probability check
	return probinj(activation_prob,(flags&MUTCHK_FORCED))

/datum/dna/gene/basic/activate(var/mob/M)
	M.mutations.Add(mutation)
	if(activation_messages.len)
		var/msg = pick(activation_messages)
		to_chat(M, SPAN_NOTICE("69msg69"))

/datum/dna/gene/basic/deactivate(var/mob/M)
	M.mutations.Remove(mutation)
	if(deactivation_messages.len)
		var/msg = pick(deactivation_messages)
		to_chat(M, SPAN_WARNING("69msg69"))
