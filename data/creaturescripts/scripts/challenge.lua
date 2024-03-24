local OPCODE_PRINT_GUILD_MEMBERS = 2

--[[ 
Remove a member with name memberName from the party of a player given by playerId
Challenge - Q3
]]
local function removeFromPlayerPartyByMemberName(playerId, memberName)
    -- Make player local to avoid leaking it to global namespace
    local player = Player(playerId)
    local party = player:getParty()

    for _, member in ipairs(party:getMembers()) do 
        if member == Player(memberName) then 
            party:removeMember(Player(memberName))
        end
    end
end

-- Challenge - Q2
local function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
    if resultId ~= false then
        repeat 
            local guildName = result.getString(resultId, "name")
            print(guildName)
        until not result.next(resultId)
        result.free(resultId)
    end
end


function onExtendedOpcode(player, opcode, buffer)
	if opcode == OPCODE_PRINT_GUILD_MEMBERS then
        print("Got your message " .. buffer)
        printSmallGuildNames(4)
	else
		-- other opcodes can be ignored, and the server will just work fine...
	end
end
