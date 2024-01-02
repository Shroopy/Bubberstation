/obj/machinery/anomaly_spawner
	name = "anomaly spawner"
	desc = "Creates an anomaly somewhere on the station."
	icon = 'icons/testing/greyscale_error.dmi'
	//icon_state = "ecto_sniffer"

/obj/machinery/anomaly_spawner/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	var/type = pick(subtypesof(/datum/round_event/anomaly))
	var/datum/round_event/anomaly/my_event = new type()
	my_event.setup_anomaly_properties(drops_core = FALSE)
	my_event.setup()
	my_event.start()
