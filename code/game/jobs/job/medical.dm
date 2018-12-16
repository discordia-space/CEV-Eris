/datum/job/cmo
	title = "Moebius Biolab Officer"
	flag = MBO
	head_position = 1
	department = "Medical"
	department_flag = MEDICAL | COMMAND
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Moebius Expedition Overseer"
	selection_color = "#94a87f"
	req_admin_notify = 1
	economic_modifier = 10
	also_known_languages = list(LANGUAGE_CYRILLIC = 10, LANGUAGE_SERBIAN = 5)

	outfit_type = /decl/hierarchy/outfit/job/medical/cmo

	access = list(
		access_moebius, access_medical_equip, access_morgue, access_genetics, access_heads,
		access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
		access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks
	)

	ideal_character_age = 50

	stat_modifers = list(
		STAT_BIO = 40,
	)

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/reports)

	description = "You are the head of the Moebius Medical branch, contracted by the captain to provide medical services to the crew.\
You are here to keep everyone alive and ideally, at work. You should make choices that preserve life as much as possible.\

The handling of the medbay is your domain, although remember that both medical and science are branches of Moebius corp, so your colleagues have free access to your resources, and vice versa"

	duties = "Organise the doctors under your command to help save lives. Assign patients, and check on their progress periodically\
Dispatch your paramedics to distress calls, and corpse recoveries as needed\
Use department funds to purchase medical supplies and equipment as needed\
Advise the captain on medical issues that concern the crew\
Advise the crew on ethical issues\
In times of crisis, lock down the medbay to protect those within, from outside threats."

	loyalties = "As a doctor, your first loyalty is to your conscience. You swore an oath to save lives and do no harm. It falls on you to be the ethical and moral core of the crew. You should speak up for prisoners, captured lifeforms, and test subjects. Nobody else will.\

Your second loyalty is to your career with Moebius corp, and to your coworkers in both branches of moebius. Help out your scientific colleagues, and aid in their pursuit of knowledge."

/obj/landmark/join/start/cmo
	name = "Moebius Biolab Officer"
	icon_state = "player-green-officer"
	join_tag = /datum/job/cmo


/datum/job/doctor
	title = "Moebius Doctor"
	flag = DOCTOR
	department = "Medical"
	department_flag = MEDICAL
	faction = "CEV Eris"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Moebius Biolab Officer"
	selection_color = "#a8b69a"
	economic_modifier = 7
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)

	outfit_type = /decl/hierarchy/outfit/job/medical/doctor

	access = list(
		access_moebius, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology,
		access_genetics
	)

	stat_modifers = list(
		STAT_BIO = 30,
	)

	software_on_spawn = list(/datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor)


	description = "You are a highly educated professional doctor, working a placement aboard Eris to treat the injured.\
Your tasks will primarily keep you inside medbay, the place needs to have a doctor onsite at all times to treat incoming wounded. As a general rule, you should not leave medbay if you're the only one in it, make sure someone is covering for you if you go elsewhere.\

As a doctor, a broad range of medical procedures fall under your potential purview. You are not expected to be able to perform all of these yourself, being a specialist is fine. \

	Diagnostics: Figuring out what's wrong and how to fix it as quickly as possible. \
	General Treatment: Administering bandages, medicine, casts and placing people in a cryocell as necessary\
	Surgery: Opening the body under general anaesthetic to treat broken bones, organ damage and internal bleeding\
	Virology: The study and manipulation of viruses\
	\
Divide responsibilities among your colleagues to ensure each patient gets the treatment they need\
You also have full access to chemistry, and can utilize  it if medical is short staffed. But if there is a dedicated chemist on staff, they take priority and the lab belongs to them\

Character Expectations:\
You are a real doctor, and as such you are expected to hold a lot of qualifications. You've most likely completed many years of medical study, and hold a PHD in one or more medical fields.\
You are expected to be knowledgeable and competent in at least basic treatment, you may have a specialty though."


	loyalties = "As a doctor, your first loyalty is to your conscience. You swore an oath to save lives and do no harm. It falls on you to be the ethical and moral core of the crew. You should speak up for prisoners, captured lifeforms, and test subjects. Nobody else will.\

Your second loyalty is to your career with Moebius corp, and to your coworkers in both branches of moebius. Help out your scientific colleagues, and aid in their pursuit of knowledge."

/obj/landmark/join/start/doctor
	name = "Moebius Doctor"
	icon_state = "player-green"
	join_tag = /datum/job/doctor



/datum/job/chemist
	title = "Moebius Chemist"
	flag = CHEMIST
	department = "Medical"
	department_flag = MEDICAL
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Moebius Biolab Officer"
	selection_color = "#a8b69a"
	economic_modifier = 5
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)

	outfit_type = /decl/hierarchy/outfit/job/medical/chemist

	access = list(
		access_moebius, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology
	)

	stat_modifers = list(
		STAT_COG = 10,
		STAT_BIO = 30,
	)

	software_on_spawn = list(/datum/computer_file/program/scanner)

/obj/landmark/join/start/chemist
	name = "Moebius Chemist"
	icon_state = "player-green"
	join_tag = /datum/job/chemist


/datum/job/psychiatrist
	title = "Moebius Psychiatrist"
	flag = PSYCHIATRIST
	department = "Medical"
	department_flag = MEDICAL
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	economic_modifier = 5
	supervisors = "the Moebius Biolab Officer"
	selection_color = "#a8b69a"
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)

	outfit_type = /decl/hierarchy/outfit/job/medical/psychiatrist

	access = list(
		access_moebius, access_medical_equip, access_morgue, access_psychiatrist
	)

	stat_modifers = list(
		STAT_BIO = 15,
	)

	software_on_spawn = list(/datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor)


/obj/landmark/join/start/psychiatrist
	name = "Moebius Psychiatrist"
	icon_state = "player-green"
	join_tag = /datum/job/psychiatrist


/datum/job/paramedic
	title = "Moebius Paramedic"
	flag = PARAMEDIC
	department = "Medical"
	department_flag = MEDICAL
	faction = "CEV Eris"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Moebius Biolab Officer"
	selection_color = "#a8b69a"
	economic_modifier = 4
	also_known_languages = list(LANGUAGE_CYRILLIC = 20, LANGUAGE_SERBIAN = 15)

	outfit_type = /decl/hierarchy/outfit/job/medical/paramedic
	access = list(
		access_moebius, access_medical_equip, access_morgue, access_surgery,
		access_eva, access_maint_tunnels, access_external_airlocks, access_psychiatrist
	)

	stat_modifers = list(
		STAT_BIO = 20,
		STAT_ROB = 10,
		STAT_TGH = 10,
	)

	software_on_spawn = list(/datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor)

	description = "You are a Moebius Paramedic, The hero of the hour! While doctors largely spend their time cloistered away in medbay, your job is to be out there on the frontlines. You work in the field, sometimes treating people on the spot, sometimes bringing them back to medical for specialist treatment. \

You have significant medical training, but typically you are not a doctor, and will lack a medical degree. The actual doctors have seniority, and you should follow their orders, especially concerning treatment and diagnosis of a patient\

You need to be ready to run at a moment's notice, and as such you should take careful care of your gear. Pack as many medicines, treatments, rollerbeds and other equipment as you can. Be sure to bring along some kind of heavy tool for breaching sealed areas.\

When the wounded are inside medbay, you will often act as a porter, transporting patients to and from various specialist treatment rooms. If your labour can save time for a doctor, get to it.\

Once your duty to the living is dispensed, your secondary duty is to the dead. You are the designated corpse recovery staff, and you will often need to retrieve bodies from where they died, bring them back and store them in the morgue. This gives a reduction in that player's respawn time.\

This is the most dangerous part of your job, and recovery should only be attempted if you can reasonably do so without endangering yourself. If there are hostile creatures preventing recovery, call ironhammer to deal with them.\

On a lighter note, since you're so fit and agile, you will often be called upon to run errands. When there's no wounded or dead, a paramedic's duties often involve fetching lunch and coffee for the rest of the medical staff.\

Character Expectations:\
Paramedic is a physically demanding job, your character must be fit and strong. No fat bodies allowed\
EVA training is expected, you should be confident in a medical Voidsuit, and optionally in driving an odysseus mech\

Remember that you are a noncombatant. Any weapons you carry should be used for breaching and rescue, not for killing. Use violence only as a last resort to defend yourself or your patient"

	duties = "	Respond to distress calls, extract wounded people from dangerous situations, stabilize them at the scene, and take them to medbay for farther treatment as necessary\
	Watch the crew monitor for signs of injuries or deaths and respond accordingly.\
	Tour around departments checking up on the health of the crew. Administer first aid on scene as required\
	During quieter times, retrieve the corpses of the dead from around the ship\
	Run errands for the medbay staff, act as their hands outside of the medbay"

	loyalties = "	As a medical specialist, your first loyalty is to save lives, you swore an oath to do no harm. When in any dangerous situation, do your best to ensure as many as possible come out of it alive. A martyr complex is not uncommon in paramedics\
	\
	Your second loyalty is to your immediate superior, the Moebius Biolab Officer. Follow their instructions and policies.\
	\
	Your third loyalty is to your fellow colleagues in Moebius, especially those in Moebius medical. You are the lowest ranked personnel in the medbay, and you take orders from everyone else working there."

/obj/landmark/join/start/paramedic
	name = "Moebius Paramedic"
	icon_state = "player-green"
	join_tag = /datum/job/paramedic

