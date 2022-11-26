
local anims = {
	{ "Carry box",          "anim@heists@box_carry@",                                       "idle"                  },
	{ "Load box",           "anim@heists@load_box",                                         "load_box_1"            },
	{ "Carry coffee",       "amb@world_human_aa_coffee@base",                               "base"                  },
	{ "Place box",          "anim@mp_fireworks",                                            "place_firework_3_box"  },
	{ "Pickup drink",       "anim@amb@nightclub@mini@drinking@drinking_shots@ped_c@normal", "pickup"                },
	{ "Pickup briefcase",   "missheist_agency2aig_13",                                      "pickup_briefcase"      },
	{ "Pickup object",      "pickup_object",                                                "pickup_low"            },
	{ "Pickup box",         "anim@heists@load_box",                                         "lift_box"              },
	{ "Carry box",          "anim@heists@box_carry@",                                       "idle"                  },
	{ "Load box",           "anim@heists@load_box",                                         "load_box_1"            },
	{ "Carry coffee",       "amb@world_human_aa_coffee@base",                               "base"                  },
	{ "Place box",          "anim@mp_fireworks",                                            "place_firework_3_box"  },
	{ "Pickup drink",       "anim@amb@nightclub@mini@drinking@drinking_shots@ped_c@normal", "pickup"                },
	{ "Pickup briefcase",   "missheist_agency2aig_13",                                      "pickup_briefcase"      },
	{ "Pickup object",      "pickup_object",                                                "pickup_low"            },
	{ "Pickup box",         "anim@heists@load_box",                                         "lift_box"              },
	{ "Carry box",          "anim@heists@box_carry@",                                       "idle"                  },
	{ "Load box",           "anim@heists@load_box",                                         "load_box_1"            },
	{ "Carry coffee",       "amb@world_human_aa_coffee@base",                               "base"                  },
	{ "Place box",          "anim@mp_fireworks",                                            "place_firework_3_box"  },
	{ "Pickup drink",       "anim@amb@nightclub@mini@drinking@drinking_shots@ped_c@normal", "pickup"                },
	{ "Pickup briefcase",   "missheist_agency2aig_13",                                      "pickup_briefcase"      },
	{ "Pickup object",      "pickup_object",                                                "pickup_low"            },
	{ "Pickup box",         "anim@heists@load_box",                                         "lift_box"              },
	{ "Carry box",          "anim@heists@box_carry@",                                       "idle"                  },
	{ "Load box",           "anim@heists@load_box",                                         "load_box_1"            },
	{ "Carry coffee",       "amb@world_human_aa_coffee@base",                               "base"                  },
	{ "Place box",          "anim@mp_fireworks",                                            "place_firework_3_box"  },
	{ "Pickup drink",       "anim@amb@nightclub@mini@drinking@drinking_shots@ped_c@normal", "pickup"                },
	{ "Pickup briefcase",   "missheist_agency2aig_13",                                      "pickup_briefcase"      },
	{ "Pickup object",      "pickup_object",                                                "pickup_low"            },
	{ "Pickup box",         "anim@heists@load_box",                                         "lift_box"              },
	{ "Carry box",          "anim@heists@box_carry@",                                       "idle"                  },
	{ "Load box",           "anim@heists@load_box",                                         "load_box_1"            },
	{ "Carry coffee",       "amb@world_human_aa_coffee@base",                               "base"                  },
	{ "Place box",          "anim@mp_fireworks",                                            "place_firework_3_box"  },
	{ "Pickup drink",       "anim@amb@nightclub@mini@drinking@drinking_shots@ped_c@normal", "pickup"                },
	{ "Pickup briefcase",   "missheist_agency2aig_13",                                      "pickup_briefcase"      },
	{ "Pickup object",      "pickup_object",                                                "pickup_low"            },
	{ "Pickup box",         "anim@heists@load_box",                                         "lift_box"              },
	{ "Carry box",          "anim@heists@box_carry@",                                       "idle"                  },
	{ "Load box",           "anim@heists@load_box",                                         "load_box_1"            },
	{ "Carry coffee",       "amb@world_human_aa_coffee@base",                               "base"                  },
	{ "Place box",          "anim@mp_fireworks",                                            "place_firework_3_box"  },
	{ "Pickup drink",       "anim@amb@nightclub@mini@drinking@drinking_shots@ped_c@normal", "pickup"                },
	{ "Pickup briefcase",   "missheist_agency2aig_13",                                      "pickup_briefcase"      },
	{ "Pickup object",      "pickup_object",                                                "pickup_low"            },
	{ "Pickup box",         "anim@heists@load_box",                                         "lift_box"              },
	{ "Carry box",          "anim@heists@box_carry@",                                       "idle"                  },
	{ "Load box",           "anim@heists@load_box",                                         "load_box_1"            },
	{ "Carry coffee",       "amb@world_human_aa_coffee@base",                               "base"                  },
	{ "Place box",          "anim@mp_fireworks",                                            "place_firework_3_box"  },
	{ "Pickup drink",       "anim@amb@nightclub@mini@drinking@drinking_shots@ped_c@normal", "pickup"                },
	{ "Pickup briefcase",   "missheist_agency2aig_13",                                      "pickup_briefcase"      },
	{ "Pickup object",      "pickup_object",                                                "pickup_low"            },
	{ "Pickup box",         "anim@heists@load_box",                                         "lift_box"              },
	{ "Carry box",          "anim@heists@box_carry@",                                       "idle"                  },
	{ "Load box",           "anim@heists@load_box",                                         "load_box_1"            },
	{ "Carry coffee",       "amb@world_human_aa_coffee@base",                               "base"                  },
	{ "Place box",          "anim@mp_fireworks",                                            "place_firework_3_box"  },
	{ "Pickup drink",       "anim@amb@nightclub@mini@drinking@drinking_shots@ped_c@normal", "pickup"                },
	{ "Pickup briefcase",   "missheist_agency2aig_13",                                      "pickup_briefcase"      },
	{ "Pickup object",      "pickup_object",                                                "pickup_low"            },
	{ "Pickup box",         "anim@heists@load_box",                                         "lift_box"              },
}

local ECM = exports["ContextMenu"]

ECM:Register(function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
	if (not DoesEntityExist(hitEntity) or PlayerPedId() ~= hitEntity) then
		return
	end

	local animMenu, animMenuItem = ECM:AddScrollSubmenu(0, "Animations", 10)

	local itemList1 = {}
	for i = 1, #anims, 1 do
		local text      = anims[i][1]
		local animDict  = anims[i][2]
		local anim      = anims[i][3]

		table.insert(itemList1, {
			animMenu,
			text,
			function()
				local playerPed = PlayerPedId()

				LoadAnimDictSync(animDict)

				TaskPlayAnim(playerPed, animDict, anim, 8.0, 8.0, 5000, 49, 1.0, false, false, false)
				RemoveAnimDict(animDict)
			end
		})
	end
	ECM:AddItems(itemList1)

	local animMenu, animMenuItem = ECM:AddPageSubmenu(0, "Animations", 5)

	local testMenu, testMenuItem = ECM:AddSubmenu(animMenu, "TestMenu")
	ECM:AddItem(testMenu, "TestItem1")
	ECM:AddItem(testMenu, "TestItem2")
	ECM:AddItem(testMenu, "TestItem3")

	local itemList2 = {}
	for i = 1, #anims, 1 do
		local text      = anims[i][1]
		local animDict  = anims[i][2]
		local anim      = anims[i][3]

		table.insert(itemList2, {
			animMenu,
			text,
			function()
				local playerPed = PlayerPedId()

				LoadAnimDictSync(animDict)

				TaskPlayAnim(playerPed, animDict, anim, 8.0, 8.0, 5000, 49, 1.0, false, false, false)
				RemoveAnimDict(animDict)
			end
		})
	end
	ECM:AddItems(itemList2)

	local asyncMenu, asyncMenuItem = ECM:AddPageSubmenu(0, "Async Menu Animations", 5)
	ECM:LoadAsync(asyncMenu, function(currentIndex, maxItems)
		local asyncItemList = {}
		for i = currentIndex, currentIndex + maxItems - 1 do
			if (i <= #anims) then
				local animDict  = anims[i][2]

				table.insert(asyncItemList, {
					asyncMenu,
					anims[i][1],
					function()
						LoadAnimDictSync(animDict)
						TaskPlayAnim(PlayerPedId(), animDict, anims[i][3], 8.0, 8.0, 5000, 49, 1.0, false, false, false)
						RemoveAnimDict(animDict)
					end
				})
			end
		end
		ECM:AddItems(asyncItemList)
	end)
end)



function LoadAnimDictSync(animDict)
	if (HasAnimDictLoaded(animDict)) then return end

	RequestAnimDict(animDict)
	while (not HasAnimDictLoaded(animDict)) do
		Citizen.Wait(0)
	end
end
