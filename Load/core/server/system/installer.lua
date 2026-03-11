function WaveShield:checkInstallation()
    local installedResources = 0
    local uninstalledResources = 0

    for i = 0, GetNumResources() - 1, 1 do
        local resourceName = GetResourceByFindIndex(i)

        if resourceName ~= "_cfx_internal" then
            for _, v in pairs({'fxmanifest.lua', '__resource.lua'}) do
                local manifestFile = Citizen.InvokeNative(string.format("0x%x", 0x76A9EE1F),tostring(resourceName),tostring(v), Citizen.ReturnResultAnyway(), Citizen.ResultAsString())
                if manifestFile ~= nil and type(manifestFile) == "string" then
                    if WaveShield.Config.Settings.IgnoredScripts[resourceName] then
                        if  string.find(manifestFile, "resource/include%.lua") or
                            string.find(manifestFile, "resource/waveshield%.js") or
                            string.find(manifestFile, "resource/waveshield%.lua")
                        then
                            local uninstalled = WaveShield:uninstallResource(resourceName)
                            if uninstalled then
-- ZGlzY29yZC5nZy9mbWE=
                                uninstalledResources = uninstalledResources + 1
                                Citizen.Wait(0)
                            end
                        end
                    else
                        local shouldInstallLUA = false
                        local shouldInstallJS = false

                        for __, metadataKey in pairs({"client_script", "server_script", "shared_script"}) do
                            for i = 0, GetNumResourceMetadata(resourceName, metadataKey) - 1 do
                                local file = (GetResourceMetadata(resourceName, metadataKey, i) or "none")
                                if file:find("%.lua") or (file:sub(-1) == "*") then
                                    shouldInstallLUA = true
                                end

                                if file:find("%.js") or (file:sub(-1) == "*") then
                                    shouldInstallJS = true
                                end
-- WlhYWFhYWFhYWFhYWFhYWENDQ0NDQ0NDQ0NDQ0NDQ0NDQyBmbWE=
                            end
                        end

                        if (shouldInstallLUA and not string.find(manifestFile, "resource/include%.lua"))
                            or (shouldInstallJS and not string.find(manifestFile, "resource/waveshield%.js"))
                        then
                            local installed = WaveShield:installResource(resourceName, v, shouldInstallLUA, shouldInstallJS)
                            if installed then
                                installedResources = installedResources + 1
                                Citizen.Wait(0)
                            end
                        end
                    end
                    break
                end
            end
        end
    end

    if (installedResources > 0) then
        WaveShield:print("WaveShield has been installed in ^3"..installedResources.."^0 resources, a restart is required to apply the changes.","^2","Installer")
        os.remove("@WaveShield/resource/waveshield.lua")
    end

    if (uninstalledResources > 0) then
        WaveShield:print("WaveShield has been uninstalled in ^3"..uninstalledResources.."^0 resources, a restart is required to apply the changes.","^2","Installer")
    end

    if (installedResources > 0 or uninstalledResources > 0) then
        WaveShield:stopServer()
    end

    return true, installedResources, uninstalledResources
end

local function uninstallFile(manifestFile)
    if manifestFile == nil or type(manifestFile) ~= "string" then return end

    local newManifestCode = manifestFile
    local patterns = {
        -- Old shared_script patterns (with and without comments)
        "shared_script%s+['\"]@" .. WaveShield.resourceName .. "/resource/waveshield%.lua['\"]%s*%-%-this%s+line%s+was%s+automatically%s+written%s+by%s+WaveShield[^\n]*\n?",
        "shared_script%s+['\"]@" .. WaveShield.resourceName .. "/resource/waveshield%.lua['\"][^\n]*\n?",
        "shared_script%s+['\"]@" .. WaveShield.resourceName .. "/resource/waveshield%.js['\"]%s*%-%-this%s+line%s+was%s+automatically%s+written%s+by%s+WaveShield[^\n]*\n?",
        "shared_script%s+['\"]@" .. WaveShield.resourceName .. "/resource/waveshield%.js['\"][^\n]*\n?",

        -- New client/server script patterns
        "client_script%s+['\"]@" .. WaveShield.resourceName .. "/resource/client/include%.lua['\"][^\n]*\n?",
        "server_script%s+['\"]@" .. WaveShield.resourceName .. "/resource/server/include%.lua['\"][^\n]*\n?",
        "shared_script%s+['\"]@" .. WaveShield.resourceName .. "/resource/include%.lua['\"][^\n]*\n?",
    }

    -- Apply all cleanup patterns
    for _, pattern in ipairs(patterns) do
        newManifestCode = newManifestCode:gsub(pattern, "")
    end

    -- Clean up multiple consecutive empty lines (more than 2)
    newManifestCode = newManifestCode:gsub("\n\n\n+", "\n\n")

    -- Clean up trailing whitespace on lines
    newManifestCode = newManifestCode:gsub("[ \t]+\n", "\n")

    -- Remove leading empty lines if any were created
    newManifestCode = newManifestCode:gsub("^[\n\r%s]*", "")

    return newManifestCode
end

function WaveShield:installResource(resourceName, manifestName, lua, js)
    if resourceName == WaveShield.resourceName then return false end
    if WaveShield.Config.Settings.IgnoredScripts[resourceName] then return false end
    local manifestFile = Citizen.InvokeNative(string.format("0x%x", 0x76A9EE1F),tostring(resourceName),tostring(manifestName), Citizen.ReturnResultAnyway(), Citizen.ResultAsString())

    local manifestCode = uninstallFile(manifestFile)
    if manifestCode then
        local changes = ""

        if lua then
            changes = changes .. "shared_script '@" .. WaveShield.resourceName .. "/resource/include.lua'\n"
        end

        if js then
            changes = changes .. "shared_script '@" .. WaveShield.resourceName .. "/resource/waveshield.js'\n"
        end

        if changes ~= "" then
            local newManifestCode = changes .. "\n" .. manifestCode
            local saved = WaveShield:saveFile(resourceName, manifestName, newManifestCode)
            return saved
        end
    end
    return false
end

function WaveShield:uninstallResource(resourceName)
    if resourceName ~= "_cfx_internal" then
        for _, v in pairs({'fxmanifest.lua', '__resource.lua'}) do
            local manifestFile = Citizen.InvokeNative(string.format("0x%x", 0x76A9EE1F),tostring(resourceName),tostring(v), Citizen.ReturnResultAnyway(), Citizen.ResultAsString())
            if resourceName ~= WaveShield.resourceName then
                local newManifestCode = uninstallFile(manifestFile)
                if newManifestCode and newManifestCode ~= manifestFile then
                    local saved = WaveShield:saveFile(resourceName, v, newManifestCode)
                    return saved
                end
            end
            break
        end
    end

    return false
end

-- b3JpZ2luYWwgb3duZXIgb2YgdGhpcyBzb3VyY2UgaXMgRk1B
function WaveShield:uninstallResources()
    local uninstalledResources = 0

    for i = 0, GetNumResources() - 1, 1 do
        local resourceName = GetResourceByFindIndex(i)
        local uninstalled = WaveShield:uninstallResource(resourceName)
        if uninstalled then uninstalledResources = uninstalledResources + 1 Citizen.Wait(0) end
    end
    if uninstalledResources > 0 then
        WaveShield:print("WaveShield has been ^3uninstalled^0 in ".. uninstalledResources .." resources, a reboot is required to apply the changes.","^2","Installer")
        WaveShield:stopServer()
    end

    return true, uninstalledResources
end