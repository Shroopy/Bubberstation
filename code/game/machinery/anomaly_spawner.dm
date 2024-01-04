/obj/machinery/anomaly_spawner
	name = "anomaly spawner"
	desc = "Creates an anomaly somewhere on the station."
	icon = 'icons/testing/greyscale_error.dmi'
	//icon_state = "ecto_sniffer"
	var/locked = TRUE
	var/list/anomaly_events /// Cache of anomaly events for speed
	var/obj/item/card/id
	var/static/list/used_ids
	req_one_access = list(ACCESS_SCIENCE)

/obj/machinery/anomaly_spawner/Initialize(mapload)
	. = ..()
	anomaly_events = subtypesof(/datum/round_event/anomaly)
	anomaly_events -= /datum/round_event/anomaly/anomaly_vortex // Remove the black hole anomaly from the list because it's too dangerous for crew to summon on purpose

/obj/machinery/anomaly_spawner/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(locked)
		balloon_alert(user, "locked!")
		playsound(src, 'sound/machines/scanbuzz.ogg', 25, TRUE)
	else
		var/type = pick(anomaly_events)
		var/datum/round_event/anomaly/my_event = new type(FALSE)
		my_event.setup_anomaly_properties(drops_core = FALSE)
		my_event.setup()
		my_event.start()
		balloon_alert(user, "summoning anomaly!")
		locked = TRUE

/obj/machinery/anomaly_spawner/attack_hand_secondary(mob/user, list/modifiers)
	if(!locked)
		balloon_alert(user, "locking...")
		playsound(src, 'sound/machines/synth_no.ogg', 100, TRUE, frequency = 6000)
		locked = TRUE
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	else
		return ..()

/obj/machinery/anomaly_spawner/attackby(obj/item/I, mob/living/user, params)
	if(locked)
		var/obj/item/card/id = I.GetID()
		if(id)
			if(check_access(id))
				src.id = id
				locked = FALSE
				balloon_alert(user, "unlocked!")
				playsound(src, 'sound/machines/synth_yes.ogg', 100, TRUE, frequency = 6000)
				//update_appearance()
			else
				balloon_alert(user, "insufficient access.")
				playsound(src, 'sound/machines/scanbuzz.ogg', 25, TRUE)
			return
	else
		balloon_alert(user, "already unlocked!")
