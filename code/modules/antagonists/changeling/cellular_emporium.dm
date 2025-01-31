#define ANTAG_EXTENDED 	(1<<0)
#define ANTAG_DYNAMIC 	(1<<1)

// cellular emporium
// The place where changelings go to buy their biological weaponry.

/datum/cellular_emporium
	var/name = "cellular emporium"
	var/datum/antagonist/changeling/changeling

/datum/cellular_emporium/New(my_changeling)
	. = ..()
	changeling = my_changeling

/datum/cellular_emporium/Destroy()
	changeling = null
	. = ..()

/datum/cellular_emporium/ui_state(mob/user)
	return GLOB.always_state

/datum/cellular_emporium/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CellularEmporium", name)
		ui.open()

/datum/cellular_emporium/ui_data(mob/user)
	var/list/data = list()

	var/can_readapt = changeling.can_respec
	var/genetic_points_remaining = changeling.geneticpoints
	var/absorbed_dna_count = changeling.absorbedcount
	var/true_absorbs = changeling.trueabsorbs

	data["can_readapt"] = can_readapt
	data["genetic_points_remaining"] = genetic_points_remaining
	data["absorbed_dna_count"] = absorbed_dna_count

	var/list/abilities = list()

	for(var/path in changeling.all_powers)
		var/datum/action/changeling/ability = path

		var/dna_cost = initial(ability.dna_cost)
		if(dna_cost <= 0)
			continue

		if(!gamemode_restricted(ability))
			continue

		var/list/AL = list()
		AL["name"] = initial(ability.name)
		AL["desc"] = initial(ability.desc)
		AL["helptext"] = initial(ability.helptext)
		AL["owned"] = changeling.has_sting(ability)
		var/req_dna = initial(ability.req_dna)
		var/req_absorbs = initial(ability.req_absorbs)
		AL["dna_cost"] = dna_cost
		AL["can_purchase"] = ((req_absorbs <= true_absorbs) && (req_dna <= absorbed_dna_count) && (dna_cost <= genetic_points_remaining))

		abilities += list(AL)

	data["abilities"] = abilities

	return data

/datum/cellular_emporium/ui_act(action, params)
	if(..())
		return

	switch(action)
		if("readapt")
			if(changeling.can_respec)
				changeling.readapt()
		if("evolve")
			var/sting_name = params["name"]
			changeling.purchase_power(sting_name)

/datum/cellular_emporium/proc/gamemode_restricted(datum/action/changeling/ability)
	if(ANTAG_EXTENDED & initial(ability.gamemode_restriction_type) && SSticker.mode.config_tag == "Extended")
		. = TRUE
	if(ANTAG_DYNAMIC & initial(ability.gamemode_restriction_type) && SSticker.mode.config_tag == "Dynamic")
		. = TRUE

/datum/action/innate/cellular_emporium
	name = "Cellular Emporium"
	icon_icon = 'icons/obj/drinks.dmi'
	button_icon_state = "changelingsting"
	background_icon_state = "bg_changeling"
	var/datum/cellular_emporium/cellular_emporium

/datum/action/innate/cellular_emporium/New(our_target)
	. = ..()
	if(istype(our_target, /datum/cellular_emporium))
		cellular_emporium = our_target
	else
		CRASH("cellular_emporium action created with non emporium")

/datum/action/innate/cellular_emporium/Activate()
	cellular_emporium.ui_interact(owner)
