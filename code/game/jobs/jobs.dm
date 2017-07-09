
var/const/ENGSEC			=(1<<0)

var/const/CAPTAIN			=(1<<0)
var/const/IHC				=(1<<1)
var/const/GUNSERG			=(1<<2)
var/const/INSPECTOR			=(1<<3)
var/const/IHOPER			=(1<<4)
var/const/MEDSPEC			=(1<<5)
var/const/EXULTANT			=(1<<6)
var/const/TECHNOMANCER		=(1<<7)
var/const/AI				=(1<<8)
var/const/CYBORG			=(1<<9)


var/const/MEDSCI			=(1<<1)

var/const/MEO				=(1<<0)
var/const/SCIENTIST			=(1<<1)
var/const/CHEMIST			=(1<<2)
var/const/MBO				=(1<<3)
var/const/DOCTOR			=(1<<4)
var/const/PSYCHIATRIST		=(1<<5)
var/const/ROBOTICIST		=(1<<6)
var/const/PARAMEDIC			=(1<<7)


var/const/CIVILIAN			=(1<<2)

var/const/FIRSTOFFICER		=(1<<0)
var/const/BARTENDER			=(1<<1)
var/const/BOTANIST			=(1<<2)
var/const/CHEF				=(1<<3)
var/const/JANITOR			=(1<<4)
var/const/MERCHANT			=(1<<5)
var/const/GUILDTECH			=(1<<6)
var/const/MINER				=(1<<7)
var/const/CHAPLAIN			=(1<<8)
var/const/ACTOR				=(1<<9)
var/const/ASSISTANT			=(1<<10)


var/list/assistant_occupations = list(
)


var/list/command_positions = list(
	"Captain",
	"First Officer",
	"Ironhammer Commander",
	"Technomancer Exultant",
	"Guild Merchant",
	"Moebius Expedition Overseer",
	"Moebius Biolab Officer"
)


var/list/engineering_positions = list(
	"Technomancer Exultant",
	"Technomancer",
)


var/list/medical_positions = list(
	"Moebius Biolab Officer",
	"Moebius Doctor",
	"Moebius Psychiatrist",
	"Moebius Chemist",
	"Moebius Paramedic"
)


var/list/science_positions = list(
	"Moebius Expedition Overseer",
	"Moebius Scientist",
	"Moebius Roboticist",
)

//BS12 EDIT
var/list/cargo_positions = list(
	"Guild Merchant",
	"Guild Technician",
	"Guild Miner"
)

var/list/civilian_positions = list(
	"First Officer",
	"Bartender",
	"Gardener",
	"Chef",
	"Janitor",
	"Cyberchristian Preacher",
	"Assistant"
)


var/list/security_positions = list(
	"Ironhammer Commander",
	"Ironhammer Gunnery Sergeant",
	"Ironhammer Medical Specialist",
	"Ironhammer Inspector",
	"Ironhammer Operative"
)


var/list/nonhuman_positions = list(
	"AI",
	"Cyborg",
	"pAI"
)


/proc/guest_jobbans(var/job)
	return ((job in command_positions) || (job in nonhuman_positions) || (job in security_positions))

/proc/get_job_datums()
	var/list/occupations = list()
	var/list/all_jobs = typesof(/datum/job)

	for(var/A in all_jobs)
		var/datum/job/job = new A()
		if(!job)	continue
		occupations += job

	return occupations
