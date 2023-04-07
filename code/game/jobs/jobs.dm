GLOBAL_LIST_INIT(department_command, list(DEPARTMENT_COMMAND))
GLOBAL_LIST_INIT(department_security, list(DEPARTMENT_SECURITY))
GLOBAL_LIST_INIT(department_moebius, list(DEPARTMENT_SCIENCE, DEPARTMENT_MEDICAL))
GLOBAL_LIST_INIT(department_engineering, list(DEPARTMENT_ENGINEERING))
GLOBAL_LIST_INIT(department_guild, list(DEPARTMENT_GUILD))
GLOBAL_LIST_INIT(department_church, list(DEPARTMENT_CHURCH))
GLOBAL_LIST_INIT(department_civilian, list(DEPARTMENT_CIVILIAN))

var/const/ENGINEERING       =(1<<0)
var/const/IRONHAMMER        =(1<<1)
var/const/MEDICAL           =(1<<2)
var/const/SCIENCE           =(1<<3)
var/const/CIVILIAN          =(1<<4)
var/const/COMMAND           =(1<<5)
var/const/MISC              =(1<<6)
var/const/SERVICE           =(1<<7)
var/const/GUILD             =(1<<8)
var/const/CHURCH           	=(1<<9)

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
var/const/BIOENGINEER		=(1<<8)


var/const/FIRSTOFFICER		=(1<<0)
var/const/CLUBMANAGER		=(1<<1)
var/const/CLUBWORKER		=(1<<2)
var/const/MERCHANT			=(1<<3)
var/const/GUILDTECH			=(1<<4)
var/const/MINER				=(1<<5)
var/const/ARTIST			=(1<<6)
var/const/ASSISTANT			=(1<<7)


var/const/CHAPLAIN			=(1<<0)
var/const/ACOLYTE			=(1<<1)
var/const/JANITOR			=(1<<2)
var/const/BOTANIST			=(1<<3)


var/list/assistant_occupations = list()


var/list/command_positions = list(JOBS_COMMAND)


var/list/engineering_positions = list(JOBS_ENGINEERING)


var/list/medical_positions = list(JOBS_MEDICAL)


var/list/science_positions = list(JOBS_SCIENCE)


var/list/moebius_positions = list(JOBS_MOEBIUS)

//BS12 EDIT
var/list/cargo_positions = list(JOBS_CARGO)


var/list/church_positions = list(JOBS_CHURCH)


var/list/civilian_positions = list(JOBS_CIVILIAN)


var/list/security_positions = list(JOBS_SECURITY)


var/list/nonhuman_positions = list(JOBS_NONHUMAN)


/proc/guest_jobbans(var/job)
	return ((job in command_positions) || (job in nonhuman_positions) || (job in security_positions))
