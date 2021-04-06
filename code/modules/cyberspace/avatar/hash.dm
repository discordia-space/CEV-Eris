/datum/CyberSpaceAvatar
	var/hash
	var/rangeOfProof = list(10, 99)

/datum/CyberSpaceAvatar/New()
	. = ..()
	GenerateSecurityHash()

/datum/CyberSpaceAvatar/proc/GenerateSecurityHash()
	if(istype(Owner) && !QDELETED(Owner) && !hash)
		hash = GetSecurityHashByAtom(Owner, rand(rangeOfProof[1], rangeOfProof[2]))

/datum/CyberSpaceAvatar/proc/GetSecurityHashByAtom(atom/A, proofOfWork = rand(10, 99))
	. = md5("\ref[A]:[proofOfWork]")
