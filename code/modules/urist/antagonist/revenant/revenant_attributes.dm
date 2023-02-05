/* Managing Powers/Hungers/Distortions */


/datum/bluespace_revenant/proc/select_flavors(var/amt = 2, var/list/choices_override = null) // -> assoc list<flavor_tag : weight>
	var/safe_amt = max(0, amt)

	var/list/choices = null

	if(istype(choices_override) && choices_override.len)
		choices = choices_override.Copy()

	if(!(choices?.len))
		choices = BSR_ALL_FLAVORS_LIST

	// We increase the weights exponentially. This is the base of the exponent.
	// 'log-base', because log of base weight_log_base increases linearly
	// This is to make one option the 'primary' flavor, and the rest spice it up.
	var/const/weight_log_base = 3

	// Reserve weight 1 for generic filler, least important
	var/flavor_weight = weight_log_base

	var/list/flavors = list()
	flavors[BSR_FLAVOR_GENERIC] = 1

	while(choices && (flavors.len < safe_amt))
		var/picked_flavor = pick(choices)
		flavors[picked_flavor] = flavor_weight
		choices.Remove(picked_flavor)

		// Exponentially increase the weights, so that we have one main flavor and
		// some secondary ones. We prefer the last pick, because mults are easier.
		flavor_weight *= weight_log_base

	if(flavors.len < safe_amt)
		to_world_log("WARNING: Bluespace Revenant exhausted all choices before picking the requested amount. Proceeding with the smaller amount available!")

	return flavors


/datum/bluespace_revenant/proc/select_bsrevenant_attributes(var/list/flavors_override = null, var/options_callable = null, var/count = 1)
	// This is a generic helper used by Power/Hunger/Distortions procgen

	if(isnull(options_callable))
		to_world_log("BLUESPACE REVENANT: ERROR - select_bsrevenant_attributes called without an options callable!")
		return

	if(isnull(count) || count < 0)
		to_world_log("BLUESPACE REVENANT: ERROR - select_bsrevenant_attributes called with an invalid count arg: [count]!")
		return

	var/list/true_flavors = flavors_override

	if(isnull(true_flavors))
		true_flavors = src.flavors

	if(isnull(true_flavors))
		true_flavors = src.select_flavors()

	var/list/power_options = call(src, options_callable)()
	var/list/powerset = list()

	var/num_powers = count
	var/list/pickable_powers = list()

	var/max_attempts = max(0, count) * 2
	var/attempts = 0

	while(powerset.len < num_powers)
		sleep(-1)

		if(!(power_options?.len))
			to_world_log("BLUESPACE REVENANT: No power options, aborting attribute selection!")
			break

		if(attempts++ >= max_attempts)
			to_world_log("BLUESPACE REVENANT: Exceeded max tries ([attempts] out of [max_attempts]), aborting attribute selection!")
			break

		pickable_powers.Cut() // we're reusing the same list object a bunch for efficiency

		var/rolled_flavor = sample_with_weights(true_flavors)

		if(isnull(rolled_flavor))
			to_world_log("BLUESPACE REVENANT: Flavor is null. This should never happen, aborting attribute selection!")
			break

		var/list/flavor_powers = power_options[rolled_flavor]
		if(flavor_powers)
			// Avoid mutating power options in-place
			flavor_powers = flavor_powers.Copy()

		if(isnull(flavor_powers))
			to_world_log("BLUESPACE REVENANT: Flavor [rolled_flavor] does not correspond to a valid option. This should never happen, aborting attribute selection!")
			break

		for(var/rawFP in flavor_powers)
			var/datum/power/revenant/FP = GLOB.revenant_powerinstances[rawFP]

			if(!istype(FP))
				continue

			if(FP in powerset)
				continue

			pickable_powers.Add(FP)

		// NOTE: this could use weights as well, potentially
		var/datum/power/revenant/selected_power = null

		if(pickable_powers?.len)
			selected_power = pick(pickable_powers)

		if(selected_power)
			powerset.Add(selected_power)

	return powerset


/datum/bluespace_revenant/proc/unlockPower(var/datum/mind/M, var/Pname, var/remake_verbs = 1)
	if(!M || !M.bluespace_revenant)
		return

	var/datum/power/revenant/Thepower = null

	if(ispath(Pname))
		Thepower = GLOB.revenant_powerinstances[Pname]

	else if(istype(Pname, /datum/power/revenant))
		Thepower = Pname

	else
		for (var/Ptype in GLOB.revenant_powerinstances)
			var/datum/power/revenant/P = GLOB.revenant_powerinstances[Ptype]
			if(P.name == Pname)
				Thepower = P

	if(Thepower == null)
		to_chat(M.current, "This is awkward.  Revenant power unlock failed for `[Pname]`, please report this bug to a coder!")
		return

	if(Thepower in src.unlocked_powers)
		to_world_log("Attempted to unlock an already unlocked Bluespace Revenant power `[Thepower]` for [M]")
		return

	src.unlocked_powers += Thepower

	Thepower.Activate()

	if(remake_verbs)
		M.current.make_bsrevenant()

	to_world_log("Unlocked power `[Thepower]` for mind [M] ([M?.current || "no mob"])")
	return
