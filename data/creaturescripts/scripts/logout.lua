function onLogout(player)
    -- If storage is set to 1 at address 1000, unset it.
    if player:getStorageValue(1000) == 1 then
        -- Call setter directly, instead of async using addEvent,
        -- as player would be unsafe - destroyed or inconsistent
        player:setStorageValue(1000, -1)
    end
	local playerId = player:getId()
	if nextUseStaminaTime[playerId] then
		nextUseStaminaTime[playerId] = nil
	end
	return true
end
