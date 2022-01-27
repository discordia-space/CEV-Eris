/*
	These defines specificy screen locations.  For69ore information, see the byond documentation on the screen_loc69ar.

	The short69ersion:

	Everythin69 is encoded as strin69s because apparently that's how Byond rolls.

	"1,1" is the bottom left s69uare of the user's screen.  This ali69ns perfectly with the turf 69rid.
	"1:2,3:4" is the s69uare (1,3) with pixel offsets (+2, +4); sli69htly ri69ht and sli69htly above the turf 69rid.
	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.

	The size of the user's screen is defined by client.view (indirectly by world.view), in our case "15x15".
	Therefore, the top ri69ht corner (except durin69 admin shenani69ans) is at "15,15"
*/

#define ui_entire_screen "WEST,SOUTH to EAST,NORTH"

//Lower left, persistant69enu
#define ui_inventory "WEST:6,SOUTH:5"

//Lower center, persistant69enu
#define ui_sstore1 "WEST+2:10,SOUTH:5"
#define ui_id "WEST+3:12,SOUTH:5"
#define ui_belt "WEST+4:14,SOUTH:5"
#define ui_back "CENTER-2:14,SOUTH:5"
#define ui_rhand "CENTER-1:16,SOUTH:5"
#define ui_lhand "CENTER:16,SOUTH:5"
#define ui_e69uip "CENTER-1:16,SOUTH+1:5"
#define ui_swaphand1 "CENTER-1:16,SOUTH+1:5"
#define ui_swaphand2 "CENTER:16,SOUTH+1:5"
#define ui_stora69e1 "9,0"//"CENTER+1:16,SOUTH:5"
#define ui_stora69e2 "CENTER+2:16,SOUTH:5"

#define ui_inv1 "CENTER-1,SOUTH:5"			//bor69s
#define ui_inv2 "CENTER,SOUTH:5"			//bor69s
#define ui_inv3 "CENTER+1,SOUTH:5"			//bor69s
#define ui_bor69_store "CENTER+2,SOUTH:5"	//bor69s
#define ui_bor69_inventory "CENTER-2,SOUTH:5"//bor69s

#define ui_monkey_mask "WEST+4:14,SOUTH:5"	//monkey
#define ui_monkey_back "WEST+5:14,SOUTH:5"	//monkey

#define ui_construct_health "EAST:00,CENTER:15" //same hei69ht as humans, hu6969in69 the ri69ht border
#define ui_construct_pur69e "EAST:00,CENTER-1:15"
#define ui_construct_fire "EAST-1:16,CENTER+1:13" //above health, sli69htly to the left
#define ui_construct_pull "EAST-1:28,SOUTH+1:10" //above the zone_sel icon

//Lower ri69ht, persistant69enu
#define ui_dropbutton "EAST-4:22,SOUTH:5"
#define ui_drop_throw "EAST-1:28,SOUTH+1:7"
#define ui_pull_resist "EAST-2:26,SOUTH+1:7"
#define ui_acti "EAST-2:26,SOUTH:5"
#define ui_movi "EAST-3:24,SOUTH:5"
#define ui_zonesel "EAST-1:28,SOUTH:5"
#define ui_acti_alt "EAST-1:28,SOUTH:5" //alternative intent switcher for when the interface is hidden (F12)

#define ui_bor69_pull "EAST-3:24,SOUTH+1:7"
#define ui_bor69_module "EAST-2:26,SOUTH+1:7"
#define ui_bor69_panel "EAST-1:28,SOUTH+1:7"

//69un buttons
#define ui_69un1 "EAST-2:26,SOUTH+2:7"
#define ui_69un2 "EAST-1:28, SOUTH+3:7"
#define ui_69un3 "EAST-2:26,SOUTH+3:7"
#define ui_69un_select "EAST-1:28,SOUTH+2:7"
#define ui_69un4 "EAST-3:24,SOUTH+2:7"

//Upper-middle ri69ht (dama69e indicators)
#define ui_toxin "EAST-1:28,NORTH-2:27"
#define ui_fire "EAST-1:28,NORTH-3:25"
#define ui_oxy69en "EAST-1:28,NORTH-4:23"
#define ui_pressure "EAST-1:28,NORTH-5:21"

//Middle ri69ht (status indicators)
#define ui_nutrition "EAST-1:28,CENTER-2:11"
#define ui_temp "EAST-1:28,CENTER-1:13"
#define ui_health "EAST-1:28,CENTER:15"
#define ui_internal "EAST-1:28,CENTER+1:17"
									//bor69s
#define ui_bor69_health "EAST-1:28,CENTER-1:13" //bor69s have the health display where humans have the pressure dama69e indicator.
#define ui_alien_health "EAST-1:28,CENTER-1:13" //aliens have the health display where humans have the pressure dama69e indicator.

//Pop-up inventory
#define ui_shoes "WEST+1:8,SOUTH:5"

#define ui_iclothin69 "WEST:6,SOUTH+1:7"
#define ui_oclothin69 "WEST+1:8,SOUTH+1:7"
#define ui_69loves "WEST+2:10,SOUTH+1:7"

#define ui_69lasses "WEST:6,SOUTH+2:9"
#define ui_mask "WEST+1:8,SOUTH+2:9"
#define ui_l_ear "WEST+2:10,SOUTH+2:9"
#define ui_r_ear "WEST+2:10,SOUTH+3:11"

#define ui_head "WEST+1:8,SOUTH+3:11"

//Intent small buttons
#define ui_help_small "EAST-3:8,SOUTH:1"
#define ui_disarm_small "EAST-3:15,SOUTH:18"
#define ui_69rab_small "EAST-3:32,SOUTH:18"
#define ui_harm_small "EAST-3:39,SOUTH:1"

//#define ui_swapbutton "6:-16,1:5" //Unused

//#define ui_headset "SOUTH,8"
#define ui_hand "CENTER-1:14,SOUTH:5"
#define ui_hstore1 "CENTER-2,CENTER-2"
//#define ui_resist "EAST+1,SOUTH-1"
#define ui_sleep "EAST+1,69ORTH-13"
#define ui_rest "EAST+1,69ORTH-14"


#define ui_iarrowleft "SOUTH-1,EAST-4"
#define ui_iarrowri69ht "SOUTH-1,EAST-2"

#define ui_spell_master "EAST-1:16,NORTH-1:16"
#define ui_69enetic_master "EAST-1:16,NORTH-3:16"
