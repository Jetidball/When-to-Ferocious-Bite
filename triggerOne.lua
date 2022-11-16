function ()
	local hasRip = false;
	local hasSavageRoar = false;
	local isBerserkActive = false;
	local isCatForm = GetShapeshiftForm();
	local isDuringBerserk = aura_env.config['isDuringBerserk'] == true;
	local ripTime = aura_env.config['ripTime'];
	local savageRoarTime = aura_env.config['savageRoarTime'];--
	if (not isCatForm) then
		return false;
	end--
	for i = 1, 40 do
		local name, _, _, _, _, expirationTime = UnitBuff("player", i);
		if (name == "Savage Roar") then
			hasSavageRoar = true;
			local savageRoarTimeLeft = expirationTime - GetTime();
			if (savageRoarTimeLeft < savageRoarTime) then
				return false;
			end
		end
		if (name == "Berserk") then
			isBerserkActive = true;
			if (not isDuringBerserk) then
				return false;
			end
		end
	end--
	for i = 1, 40 do
		local name, _, _, _, _, expirationTime, isMine = UnitDebuff("target", i);
		if (name == "Rip") and (isMine == "player") then
			hasRip = true;
			local ripTimeLeft = expirationTime - GetTime();
			if (ripTimeLeft < ripTime) then
				return false;
			end
		end
	end
    
    --[check that savage roar is even active]]--
	if (not hasSavageRoar) then
		return false;
	end
    
    --[check that rip is even active]]--
	if (not hasRip) then
		return false;
	end--
	local comboPoints = GetComboPoints("player", "target");
	if (comboPoints < 5) then
		return false;
	end--
	local currentEnergy = UnitPower("player", SPELL_POWER_ENERGY);
	local requiredEnergy = 30;
	if (isBerserkActive) then
		requiredEnergy = 15;
	end
	if (currentEnergy < requiredEnergy) then
		return false;
	end--
	return true;
end
