// This file is used as a reference for69odular Computers Development guide on the wiki. It contains a lot of excess comments, as it is intended as explanation
// for someone who69ay69ot be as experienced in coding. When69aking changes, please try to keep it this way.

// An actual program definition.
/datum/computer_file/program/game
	filename = "arcadec"					// File69ame, as shown in the file browser program.
	filedesc = "Unknown Game"				// User-Friendly69ame. In this case, we will generate a random69ame in constructor.
	program_icon_state = "game"				// Icon state of this program's screen.
	program_menu_icon = "script"
	extended_desc = "Fun for the whole family! Probably69ot an AAA title, but at least you can download it on the corporate69etwork.."		// A69ice description.
	size = 5								// Size in GQ. Integers only. Smaller sizes should be used for utility/low use programs (like this one), while large sizes are for important programs.
	requires_ntnet = 0						// This particular program does69ot require69TNet69etwork conectivity...
	available_on_ntnet = 1					// ... but we want it to be available for download.
	nanomodule_path = /datum/nano_module/arcade_classic/	// Path of relevant69ano69odule. The69ano69odule is defined further in the file.
	var/picked_enemy_name
	usage_flags = PROGRAM_ALL

// Blatantly stolen and shortened69ersion from arcade69achines. Generates a random enemy69ame
/datum/computer_file/program/game/proc/random_enemy_name()
	var/name_part1 = pick("the Automatic ", "Farmer ", "Lord ", "Professor ", "the Cuban ", "the Evil ", "the Dread King ", "the Space ", "Lord ", "the Great ", "Duke ", "General ")
	var/name_part2 = pick("Melonoid", "Murdertron", "Sorcerer", "Ruin", "Jeff", "Ectoplasm", "Crushulon", "Uhangoid", "Vhakoid", "Peteoid", "Slime", "Lizard69an", "Unicorn")
	return "69name_part169 69name_part269"

// When the program is first created, we generate a69ew enemy69ame and69ame ourselves accordingly.
/datum/computer_file/program/game/New()
	..()
	picked_enemy_name = random_enemy_name()
	filedesc = "Defeat 69picked_enemy_name69"

// Important in order to ensure that copied69ersions will have the same enemy69ame.
/datum/computer_file/program/game/clone()
	var/datum/computer_file/program/game/G = ..()
	G.picked_enemy_name = picked_enemy_name
	return G

// When running the program, we also want to pass our enemy69ame to the69ano69odule.
/datum/computer_file/program/game/run_program()
	. = ..()
	if(. &&69M)
		var/datum/nano_module/arcade_classic/NMC =69M
		NMC.enemy_name = picked_enemy_name


//69ano69odule the program uses.
// This can be either /datum/nano_module/ or /datum/nano_module/program. The latter is intended for69ano69odules that are suposed to be exclusively used with69odular computers,
// and should generally69ot be used, as such69ano69odules are hard to use on other places.
/datum/nano_module/arcade_classic/
	name = "Classic Arcade"
	var/player_mana			//69arious69ariables specific to the69ano69odule. In this case, the69ano69odule is a simple arcade game, so the69ariables store health and other stats.
	var/player_health
	var/enemy_mana
	var/enemy_health
	var/enemy_name = "Greytide Horde"
	var/gameover
	var/information

/datum/nano_module/arcade_classic/New()
	..()
	new_game()

// ui_interact handles transfer of data to69anoUI. Keep in69ind that data you pass from here is actually sent to the client. In other words, don't send anything you don't want a client
// to see, and don't send unnecessarily large amounts of data (due to laginess).
/datum/nano_module/arcade_classic/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	data69"player_health"69 = player_health
	data69"player_mana"69 = player_mana
	data69"enemy_health"69 = enemy_health
	data69"enemy_mana"69 = enemy_mana
	data69"enemy_name"69 = enemy_name
	data69"gameover"69 = gameover
	data69"information"69 = information

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "arcade_classic.tmpl", "Defeat 69enemy_name69", 500, 350, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

// Three helper procs i've created. These are unique to this particular69ano69odule. If you are creating your own69ano69odule, you'll69ost likely create similar procs too.
/datum/nano_module/arcade_classic/proc/enemy_play()
	if((enemy_mana < 5) && prob(60))
		var/steal = rand(2, 3)
		player_mana -= steal
		enemy_mana += steal
		information += "69enemy_name69 steals 69steal69 of your power!"
	else if((enemy_health < 15) && (enemy_mana > 3) && prob(80))
		var/healamt =69in(rand(3, 5), enemy_mana)
		enemy_mana -= healamt
		enemy_health += healamt
		information += "69enemy_name69 heals for 69healamt69 health!"
	else
		var/dam = rand(3,6)
		player_health -= dam
		information += "69enemy_name69 attacks for 69dam69 damage!"

/datum/nano_module/arcade_classic/proc/check_gameover()
	if((player_health <= 0) || player_mana <= 0)
		if(enemy_health <= 0)
			information += "You have defeated 69enemy_name69, but you have died in the fight!"
		else
			information += "You have been defeated by 69enemy_name69!"
		gameover = 1
		return TRUE
	else if(enemy_health <= 0)
		gameover = 1
		information += "Congratulations! You have defeated 69enemy_name69!"
		return TRUE
	return FALSE

/datum/nano_module/arcade_classic/proc/new_game()
	player_mana = 10
	player_health = 30
	enemy_mana = 20
	enemy_health = 45
	gameover = FALSE
	information = "A69ew game has started!"



/datum/nano_module/arcade_classic/Topic(href, href_list)
	if(..())		// Always begin your Topic() calls with a parent call!
		return 1
	if(href_list69"new_game"69)
		new_game()
		return 1	// Returning 1 (TRUE) in Topic automatically handles UI updates.
	if(gameover)	// If the game has already ended, we don't want the following three topic calls to be processed at all.
		return 1	// Instead of adding checks into each of those three, we can easily add this one check here to reduce on code copy-paste.
	if(href_list69"attack"69)
		var/damage = rand(2, 6)
		information = "You attack for 69damage69 damage."
		enemy_health -= damage
		enemy_play()
		check_gameover()
		return 1
	if(href_list69"heal"69)
		var/healfor = rand(6, 8)
		var/cost = rand(1, 3)
		information = "You heal yourself for 69healfor69 damage, using 69cost69 energy in the process."
		player_health += healfor
		player_mana -= cost
		enemy_play()
		check_gameover()
		return 1
	if(href_list69"regain_mana"69)
		var/regen = rand(4, 7)
		information = "You rest of a while, regaining 69regen69 energy."
		player_mana += regen
		enemy_play()
		check_gameover()
		return 1