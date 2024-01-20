/mob/living/carbon/human
	//first and last name
	var/first_name
	var/last_name

	//Hair colour and style
	var/hair_color = "#000000"
	var/h_style = "Bald"

	//Facial hair colour and style
	var/facial_color = "#000000"
	var/f_style = "Shaved"

	//Eye colour
	var/eyes_color = "#000000"

	var/s_tone = 0	//Skin tone

	//Skin colour
	var/skin_color = "#000000"

	var/size_multiplier = 1 //multiplier for the mob's icon size
	var/damage_multiplier = 1 //multiplies melee combat damage
	var/icon_update = 1 //whether icon updating shall take place

	/// How much energy we currently have for combat actions
	var/energy = 100
	/// How much energy we regenerate per human life tick
	var/energyRegenRate = 10
	/// Maximum permitted, can be increased with stimulants
	var/maxEnergy = 100
	/// Triggers a energy update on the next life tick.
	var/needsEnergyUpdate = FALSE


	var/lip_style	//no lipstick by default- arguably misleading, as it could be used for general makeup

	var/age = 30		//Player's age (pure fluff)

	var/list/worn_underwear = list()

	var/datum/backpack_setup/backpack_setup

	//Equipment slots
	var/obj/item/wear_suit
	var/obj/item/w_uniform
	var/obj/item/shoes
	var/obj/item/belt
	var/obj/item/gloves
	var/obj/item/glasses
	var/obj/item/head
	var/obj/item/l_ear
	var/obj/item/r_ear
	var/obj/item/wear_id
	var/obj/item/r_store
	var/obj/item/l_store
	var/obj/item/s_store

	var/icon/stand_icon
	var/icon/lying_icon

	var/voice = ""	//Instead of new say code calling GetVoice() over and over and over, we're just going to ask this variable, which gets updated in Life()

	var/speech_problem_flag = 0

	var/miming //Toggle for the mime's abilities.
	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/ability_last = 0 // world.time when last proc from "Ability" tab have been used
	var/last_dam = -1	//Used for determining if we need to process all organs or just some or even none.
	var/list/bad_external_organs = list()// organs we check until they are good.

	var/punch_damage_increase = 0 // increases... punch damage... can be affected by clothing or implants.

	var/xylophone = 0 //For the spoooooooky xylophone cooldown

	var/mob/remoteview_target
	var/remoteviewer = FALSE //Acts as an override for remoteview_target viewing, see human/life.dm: handle_vision()
	var/hand_blood_color

	var/gunshot_residue
	var/holding_back // Are you trying not to hurt your opponent?
	var/blocking = FALSE //ready to block melee attacks?

	mob_bump_flag = HUMAN
	mob_push_flags = ~HEAVY
	mob_swap_flags = ~HEAVY

	var/flash_protection = 0				// Total level of flash protection
	var/equipment_tint_total = 0			// Total level of visualy impairing items
	var/equipment_darkness_modifier			// Darkvision modifier from equipped items
	var/equipment_vision_flags				// Extra vision flags from equipped items
	var/equipment_see_invis					// Max see invibility level granted by equipped items
	var/equipment_prescription				// Eye prescription granted by equipped items
	var/list/equipment_overlays = list()	// Extra overlays from equipped items

	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/exploit_record = ""

	var/stance_damage = 0 //Whether this mob's ability to stand has been affected
	var/identifying_gender // In case the human identifies as another gender than it's biological
	mob_classification = CLASSIFICATION_ORGANIC | CLASSIFICATION_HUMANOID

	var/datum/sanity/sanity

	var/rest_points = 0

	var/style = 0
	var/max_style = MAX_HUMAN_STYLE

	var/shock_resist = 0 // Resistance to paincrit

	var/language_blackout = 0
	var/suppress_communication = 0

	var/momentum_speed = 0 // The amount of run-up
	var/momentum_dir = 0 // Direction of run-up
	var/momentum_reduction_timer

	var/statusEffects = list()
