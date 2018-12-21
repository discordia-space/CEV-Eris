//Cargo
/datum/job/merchant
	title = "Guild Merchant"
	flag = MERCHANT
	department = "Cargo"
	head_position = 1
	department_flag = GUILD | COMMAND
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "your greed"
	selection_color = "#b3a68c"
	economic_modifier = 20
	also_known_languages = list(LANGUAGE_CYRILLIC = 100, LANGUAGE_SERBIAN = 100)
	access = list(
		access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_merchant, access_mining,
		access_heads, access_mining_station, access_RC_announce, access_keycard_auth, access_sec_doors,
		access_eva, access_external_airlocks
	)
	ideal_character_age = 40

	software_on_spawn = list(///datum/computer_file/program/supply,
							 ///datum/computer_file/program/deck_management,
							 /datum/computer_file/program/scanner,
							 /datum/computer_file/program/wordprocessor,
							 /datum/computer_file/program/reports)

	outfit_type = /decl/hierarchy/outfit/job/cargo/merchant

	description = "You are the head of the local branch of Asters Merchant Guild, and eris' guild representative<br>\
A staunch entrepreneur, you are motivated by profit, for the guild and especially for yourself.<br>\

Things to bear in mind:<br>\
Nobody has a right to free stuff. You are well within your rights to charge for anything you distribute, and you won't make a penny if you don't.<br>\
Eris has few laws on contraband. If someone wants something and they can afford it, you get it for them. Don't try to play moral guardian and don't ask questions. You are not responsible for whatever they do with your products.<br>\
Loyalty is a priceless resource, yet cheap to maintain. Don't screw over the miners and technicians working under you. <br>\
Charity is a weapon. Used correctly, it can do wonders for your public image.  A few gifts spread around makes for good returning customers"

	duties = "Keep the crew supplied with anything they might need, at a healthy profit to you of course<br>\
Buy up valueable items from scavengers, and make a profit reselling them<br>\
Deploy your mining staff to harvest matter and materials<br>\
Counsel the captain on directing the ship towards profitable opportunities"

	loyalties = "As a merchant, your first loyalty is to money. You should be unscrupulous, willing to sell anything to anyone if they can pay your prices. Direct the ship towards profitable endeavours, and press the captain to make choices that will be financially lucrative<br>\

Your second loyalty is to the guild. Ensure it retains good relations with privateers like the captain of Eris, and don't embarass it. This means limiting your price gouging to only moderate levels. If you make an enemy of everyone, it may prove a costly mistake"

/obj/landmark/join/start/merchant
	name = "Guild Merchant"
	icon_state = "player-beige-officer"
	join_tag = /datum/job/merchant



/datum/job/cargo_tech
	title = "Guild Technician"
	flag = GUILDTECH
	department = "Cargo"
	department_flag = GUILD
	faction = "CEV Eris"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Guild Merchant"
	selection_color = "#c3b9a6"
	also_known_languages = list(LANGUAGE_CYRILLIC = 15, LANGUAGE_SERBIAN = 5)

	outfit_type = /decl/hierarchy/outfit/job/cargo/cargo_tech

	access = list(
		access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining,
		access_mining_station
	)

	stat_modifiers = list(
		STAT_ROB = 10,
		STAT_TGH = 10,
	)

	software_on_spawn = list(///datum/computer_file/program/supply,
							 ///datum/computer_file/program/deck_management,
							 /datum/computer_file/program/scanner,
							 /datum/computer_file/program/wordprocessor,
							 /datum/computer_file/program/reports)


	description = "You are a low ranking member of the Asters' Merchant Guild, and an apprentice to the local merchant.  You may one day take over his position. You are equal parts scavenger, loader, shopkeeper and salesman. Remember the guild's core role here. To keep everyone supplied with everything they could need, and to profit from this endeavour<br>\

Your main duties are to keep the local guild branch operational and profitable. To that end you should look out for all of the following tasks:"

	duties = "	-Delivering goods to persons or departments that ordered them<br>\
	-Staffing the front desk, taking payments and orders, buying up items from scavengers that come to sell things.<br>\
	-Visiting departments to take orders in person, ask if there's anything they need, and try to sell them unusual items that may aid their efforts.<br>\
	-Providing lesser services. Busted lights? Broken vendors? The guild can be there to help, for a small fee.<br>\
	-In quieter times, head into maintenance areas and scavenge for useful goods to resell"

	loyalties = "		Your first loyalty is to yourself and survival. This ship is mostly just a paycheck to you<br>\
		Your second loyalty is to the merchant, he ensures you're well paid and respected, in a universe where workers are often treated as interchangeable parts."

/obj/landmark/join/start/cargo_tech
	name = "Guild Technician"
	icon_state = "player-beige"
	join_tag = /datum/job/cargo_tech

/datum/job/mining
	title = "Guild Miner"
	flag = MINER
	department = "Cargo"
	department_flag = GUILD
	faction = "CEV Eris"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Guild Merchant"
	selection_color = "#c3b9a6"
	economic_modifier = 5
	also_known_languages = list(LANGUAGE_CYRILLIC = 15, LANGUAGE_SERBIAN = 5)

	outfit_type = /decl/hierarchy/outfit/job/cargo/mining

	access = list(
		access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining,
		access_mining_station
	)


	stat_modifiers = list(
		STAT_ROB = 20,
		STAT_TGH = 15,
		STAT_MEC = 15
	)

	software_on_spawn = list(///datum/computer_file/program/supply,
							 ///datum/computer_file/program/deck_management,
							 /datum/computer_file/program/wordprocessor,
							 /datum/computer_file/program/reports)

	description = "You are an asteroid miner, working in resource Procurement for the local branch of Asters' Merchant Guild.<br>\
Your primary responsibility is to head out on the Mining Barge, and dig up as much ore as you can on an asteroid. The barge contains all the facilities to process that ore too, and allows you to deliver refined materials ready for use.<br>\

All the stuff you dig up goes to the guild, and from then on it's the merchant's responsibility to sell it to other departments. <br>\

Your second responsibility is to help out aboard ship, while waiting to reach an asteroid. Quite notably, the roaches infesting the ship make heavy use of burrows to get around. You have the tools and expertise to effectively deal with these burrows, and you should try to destroy them wherever you find them<br>\

Character Expectations:<br>\
	Miners should be tough and physically strong. Unafraid to get their hands dirty.<br>\
	You should be competent in an EVA suit and in operating heavy machinery"


	duties = "Dig up ores and minerals, process them into useable material.<br>\
	Collapse burrows around the ship to help fight off the roach infestation"

	loyalties = "	Your first loyalty is to yourself and survival. This ship is mostly just a paycheck to you<br>\
	Your second loyalty is to the merchant, he ensures you're well paid and respected, in a universe where workers are often treated as interchangeable parts.	"

/obj/landmark/join/start/mining
	name = "Guild Miner"
	icon_state = "player-beige"
	join_tag = /datum/job/mining
