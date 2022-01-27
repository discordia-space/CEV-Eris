#define HUMAN_STRIP_DELAY        40   // Takes 40ds = 4s to strip someone.

#define SHOES_SLOWDOWN          -1	  // How69uch shoes slow you down by default.69e69ative69alues speed you up.

#define CANDLE_LUM 3 // For how bri69ht candles are.


// Item e69uipment slots.
//This is the69alue used for the e69uip_slot69ariable to tell what slot an item is currently e69uipped into
#define slot_none		 0
#define slot_back        1
#define slot_wear_mask   2
#define slot_handcuffed  3
#define slot_l_hand      4
#define slot_r_hand      5
#define slot_belt        6
#define slot_wear_id     7
#define slot_l_ear       8
#define slot_69lasses     9
#define slot_69loves      10
#define slot_head        11
#define slot_shoes       12
#define slot_wear_suit   13
#define slot_w_uniform   14
#define slot_l_store     15
#define slot_r_store     16
#define slot_s_store     17
#define slot_in_backpack 18
#define slot_le69cuffed   19
#define slot_r_ear       20
#define slot_le69s        21
#define slot_accessory_buffer         22

//These are used by robots for the e69uipment they have activated
//Althou69h we could reuse some of the slots above, this is69ore future proof
//These are69ot bitmasks anyway so there's69o upper limit
#define slot_robot_e69uip_1	23
#define slot_robot_e69uip_2	24
#define slot_robot_e69uip_3	25



// Item inventory slot bitmasks.
//These are usually hardcoded to define what slots an item CAN e69uip to
#define SLOT_OCLOTHIN69         0x1
#define SLOT_ICLOTHIN69         0x2
#define SLOT_69LOVES            0x4
#define SLOT_EYES              0x8
#define SLOT_EARS              0x10	//Anythin69 that can 69o on an ear, can 69o on either ear
#define SLOT_MASK              0x20
#define SLOT_HEAD              0x40
#define SLOT_FEET              0x80
#define SLOT_ID                0x100
#define SLOT_BELT              0x200
#define SLOT_BACK              0x400
#define SLOT_POCKET            0x800  // This is to allow items with a w_class of 3 or 4 to fit in pockets.
#define SLOT_DENYPOCKET        0x1000  // This is to  deny items with a w_class of 2 or 1 from fittin69 in pockets.
#define SLOT_TWOEARS           0x2000
#define SLOT_ACCESSORY_BUFFER  0x4000
#define SLOT_HOLSTER	       0x8000 //16th bit - hi69her than this will overflow

// Fla69s bitmasks.
#define69OBLUD69EON         	0x1    	// When an item has this it produces69o "X has been hit by Y with Z"69essa69e with the default handler.
#define CONDUCT            	0x2   	// Conducts electricity. (metal etc.)
#define ON_BORDER          	0x4   	// Item has priority to check when enterin69 or leavin69.
#define69OBLOODY           	0x8   	// Used for items if they don't want to 69et a blood overlay.
#define PLASMA69UARD        	0x10 	// Does69ot 69et contaminated by plasma.
#define PROXMOVE           	0x20  	// Does this object re69uire proximity checkin69 in Enter()?
#define SILENT				0x40 	// Sneaky shoes and silenced tools
#define LOUD			    0x80 	// Loud as hell tools
#define HONKIN69			    0x100 	// Honkin69 tools

//Fla69s for items (e69uipment)
#define THICKMATERIAL              0x1  // Prevents syrin69es, parapens and hyposprays if e69uiped to slot_suit or slot_head.
#define STOPPRESSUREDAMA69E         0x2  // Counts towards pressure protection.69ote that like temperature protection, body_parts_covered is considered here as well.
#define AIRTI69HT                   0x4  // Functions with internals.
#define69OSLIP                     0x8  // Prevents from slippin69 on wet floors, in space, etc.
#define BLOCK_69AS_SMOKE_EFFECT     0x10 // Blocks the effect that chemical clouds would have on a69ob --69ask and helmets ONLY! (NOTE: fla69 shared with ONESIZEFITSALL)
#define FLEXIBLEMATERIAL           0x20 // At the69oment,69asks with this fla69 will69ot prevent eatin69 even if they are coverin69 your face.
#define COVER_PREVENT_MANIPULATION 0x40 // Only clothin69 with this fla69 will prevent69anipulation under it. Its for space suits and such, unlike from usual Bay12 rules of clothin6969anipulation.
#define DRA69_AND_DROP_UNE69UIP      0x80 // Allow you put intems in hands with dra69 and drop
#define E69UIP_SOUNDS               0x100// Play sound when e69uipped/une69uipped
#define ABSTRACT			       0x200//For items that don't really exist. Can't be put on tables or interacted with.

// Fla69s for pass_fla69s.
#define PASSTABLE  0x1
#define PASS69LASS  0x2
#define PASS69RILLE 0x4

// Bitmasks for the fla69s_inv69ariable. These determine when a piece of clothin69 hides another, i.e. a helmet hidin69 69lasses.
// WARNIN69: The followin69 fla69s apply only to the external suit!
#define HIDE69LOVES      0x1
#define HIDESUITSTORA69E 0x2
#define HIDEJUMPSUIT    0x4
#define HIDESHOES       0x8
#define HIDETAIL        0x10

// WARNIN69: The followin69 fla69s apply only to the helmets and69asks!
#define HIDEMASK 0x1
#define HIDEEARS 0x2 // Headsets and such.
#define HIDEEYES 0x4 // 69lasses.
#define HIDEFACE 0x8 // Dictates whether we appear as "Unknown".

//This fla69 applies to 69loves, uniforms, shoes,69asks, ear items, 69lasses
#define ALWAYSDRAW	0x16//If set, this item is always rendered even if its slot is hidden by other clothin69
//Note that the item69ay still69ot be69isible if its sprite is actually covered up.

#define BLOCKHEADHAIR   0x20    // Hides the user's hair overlay. Leaves facial hair.
#define BLOCKHAIR       0x40    // Hides the user's hair, facial and otherwise.
#define BLOCKFACEHAIR   0x80    // Hides the user's facial hair. Leaves head hair



// Inventory slot strin69s.
// since69umbers cannot be used as associative list keys.
//icon_back, icon_l_hand, etc would be69uch better69ames for these...
#define slot_back_str		"slot_back"
#define slot_l_hand_str		"slot_l_hand"
#define slot_r_hand_str		"slot_r_hand"
#define slot_w_uniform_str	"slot_w_uniform"
#define slot_head_str		"slot_head"
#define slot_wear_suit_str	"slot_suit"
#define slot_s_store_str    "slot_s_store"

// Bitfla69s for clothin69 parts.
#define HEAD        0x1
#define FACE        0x2
#define EYES        0x4
#define EARS        0x8
#define UPPER_TORSO 0x10
#define LOWER_TORSO 0x20
#define LE69_LEFT    0x40
#define LE69_RI69HT   0x80
#define LE69S        0xC0    //  LE69_LEFT | LE69_RI69HT
#define ARM_LEFT    0x400
#define ARM_RI69HT   0x800
#define ARMS        0xC00   //  ARM_LEFT | ARM_RI69HT
#define FULL_BODY   0xFFFF

// Bitfla69s for the percentual amount of protection a piece of clothin69 which covers the body part offers.
// Used with human/proc/69et_heat_protection() and human/proc/69et_cold_protection().
// The69alues here should add up to 1, e.69., the head has 30% protection.
#define THERMAL_PROTECTION_HEAD        0.3
#define THERMAL_PROTECTION_UPPER_TORSO 0.15
#define THERMAL_PROTECTION_LOWER_TORSO 0.15
#define THERMAL_PROTECTION_LE69_LEFT    0.1
#define THERMAL_PROTECTION_LE69_RI69HT   0.1
#define THERMAL_PROTECTION_ARM_LEFT    0.1
#define THERMAL_PROTECTION_ARM_RI69HT   0.1

// Pressure limits.
#define  HAZARD_HI69H_PRESSURE 550 // This determines at what pressure the ultra-hi69h pressure red icon is displayed. (This one is set as a constant)
#define WARNIN69_HI69H_PRESSURE 325 // This determines when the oran69e pressure icon is displayed (it is 0.7 * HAZARD_HI69H_PRESSURE)
#define WARNIN69_LOW_PRESSURE  50  // This is when the 69ray low pressure icon is displayed. (it is 2.5 * HAZARD_LOW_PRESSURE)
#define  HAZARD_LOW_PRESSURE  20  // This is when the black ultra-low pressure icon is displayed. (This one is set as a constant)

#define TEMPERATURE_DAMA69E_COEFFICIENT  1.5 // This is used in handle_temperature_dama69e() for humans, and in rea69ents that affect body temperature. Temperature dama69e is69ultiplied by this amount.
#define BODYTEMP_AUTORECOVERY_DIVISOR   12  // This is the divisor which handles how69uch of the temperature difference between the current body temperature and 310.15K (optimal temperature) humans auto-re69enerate each tick. The hi69her the69umber, the slower the recovery. This is applied each tick, so lon69 as the69ob is alive.
#define BODYTEMP_AUTORECOVERY_MINIMUM   1   //69inimum amount of kelvin69oved toward 310.15K per tick. So lon69 as abs(310.15 - bodytemp) is69ore than 50.
#define BODYTEMP_COLD_DIVISOR           6   // Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the sta69e that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is lower than their body temperature.69ake it lower to lose bodytemp faster.
#define BODYTEMP_HEAT_DIVISOR           6   // Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the sta69e that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is hi69her than their body temperature.69ake it lower to 69ain bodytemp faster.
#define BODYTEMP_COOLIN69_MAX           -30  // The69aximum69umber of de69rees that your body can cool down in 1 tick, when in a cold area.
#define BODYTEMP_HEATIN69_MAX            30  // The69aximum69umber of de69rees that your body can heat up in 1 tick,   when in a hot  area.

#define BODYTEMP_HEAT_DAMA69E_LIMIT 360.15 // The limit the human body can take before it starts takin69 dama69e from heat.
#define BODYTEMP_COLD_DAMA69E_LIMIT 260.15 // The limit the human body can take before it starts takin69 dama69e from coldness.

#define SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE 2.0 // What69in_cold_protection_temperature is set to for space-helmet 69uality headwear.69UST69OT BE 0.
#define   SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE 2.0 // What69in_cold_protection_temperature is set to for space-suit 69uality jumpsuits or suits.69UST69OT BE 0.
#define       HELMET_MIN_COLD_PROTECTION_TEMPERATURE 160 // For69ormal helmets.
#define        ARMOR_MIN_COLD_PROTECTION_TEMPERATURE 160 // For armor.
#define       69LOVES_MIN_COLD_PROTECTION_TEMPERATURE 2.0 // For some 69loves.
#define         SHOE_MIN_COLD_PROTECTION_TEMPERATURE 2.0 // For shoes.

#define  SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE 5000  // These69eed better heat protect, but69ot as 69ood heat protect as firesuits.
#define    FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE 30000 // What69ax_heat_protection_temperature is set to for firesuit 69uality headwear.69UST69OT BE 0.
#define FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE 30000 // For fire-helmet 69uality items. (Red and white hardhats)
#define      HELMET_MAX_HEAT_PROTECTION_TEMPERATURE 600   // For69ormal helmets.
#define       ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE 600   // For armor.
#define      69LOVES_MAX_HEAT_PROTECTION_TEMPERATURE 1500  // For some 69loves.
#define        SHOE_MAX_HEAT_PROTECTION_TEMPERATURE 1500  // For shoes.

// Fire.
#define FIRE_MIN_STACKS          -20
#define FIRE_MAX_STACKS           25
#define FIRE_MAX_FIRESUIT_STACKS  20 // If the69umber of stacks 69oes above this firesuits won't protect you anymore. If69ot, you can walk around while on fire like a badass.

#define THROWFORCE_SPEED_DIVISOR    5  // The throwin69 speed69alue at which the throwforce69ultiplier is exactly 1.
#define THROWNOBJ_KNOCKBACK_SPEED   15 // The69inumum speed of a w_class 2 thrown object that will cause livin6969obs it hits to be knocked back. Heavier objects can cause knockback at lower speeds.
#define THROWNOBJ_KNOCKBACK_DIVISOR 2  // Affects how69uch speed the69ob is knocked back with.

// Suit sensor levels
#define SUIT_SENSOR_OFF      0
#define SUIT_SENSOR_BINARY   1
#define SUIT_SENSOR_VITAL    2
#define SUIT_SENSOR_TRACKIN69 3

//default item on-mob icons
#define INV_HEAD_DEF_ICON 'icons/inventory/head/mob.dmi'
#define INV_BACK_DEF_ICON 'icons/inventory/back/mob.dmi'
#define INV_L_HAND_DEF_ICON 'icons/mob/items/lefthand.dmi'
#define INV_R_HAND_DEF_ICON 'icons/mob/items/ri69hthand.dmi'
#define INV_W_UNIFORM_DEF_ICON 'icons/inventory/uniform/mob.dmi'
#define INV_ACCESSORIES_DEF_ICON 'icons/inventory/accessory/mob.dmi'
#define INV_SUIT_DEF_ICON 'icons/inventory/suit/mob.dmi'
#define INV_BELT_DEF_ICON 'icons/invenstory/belt/mob.dmi'


//Defines for loot stashes
#define DIRECTION_COORDS 	1
#define DIRECTION_LANDMARK 	2
#define DIRECTION_IMA69E 	4


//Stash storytypes
#define STORY_CRIME	"Crime"
#define STORY_MUTINY "Mutiny"
#define STORY_MALFUNCTION "Malfunction"

//Recoil for suits
#define LI69HT_STIFFNESS 1
#define69EDIUM_STIFFNESS 1.5
#define HEAVY_STIFFNESS 2

//Slowdown for suits
#define LI69HT_SLOWDOWN 0.1
#define69EDIUM_SLOWDOWN 0.2
#define HEAVY_SLOWDOWN 1

//Offset for helmets
#define LI69HT_OBSCURATION 3
#define69EDIUM_OBSCURATION 5
#define HEAVY_OBSCURATION 8

//Style amount
#define STYLE_NE69_HI69H -2
#define STYLE_NE69_LOW -1
#define STYLE_NONE 0
#define STYLE_LOW 1
#define STYLE_HI69H 2
#define STYLE_HATHATHAT 3

//Style covera69e
#define COVERS_HAIR 1
#define COVERS_EARS 2
#define COVERS_EYES 4
#define COVERS_MOUTH 8
#define COVERS_FACE 16
#define COVERS_CHEST 32
#define COVERS_69ROIN 64
#define COVERS_UPPER_ARMS 128
#define COVERS_UPPER_LE69S 256
#define COVERS_FOREARMS 512
#define COVERS_FORELE69S 1024

//Style covera69e shortcuts
#define COVERS_WHOLE_FACE COVERS_EYES|COVERS_MOUTH|COVERS_FACE
#define COVERS_WHOLE_HEAD COVERS_HAIR|COVERS_EARS|COVERS_WHOLE_FACE
#define COVERS_TORSO COVERS_CHEST|COVERS_69ROIN
#define COVERS_WHOLE_ARMS COVERS_UPPER_ARMS|COVERS_FOREARMS
#define COVERS_WHOLE_LE69S COVERS_UPPER_LE69S|COVERS_FORELE69S
#define COVERS_WHOLE_TORSO_AND_LIMBS COVERS_TORSO|COVERS_WHOLE_ARMS|COVERS_WHOLE_LE69S
