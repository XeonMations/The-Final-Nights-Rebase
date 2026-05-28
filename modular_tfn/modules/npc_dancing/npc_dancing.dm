#define DANCE_DETECTION_RANGE 15

/turf/open/floor/light/colour_cycle
	var/mob/living/carbon/human/npc/dancer
	var/npcs_can_dance = TRUE
	desc = "Funky floor. Alt-click to toggle NPC dancing."

/turf/open/floor/light/colour_cycle/click_alt(mob/user)
	npcs_can_dance = !npcs_can_dance
	if(!npcs_can_dance && dancer)
		dancer.leave_dance_floor()
	to_chat(user, span_notice("NPC dancing on this tile is now [npcs_can_dance ? "enabled" : "disabled"]."))
	return CLICK_ACTION_SUCCESS

/mob/living/carbon/human/npc
	var/can_dance = FALSE
	var/turf/open/floor/light/colour_cycle/dance_center = null

/mob/living/carbon/human/npc/walkby
	can_dance = TRUE

/mob/living/carbon/human/npc/Destroy()
	leave_dance_floor()
	. = ..()

/mob/living/carbon/human/npc/Aggro(mob/living/victim, attacked = FALSE)
	. = ..()
	leave_dance_floor()

/mob/living/carbon/human/npc/proc/leave_dance_floor()
	if(!dance_center)
		return
	dance_center.dancer = null
	dance_center = null

/mob/living/proc/npc_dance(chained = FALSE)
	if(dancing)
		return
	if(!chained && !prob(60))
		return
	dancing = TRUE

	var/beat = rand(1, 3)
	var/matrix/left = matrix()
	left.Translate(-3, 0)
	var/matrix/right = matrix()
	right.Translate(3, 0)
	var/matrix/up = matrix()
	up.Translate(0, 3)
	var/matrix/down = matrix()
	down.Translate(0, -3)
	var/matrix/center = matrix()
	var/total_ticks = 0

	// shimmy
	animate(src, transform = left, time = beat, loop = 0)
	animate(transform = right, time = beat, loop = 0)
	total_ticks += 2 * beat
	if(prob(50))
		animate(transform = left, time = beat, loop = 0)
		animate(transform = right, time = beat, loop = 0)
		total_ticks += 2 * beat
	if(prob(50))
		animate(transform = left, time = beat, loop = 0)
		animate(transform = right, time = beat, loop = 0)
		total_ticks += 2 * beat
	animate(transform = center, time = beat, loop = 0)
	total_ticks += beat

	// hippity hop
	animate(transform = up, time = beat, loop = 0)
	animate(transform = down, time = beat, loop = 0)
	total_ticks += 2 * beat
	if(prob(50))
		animate(transform = up, time = beat, loop = 0)
		animate(transform = down, time = beat, loop = 0)
		total_ticks += 2 * beat
	if(prob(50))
		animate(transform = up, time = beat, loop = 0)
		animate(transform = down, time = beat, loop = 0)
		total_ticks += 2 * beat
	animate(transform = center, time = beat, loop = 0)
	total_ticks += beat

	if(prob(20))
		addtimer(CALLBACK(src, PROC_REF(npc_spin_dirs), dir), total_ticks * 0.1 SECONDS)
		total_ticks += 4

	addtimer(CALLBACK(src, PROC_REF(clear_dance_flag)), total_ticks * 0.1 SECONDS)

/mob/living/proc/npc_spin_dirs(original_dir)
	for(var/spin_dir in list(SOUTH, EAST, NORTH, WEST))
		setDir(spin_dir)
		sleep(1)
	setDir(original_dir)

/mob/living/proc/clear_dance_flag()
	dancing = FALSE

/mob/living/carbon/human/npc/clear_dance_flag()
	. = ..()
	if(dance_center && !danger_source)
		do_npc_dance(chained = TRUE)

/mob/living/carbon/human/npc/proc/do_npc_dance(chained = FALSE)
	npc_dance(chained)
	if(!dancing || !dance_center || danger_source)
		return
	if(!prob(25))
		return
	balloon_alert_to_viewers(pick("dances!", "busts a move!", "grooves!", "shakes it!", "gets down!", "vibes!"))

/mob/living/carbon/human/npc/ChoosePath()
	if(dance_center)
		return dance_center
	if(can_dance && !danger_source && !old_movement && try_claim_dance_turf())
		return dance_center
	return ..()

/mob/living/carbon/human/npc/proc/try_claim_dance_turf()
	for(var/turf/open/floor/light/colour_cycle/T in view(DANCE_DETECTION_RANGE, src))
		if(T.dancer || !T.npcs_can_dance)
			continue
		dance_center = T
		T.dancer = src
		return TRUE
	return FALSE

#undef DANCE_DETECTION_RANGE
