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

	// Must be one of the FUNDING_XXX defines in __defines/economy.dm
	var/funding_type = FUNDING_INTERNAL

	// Where the money for wages and budget comes from
	var/funding_source = DEPARTMENT_COMMAND

	// Budget for misc department expenses, paid regardless of it being manned or not
	var/budget_base = 500

	// Budget for crew salaries. Summed up initial wages of department's personnel
	var/budget_personnel = 0

	// How much account failed to pay to employees. Used for emails
	var/total_debt = 0

/datum/department/proc/get_total_budget()
	return budget_base + budget_personnel


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
	funding_type = FUNDING_NONE


/*************
	Retainers
**************/
//These departments are paid out of ship funding
/datum/department/ironhammer
	name = "Ironhammer Mercenary Company"
	id = DEPARTMENT_SECURITY

/datum/department/technomancers
	name = "Technomancer League"
	id = DEPARTMENT_ENGINEERING

/datum/department/civilian
	name = "CEV Eris Civilian"
	id = DEPARTMENT_CIVILIAN
	//Now for the club


/******************
	Benefactors
*******************/
//Departments subsidised by an external organisation. These pay their own employees
/datum/department/moebius_medical
	name = "Moebius Corp: Medical Division"
	id = DEPARTMENT_MEDICAL
	funding_type = FUNDING_EXTERNAL
	funding_source = "Moebius Corp."

/datum/department/moebius_research
	name = "Moebius Corp: Research Division"
	id = DEPARTMENT_SCIENCE
	funding_type = FUNDING_EXTERNAL
	funding_source = "Moebius Corp."

/datum/department/church
	name = "Church of NeoTheology"
	id = DEPARTMENT_CHURCH
	funding_type = FUNDING_NONE //The church on eris has no external funding. This further reinforces the theory that everyone on the CEV Eris is a reject of their factions
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
	funding_type = FUNDING_NONE

/datum/department/offship //So we can pay the Club without giving them independant money
	name = "Offship entities"
	id = DEPARTMENT_OFFSHIP
	funding_type = FUNDING_NONE
