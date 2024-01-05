/obj/machinery/anomaly_spawner
	name = "anomaly spawner"
	desc = "Creates an anomaly somewhere on the station."
	icon = 'icons/testing/greyscale_error.dmi'
	//icon_state = "ecto_sniffer"
	var/locked = TRUE
	var/list/obj/effect/anomaly/anomalies
	var/obj/item/card/id
	var/list/obj/item/card/used_ids = list()
	var/static/datum/anomaly_placer/placer = new()
	req_one_access = list(ACCESS_SCIENCE)

/obj/machinery/anomaly_spawner/Initialize(mapload)
	. = ..()
	anomalies = list(
		/obj/effect/anomaly/bioscrambler,
		/obj/effect/anomaly/bluespace,
		/obj/effect/anomaly/dimensional,
		// /obj/effect/anomaly/ectoplasm, // Too dangerous? Not sure
		/obj/effect/anomaly/flux,
		/obj/effect/anomaly/grav,
		/obj/effect/anomaly/hallucination,
		// /obj/effect/anomaly/pyro, // Probably too dangerous
		// /obj/effect/anomaly/bhole, // Definitely too dangerous
	)

/obj/machinery/anomaly_spawner/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(locked)
		balloon_alert(user, "locked!")
		playsound(src, 'sound/machines/scanbuzz.ogg', 25, TRUE)
	else // Spawn anomaly
		var/area/impact_area = placer.findValidArea()
		var/turf/anomaly_turf = placer.findValidTurf(impact_area)
		var/type = pick(anomalies)
		var/obj/effect/anomaly/newAnomaly = new type(anomaly_turf, 0, FALSE)
		priority_announce("An anomaly has been summoned by the science team, impacting in [impact_area.name].", "Anomaly Alert", ANNOUNCER_ANOMALIES)
		used_ids += id
		used_ids[used_ids[used_ids.len]] = newAnomaly
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
			if(used_ids.len != 0)
				var/index = used_ids.Find(id)
				var/obj/effect/anomaly/anomaly = used_ids[used_ids[index]]
				if(anomaly.is_stable() || QDELETED(anomaly))
					used_ids.Remove(id)
				else
					balloon_alert(user, "reused id!")
					to_chat(user, span_warning("This ID has already been used to summon an anomaly. You must stabilize or neutralize it before you can summon another!"))
					playsound(src, 'sound/machines/scanbuzz.ogg', 25, TRUE)
					return
			if(check_access(id))
				src.id = id
				locked = FALSE
				balloon_alert(user, "unlocked!")
				playsound(src, 'sound/machines/synth_yes.ogg', 100, TRUE, frequency = 6000)
				//update_appearance()
			else
				balloon_alert(user, "insufficient access.")
				playsound(src, 'sound/machines/scanbuzz.ogg', 25, TRUE)
	else
		balloon_alert(user, "already unlocked!")
