/*
	Department Datums
	Currently only used for a non-shitcode way of having variable initial balances in department accounts
	in future, should be a holder for job datums
*/

/datum/department
	var/name = "unspecified department"	//Name may be shown in UIs, proper capitalisation
	var/id	= "department" //This should be one of the DEPARTMENT_XXX defines in __defines/jobs.dm
	var/account_number = 0
	var/account_pin
	var/account_initial_balance = 3500	//How much money this account starts off with

	// Where the money for wages and budget comes from
	var/funding_source

	// Budget for misc department expenses, paid regardless of it being manned or not
	var/budget_base = 500

	// Budget for crew salaries. Summed up initial wages of department's personnel
	var/budget_personnel = 0

	// How much account failed to pay to employees. Used for emails
	var/total_debt = 0

/datum/department/proc/get_total_budget()
	if(funding_source)
		return budget_base + budget_personnel
	else
		return FALSE


/*************
	Command
**************/
/datum/department/command
	name = "CEV Eris Command"
	id = DEPARTMENT_COMMAND
	/*
	The command account is the ship account. It is the master account that retainer departments are paid from,
	and represents the Captain's wealth, assets and holdings

	For now, it is set to an effectively infinitely high amount which shouldn't run out in normal gameplay
	In future, we will implement largescale missions and research contracts to earn money, and then set it
	to a much lower starting value
	*/
	account_initial_balance = 2000000


/*************
	Retainers
**************/
//These departments are paid out of ship funding
/datum/department/ironhammer
	name = "Ironhammer Mercenary Company"
	id = DEPARTMENT_SECURITY
	funding_source = DEPARTMENT_COMMAND

/datum/department/technomancers
	name = "Technomancer League"
	id = DEPARTMENT_ENGINEERING
	funding_source = DEPARTMENT_COMMAND

/datum/department/civilian
	name = "CEV Eris Civilian"
	id = DEPARTMENT_CIVILIAN
	funding_source = DEPARTMENT_COMMAND


/******************
	Benefactors
*******************/
//Departments subsidised by an external organisation. These pay their own employees
/datum/department/moebius_medical
	name = "Moebius Corp: Medical Division"
	id = DEPARTMENT_MEDICAL
	funding_source = "Moebius Corp."

/datum/department/moebius_research
	name = "Moebius Corp: Research Division"
	id = DEPARTMENT_SCIENCE
	funding_source = "Moebius Corp."

/datum/department/church
	name = "Church of NeoTheology"
	id = DEPARTMENT_CHURCH
	funding_source = "Church of NeoTheology"


/******************
	Independant
*******************/
//Self funds and pays wages out of its earnings
/datum/department/guild
	name = "Asters Merchant Guild"
	id = DEPARTMENT_GUILD

	/*
		The guild account represents the holdings of the local branch, and merchant.
		He recieves no funding, infact later he will pay guild fees out of his earnings
	*/
	account_initial_balance = 7500

/datum/department/offship // Money from serbomat and billomat come here
	name = "Offship entities"
	id = DEPARTMENT_OFFSHIP
