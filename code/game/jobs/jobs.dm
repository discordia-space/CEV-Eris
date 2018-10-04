//delete this after adaptation

var/const/ENG               =(1<<0)
var/const/SEC               =(1<<1)
var/const/MED               =(1<<2)
var/const/SCI               =(1<<3)
var/const/CIV               =(1<<4)
var/const/COM               =(1<<5)
var/const/MSC               =(1<<6)
var/const/SRV               =(1<<7)
var/const/SUP               =(1<<8)
var/const/SPT               =(1<<9)
var/const/EXP               =(1<<10)

//delete this end

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


var/list/assistant_occupations = list()


var/list/command_positions = list(JOBS_COMMAND)


var/list/engineering_positions = list(JOBS_ENGINEERING)


var/list/medical_positions = list(JOBS_MEDICAL)


var/list/science_positions = list(JOBS_SCIENCE)

//BS12 EDIT
var/list/cargo_positions = list(JOBS_CARGO)

var/list/civilian_positions = list(JOBS_CIVILIAN)


var/list/security_positions = list(JOBS_SECURITY)


var/list/nonhuman_positions = list(JOBS_NONHUMAN)


var/list/all_positions = list (JOBS_COMMAND,JOBS_ENGINEERING,JOBS_MEDICAL,JOBS_SCIENCE,JOBS_CARGO,JOBS_CIVILIAN,JOBS_SECURITY,JOBS_NONHUMAN)


/proc/guest_jobbans(var/job)
	return ((job in command_positions) || (job in nonhuman_positions) || (job in security_positions))
