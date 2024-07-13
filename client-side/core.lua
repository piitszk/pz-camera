local ObjectCam = nil
local Sensitivity = 0.2
local Save = GetGameTimer()

RegisterCommand("camera", function()
    local Ped = PlayerPedId()
    local Coords = GetEntityCoords(Ped)

    ObjectCam = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
    SetCamCoord(ObjectCam, Coords.x, Coords.y, Coords.z)
    RenderScriptCams(true, true, 600, true, true)
    SetCamActive(ObjectCam, true)
    
    local CameraShaking = false

    while DoesCamExist(ObjectCam) do
        DisableControls(true)

        local X, Y, Z = table.unpack(GetCamCoord(ObjectCam))
        local Pitch, Roll, Yaw = table.unpack(GetCamRot(ObjectCam, 2))
        local Direction = GetGameplayCamRot(0)
        local Speed = 2.0

        local R = -Direction.z * math.pi / 180
        local Dx = Speed * Sensitivity * math.sin(R)
        local Dy = Speed * Sensitivity * math.cos(R)
        local Dz = Sensitivity * math.sin(math.rad(Pitch))

        if IsDisabledControlPressed(1, 21) then
            Speed = 5.0
        end 
        
        if IsDisabledControlPressed(1, 36) then
            Speed = 0.2
        end 

        if IsDisabledControlJustReleased(1, 74) then
            CameraShaking = not CameraShaking
            local Amplitude = (CameraShaking) and 0.2 or 0.0

            ShakeCam(ObjectCam, 'DRUNK_SHAKE', Amplitude)
        end

        if IsDisabledControlPressed(1, 32) then
            X = X + Speed * Dx
            Y = Y + Speed * Dy
            Z = Z + Speed * Dz
        end
    
        if IsDisabledControlPressed(1, 33) then
            X = X - Speed * Dx
            Y = Y - Speed * Dy
            Z = Z - Speed * Dz
        end

        if IsDisabledControlPressed(1, 14) then
            SetCamFov(ObjectCam, GetCamFov(ObjectCam) + 1.0)
        end

        if IsDisabledControlPressed(1, 15) then
            SetCamFov(ObjectCam, GetCamFov(ObjectCam) - 1.0)
        end

        if IsDisabledControlJustReleased(1, 47) and GetGameTimer() >= Save then
            Save = GetGameTimer() + 500

            local SaveCamCoords = Truncate(GetCamCoord(ObjectCam))
            local SaveCamRotation = Truncate(GetGameplayCamRot(0))
            local SaveCamFov = Truncate(GetCamFov(ObjectCam))

            Clipboard(json.encode({
                Coords = tostring(SaveCamCoords),
                Rotation = tostring(SaveCamRotation),
                Fov = tostring(SaveCamFov),
                Shaking = CameraShaking,
            }, { indent = true }))
        end

        if IsDisabledControlJustReleased(1, 202) then
            RenderScriptCams(false,false,600,false,false)
            SetCamActive(ObjectCam, false)
            DestroyCam(ObjectCam)
            SetNuiFocus(false, false)
            ObjectCam = nil
        end

        SetCamCoord(ObjectCam, X, Y, Z)
        SetCamRot(ObjectCam, Direction.x, Direction.y, Direction.z)

        Wait(1)
    end
end)