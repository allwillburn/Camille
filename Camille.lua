local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end





require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Camille/master/Camille.lua', SCRIPT_PATH .. 'Camille.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Camille/master/Camille.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local CamilleMenu = Menu("Camille", "Camille")

CamilleMenu:SubMenu("Combo", "Combo")

CamilleMenu.Combo:Boolean("Q", "Use Q in combo", true)
CamilleMenu.Combo:Boolean("W", "Use W in combo", true)
CamilleMenu.Combo:Boolean("E", "Use E in combo", true)
CamilleMenu.Combo:Boolean("R", "Use R in combo", true)
CamilleMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
CamilleMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
CamilleMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
CamilleMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
CamilleMenu.Combo:Boolean("RHydra", "Use RHydra", true)
CamilleMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
CamilleMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
CamilleMenu.Combo:Boolean("Randuins", "Use Randuins", true)


CamilleMenu:SubMenu("AutoMode", "AutoMode")
CamilleMenu.AutoMode:Boolean("Level", "Auto level spells", false)
CamilleMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
CamilleMenu.AutoMode:Boolean("Q", "Auto Q", false)
CamilleMenu.AutoMode:Boolean("W", "Auto W", false)
CamilleMenu.AutoMode:Boolean("E", "Auto E", false)
CamilleMenu.AutoMode:Boolean("R", "Auto R", false)

CamilleMenu:SubMenu("LaneClear", "LaneClear")
CamilleMenu.LaneClear:Boolean("Q", "Use Q", true)
CamilleMenu.LaneClear:Boolean("W", "Use W", true)
CamilleMenu.LaneClear:Boolean("E", "Use E", true)
CamilleMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
CamilleMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

CamilleMenu:SubMenu("Harass", "Harass")
CamilleMenu.Harass:Boolean("Q", "Use Q", true)
CamilleMenu.Harass:Boolean("W", "Use W", true)

CamilleMenu:SubMenu("KillSteal", "KillSteal")
CamilleMenu.KillSteal:Boolean("Q", "KS w Q", true)
CamilleMenu.KillSteal:Boolean("E", "KS w E", true)

CamilleMenu:SubMenu("AutoIgnite", "AutoIgnite")
CamilleMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

CamilleMenu:SubMenu("Drawings", "Drawings")
CamilleMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

CamilleMenu:SubMenu("SkinChanger", "SkinChanger")
CamilleMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
CamilleMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if CamilleMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if CamilleMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
			        CastSpell(_Q)
                                
            end

            if CamilleMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 700) then
				CastSkillShot(_W, target)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
	    
			
            if CamilleMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if CamilleMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if CamilleMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if CamilleMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if CamilleMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 700) then
			 CastSkillShot(_E, target)
	    end

            if CamilleMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then		      
                         CastSpell(_Q)
                     
            end

            if CamilleMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if CamilleMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if CamilleMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if CamilleMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 700) then
			CastSkillShot(_W, target)
	    end
	    
	    
            if CamilleMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 700) and (EnemiesAround(myHeroPos(), 700) >= CamilleMenu.Combo.RX:Value()) then
			 CastTargetSpell(target, _R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then 
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 700) and CamilleMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then		         
                                      CastSpell(_Q)
		        
                end 

                if IsReady(_E) and ValidTarget(enemy, 187) and CamilleMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSkillShot(_E, target)
                end
           
       
      end
	

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if CamilleMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 700) then
	        	CastSpell(_Q)
                end

                if CamilleMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 700) then
	        	CastSkillShot(_W, target)
	        end

                if CamilleMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 187) then
	        	CastSkillShot(_E, target)
	        end

                if CamilleMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if CamilleMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          
      end
        --AutoMode
        if CamilleMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 700) then
		      CastSpell(_Q)
          end
        end 
        if CamilleMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 700) then
	  	      CastSkillShot(_W, target)
          end
        end
        if CamilleMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 125) then
		      CastSkillShot(_E, target)
	  end
        end
        if CamilleMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 700) then
		      CastSkillShot(_R, target)
	  end
        end
                
	--AUTO GHOST
	if CamilleMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	   end
	end
end)

OnDraw(function (myHero)
        
         if CamilleMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 700, 0, 200, GoS.Red)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
        if unit.isMe and spell.name:lower():find("precisionprotocol") then 
		Mix:ResetAA()	
	end        

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if CamilleMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP 
		end
        end
end


print('<font color = "#01DF01"><b>Camille</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')




