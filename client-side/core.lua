local ObjectCam = nil
local Raycasting = false
local Sensitivity = 0.2
local Save = GetGameTimer()

RegisterCommand("camera", function()
    RequestStreamedTextureDict("crosstheline")

    while not HasStreamedTextureDictLoaded("crosstheline") do
        Wait(0)
    end

    ObjectCam = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
    SetCamCoord(ObjectCam, GetEntityCoords(PlayerPedId()))
    RenderScriptCams(true, true, 600, true, true)
    SetCamActive(ObjectCam, true)
    
    local CameraShaking = false
    local CameraPoiting = false

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

        if IsDisabledControlPressed(1, 34) and not CameraPoiting then
            X = X - Speed * Dy
            Y = Y + Speed * Dx
        end
    
        if IsDisabledControlPressed(1, 35) and not CameraPoiting then
            X = X + Speed * Dy
            Y = Y - Speed * Dx
        end

        if IsDisabledControlPressed(1, 14) then
            SetCamFov(ObjectCam, GetCamFov(ObjectCam) + 1.0)
        end

        if IsDisabledControlPressed(1, 15) then
            SetCamFov(ObjectCam, GetCamFov(ObjectCam) - 1.0)
        end
        
        if IsDisabledControlJustReleased(1, 45) then
            Raycasting = not Raycasting
        end

        if IsDisabledControlJustReleased(1, 47) and GetGameTimer() >= Save then
            Save = GetGameTimer() + 500

            Clipboard(json.encode({
                Coords = tostring(vec3(X, Y, Z)),
                Rotation = tostring(Direction),
                Fov = GetCamFov(ObjectCam),
                Shaking = CameraShaking,
                Pointing = CameraPoiting
            }, { indent = true }))
        end

        if IsDisabledControlJustReleased(1, 202) then
            RenderScriptCams(false,false,600,false,false)
            SetCamActive(ObjectCam, false)
            DestroyCam(ObjectCam)
            SetNuiFocus(false, false)
            ObjectCam = nil
        end

        if Raycasting then
            DrawSprite("crosstheline", "timer_largecross_32", 0.5, 0.5, 0.01, 0.015, 0.0, 255, 255, 255, 255)

            local Hit, Coords, Entity = CamRaycast()

            if Hit then
                if IsDisabledControlJustReleased(1, 24) then
                    CameraPoiting = not CameraPoiting
                    
                    if CameraPoiting then
                        PointCamAtEntity(ObjectCam, Entity, 0.0, 0.0, 0.0, true)
                    else
                        StopCamPointing(ObjectCam)
                    end
                end
            end
        end

        SetCamCoord(ObjectCam, X, Y, Z)
        SetCamRot(ObjectCam, Direction.x, Direction.y, Direction.z)

        Wait(1)
    end

    SetStreamedTextureDictAsNoLongerNeeded("crosstheline")
end)

function CamRaycast()
    if DoesCamExist(ObjectCam) then
        local Cam = GetCamCoord(ObjectCam)
        local GetAdjust = function()
            local Pitch, Roll, Yaw = table.unpack(GetCamRot(ObjectCam, 2))

            local RX = -math.sin(math.rad(Yaw)) * math.abs(math.cos(math.rad(Pitch)))
            local RY =  math.cos(math.rad(Yaw)) * math.abs(math.cos(math.rad(Pitch)))
            local RZ =  math.sin(math.rad(Pitch))
        
            return vec3(RX, RY, RZ)
        end

        local Adjust = GetAdjust()
        
        local x = Cam.x + Adjust.x * 10000.0
        local y = Cam.y + Adjust.y * 10000.0
        local z = Cam.z + Adjust.z * 10000.0

        local Handle = StartExpensiveSynchronousShapeTestLosProbe(Cam.x, Cam.y, Cam.z, x, y, z, 8)
        local _, Hit, Coords, Surface, Entity = GetShapeTestResult(Handle)

        if Hit ~= 0 then
            return Hit, Coords, Entity
        end
    end

    return false
end