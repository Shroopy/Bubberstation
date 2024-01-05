///Use on an anomaly to stabilize it
/obj/item/anomaly_stabilizer
	name = "anomaly stabilizer"
	desc = "Single-use injector that stabilizes anomalies by injecting an unknown substance."
	icon = 'icons/obj/devices/syndie_gadget.dmi'
	icon_state = "anomaly_releaser"
	inhand_icon_state = "stimpen"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5

	///icon state after being used up
	var/used_icon_state = "anomaly_releaser_used"
	///are we used? if used we can't be used again
	var/used = FALSE
	///Can we be used infinitely?
	var/infinite = FALSE

/obj/item/anomaly_stabilizer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()

	if(used || !proximity_flag || !istype(target, /obj/effect/anomaly))
		return

	var/obj/effect/anomaly/anomaly = target
	anomaly.stabilize(TRUE)
	// add sound

	if(infinite)
		return

	icon_state = used_icon_state
	used = TRUE
	name = "used " + name
