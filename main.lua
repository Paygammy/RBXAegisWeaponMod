local getregistry = getreg or debug.getregistry
local getupvalues = getupvalues or debug.getupvalues
local islocalclosure = isexecutorclosure or is_synapse_function

for i, v in pairs(debug.getregistry()) do
    if type(v) == "function" and not islocalclosure(v) == true then
        local script = getfenv(v)["script"]

        if script and typeof(script) == "Instance" then
            for index, value in pairs(getupvalues(v)) do
                if type(value) == "table" then
                    if value._ConnectFire then
                        local _ConnectFire = value._ConnectFire
                        value._ConnectFire = function(self)
                            local success, response = pcall(function()
                                self.IsDestroyed = false
                                self.WeaponData.Stats.InfiniteAmmo = false
                                self.WeaponData.Stats.ShotDelay = 0
                                self.WeaponData.Stats.FireRate = 0
                                self.WeaponData.Stats.ShotCount = 1
                                self.WeaponData.FireType = "FullAuto"
                                self.LastShotFired = 0
                                return self
                            end)
                            if success == true then
                                return _ConnectFire(response)
                            end
                        end
                    end
                    if value.OnFire then
                        value.OnFire = function()
                            value:_ConnectFire()
                        end
                    end
                    if value.ApplyRecoil then
                        value.ApplyRecoil = function()
                            return nil
                        end
                    end
                end
            end
        end
    end
end
