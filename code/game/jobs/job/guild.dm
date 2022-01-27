//Cargo
/datum/job/merchant
	title = "Guild69erchant"
	flag =69ERCHANT
	department = DEPARTMENT_GUILD
	head_position = TRUE
	aster_guild_member = TRUE
	department_flag = GUILD | COMMAND
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "your greed"
	selection_color = "#b3a68c"
	wage = WAGE_NONE	//Guild69erchant draws a salary from the guild account
	also_known_languages = list(LANGUAGE_JIVE = 100)
	access = list(
		access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_merchant, access_mining,
		access_heads, access_mining_station, access_RC_announce, access_keycard_auth, access_sec_doors,
		access_eva, access_external_airlocks, access_change_cargo, access_artist
	)
	ideal_character_age = 40
	stat_modifiers = list(
		STAT_ROB = 10,
		STAT_COG = 20,
		STAT_MEC = 15,
		STAT_VIG = 10
	)

	perks = list(/datum/perk/merchant, /datum/perk/deep_connection, /datum/perk/oddity/market_prof)

	description = "You are the head of the local branch of Asters69erchant Guild, and eris' guild representative<br>\
A staunch entrepreneur, you are69otivated by profit, for the guild and especially for yourself. You are here firstly to69ake as69uch69oney as you can, and secondly to keep the crew supplied. You can order things at cargo using the local guild funds, these will not69agically replenish so you will run out of69oney 69uickly if you don't charge. Take payments by card or cash, and deposit them into the guild account to enable69ore purchases.<br>\
<br>\
The guild also operates all the69endors on the ship, every credit paid into them goes to your guild account. Naturally operating is a two way street, you are expected, when necessary, to refill those69endors. Or send a technician to do it<br>\
<br>\
You do not recieve a salary, but the local guild funds are yours to use. You69ay pay yourself as69uch as you like from that account, take the funds and use them for any purpose.  Bribery is a good one, you can get people to do a lot of things if you flash some cash, and its a good idea to keep a few thousand credits on hand in-cash to bribe your way through potentially difficult situations.<br>\
<br>\
Things to bear in69ind:<br>\
	-Nobody has a right to free stuff. You are well within your rights to charge for anything you distribute, and you won't69ake a penny if you don't.<br>\
	-Eris has few laws on contraband. If someone wants something and they can afford it, you get it for them. Don't try to play69oral guardian and don't ask 69uestions. You are not responsible for whatever they do with your products.<br>\
	-Loyalty is a priceless resource, yet cheap to69aintain. Don't screw over the69iners and technicians working under you. <br>\
	-Charity is a weapon. Used correctly, it can do wonders for your public image.  A few gifts spread around69akes for good returning customers"

	duties = "Keep the crew supplied with anything they69ight need, at a healthy profit to you of course<br>\
Buy up69alueable items from scavengers, and69ake a profit reselling them<br>\
Deploy your69ining staff to harvest69atter and69aterials<br>\
Counsel the captain on directing the ship towards profitable opportunities"

	loyalties = "As a69erchant, your first loyalty is to69oney. You should be unscrupulous, willing to sell anything to anyone if they can pay your prices. Direct the ship towards profitable endeavours, and press the captain to69ake choices that will be financially lucrative<br>\
Your second loyalty is to the guild. Ensure it retains good relations with privateers like the captain of Eris, and don't embarass it. This69eans limiting your price gouging to only69oderate levels. If you69ake an enemy of everyone, it69ay prove a costly69istake"

	software_on_spawn = list(///datum/computer_file/program/supply,
							 ///datum/computer_file/program/deck_management,
							 /datum/computer_file/program/scanner,
							 /datum/computer_file/program/wordprocessor,
							 /datum/computer_file/program/reports)

	outfit_type = /decl/hierarchy/outfit/job/cargo/merchant

/obj/landmark/join/start/merchant
	name = "Guild69erchant"
	icon_state = "player-beige-officer"
	join_tag = /datum/job/merchant



/datum/job/cargo_tech
	title = "Guild Technician"
	flag = GUILDTECH
	department = DEPARTMENT_GUILD
	department_flag = GUILD
	faction = "CEV Eris"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Guild69erchant"
	selection_color = "#c3b9a6"
	also_known_languages = list(LANGUAGE_JIVE = 100)
	wage = WAGE_LABOUR_DUMB
	department_account_access = TRUE
	outfit_type = /decl/hierarchy/outfit/job/cargo/cargo_tech

	access = list(
		access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining,
		access_mining_station
	)

	stat_modifiers = list(
		STAT_ROB = 10,
		STAT_TGH = 10,
		STAT_VIG = 10,
	)

	perks = list(/datum/perk/deep_connection)

	software_on_spawn = list(///datum/computer_file/program/supply,
							 ///datum/computer_file/program/deck_management,
							 /datum/computer_file/program/scanner,
							 /datum/computer_file/program/wordprocessor,
							 /datum/computer_file/program/reports)


	description = "You are a low ranking69ember of the Asters'69erchant Guild, and an apprentice to the local69erchant.  You69ay one day take over his position. You are e69ual parts scavenger, loader, shopkeeper and salesman. Remember the guild's core role here. To keep everyone supplied with everything they could need, and to profit from this endeavour<br>\
<br>\
Your69ain duties are to keep the local guild branch operational and profitable. To that end you should look out for all of the following tasks:"

	duties = "	-Delivering goods to persons or departments that ordered them<br>\
	-Staffing the front desk, taking payments and orders, buying up items from scavengers that come to sell things.<br>\
	-Visiting departments to take orders in person, ask if there's anything they need, and try to sell them unusual items that69ay aid their efforts.<br>\
	-Providing lesser services. Busted lights? Broken69endors? The guild can be there to help, for a small fee.<br>\
	-In 69uieter times, head into69aintenance areas and scavenge for useful goods to resell"

	loyalties = "		Your first loyalty is to yourself and survival. This ship is69ostly just a paycheck to you<br>\
		Your second loyalty is to the69erchant, he ensures you're well paid and respected, in a universe where workers are often treated as interchangeable parts."

/obj/landmark/join/start/cargo_tech
	name = "Guild Technician"
	icon_state = "player-beige"
	join_tag = /datum/job/cargo_tech

/datum/job/mining
	title = "Guild69iner"
	flag =69INER
	department = DEPARTMENT_GUILD
	department_flag = GUILD
	faction = "CEV Eris"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Guild69erchant"
	selection_color = "#c3b9a6"
	wage = WAGE_LABOUR_HAZARD //The69iners union is stubborn
	also_known_languages = list(LANGUAGE_JIVE = 100)

	outfit_type = /decl/hierarchy/outfit/job/cargo/mining

	description = "You are an asteroid69iner, working in resource Procurement for the local branch of Asters'69erchant Guild.<br>\
Your primary responsibility is to head out on the69ining Barge, and dig up as69uch ore as you can on an asteroid. The barge contains all the facilities to process that ore too, and allows you to deliver refined69aterials ready for use.<br>\
<br>\
All the stuff you dig up goes to the guild, and from then on it's the69erchant's responsibility to sell it to other departments. <br>\
<br>\
Your second responsibility is to help out aboard ship, while waiting to reach an asteroid. 69uite notably, the roaches infesting the ship69ake heavy use of burrows to get around. You have the tools and expertise to effectively deal with these burrows, and you should try to destroy them wherever you find them<br>\
<br>\
Your third responsibility is as an unofficial security guard. The guild is a popular target for thieves, and one of the unspoken reasons for keeping rough, sturdy people like you on the payroll is to deter those thieves, and punish them with a swift beating for attempting to steal from the69erchant. Try to keep the beatings nonlethal though,69urder generates too69uch bad publicity<br>\
<br>\
Character Expectations:<br>\
	Miners should be tough and physically strong. Unafraid to get their hands dirty.<br>\
	You should be competent in an EVA suit and in operating heavy69achinery"


	duties = "Dig up ores and69inerals, process them into useable69aterial.<br>\
	Collapse burrows around the ship to help fight off the roach infestation<br>\
	Protect the Guild wing and the69erchant, from thieves and intruders."

	loyalties = "	Your first loyalty is to yourself and survival. This ship is69ostly just a paycheck to you<br>\
	Your second loyalty is to the69erchant, he ensures you're well paid and respected, in a universe where workers are often treated as interchangeable parts.	"

	access = list(
		access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining,
		access_mining_station
	)


	stat_modifiers = list(
		STAT_ROB = 15,
		STAT_TGH = 15,
		STAT_VIG = 15,
		STAT_MEC = 15
	)

	perks = list(/datum/perk/deep_connection)

	software_on_spawn = list(///datum/computer_file/program/supply,
							 ///datum/computer_file/program/deck_management,
							 /datum/computer_file/program/wordprocessor,
							 /datum/computer_file/program/reports)

/obj/landmark/join/start/mining
	name = "Guild69iner"
	icon_state = "player-beige"
	join_tag = /datum/job/mining

/datum/job/artist
	title = "Guild Artist"
	flag = ARTIST
	department = DEPARTMENT_GUILD
	department_flag = GUILD
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 1
	supervisors = "the Guild69erchant"
	selection_color = "#dddddd"
	also_known_languages = list(LANGUAGE_JIVE = 100)
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station, access_artist, access_theatre)

	outfit_type = /decl/hierarchy/outfit/job/cargo/artist
	wage = WAGE_LABOUR_DUMB	//Barely a retaining fee. Actor can busk for credits to keep themselves fed
	stat_modifiers = list(
		STAT_TGH = 30,
	)

	perks = list(PERK_ARTIST)

	software_on_spawn = list(///datum/computer_file/program/supply,
							 ///datum/computer_file/program/deck_management,
							 /datum/computer_file/program/scanner,
							 /datum/computer_file/program/wordprocessor,
							 /datum/computer_file/program/reports)

	description = "You are a creative soul aboard this69essel. You have been conscripted by the Aster's Guild to create69asterful works of art to be sold at69ind-boggling prices... and something about the CEV Eris and it's doomed journey sparks the fire of creation within you.<br>\
	You do not gain desires like other69embers of the crew. Instead, you stop gaining insight once you69ax out at 100 points.<br>\
	You can gain desires by spending this insight at your Artist's Bench to build a work of art, this art you create69ary wildly in type, 69uality, and (most importantly, in the eyes of the69erchant)69alue. Sell your artwork to the unwashed69asses, or give you work to the69erchant to sell for a profit."

	duties = "Create works of art using your insight.<br>\
	Sell your work, or give it to the69erchant to sell for you.<br>\
	Be in the69idst of action or combat to level your insight faster."

	loyalties = "You are loyal to your soul, first and foremost. You are fascinated by this cursed ship, and want to69old this interest into your works of art.<br>\
	Your second loyalty is to the69erchant and the Aster's Guild as a whole. After all, they're the ones giving you housing, payment, and69aterials to create your art."

/obj/landmark/join/start/artist
	name = "Guild Artist"
	icon_state = "player-grey"
	join_tag = /datum/job/artist
