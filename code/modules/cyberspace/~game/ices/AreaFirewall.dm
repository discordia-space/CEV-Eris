/datum/CyberSpaceAvatar/AreaFirewall
	var/SecurityHash // Generates almost random md5 hash on initialize that will available to AI // Hackers will bruteforce it like miners
	var/rangeOfProof = list(10, 99)

	// icon_file = 
	// icon_state = 

/datum/CyberSpaceAvatar/AreaFirewall/New()
	. = ..()
	GenerateSecurityHash()

/datum/CyberSpaceAvatar/AreaFirewall/proc/GenerateSecurityHash()
	if(istype(Owner) && !QDELETED(Owner))
		SecurityHash = GetSecurityHashByAtom(Owner, rand(rangeOfProof[1], rangeOfProof[2]))

/datum/CyberSpaceAvatar/AreaFirewall/proc/GetSecurityHashByAtom(atom/A, proofOfWork = rand(10, 99))
	. = md5("[A.x][A.y][A.z][proofOfWork]")
