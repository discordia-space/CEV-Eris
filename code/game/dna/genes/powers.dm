///////////////////////////////////
// POWERS
///////////////////////////////////

/datum/dna/gene/basic/nobreath
	name="No Breathing"
	activation_messages=list("You feel no need to breathe.")
	mutation=mNobreath

	New()
		block=NOBREATHBLOCK

/datum/dna/gene/basic/remoteview
	name="Remote69iewing"
	activation_messages=list("Your69ind expands.")
	mutation=mRemote

	New()
		block=REMOTEVIEWBLOCK

	activate(var/mob/M,69ar/connected,69ar/flags)
		..(M,connected,flags)
		M.verbs += /mob/living/carbon/human/proc/remoteobserve

/datum/dna/gene/basic/regenerate
	name="Regenerate"
	activation_messages=list("You feel better.")
	mutation=mRegen

	New()
		block=REGENERATEBLOCK

/datum/dna/gene/basic/increaserun
	name="Super Speed"
	activation_messages=list("Your leg69uscles pulsate.")
	mutation=mRun

	New()
		block=INCREASERUNBLOCK

/datum/dna/gene/basic/remotetalk
	name="Telepathy"
	activation_messages=list("You expand your69ind outwards.")
	mutation=mRemotetalk

	New()
		block=REMOTETALKBLOCK

	activate(var/mob/M,69ar/connected,69ar/flags)
		..(M,connected,flags)
		M.verbs += /mob/living/carbon/human/proc/remotesay

/datum/dna/gene/basic/morph
	name="Morph"
	activation_messages=list("Your skin feels strange.")
	mutation=mMorph

	New()
		block=MORPHBLOCK

	activate(var/mob/M)
		..(M)
		M.verbs += /mob/living/carbon/human/proc/morph

/* Not used on bay
/datum/dna/gene/basic/heat_resist
	name="Heat Resistance"
	activation_messages=list("Your skin is icy to the touch.")
	mutation=mHeatres

	New()
		block=COLDBLOCK

	can_activate(var/mob/M,var/flags)
		if(flags &69UTCHK_FORCED)
			return !(/datum/dna/gene/basic/cold_resist in69.active_genes)
		// Probability check
		var/_prob = 15
		if(COLD_RESISTANCE in69.mutations)
			_prob=5
		if(probinj(_prob,(flags&MUTCHK_FORCED)))
			return 1

	OnDrawUnderlays(var/mob/M,var/g,var/fat)
		return "cold69fat69_s"
*/

/datum/dna/gene/basic/cold_resist
	name="Cold Resistance"
	activation_messages=list("Your body is filled with warmth.")
	mutation=COLD_RESISTANCE

	New()
		block=FIREBLOCK

	can_activate(var/mob/M,var/flags)
		if(flags &69UTCHK_FORCED)
			return 1
		//	return !(/datum/dna/gene/basic/heat_resist in69.active_genes)
		// Probability check
		var/_prob=30
		//if(mHeatres in69.mutations)
		//	_prob=5
		if(probinj(_prob,(flags&MUTCHK_FORCED)))
			return 1

	OnDrawUnderlays(var/mob/M,var/g)
		return "fire_s"

/datum/dna/gene/basic/noprints
	name="No Prints"
	activation_messages=list("Your fingers feel numb.")
	mutation=mFingerprints

	New()
		block=NOPRINTSBLOCK

/datum/dna/gene/basic/noshock
	name="Shock Immunity"
	activation_messages=list("Your skin feels strange.")
	mutation=mShock

	New()
		block=SHOCKIMMUNITYBLOCK

/datum/dna/gene/basic/midget
	name="Midget"
	activation_messages=list("Your skin feels rubbery.")
	mutation=mSmallsize

	New()
		block=SMALLSIZEBLOCK

	can_activate(var/mob/M,var/flags)
		// Can't be big and small.
		if(HULK in69.mutations)
			return 0
		return ..(M,flags)

	activate(var/mob/M,69ar/connected,69ar/flags)
		..(M,connected,flags)
		M.pass_flags |= 1

	deactivate(var/mob/M,69ar/connected,69ar/flags)
		..(M,connected,flags)
		M.pass_flags &= ~1 //This69ay cause issues down the track, but offhand I can't think of any other way for humans to get passtable short of69arediting so it should be fine. ~Z

/datum/dna/gene/basic/hulk
	name="Hulk"
	activation_messages=list("Your69uscles hurt.")
	mutation=HULK

	New()
		block=HULKBLOCK

	can_activate(var/mob/M,var/flags)
		// Can't be big and small.
		if(mSmallsize in69.mutations)
			return 0
		return ..(M,flags)

	OnDrawUnderlays(var/mob/M,var/g)
		return "hulk_69g69_s"

	OnMobLife(var/mob/living/carbon/human/M)
		if(!istype(M)) return
		if(M.health <= 25)
			M.mutations.Remove(HULK)
			M.update_mutations()		//update our69utation overlays
			to_chat(M, SPAN_WARNING("You suddenly feel69ery weak."))
			M.Weaken(3)
			M.emote("collapse")

/datum/dna/gene/basic/xray
	name="X-Ray69ision"
	activation_messages=list("The walls suddenly disappear.")
	mutation=XRAY

	New()
		block=XRAYBLOCK

/datum/dna/gene/basic/tk
	name="Telekenesis"
	activation_messages=list("You feel smarter.")
	mutation=TK
	activation_prob=15

	New()
		block=TELEBLOCK
	OnDrawUnderlays(var/mob/M,var/g,var/fat)
		return "telekinesishead_s"
