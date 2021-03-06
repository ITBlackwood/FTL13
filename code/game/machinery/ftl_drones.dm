/obj/machinery/drone
  name = "common drone"
  icon = 'icons/obj/drones.dmi'
  icon_state = "drone_def"
  density = 1
  anchored = 0
  var/health_max
  var/health_current
  var/deployed = 0
  var/ammo_max
  var/ammo_remaining
  var/hit_chance = 1

/obj/machinery/drone/proc/can_action()
	if(ammo_remaining > 0)
		return 1
	else	return 0

/obj/machinery/drone/proc/attempt_action()
	if(!can_action())
		return
	ammo_remaining--

/obj/machinery/drone/proc/any_success()
  if(prob(hit_chance))    return 1
  else  return 0


/obj/machinery/drone/defence
  name = "Defence drone Mk.I"
  desc = "Standard defence drone for NT vessels."
  icon = 'icons/obj/drones.dmi'
  icon_state = "drone_def"
  health_max = 50
  health_current = 50
  ammo_max = 250
  ammo_remaining = 250

/obj/machinery/drone/defence/attack_hand(mob/user as mob)
  if(ammo_remaining)
    var/obj/item/weapon/twohanded/required/drone_ammo_case/pack = new /obj/item/weapon/twohanded/required/drone_ammo_case(null)
    pack.ammo = ammo_remaining
    ammo_remaining = 0
    user.put_in_hands(pack)
    user << "You took the ammo from the drone!"

/obj/machinery/drone/defence/attackby(obj/item/weapon/W, mob/user, params)
  if(istype(W, /obj/item/weapon/twohanded/required/drone_ammo_case))
    var/obj/item/weapon/twohanded/required/drone_ammo_case/B = W
    if(!ammo_remaining)
      ammo_remaining = B.ammo
      user << "You replaced the drone ammo!"
      qdel(W)
    else
      user << "Pack was already installed."


/obj/item/weapon/twohanded/required/drone_ammo_case
	name = "defence drone ammo case"
	desc = "Inject it into drone to reload it"
	icon = 'icons/obj/ammo.dmi'
	icon_state = ".50mag"
	item_state = ".50mag"
	var/ammo = 250

/obj/machinery/drone/repair
  name = "Repair drone Type-I"
  desc = "Drone used for quick breach repairs"
  icon = 'icons/obj/drones.dmi'
  icon_state = "drone_rep"
  health_max = 50
  health_current = 50
  ammo_max = 5
  ammo_remaining = 5

/obj/machinery/drone/repair/attack_hand(mob/user as mob)
  if(ammo_remaining)
    var/obj/item/weapon/grenade/chem_grenade/metalfoam/grenade = new /obj/item/weapon/grenade/chem_grenade/metalfoam(null)
    ammo_remaining--
    user.put_in_hands(grenade)
    user << "You took the [grenade] from the drone!"

/obj/machinery/drone/defence/attackby(obj/item/weapon/W, mob/user, params)
  if(istype(W, /obj/item/weapon/grenade/chem_grenade/metalfoam))
    if(ammo_remaining < ammo_max)
      ammo_remaining++
      user << "You replaced the drone ammo!"
      qdel(W)
    else
      user << "Drone already full."
