function DisableControls()
    DisableControlAction(1, 14, true)
    DisableControlAction(1, 15, true)
    DisableControlAction(1, 26, true)
    DisableControlAction(1, 30, true)
    DisableControlAction(1, 31, true)
    DisableControlAction(1, 32, true)
    DisableControlAction(1, 33, true)
    DisableControlAction(1, 34, true)
    DisableControlAction(1, 35, true)
    DisableControlAction(1, 36, true)
    DisableControlAction(1, 202, true)
    DisablePlayerFiring(PlayerPedId(),true)
end

function Clipboard(Text)
    -- Responsável por abrir uma box message pra que possa ser possível copiar o texto de debug - geralmente vRP.Prompt
    -- Adapte pra sua framework.
    print(Text)
end

local Vectors = {
    vector2 = function(vec)
        return vec2(Truncate(vec["x"]), Truncate(vec["y"]))
    end,

    vector3 = function(vec)
        return vec3(Truncate(vec["x"]), Truncate(vec["y"]), Truncate(vec["z"]))
    end,

    vector4 = function(vec)
        return vec4(Truncate(vec["x"]), Truncate(vec["y"]), Truncate(vec["z"]), Truncate(vec["w"]))
    end
}

function Truncate(Number)
    if StartsWith(Number, "vector") then
        return Vectors[type(Number)](Number)
    end

    return mathLength(Number)
end

function mathLength(Number)
	return math.ceil(Number * 100) / 100
end

function StartsWith(String, Prefix)
    return string.sub(String, 1, #Prefix) == Prefix
end