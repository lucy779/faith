print("executed voidious v4 (build 14)")
local execute_permission, blacklisted, whitelisted = loadstring(game:HttpGet("https://raw.githubusercontent.com/lucy779/God/main/tables.txt"))()

while game.Players.LocalPlayer == nil do
	wait(0.1)
end

local client = game.Players.LocalPlayer

if not table.find(execute_permission, client.Name) then
	client:Kick("You are not autorized to run & use voidious! Contact @lucy on discord to purchase.")
	return
end

wait(0.3) -- wait for perm admin to load

print("running code...")

table.insert(whitelisted, client.Name)

local bypassed = {}
local commands1 = {
	"Level 1 (anyone) commands:",
	"cmds - shows this commands page",
	"items - display a list of all current items",
	"item <name> - give yourself an item",
	"lban - list all banned users",
	"lwl - list all whitelisted users"
}
local commands2 = {
	"\n-------------\nLevel 2 (whitelist) commands:",
	"kick <user> - crashes a player",
	"ban <user> - kick but stronger (crash on join)",
	"unban <user> - remove someone from the blacklist",
	"rickroll - bugged m message with rickroll text",
	"btools - toggle whether players should be able to get btools",
	"ac & dac - toggle the anticrash (nohats spam)",
	"loop, delay & amt - loop a command with custom delay & amount",
	"op <cmd, user> - execute a command, bypassing the chatbox character limit",
	"rspam - spam reset using ,op method",
	"shock <user> - ice & thaw a player, in strong"
}
local commands3 = {
	"\n-------------\nLevel 3 (script-owners) commands:",
	"security - toggle whether players get banned on abuse",
	"wl - whitelist a user to use most commands",
	"unwl - remove someone from the whitelist",
	"bp - allow someone to bypass lockdown & btools",
	"unbp - remove someone from the bypass list",
	"op2 - op but 50x at once",
	"shutdown - crash the server instantly",
	"break - softcrash using flood in deadlands",
	"break2 - softcrash by spam resetting others",
	"break3 - crash by spam pianoing others",
	"lockdown - auto-crash joining players",
	"flood - flood the server with bots (softcrash)"
}
local items = {
	"cloner - use this tool to clone gears (such as btools)",
	"laser - a laser gun to shoot others",
	"swords - all op swords with Q ability"
}
local notplayer = {"all", "others"}
local abuse_detection = {"pm", "notify"}
local security = true
local btools = true
local ac = false
local loop = false
local looptime = 1
local loopamt = false
local lockdown = false
local last_bl = ""
local last_wl = ""
local prefix = ","

function find_player(name)
	local found_players = {}
	if string.lower(name) == "all" then
		table.insert(found_players, "all")
		return found_players
	elseif string.lower(name) == "others" then
		table.insert(found_players, "others")
		return found_players
	end
	for _, player in pairs(game.Players:GetPlayers()) do
		if string.find(string.lower(player.Name), string.lower(name)) then
			table.insert(found_players, player.Name)
		end
	end
	return found_players
end

function isdev(player)
	if table.find(execute_permission, player.Name) then
		return true
	else
		return false
	end
end

function iswl(player)
	if table.find(whitelisted, player.Name) or table.find(execute_permission, player.Name) then
		return true
	else
		return false
    end
end

function get_target(name)
	name = string.lower(name)
    local shortName = name
    local allNames = {}

    for _, player in pairs(game.Players:GetChildren()) do
        table.insert(allNames, string.lower(player.Name))
    end

    for i = 1, #name do
        local prefix = string.sub(name, 1, i)
        local count = 0

        for _, plr in pairs(allNames) do
            if string.sub(plr, 1, i) == prefix then
                count = count + 1
				if prefix == "me" or prefix == "all" then
					count = count + 1
				end
            end
        end

        if count == 1 then
            shortName = prefix
            break
        end
    end

    if name == "others" or name == "all" then
        shortName = name
    end

    local fulltext = shortName
    while string.len(fulltext) < 950 do
        fulltext = fulltext .. "," .. shortName
    end

    return fulltext
end


function crash_player(name, reason)
	print("Crashing "..name.."...")
	if name ~= "others" then
		local player = game.Players:WaitForChild(name, 2)
		if player then
			print("PlayerLoaded: OK!")
			local char = player.Character or player.CharacterAdded:Wait(5)
			if not char then
				print("Crashing of "..name.." has failed: no character")
				return
			end
			print("CharacterLoaded: OK!")
		else
			print("Crashing of "..name.." has failed: no player")
			return
		end
	end

	local target = get_target(name)
	delay = 0.1
	for i = 1, 20, 1 do
		if name ~= "others" and not game.Players:WaitForChild(name, 2) then
			print("Error crashing player "..name.." at crash-message number "..i)
			break
		end
		game.Players:Chat("notify "..target.." "..reason)
		if i == 10 then
			delay = 0.2
		end
		wait(delay)
	end
	print("Player "..name.." has been crashed with reason "..reason)
	wait(0.5)
	game.Players:Chat("bring "..name)
	game.Players:Chat("name "..name.." "..name.." (Crashed)")
end

game.Players.PlayerAdded:Connect(function(player)
	if table.find(blacklisted, player.Name) then
		game.Players:Chat("chatnotify all {Security} Crashing "..player.Name)
		crash_player(player.Name, "Banned!")
	elseif lockdown and not table.find(bypassed, player.Name) and not table.find(execute_permission, player.Name) then
		game.Players:Chat("chatnotify all {Security} Disconnecting "..player.Name)
		crash_player(player.Name, "Access denied!")
	else
		while player.Character == nil do
			wait(0.1)
		end
		wait(2)
		game.Players:Chat("notify "..player.Name.." This server is protected by voidious anti-abuse. Spammers get banned!")
	end
end)

game.Players.PlayerAdded:Connect(function(player)
	player.Chatted:connect(function(msg)
		loadAntiAbuse(player, msg)
		loadCommands(player, msg)
	end)
end)

for v,player in pairs(game.Players:GetChildren()) do
	player.Chatted:connect(function(msg)
		loadAntiAbuse(player, msg)
		loadCommands(player, msg)
	end)
end

function loadAntiAbuse(player, msg)
	local modified, count1 = string.gsub(msg, ",", "")
	local modified, count2 = string.gsub(msg, "#", "")
	local count = count1 + count2
	if string.lower(msg:sub(1,3)) == "f3x" and not btools and not isdev(player) and not table.find(bypassed, player.Name) then
		game.Players:Chat("punish "..player.Name)
		wait(1)
		game.Players:Chat("re "..player.Name)
		wait(1)
		game.Players:Chat("notify "..player.Name.." btools are disabled!")
	end
	if string.lower(msg:sub(1,4)) == ":f3x" and not btools and not isdev(player) and not table.find(bypassed, player.Name) then
		game.Players:Chat("punish "..player.Name)
		wait(1)
		game.Players:Chat("re "..player.Name)
		wait(1)
		game.Players:Chat("notify "..player.Name.." btools are disabled!")
	end
	if string.lower(msg:sub(1,6)) == "btools" and not btools and not isdev(player) and not table.find(bypassed, player.Name) then
		game.Players:Chat("punish "..player.Name)
		wait(1)
		game.Players:Chat("re "..player.Name)
		wait(1)
		game.Players:Chat("notify "..player.Name.." btools are disabled!")
	end
	if string.lower(msg:sub(1,7)) == ":btools" and not btools and not isdev(player) and not table.find(bypassed, player.Name) then
		game.Players:Chat("punish "..player.Name)
		wait(1)
		game.Players:Chat("re "..player.Name)
		wait(1)
		game.Players:Chat("notify "..player.Name.." btools are disabled!")
	end
	if string.lower(msg:sub(1,5)) == "reset" and count > 4 and not isdev(player) then
		game.Players:Chat("chatnotify all {Security} Reset Abuse detected: "..player.Name)
		target = player.Name
		if security then
			blacklist(target, true)
		end
	end
	if string.lower(msg:sub(1,6)) == ":reset" and count > 4 and not isdev(player) then
		game.Players:Chat("chatnotify all {Security} Reset Abuse detected: "..player.Name)
		target = player.Name
		if security then
			blacklist(target, true)
		end
	end
	if string.lower(msg:sub(1,3)) == "re " and count > 4 and not isdev(player) then
		game.Players:Chat("chatnotify all {Security} Reset Abuse detected: "..player.Name)
		target = player.Name
		if security then
			blacklist(target, true)
		end
	end
	if string.lower(msg:sub(1,4)) == ":re " and count > 4 and not isdev(player) then
		game.Players:Chat("chatnotify all {Security} Reset Abuse detected: "..player.Name)
		target = player.Name
		if security then
			blacklist(target, true)
		end
	end
	if string.lower(msg:sub(1,2)) == "pm" and count > 4  and not isdev(player) then
		game.Players:Chat("re")
		game.Players:Chat("chatnotify all {Security} Pm Abuse detected: "..player.Name)
		target = player.Name
		if security then
			blacklist(target, true)
		end
	end
	if string.lower(msg:sub(1,3)) == ":pm" and count > 4 and not isdev(player) then
		game.Players:Chat("re")
		game.Players:Chat("chatnotify all {Security} Pm Abuse detected: "..player.Name)
		target = player.Name
		if security then
			blacklist(target, true)
		end
	end
	if string.lower(msg:sub(1,5)) == "piano" and count > 4 and not isdev(player) then
		game.Players:Chat("re")
		game.Players:Chat("chatnotify all {Security} Piano Abuse detected: "..player.Name)
		target = player.Name
		if security then
			blacklist(target, true)
		end
	end
	if string.lower(msg:sub(1,6)) == ":piano" and count > 4 and not isdev(player) then
		game.Players:Chat("re")
		game.Players:Chat("chatnotify all {Security} Piano Abuse detected: "..player.Name)
		target = player.Name
		if security then
			blacklist(target, true)
		end
	end
	if string.lower(msg:sub(1,6)) == "notify" and count > 4 and not isdev(player) then
		game.Players:Chat("re")
		game.Players:Chat("chatnotify all {Security} Notify Abuse detected: "..player.Name)
		target = player.Name
		if security then
			blacklist(target, true)
		end
	end
	if string.lower(msg:sub(1,7)) == ":notify" and count > 4 and not isdev(player) then
		game.Players:Chat("re")
		game.Players:Chat("chatnotify all {Security} Notify Abuse detected: "..player.Name)
		target = player.Name
		if security then
			blacklist(target, true)
		end
	end
	if string.lower(msg:sub(1,5)) == "bacon" and count > 4 and not isdev(player) then
		game.Players:Chat("chatnotify all {Security} Reset Abuse detected: "..player.Name)
		target = player.Name
		if security then
			blacklist(target, true)
		end
	end
	if string.lower(msg:sub(1,6)) == ":bacon" and count > 4 and not isdev(player) then
		game.Players:Chat("chatnotify all {Security} Reset Abuse detected: "..player.Name)
		target = player.Name
		if security then
			blacklist(target, true)
		end
	end
	if string.lower(msg:sub(1,6)) == ":bacon" and count > 4 and not isdev(player) then
		game.Players:Chat("chatnotify all {Security} Reset Abuse detected: "..player.Name)
		target = player.Name
		if security then
			blacklist(target, true)
		end
	end
	if string.lower(msg:sub(1,7)) == "hatpets" and count > 0 and not isdev(player) then
		game.Players:Chat("clr")
		game.Players:Chat(",ac")
		game.Players:Chat("chatnotify all {Security} Crash Abuse detected: "..player.Name)
		target = player.Name
		if security then
			blacklist(target, true)
		end
	end
	if string.lower(msg:sub(1,8)) == ":hatpets" and count > 0 and not isdev(player) then
		game.Players:Chat("clr")
		game.Players:Chat(",ac")
		game.Players:Chat("chatnotify all {Security} Crash Abuse detected: "..player.Name)
		target = player.Name
		if security then
			blacklist(target, true)
		end
	end
	if string.lower(msg:sub(1,8)) == "####### " and count > 0 and not isdev(player) then
		game.Players:Chat("clr")
		game.Players:Chat(",ac")
		game.Players:Chat("chatnotify all {Security} Crash Abuse detected: "..player.Name)
	end
	if string.lower(msg:sub(1,9)) == "######## " and count > 0 and not isdev(player) then
		game.Players:Chat("clr")
		game.Players:Chat(",ac")
		game.Players:Chat("chatnotify all {Security} Crash Abuse detected: "..player.Name)
	end
end

function loadCommands(player, msg)
	local args = msg:split(" ")
	local cmd = args[1]
	local victim = args[2]
	local victim2 = args[3]

	if msg:sub(1, #prefix) ~= prefix then
		return
	end
	if not victim then
		victim = player.Name
	end
	if not victim2 then
		victim2 = player.Name
	end

	cmd = cmd:sub(#prefix + 1)
	local allargs = table.concat(args, " ", 2)

	if cmd == "test" then
		print("test passed")
	end

	if cmd == "cmds" then
		local list1 = table.concat(commands1, "\n")
		local list2 = table.concat(commands2, "\n")
		local list3 = table.concat(commands3, "\n")
		game.Players:Chat("chatnotify "..player.Name.." "..list1)
		wait(1)
		game.Players:Chat("chatnotify "..player.Name.." "..list2)
		wait(1)
		game.Players:Chat("chatnotify "..player.Name.." "..list3)
	end
	if cmd == "items" then
		local list = table.concat(items, "\n")
		game.Players:Chat("pm "..player.Name.." List of all items avaible in Voidious:\n"..list)
	end
	if cmd == "lban" then
		game.Players:Chat("chatnotify all Currently banned: "..table.concat(blacklisted, ", "))
	end
	if cmd == "lwl" then
		game.Players:Chat("chatnotify all Currently whitelisted: "..table.concat(whitelisted, ", "))
	end
	if cmd == "rj" then
		if player.Name ~= client.Name then
			return
		end
		game:GetService("TeleportService"):Teleport(game.PlaceId)
	end
	if cmd == "security" then
		if not isdev(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} Restricted to script owners!")
			return
		end
		security = not security
		if security == true then
			game.Players:Chat("chatnotify all {Security}: Enabled!")
		else
			game.Players:Chat("chatnotify all {Security}: Disabled!")
		end
	end
	if cmd == "btools" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		btools = not btools
		if btools == true then
			print("Btools has been set to "..tostring(btools))
			game.Players:Chat("chatnotify all {System}: Btools Enabled!")
		else
			print("Btools has been set to "..tostring(btools))
			game.Players:Chat("chatnotify all {System}: Btools Disabled!")
		end
	end
	if cmd == "reportabuse" then
		if not isdev(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} Restricted to script owners!")
			return
		end
		local target = find_player(victim)
		if #target == 1 then
			target = table.concat(target)
		else
			if string.len(victim) > 5 then
				target = victim
			else
				game.Players:Chat("chatnotify all {Error} Couldn't find 1 player == "..victim)
				return
			end
		end
		print("MassReport starting on "..target)
		for i = 1, 1000, 1 do
			game.Players:ReportAbuse(game:GetService("Players"), target, "Cheating/Exploiting", "Using a spam script to disrupt the chat for everyone")
		end
		print("MassReport done on "..target)
	end
	if cmd == "ac" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		if not ac then
			ac = true
			game.Players:Chat("chatnotify all {Security} Anti-Crash Enabled!")
			while ac do
				game.Players:Chat("nohats all")
				wait(0.5)
			end
		end
	end
	if cmd == "dac" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		if ac then
			ac = false
			game.Players:Chat("chatnotify all {Security} Anti-Crash Disabled!")
			return
		end
	end

	if cmd == "loop" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		local toloop = allargs
		game.Players:Chat("chatnotify all {Loop} Looping with "..looptime.."s delay "..toloop)
		loop = true
		if not loopamt then
			while loop do
				game.Players:Chat(toloop)
				wait(looptime)
			end
		else
			local x = 0
			while loop and x < loopamt do
				game.Players:Chat(toloop)
				wait(looptime)
				x = x + 1
			end
		end
	end

	if cmd == "delay" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		looptime = tonumber(victim)
		if not looptime then
			looptime = 1
		end
		game.Players:Chat("chatnotify all {Loop} Delay set to "..looptime.."s")
	end

	if cmd == "amt" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		if victim == "inf" then
			loopamt = false
			game.Players:Chat("chatnotify all {Loop} Amount set to infinite")
			return
		end
		loopamt = tonumber(victim)
		if not loopamt then
			loopamt = false
			game.Players:Chat("chatnotify all {Loop} Amount set to infinite")
			return
		end
		game.Players:Chat("chatnotify all {Loop} Amount set to "..loopamt)
	end

	if cmd == "unloop" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		loop = false
		game.Players:Chat("chatnotify all {Voidious} Stopping all loops")
	end
	if cmd == "rban" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		local target = last_bl
		if target ~= "" then
			blacklist(target, false)
		end
	end
	if cmd == "rwl" then
		if not isdev(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} Restricted to script owners!")
			return
		end
		local target = last_wl
		if target ~= "" then
			whitelist(target, false)
		end
	end
	if cmd == "rbp" then
		if not isdev(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} Restricted to script owners!")
			return
		end
		local target = last_wl
		if target ~= "" then
			allowjoin(target, false)
		end
	end
	if cmd == "ban" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		local target = victim
		if table.find(notplayer, target) then
			game.Players:Chat("chatnotify all {Error} Cannot ban all/others!")
			return
		end
		blacklist(target, true)
	end 
	if cmd == "unban" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		local target = victim
		blacklist(target, false)
	end
	if cmd == "mute" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		local target = find_player(victim)
		if #target == 1 then
			target = table.concat(target)
		else
			if string.len(victim) > 5 then
				target = victim
			else
				game.Players:Chat("chatnotify all {Error} Couldn't find 1 player == "..victim)
				return
			end
		end
		otarget = target
		target = get_target(target)
		game.Players:Chat("punish "..otarget)
		for player = 1, 5, 1 do
			game.Players:Chat("piano "..target)
			wait(0.1)
		end
		game.Players:Chat("chatnotify all {Voidious} Muted "..otarget)
	end
	if cmd == "wl" then
		if not isdev(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} Restricted to script owners!")
			return
		end
		local target = victim
		whitelist(target, true)
	end 
	if cmd == "unwl" then
		if not isdev(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} Restricted to script owners!")
			return
		end
		local target = victim
		whitelist(target, false)
	end
	if cmd == "bp" then
		if not isdev(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} Restricted to script owners!")
			return
		end
		local target = victim
		bypass(target, true)
	end 
	if cmd == "unbp" then
		if not isdev(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} Restricted to script owners!")
			return
		end
		local target = victim
		bypass(target, false)
	end
	if cmd == "kick" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		local target = find_player(victim)
		if #target == 1 then
			target = table.concat(target)
		else
			if string.len(victim) > 5 then
				target = victim
			else
				game.Players:Chat("chatnotify all {Error} Couldn't find 1 player == "..victim)
				return
			end
		end
		if target == client.Name then
			game.Players:Chat("chatnotify all {Error} Cannot kick the script executor!")
			return
		elseif string.lower(target) == "all" then
			game.Players:Chat("chatnotify all {Error} Cannot kick all!")
			return
		end
		game.Players:Chat("chatnotify all {Voidious} Kicked "..target)
		crash_player(target, "Kicked!")
	end
	if cmd == "rspam" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		local target = find_player(victim)
		if #target == 1 then
			target = table.concat(target)
		else
			if string.len(victim) > 5 then
				target = victim
			else
				game.Players:Chat("chatnotify all {Error} Couldn't find 1 player == "..victim)
				return
			end
		end
		target = get_target(target)
		for player = 1, 15, 1 do
			game.Players:Chat("re "..target)
		end
	end
	if cmd == "badlands" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		local target = find_player(victim)
		if #target == 1 then
			target = table.concat(target)
		else
			if string.len(victim) > 5 then
				target = victim
			else
				game.Players:Chat("chatnotify all {Error} Couldn't find 1 player == "..victim)
				return
			end
		end
		game.Players:Chat("chatnotify all {Voidious} Sending "..target.." to badlands!")
		target = get_target(target)
		for player = 1, 15, 1 do
			game.Players:Chat("sfling "..target)
		end
	end
	if cmd == "flood" then
		if not isdev(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} Restricted to script owners!")
			return
		end
		target = "all"
		target = get_target(target)
		for player = 1, 50, 1 do
			game.Players:Chat("bot "..target.." inf true true")
			wait(0.1)
		end
	end
	if cmd == "break" then
		if not isdev(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} Restricted to script owners!")
			return
		end
		target = "me"
		target = get_target(target)
		game.Players:Chat("chatnotify all {Voidious} Breaking the server!")
		game.Players:Chat("deadlands")
		wait(1)
		for i = 1, 50, 1 do
			game.Players:Chat("bot "..target.." inf true true")
			wait(0.1)
		end
		wait(1)
		game.Players:Chat("kill")
	end
	if cmd == "break2" then
		if not isdev(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} Restricted to script owners!")
			return
		end
		target = "others"
		target = get_target(target)
		game.Players:Chat("chatnotify all {Voidious} Breaking the server!")
		for i = 1, 50, 1 do
			game.Players:Chat("re "..target)
			wait(0.1)
		end
	end
	if cmd == "break3" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		local target = "others"
		target = get_target(target)
		game.Players:Chat("chatnotify all {Voidious} Breaking the server!")
		for player = 1, 100, 1 do
			game.Players:Chat("piano "..target)
			wait(0.1)
		end
	end
	if cmd == "rickroll" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		game.Players:Chat("m We're no strangers to love\nYou know the rules and so do I (do I)\nA full commitment's what I'm thinking of\nYou wouldn't get this from any other guy\n---------------\nI just wanna tell you how I'm feeling\nGotta make you understand\n---------------\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you\n---------------\nWe've known each other for so long\nYour heart's been aching, but you're too shy to say it (say it)\nInside, we both know what's been going on (going on)\nWe know the game and we're gonna play it\n---------------\nAnd if you ask me how I'm feeling\nDon't tell me you're too blind to see\n---------------\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you")
	end
	if cmd == "op" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		local target = find_player(victim2)
		if #target == 1 then
			target = table.concat(target)
		else
			if string.len(victim2) > 5 then
				target = victim2
			else
				game.Players:Chat("chatnotify all {Error} Couldn't find 1 player == "..victim2)
				return
			end
		end
		game.Players:Chat("chatnotify all {Voidious} Super-Command "..victim.." used on: "..target)
		target = get_target(target)
		local extra = table.concat(args, " ", 4)
		if not extra then
			extra = ""
		end
		game.Players:Chat(victim.." "..target.." "..extra)
	end
	if cmd == "op2" then
		if not isdev(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} Restricted to script owners!")
			return
		end
		local target = find_player(victim2)
		if #target == 1 then
			target = table.concat(target)
		else
			if string.len(victim2) > 5 then
				target = victim2
			else
				game.Players:Chat("chatnotify all {Error} Couldn't find 1 player == "..victim2)
				return
			end
		end
		game.Players:Chat("chatnotify all {Voidious} Mega-Command "..victim.." used on: "..target)
		target = get_target(target)
		local extra = table.concat(args, " ", 4)
		if not extra then
			extra = ""
		end
		for i = 1, 50, 1 do
			game.Players:Chat(victim.." "..target.." "..extra)
		end
	end
	if cmd == "shock" then
		if not iswl(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} You are not whitelisted!")
			return
		end
		local target = find_player(victim)
		if #target == 1 then
			target = table.concat(target)
		else
			if string.len(victim) > 5 then
				target = victim
			else
				game.Players:Chat("chatnotify all {Error} Couldn't find 1 player == "..victim)
				return
			end
		end
		game.Players:Chat("notify "..target.." You are being shocked!")
		target = get_target(target)
		for player = 1, 2, 1 do
			game.Players:Chat("ice "..target)
			wait(0.5)
		end
		wait(1.5)
		game.Players:Chat("thaw "..target)
	end
	if cmd == "shutdown" then
		if not isdev(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} Restricted to script owners!")
			return
		end
		victim = "all"
		target = get_target(victim)
		game.Players:Chat("notify all Disconnected")
		wait(1)
		for i = 1, 15, 1 do
			game.Players:Chat("hatpets "..target.." 9999")
		end
	end
	if cmd == "lockdown" then
		if not isdev(player) then
			game.Players:Chat("chatnotify "..player.Name.." {Voidious} Restricted to script owners!")
			return
		end
		lockdown = not lockdown
		if lockdown then
			game.Players:Chat("chatnotify all {Voidious} Server has been placed in lockdown\n-> Players cannot join")
		else
			game.Players:Chat("chatnotify all {Voidious} Server is no longer in lockdown\n-> Players can join again")
		end
	end
	if cmd == "item" then
		local target = find_player(victim2)
		if #target == 1 then
			target = table.concat(target)
		else
			if string.len(victim2) > 5 then
				target = victim2
			else
				game.Players:Chat("chatnotify all {Error} Couldn't find 1 player == "..victim2)
				return
			end
		end
		if victim == "cloner" then
			game.Players:Chat("gear "..target.." 97161295")
		elseif victim == "laser" then
			game.Players:Chat("gear "..target.." 212296936")
		elseif victim == "boombox" then
			game.Players:Chat("gear "..target.." 212641536")
		elseif victim == "swords" then
			local itemids = {108158379, 99119240, 80661504, 69499437, 93136802, 120307951, 159229806, 73829193}
			for _, itemid in ipairs(itemids) do
				game.Players:Chat("gear "..target.." "..tonumber(itemid))
				wait(1.2)
			end
		else
			game.Players:Chat("chatnotify all {Voidious} Item '"..victim.."' was not found!")
			return
		end
		wait(1)
		game.Players:Chat("chatnotify all {Voidious} "..victim.." given to "..target)
	end
	if cmd == "pitch" then
		if victim == "slowed" or victim == "sl" then
			game.Players:Chat("pitch 0.8")
		elseif victim == "nightcore" or victim == "nc" then
			game.Players:Chat("pitch 1.2")
		end
	end
end

function blacklist(target, add)
	test = find_player(target)
	if #test == 1 then
		target = table.concat(test)
	else
		if string.len(target) > 5 then
			target = target
		else
			game.Players:Chat("chatnotify all {Blacklist} Couldn't find 1 player == "..target)
			return
		end
	end
	if add and not table.find(notplayer, target) and string.lower(target) ~= string.lower(client.Name) then
		if not table.find(blacklisted, target) then
			table.insert(blacklisted, target)
			game.Players:Chat("chatnotify all {Blacklist} Banned "..target)
			last_bl = target
		end
		if game.Players:WaitForChild(target, 5) then
			crash_player(target, "Banned!")
		end
	end
	if not add and not table.find(notplayer, target) then
		local index = table.find(blacklisted, target)
		if index then
			table.remove(blacklisted, index)
			game.Players:Chat("chatnotify all {Blacklist} un-banned "..target)
			last_bl = ""
		end
	end
end

function whitelist(target, add)
	test = find_player(target)
	if #test == 1 then
		target = table.concat(test)
	else
		if string.len(target) > 5 then
			target = target
		else
			game.Players:Chat("chatnotify all {Whitelist} Couldn't find 1 player == "..target)
			return
		end
	end
	if add and not table.find(notplayer, target) then
		local index = table.find(whitelisted, target)
		if not index then
			table.insert(whitelisted, target)
			game.Players:Chat("chatnotify all {Whitelist} added "..target)
			last_wl = target
        end
	end
	if not add and not table.find(notplayer, target) then
		local index = table.find(whitelisted, target)
		if index then
			table.remove(whitelisted, index)
			game.Players:Chat("chatnotify all {Whitelist} removed "..target)
			last_wl = ""
		end
	end
end

function bypass(target, add)
	test = find_player(target)
	if #test == 1 then
		target = table.concat(test)
	else
		if string.len(target) > 5 then
			target = target
		else
			game.Players:Chat("chatnotify all {Bypass} Couldn't find 1 player == "..target)
			return
		end
	end
	if add and not table.find(notplayer, target) then
		local index = table.find(bypassed, target)
		if not index then
			table.insert(bypassed, target)
			game.Players:Chat("chatnotify all {Bypass} added "..target)
			last_wl = target
        end
	end
	if not add and not table.find(notplayer, target) then
		local index = table.find(bypassed, target)
		if index then
			table.remove(bypassed, index)
			game.Players:Chat("chatnotify all {Bypass} removed "..target)
			last_wl = ""
		end
	end
end

game.Players:Chat("chatnotify all Loaded Voidious Super-Admin v4\n-> Anti-Abuse has been enabled")

for v,player in pairs(game.Players:GetChildren()) do
	if table.find(blacklisted, player.Name) then
		crash_player(player.Name, "Banned!")
	end
end
