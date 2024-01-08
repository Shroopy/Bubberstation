/obj/item/anomaly_analyzer
	name = "anomaly analyzer"
	icon = 'icons/testing/greyscale_error.dmi'
	//icon_state = "health"
	//inhand_icon_state = "healthanalyzer"
	//worn_icon_state = "healthanalyzer"
	//lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	//righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	desc = "A scanner to log anomalies with for research bonuses."
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	//custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT *2)
	var/datum/techweb/stored_research

/obj/machinery/rnd/LateInitialize()
	. = ..()
	if(!CONFIG_GET(flag/no_default_techweb_link) && !stored_research)
		CONNECT_TO_RND_SERVER_ROUNDSTART(stored_research, src)
	if(stored_research)
		on_connected_techweb()

/obj/item/anomaly_analyzer/interact_with_atom(atom/interacting_with, mob/living/user)
	if(!istype(interacting_with, /obj/effect/anomaly))
		return NONE

	var/obj/effect/anomaly/anomaly = interacting_with

	// SHROOPYTODO link the anomaly to the techweb?





