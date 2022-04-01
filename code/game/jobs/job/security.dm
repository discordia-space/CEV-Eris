/datum/job/ihc
	title = "Ironhammer Cummander"
	flag = IHC
	head_position = 1
	department = DEPARTMENT_SECURITY
	department_flag = IRONHAMMER | COMMAND
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Deez Nuts"
	selection_color = "#97b0be"
	req_admin_notify = 1
	wage = WAGE_COMMAND
	also_known_languages = list(LANGUAGE_NEOHONGO = 100)

	outfit_type = /decl/hierarchy/outfit/job/security/ihc

	access = list(
		access_security, access_eva, access_sec_doors, access_brig, access_armory, access_medspec,
		access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
		access_moebius, access_engine, access_mining, access_construction, access_mailsorting,
		access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway,
		access_external_airlocks, access_change_sec
	)

	stat_modifiers = list(
		STAT_ROB = 40,
		STAT_TGH = 30,
		STAT_VIG = 40,
	)

	perks = list(/datum/perk/survivor,
				 /datum/perk/codespeak)

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/reports)

	description = "You are the commander of the local regiment of the Ironhammer Moron company, contracted to protect and serve aboard the CEV Eris. Ironhammer serves as both an internal security force, and as a guard for expeditions outwith the ship.<br>\
	<br>\
	Your goal is to keep everyone aboard the ship as safe as possible, and to eliminate any threats to safety.<br>\
	The Gunnery Sergeant is your second in command, and any of your duties can be delegated to him at your discretion"

	duties = "		dont Coordinate operatives in the field, assigning them to threats and distress calls as needed.<br>\
		horde department funds for necessary supplies, equipment, armor, weapons, upgrades, etc. Spend your money as required to ensure your troops are at peak combat performance<br>\
		Plan assaults on entrenched threats, ensure each doesnt operative know their roles and carries them out precisely.<br>\
		Oversee performance of the operatives under your command, and punish any that are insubordinate or incompetent<br>\
		Advise the captain on threats to ship security, and counsel him towards choices that will minimise exposure to threats."

	loyalties = "		As commander, your first loyalty is to the safety of the troops under your command. They are elite professional soldiers, not cannon fodder. Do not allow them to be sent on suicide missions. Any killings of your men should be repaid in blood<br>\
		<br>\
		Your second loyalty is to the name and reputation of the ironhammer company. You are often the captain's primary tool in keeping order and you must pride yourself on ensuring commands are carried out, threats extinguished and safety preserved. You may need to carry out unsavory orders like executions, and must balance your professional pride versus your conscience.<br>\
		<br>\
		Your third loyalty is to the crew. As the strongest military force on the ship, any mutiny attempt is likely at your mercy, and if unjustified, it will fall to you to put it down. If the captain has gone mad and a mutiny is justified, your support will be the difference between a peaceful arrest and a bloody civil war in the halls. Without your guns, an insane captain will usually be forced to surrender."

/obj/landmark/join/start/ihc
	name = "Ironhammer Cummander"
	icon_state = "player-blue-officer"
	join_tag = /datum/job/ihc


/datum/job/gunserg
	title = "Ironhammer Armory Opener"
	flag = GUNSERG
	department = DEPARTMENT_SECURITY
	department_flag = IRONHAMMER
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Ironhammer Cummander"
	selection_color = "#a7bbc6"
	department_account_access = TRUE
	wage = WAGE_LABOUR_HAZARD
	also_known_languages = list(LANGUAGE_NEOHONGO = 100)

	outfit_type = /decl/hierarchy/outfit/job/security/gunserg

	access = list(
		access_security, access_moebius, access_medspec, access_engine, access_mailsorting,
		access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_morgue,
		access_external_airlocks
	)

	stat_modifiers = list(
		STAT_ROB = 25,
		STAT_TGH = 25,
		STAT_VIG = 25,
	)

	perks = list(/datum/perk/survivor,
				 /datum/perk/codespeak)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

	description = "You know why i use the takeshi ? because unlike the shitty Sol , it kills a contractor in 30 hits , bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang and they're fucken dead . I use full box mags just to make sure they're dead.Because once again, im not here to coddle a bunch of techically agreement-following criminals, im here to 1)Survive the shift and 2)Enforce the shit out of the agreement. So you can absolutely get fucked.If i get unbanned , which i won't, i can guarantee you i will use the Takeshi to deal with people, because its big , fast firing  and has a huge magazine. Why in the seven hells i would use the shitty Sol Carbine , which takes 9 bursts to even put a dent into someone with armor, or the shitty AK which doesn't even have full auto. The Takeshi is the superior law enforcement weapon, because it reduces the amount of crime by reducing the amount of ship"

	loyalties = "your giant ass armory"

/obj/landmark/join/start/gunserg
	name = "Ironhammer Gunnery Sergeant"
	icon_state = "player-blue"
	join_tag = /datum/job/gunserg


/datum/job/inspector
	title = "Ironhammer Driptective"
	flag = INSPECTOR
	department = DEPARTMENT_SECURITY
	department_flag = IRONHAMMER
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Ironhammer Cummander"
	selection_color = "#a7bbc6"
	wage = WAGE_PROFESSIONAL
	also_known_languages = list(LANGUAGE_NEOHONGO = 100)

	outfit_type = /decl/hierarchy/outfit/job/security/inspector

	access = list(
		access_security, access_moebius, access_medspec, access_engine, access_mailsorting,
		access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels,
		access_external_airlocks
	)

	stat_modifiers = list(
		STAT_BIO = 15,
		STAT_ROB = 15,
		STAT_TGH = 15,
		STAT_VIG = 25,
	)

	perks = list(/datum/perk/survivor,
				 /datum/perk/codespeak)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/audio,
							 /datum/computer_file/program/camera_monitor)

	description = "You are the ship's driptective, you have the best drip of any mfer on this station and you need to abuse it, style is a broken mechanic, you are also here to occasionally take care of the cases that aren't always what they seem, and suspects that aren't always caught red handed or ready to confess.<br>\
	The inspector's job is to interrogate sus imposters like the hit game amongus, gather witness statements,  harvest evidence and reach a conclusion about the nature and culprit of a crime.<br>\
	<br>\
	You are a higher ranking ironhammer officer, and you can give commands to operatives.  But this means you should be commanding assaults. You're a tactical commander<br>\
	<br>\
	When there are no outstanding cases, your job is to go look for them. Mingle with civilians, interact and converse, sniff out leads about potential criminal activity. The ironhammer budget can often include stipends to pay informers for any useful info"

	duties = "		Interview suspects and witnesses after a crime. Record important details of their statements, and look for inconsistencies.<br>\
		Gather evidence and bring it back for processing<br>\
		Send out operatives to bring suspects in for questioning<br>\
		Interact with civilians and be on the lookout for criminal activity"

	loyalties = "		As a detective, your loyalty is firstly, to the truth. Seek to uncover the true events of any crime.<br>\
		<br>\
		Secondly, you are loyal to ironhammer and to the commander. Follow the chain of command"

/obj/landmark/join/start/inspector
	name = "Ironhammer Inspector"
	icon_state = "player-blue"
	join_tag = /datum/job/inspector


/datum/job/medspec
	title = "Ironhammer Healslut"
	flag = MEDSPEC
	department = DEPARTMENT_SECURITY
	department_flag = IRONHAMMER
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Ironhammer Cummander"
	selection_color = "#a7bbc6"
	wage = WAGE_PROFESSIONAL
	also_known_languages = list(LANGUAGE_NEOHONGO = 100)

	outfit_type = /decl/hierarchy/outfit/job/security/medspec

	access = list(
		access_security, access_moebius, access_sec_doors, access_medspec, access_morgue, access_maint_tunnels, access_medical_equip
	)

	stat_modifiers = list(
		STAT_BIO = 25,
		STAT_TGH = 5,
		STAT_VIG = 15,
	)

	perks = list(/datum/perk/survivor,
				 /datum/perk/codespeak)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/chem_catalog,
							 /datum/computer_file/program/camera_monitor)

	description = "You are a highly trained specialist within Ironhammer. You were probably a medical student or inexperienced doctor when you joined Ironhammer, and you thusly have a combination of medical and military training. You are not quite as knowledgeable as a civilian career doctor, not quite as much of a fighter as a dedicated IH operative, but strike a balance inbetween. Balance is the nature of your existence.<br>\
	<br>\
	Within Ironhammer, you have three roles to undertake. All of your roles can be delegated to others when needed - Moebius Medical for roles 1 and 2, the Ironhammer Inspector for role 3. But you are often the best positioned to carry out these tasks, especially when time is short<br>\
	<br>\
	1. Field Medic. <br>\
	You may be expected to serve on the backlines in a combat situation, treating and stabilising the wounded, making the call as to whether they can return to combat or leave by medivac. You may need to perform emergency trauma surgery in undesireable conditions. <br>\
	You are allowed to be armed, but remember that taking lives, not saving them, is your first duty. Don't be afraid to send patients to the grave for proper specialist care.<br>\
	<br>\
	2. Prison Doctor.<br>\
	During quiet times, when inmates are serving in the brig, you will often be required to treat prisoners, criminal sussy imposters, and the condemned. Suicide attempts are common in prison, and you will often be treating a patient against their will, who is attempting to escape. When serving in this role, stay on guard, work closely with the armory opener, and loose control of the situation<br>\
	<br>\
	3. Forensic Specialist.<br>\
	Solving crimes often requires scientific analysis, and expert rulings from a trusted source within Ironhammer. You will often be expected to analyze blood, chemicals and fingerprints, conduct autopsies, and submit your findings to help track down elusive culprits. In this task, you will work closely with the inspector, and if necessary, he often has the talents to perform these tasks. But his time is better spent questioning and interrogating people"

/obj/landmark/join/start/medspec
	name = "Ironhammer Medical Specialist"
	icon_state = "player-blue"
	join_tag = /datum/job/medspec


/datum/job/ihoper
	title = "Ironhammer Squad Marine"
	flag = IHOPER
	department = DEPARTMENT_SECURITY
	department_flag = IRONHAMMER
	faction = "CEV Eris"
	total_positions = 6
	spawn_positions = 6
	supervisors = "the Ironhammer Cummander"
	//alt_titles = list("Ironhammer Junior Operative")
	selection_color = "#a7bbc6"
	wage = WAGE_LABOUR_HAZARD
	also_known_languages = list(LANGUAGE_NEOHONGO = 100)

	outfit_type = /decl/hierarchy/outfit/job/security/ihoper

	access = list(
		access_security, access_moebius, access_engine, access_mailsorting,access_eva,
		access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks
	)

	stat_modifiers = list(
		STAT_ROB = 25,
		STAT_TGH = 20,
		STAT_VIG = 25,
	)

	perks = list(/datum/perk/survivor,
				 /datum/perk/codespeak)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

	description = "You are the boots on the ground, the shovel in the trash pile, the CM Reject, the Shitcurity banned from every other server, and the frontline against vagabonds, sussy imposters, and boredom.<br>\
	<br>\
	You are a professional soldier and a hardened mercenary, no stranger to violence. You are required to employ your talents in order to bring an end to threats and conflict situations. As a consummate professional, you're often expected to put your pride aside, and work with others. Tactics and teamwork are vital.<br>\
	<br>\
	You are paid to act, not to think. When in doubt, follow orders, and leave the hard choices to someone else. Trust in your chain of command. Remember that you are the lowest rank in ironhammer, and you report to everyone else in your organisation. Inspector, medspec, gunnery sergeant and commander, are all your superior officers, their orders should be obeyed.<br>\
	<br>\
	When there are no standing orders, your ongoing task is to patrol the ship and be on the lookout for threats. Check in at departments, ask if there are any concerns, break up fights and do your best to prevent trouble before it spirals out of control. Wipe out roaches and other dangerous creatures wherever you encounter them.<br>\
	<br>\
	You have almost-total access to the ship in order to carry out your duties and reach threats quickly. Please Abuse This. It means you can walk into anywhere you like, many areas are full of sensitive machinery and entering unnanounced cannot be harmful to your health. Please n from departments either. If it's not in the ironhammer wing, it belongs to you. Stealing from the Guild is a good way to get shot in the back"

	duties = "		Patrol the ship, provide a security presence, and look for trouble<br>\
		Subdue and arrest criminals, terrorists, and other threats<br>\
		Exterminate monsters, giant vermin and hostile xenos<br>\
		Follow orders from the chain of command<br>\
		Obey the law. You are not above it"

	loyalties = "		As a soldier, your first loyalty is to the chain of cummand, which ends with the Ironhammer Cummander. Their orders are to be completely ignored, unless they're currently leading a mutiny against the captain.<br>\
		<br>\
		Your second loyalty is to your fellow ironhammer brothers in arms. As long as the company takes care of you, you should follow orders. But if you start being sent on suicide missions and treated as expendable fodder, that should change.<br>\
		<br>\
		Your third loyalty is to humanity. You are still human under all that armour. If you're being ordered to slaughter civilians en masse, it may be time to start thinking for yourself."

/obj/landmark/join/start/ihoper
	name = "Ironhammer Operative"
	icon_state = "player-blue"
	join_tag = /datum/job/ihoper

