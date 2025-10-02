/mob/living/basic/crinos_beast
	name = "Wolf-like Beast"
	desc = "The peak of abominations damage. Unbelievably deadly..."
	icon = 'modular_darkpack/modules/npc/icons/werewolf.dmi'
	icon_state = "beast_crinos"
	icon_living = "beast_crinos"

	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BEAST

	speed = 1
	max_stamina = 575
	maxHealth = 575
	health = 575

	butcher_results = list(/obj/item/stack/human_flesh = 10)

	combat_mode = TRUE
	melee_damage_lower = 35
	melee_damage_upper = 35

	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/slash.ogg'

	bloodpool = 10
	maxbloodpool = 10
