local Players = game:GetService("Players")

local PermanentBans = {
    [11549422626] = true,
    [] = true,
    [] = true,
    [] = true,
    [] = true,
    [] = true,
    [] = true,
    [] = true,
    [] = true,
    [] = true,
}

local TemporaryBans = {
    [] = "2026-10-15",
    [] = "2026-10-20",
    [] = "2026-10-25",
    [] = "2026-10-30",
    [] = "2026-11-05",
    [] = "2026-11-10",
    [] = "2026-11-15",
    [] = "2026-11-20",
    [] = "2026-11-25",
    [] = "2026-11-30",
}

local function GetDateTimestamp(date)
    local year, month, day =
        date:match("^(%d+)%-(%d+)%-(%d+)$")

    if not year then
        return nil
    end

    return os.time({
        year = tonumber(year),
        month = tonumber(month),
        day = tonumber(day),
        hour = 23,
        min = 59,
        sec = 59
    })
end

local function CheckBan(player)
    local userId = player.UserId

    if PermanentBans[userId] == true then
        player:Kick("تم حظرك نهائياً.")
        return
    end

    local expiryDate = TemporaryBans[userId]

    if not expiryDate then
        return
    end

    local expiryTimestamp = GetDateTimestamp(expiryDate)

    if not expiryTimestamp then
        return
    end

    local currentTime = os.time()

    if currentTime >= expiryTimestamp then
        return
    end

    local remainingSeconds = expiryTimestamp - currentTime
    local remainingDays = math.ceil(remainingSeconds / 86400)

    player:Kick(
        "تم حظرك مؤقتاً.\nالأيام المتبقية: "
        .. tostring(remainingDays)
    )
end

Players.PlayerAdded:Connect(function(player)
    task.spawn(function()
        CheckBan(player)
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(function()
        CheckBan(player)
    end)
end
