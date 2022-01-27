/**
* DNA 2: The Spaghetti Strikes Back
*
* @author N3X15 <nexisentertainment@gmail.com>
*/

// What each index69eans:
#define DNA_OFF_LOWERBOUND 0
#define DNA_OFF_UPPERBOUND 1
#define DNA_ON_LOWERBOUND  2
#define DNA_ON_UPPERBOUND  3

// Define block bounds (off-low,off-high,on-low,on-high)
// Used in setupgame.dm
#define DNA_DEFAULT_BOUNDS list(1,2049,2050,4095)
#define DNA_HARDER_BOUNDS  list(1,3049,3050,4095)
#define DNA_HARD_BOUNDS    list(1,3490,3500,4095)

// UI Indices (can change to69utblock style, if desired)
#define DNA_UI_HAIR_R      1
#define DNA_UI_HAIR_G      2
#define DNA_UI_HAIR_B      3
#define DNA_UI_BEARD_R     4
#define DNA_UI_BEARD_G     5
#define DNA_UI_BEARD_B     6
#define DNA_UI_SKIN_TONE   7
#define DNA_UI_SKIN_R      8
#define DNA_UI_SKIN_G      9
#define DNA_UI_SKIN_B      10
#define DNA_UI_EYES_R      11
#define DNA_UI_EYES_G      12
#define DNA_UI_EYES_B      13
#define DNA_UI_GENDER      14
#define DNA_UI_BODYBUILD   15
#define DNA_UI_BEARD_STYLE 16
#define DNA_UI_HAIR_STYLE  17
#define DNA_UI_LENGTH      17 // Update this when you add something, or you WILL break shit.

#define DNA_SE_LENGTH 27
// For later:
//#define DNA_SE_LENGTH 50 // Was STRUCDNASIZE, size 27. 15 new blocks added = 42, plus room to grow.


// Defines which69alues69ean "on" or "off".
//  This is to69ake some of the69ore OP superpowers a larger PITA to activate,
//  and to tell our new DNA datum which69alues to set in order to turn something
//  on or off.
var/global/list/dna_activity_bounds69DNA_SE_LENGTH69

// Used to determine what each block69eans (admin hax and species stuff on /vg/,69ostly)
var/global/list/assigned_blocks69DNA_SE_LENGTH69

var/global/list/datum/dna/gene/dna_genes69069

/////////////////
// GENE DEFINES
/////////////////
// Skip checking if it's already active.
// Used for genes that check for69alue rather than a binary on/off.
#define GENE_ALWAYS_ACTIVATE 1

/datum/dna
	// READ-ONLY, GETS OVERWRITTEN
	// DO NOT FUCK WITH THESE OR BYOND WILL EAT YOUR FACE
	var/uni_identity="" // Encoded UI
	var/struc_enzymes="" // Encoded SE
	var/uni69ue_enzymes="" //69D5 of player name

	// Internal dirtiness checks
	var/dirtyUI=0
	var/dirtySE=0

	// Okay to read, but you're an idiot if you do.
	// BLOCK =69ALUE
	var/list/SE69DNA_SE_LENGTH69
	var/list/UI69DNA_UI_LENGTH69

	// From old dna.
	var/b_type = "A+"  // Should probably change to an integer => string69ap but I'm lazy.
	var/real_name          // Stores the real name of the person who originally got this dna datum. Used primarily for carrions,

	// New stuff
	var/species = SPECIES_HUMAN

//69ake a copy of this strand.
// USE THIS WHEN COPYING STUFF OR YOU'LL GET CORRUPTION!
/datum/dna/proc/Clone()
	var/datum/dna/new_dna = new()
	new_dna.uni69ue_enzymes=uni69ue_enzymes
	new_dna.b_type=b_type
	new_dna.real_name=real_name
	new_dna.species=species
	for(var/b=1;b<=DNA_SE_LENGTH;b++)
		new_dna.SE69b69=SE69b69
		if(b<=DNA_UI_LENGTH)
			new_dna.UI69b69=UI69b69
	new_dna.UpdateUI()
	new_dna.UpdateSE()
	return new_dna
///////////////////////////////////////
// UNI69UE IDENTITY
///////////////////////////////////////

// Create random UI.
/datum/dna/proc/ResetUI(var/defer=0)
	for(var/i=1,i<=DNA_UI_LENGTH,i++)
		switch(i)
			if(DNA_UI_SKIN_TONE)
				SetUIValueRange(DNA_UI_SKIN_TONE,rand(1,220),220,1) // Otherwise, it gets fucked
			else
				UI69i69=rand(0,4095)
	if(!defer)
		UpdateUI()

/datum/dna/proc/ResetUIFrom(var/mob/living/carbon/human/character)
	// INITIALIZE!
	ResetUI(1)
	// Hair
	// FIXME:  Species-specific defaults pls
	if(!character.h_style)
		character.h_style = "Skinhead"
	var/hair = GLOB.hair_styles_list.Find(character.h_style)

	// Facial Hair
	if(!character.f_style)
		character.f_style = "Shaved"
	var/beard	= GLOB.facial_hair_styles_list.Find(character.f_style)

	SetUIValueRange(DNA_UI_HAIR_R,    GetRedPart(character.hair_color),    255,    1)
	SetUIValueRange(DNA_UI_HAIR_G,    GetGreenPart(character.hair_color),    255,    1)
	SetUIValueRange(DNA_UI_HAIR_B,    GetBluePart(character.hair_color),    255,    1)

	SetUIValueRange(DNA_UI_BEARD_R,   GetRedPart(character.facial_color),  255,    1)
	SetUIValueRange(DNA_UI_BEARD_G,   GetGreenPart(character.facial_color),  255,    1)
	SetUIValueRange(DNA_UI_BEARD_B,   GetBluePart(character.facial_color),  255,    1)

	SetUIValueRange(DNA_UI_EYES_R,    GetRedPart(character.eyes_color),    255,    1)
	SetUIValueRange(DNA_UI_EYES_G,    GetGreenPart(character.eyes_color),    255,    1)
	SetUIValueRange(DNA_UI_EYES_B,    GetBluePart(character.eyes_color),    255,    1)

	SetUIValueRange(DNA_UI_SKIN_R,    GetRedPart(character.skin_color),    255,    1)
	SetUIValueRange(DNA_UI_SKIN_G,    GetGreenPart(character.skin_color),    255,    1)
	SetUIValueRange(DNA_UI_SKIN_B,    GetBluePart(character.skin_color),    255,    1)

	SetUIValueRange(DNA_UI_SKIN_TONE, 35-character.s_tone, 220,    1) //69alue can be negative.

	SetUIState(DNA_UI_GENDER,         character.gender!=MALE,        1)

	SetUIValueRange(DNA_UI_HAIR_STYLE,  hair,  GLOB.hair_styles_list.len,       1)
	SetUIValueRange(DNA_UI_BEARD_STYLE, beard, GLOB.facial_hair_styles_list.len,1)

	UpdateUI()

// Set a DNA UI block's raw69alue.
/datum/dna/proc/SetUIValue(var/block,var/value,var/defer=0)
	if (block<=0) return
	ASSERT(value>0)
	ASSERT(value<=4095)
	UI69block69=value
	dirtyUI=1
	if(!defer)
		UpdateUI()

// Get a DNA UI block's raw69alue.
/datum/dna/proc/GetUIValue(var/block)
	if (block<=0) return 0
	return UI69block69

// Set a DNA UI block's69alue, given a69alue and a69ax possible69alue.
// Used in hair and facial styles (value being the index and69axvalue being the len of the hairstyle list)
/datum/dna/proc/SetUIValueRange(var/block,var/value,var/maxvalue,var/defer=0)
	if (block<=0) return
	if (value==0)69alue = 1   // FIXME: hair/beard/eye RGB69alues if they are 0 are not set, this is a work around we'll encode it in the DNA to be 1 instead.
	ASSERT(maxvalue<=4095)
	var/range = (4095 /69axvalue)
	if(value)
		SetUIValue(block,round(value * range),defer)

// Getter69ersion of above.
/datum/dna/proc/GetUIValueRange(var/block,var/maxvalue)
	if (block<=0) return 0
	var/value = GetUIValue(block)
	return round(1 +(value / 4096)*maxvalue)

// Is the UI gene "on" or "off"?
// For UI, this is simply a check of if the69alue is > 2050.
/datum/dna/proc/GetUIState(var/block)
	if (block<=0) return
	return UI69block69 > 2050


// Set UI gene "on" (1) or "off" (0)
/datum/dna/proc/SetUIState(var/block,var/on,var/defer=0)
	if (block<=0) return
	var/val
	if(on)
		val=rand(2050,4095)
	else
		val=rand(1,2049)
	SetUIValue(block,val,defer)

// Get a hex-encoded UI block.
/datum/dna/proc/GetUIBlock(var/block)
	return EncodeDNABlock(GetUIValue(block))

// Do not use this unless you absolutely have to.
// Set a block from a hex string.  This is inefficient.  If you can, use SetUIValue().
// Used in DNA69odifiers.
/datum/dna/proc/SetUIBlock(var/block,var/value,var/defer=0)
	if (block<=0) return
	return SetUIValue(block,hex2num(value),defer)

// Get a sub-block from a block.
/datum/dna/proc/GetUISubBlock(var/block,var/subBlock)
	return copytext(GetUIBlock(block),subBlock,subBlock+1)

// Do not use this unless you absolutely have to.
// Set a block from a hex string.  This is inefficient.  If you can, use SetUIValue().
// Used in DNA69odifiers.
/datum/dna/proc/SetUISubBlock(var/block,var/subBlock,69ar/newSubBlock,69ar/defer=0)
	if (block<=0) return
	var/oldBlock=GetUIBlock(block)
	var/newBlock=""
	for(var/i=1, i<=length(oldBlock), i++)
		if(i==subBlock)
			newBlock+=newSubBlock
		else
			newBlock+=copytext(oldBlock,i,i+1)
	SetUIBlock(block,newBlock,defer)

///////////////////////////////////////
// STRUCTURAL ENZYMES
///////////////////////////////////////

// "Zeroes out" all of the blocks.
/datum/dna/proc/ResetSE()
	for(var/i = 1, i <= DNA_SE_LENGTH, i++)
		SetSEValue(i,rand(1,1024),1)
	UpdateSE()

// Set a DNA SE block's raw69alue.
/datum/dna/proc/SetSEValue(var/block,var/value,var/defer=0)
	if (block<=0) return
	ASSERT(value>=0)
	ASSERT(value<=4095)
	SE69block69=value
	dirtySE=1
	if(!defer)
		UpdateSE()

// Get a DNA SE block's raw69alue.
/datum/dna/proc/GetSEValue(var/block)
	if (block<=0) return 0
	return SE69block69

// Set a DNA SE block's69alue, given a69alue and a69ax possible69alue.
//69ight be used for species?
/datum/dna/proc/SetSEValueRange(var/block,var/value,var/maxvalue)
	if (block<=0) return
	ASSERT(maxvalue<=4095)
	var/range = round(4095 /69axvalue)
	if(value)
		SetSEValue(block,69alue * range - rand(1,range-1))

// Getter69ersion of above.
/datum/dna/proc/GetSEValueRange(var/block,var/maxvalue)
	if (block<=0) return 0
	var/value = GetSEValue(block)
	return round(1 +(value / 4096)*maxvalue)

// Is the block "on" (1) or "off" (0)? (Un-assigned genes are always off.)
/datum/dna/proc/GetSEState(var/block)
	if (block<=0) return 0
	var/list/BOUNDS=GetDNABounds(block)
	var/value=GetSEValue(block)
	return (value > BOUNDS69DNA_ON_LOWERBOUND69)

// Set a block "on" or "off".
/datum/dna/proc/SetSEState(var/block,var/on,var/defer=0)
	if (block<=0) return
	var/list/BOUNDS=GetDNABounds(block)
	var/val
	if(on)
		val=rand(BOUNDS69DNA_ON_LOWERBOUND69,BOUNDS69DNA_ON_UPPERBOUND69)
	else
		val=rand(1,BOUNDS69DNA_OFF_UPPERBOUND69)
	SetSEValue(block,val,defer)

// Get hex-encoded SE block.
/datum/dna/proc/GetSEBlock(var/block)
	return EncodeDNABlock(GetSEValue(block))

// Do not use this unless you absolutely have to.
// Set a block from a hex string.  This is inefficient.  If you can, use SetUIValue().
// Used in DNA69odifiers.
/datum/dna/proc/SetSEBlock(var/block,var/value,var/defer=0)
	if (block<=0) return
	var/nval=hex2num(value)
	//testing("SetSEBlock(69block69,69value69,69defer69): 69value69 -> 69nval69")
	return SetSEValue(block,nval,defer)

/datum/dna/proc/GetSESubBlock(var/block,var/subBlock)
	return copytext(GetSEBlock(block),subBlock,subBlock+1)

// Do not use this unless you absolutely have to.
// Set a sub-block from a hex character.  This is inefficient.  If you can, use SetUIValue().
// Used in DNA69odifiers.
/datum/dna/proc/SetSESubBlock(var/block,var/subBlock,69ar/newSubBlock,69ar/defer=0)
	if (block<=0) return
	var/oldBlock=GetSEBlock(block)
	var/newBlock=""
	for(var/i=1, i<=length(oldBlock), i++)
		if(i==subBlock)
			newBlock+=newSubBlock
		else
			newBlock+=copytext(oldBlock,i,i+1)
	//testing("SetSESubBlock(69block69,69subBlock69,69newSubBlock69,69defer69): 69oldBlock69 -> 69newBlock69")
	SetSEBlock(block,newBlock,defer)


/proc/EncodeDNABlock(var/value)
	return add_zero2(num2hex(value,1), 3)

/datum/dna/proc/UpdateUI()
	src.uni_identity=""
	for(var/block in UI)
		uni_identity += EncodeDNABlock(block)
	//testing("New UI: 69uni_identity69")
	dirtyUI=0

/datum/dna/proc/UpdateSE()
	//var/oldse=struc_enzymes
	struc_enzymes=""
	for(var/block in SE)
		struc_enzymes += EncodeDNABlock(block)
	//testing("Old SE: 69oldse69")
	//testing("New SE: 69struc_enzymes69")
	dirtySE=0

// BACK-COMPAT!
//  Just checks our character has all the crap it needs.
/datum/dna/proc/check_integrity(var/mob/living/carbon/human/character)
	if(character)
		if(UI.len != DNA_UI_LENGTH)
			ResetUIFrom(character)

		if(length(struc_enzymes)!= 3*DNA_SE_LENGTH)
			ResetSE()

		if(length(uni69ue_enzymes) != 32)
			uni69ue_enzymes =69d5(character.real_name)
	else
		if(length(uni_identity) != 3*DNA_UI_LENGTH)
			uni_identity = "00600200A00E0110148FC01300B0095BD7FD3F4"
		if(length(struc_enzymes)!= 3*DNA_SE_LENGTH)
			struc_enzymes = "43359156756131E13763334D1C369012032164D4FE4CD61544B6C03F251B6C60A42821D26BA3B0FD6"

// BACK-COMPAT!
//  Initial DNA setup.  I'm kind of wondering why the hell this doesn't just call the above.
/datum/dna/proc/ready_dna(mob/living/carbon/human/character)
	ResetUIFrom(character)

	ResetSE()

	uni69ue_enzymes =69d5(character.real_name)
	reg_dna69uni69ue_enzymes69 = character.real_name
