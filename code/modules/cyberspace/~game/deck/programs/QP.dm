/obj/item/computer_hardware/deck
	var/QuantumPointsLimit = 6
	var/QuantumPoints = 0

	proc
		SetQP(value, force = FALSE) // If you use it, proper check that it returns TRUE. TRUE means that new value can be assigned, and assigned or already.
									// If returned nothing then value too big or somewhy it unable to be setted.
			if(QuantumPoints == value)
				return TRUE
			else if(value <= QuantumPointsLimit || force)
				QuantumPoints = value
				. = TRUE

		GetFreePlaceForQP()
			return QuantumPointsLimit - QuantumPoints
		CostQP(value)
			. = QuantumPoints > value
			if(.)
				QuantumPoints -= value

