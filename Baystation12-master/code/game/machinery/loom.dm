var/global/list/loom_recipes = list( \
		/* screwdriver removed*/ \
		new /obj/item/weapon/grown/cotton(),\
		new /obj/item/clothing/glasses/eyepatch(), \
		new /obj/item/clothing/gloves/grey(), \
		new /obj/item/clothing/gloves/swat(), \
		new /obj/item/clothing/head/bandana(), \
		new /obj/item/clothing/head/beret(), \
		new /obj/item/clothing/head/bowler(), \
		new /obj/item/clothing/head/cakehat(), \
		new /obj/item/clothing/head/chicken(), \
		new /obj/item/clothing/head/hgpiratecap(), \
		new /obj/item/clothing/head/kitty(), \
		new /obj/item/clothing/head/mousey(), \
		new /obj/item/clothing/head/plaguedoctorhat(), \
		new /obj/item/clothing/head/powdered_wig(), \
		new /obj/item/clothing/head/rabbitears(), \
		new /obj/item/clothing/head/soft/grey(), \
		new /obj/item/clothing/head/that(), \
		new /obj/item/clothing/mask/balaclava(), \
		new /obj/item/clothing/suit/chickensuit(), \
		new /obj/item/clothing/suit/hgpirate(), \
		new /obj/item/clothing/suit/ianshirt(), \
		new /obj/item/clothing/suit/imperium_monk(), \
		new /obj/item/clothing/suit/monkeysuit(), \
		new /obj/item/clothing/suit/pirate(), \
		new /obj/item/clothing/suit/suspenders(), \
		new /obj/item/clothing/under/blackskirt(),\
		new /obj/item/clothing/under/color/grey(),\
		new /obj/item/clothing/mask/gas/monkeymask(),\
		new /obj/item/clothing/mask/gas/owl_mask(), \
		new /obj/item/clothing/mask/gas/sexyclown(), \
		new /obj/item/clothing/mask/gas/sexymime(), \
		new /obj/item/clothing/under/dress/dress_orange(), \
		new /obj/item/clothing/under/dress/dress_green(), \
		new /obj/item/clothing/under/dress/dress_pink(), \
		new /obj/item/clothing/under/dress/dress_yellow(), \
		new /obj/item/clothing/under/kilt(), \
		new /obj/item/clothing/under/owl(), \
		new /obj/item/clothing/under/pirate(), \
		new /obj/item/clothing/under/schoolgirl(), \
		new /obj/item/clothing/under/sexyclown(), \
		new /obj/item/clothing/under/sexymime(), \
		new /obj/item/clothing/under/wedding/bride_blue(), \
		new /obj/item/clothing/under/lawyer/black(), \
		new /obj/item/clothing/under/lawyer/blue(),\
		new /obj/item/clothing/under/lawyer/bluesuit(),\
		new /obj/item/clothing/under/lawyer/purpsuit(),\
		new /obj/item/clothing/suit/storage/lawyer/bluejacket(),\
		new /obj/item/clothing/suit/storage/lawyer/purpjacket(),\
		new /obj/item/clothing/under/suit_jacket(),\
		new /obj/item/clothing/under/suit_jacket/really_black(),\
		new /obj/item/clothing/under/suit_jacket/female(),\
		new /obj/item/clothing/under/suit_jacket/red(),\
		new /obj/item/clothing/under/pj/red(), \
		new /obj/item/clothing/under/pj/blue(),\
		new /obj/item/weapon/bedsheet(),\
		new /obj/item/weapon/bedsheet/blue(),\
		new /obj/item/weapon/bedsheet/green(),\
		new /obj/item/weapon/bedsheet/orange(),\
		new /obj/item/weapon/bedsheet/purple(),\
		new /obj/item/weapon/bedsheet/rainbow(),\
		new /obj/item/weapon/bedsheet/red(),\
		new /obj/item/weapon/bedsheet/yellow(),\
		new /obj/item/weapon/bedsheet/mime(),\
		new /obj/item/weapon/bedsheet/clown(),\
		new /obj/item/weapon/bedsheet/captain(),\
		new /obj/item/weapon/bedsheet/rd(),\
		new /obj/item/weapon/bedsheet/medical(),\
		new /obj/item/weapon/bedsheet/hos(),\
		new /obj/item/weapon/bedsheet/hop(),\
		new /obj/item/weapon/bedsheet/ce(),\
		new /obj/item/weapon/bedsheet/brown(),\
	)

var/global/list/loom_recipes_hidden = list(

)

/obj/machinery/loom
	name = "Autoloom"
	desc = "It produces clothes using cotton"
	icon = 'icons/obj/cotton.dmi'
	icon_state = "loom"
	density = 1
	var/max_cotton=100
	var/cotton=0


	var/m_amount = 0.0
	var/max_m_amount = 150000.0



	var/operating = 0.0
	var/opened = 0.0
	anchored = 1.0
	var/list/L = list()
	var/list/LL = list()
	var/hacked = 0
	var/disabled = 0
	var/shocked = 0
/*	var/list/wires = list()
	var/hack_wire
	var/disable_wire
	var/shock_wire*/
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100
	var/busy = 0

	proc

		regular_win(mob/user as mob)
			var/dat as text
			dat = text("<B>Cotton Amount:</B> [src.cotton] cm<sup>3</sup> (MAX: [max_cotton])<br>")
			var/list/objs = list()
			objs += src.L

			for(var/obj/t in objs)
				var/title = "[t.name] ([t.m_amt] cotton)"
				if (cotton<t.m_amt )//If the amount you have is less than the amount required
					dat += title + "<br>"
					continue
				dat += "<A href='?src=\ref[src];make=\ref[t]'>[title]</A>"
				if (istype(t, /obj/item/stack))
					var/obj/item/stack/S = t
					var/max_multiplier = min(S.max_amount, S.m_amt?round(m_amount/S.m_amt):INFINITY)
					if (max_multiplier>1)
						dat += " |"
					if (max_multiplier>10)
						dat += " <A href='?src=\ref[src];make=\ref[t];multiplier=[10]'>x[10]</A>"
					if (max_multiplier>25)
						dat += " <A href='?src=\ref[src];make=\ref[t];multiplier=[25]'>x[25]</A>"
					if (max_multiplier>1)
						dat += " <A href='?src=\ref[src];make=\ref[t];multiplier=[max_multiplier]'>x[max_multiplier]</A>"
				dat += "<br>"
			user << browse("<HTML><HEAD><TITLE> Autoloom Control Panel</TITLE></HEAD><BODY><TT>[dat]</TT></BODY></HTML>", "window=autoloom_regular")
			onclose(user, "autoloom_regular")



	interact(mob/user as mob)
		if(..())
			return
		if (src.disabled)
			user << "\red You press the button, but nothing happens."
			return
		regular_win(user)
		return

	attackby(var/obj/item/O as obj, var/mob/user as mob)
		if (stat)
			return 1
		if (busy)
			user << "\red The autoloom is busy. Please wait for completion of previous operation."
			return 1
		if (src.cotton + 1 > max_cotton)
			user << "\red The autoloom is full."
			return 1
		else if (istype(O, /obj/item/weapon/grown/cotton))
			src.cotton=src.cotton + 1
			del(O)
			src.updateUsrDialog()
			return 1

		else
			user.set_machine(src)
			interact(user)
			return 1


	attack_paw(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		user.set_machine(src)
		interact(user)


	Topic(href, href_list)//You need this
		if(..())
			return
		usr.set_machine(src)
		src.add_fingerprint(usr)
		if (!busy)
			if(href_list["make"])
				var/turf/T = get_step(src.loc, get_dir(src,usr))
				var/obj/template = locate(href_list["make"])
				var/multiplier = text2num(href_list["multiplier"])
				if (!multiplier) multiplier = 1
				var/power = max(2000, (template.m_amt)*multiplier/5)
				if(src.cotton >= template.m_amt*multiplier )
					busy = 1
					use_power(power)
					icon_state = "loom"
//					flick("autolathe_n",src)
					spawn(16)
						use_power(power)
						spawn(16)
							use_power(power)
							spawn(16)
								src.cotton -= template.m_amt*multiplier
								if(src.cotton < 0)
									src.cotton = 0
								var/obj/new_item = new template.type(T)
								if (multiplier>1)
									var/obj/item/stack/S = new_item
									S.amount = multiplier
								busy = 0
								src.updateUsrDialog()
		else
			usr << "\red The autoloom is busy. Please wait for completion of previous operation."
		src.updateUsrDialog()
		return


	RefreshParts()
		..()
		var/tot_rating = 0
		for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
			tot_rating += MB.rating
		tot_rating *= 25000
		max_m_amount = tot_rating * 2


	New()
		..()
		component_parts = list()
		component_parts += new /obj/item/weapon/circuitboard/autoloom(src)
		component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
		component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
		component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
		component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
		component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
		RefreshParts()

		src.L = loom_recipes
		src.LL = loom_recipes_hidden