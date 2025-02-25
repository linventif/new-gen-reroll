if !LinvLib then
    print(" ")
    print(" ")
    print(" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
    print(" -                                                           - ")
    print(" -               Linventif Library is missing !              - ")
    print(" -                                                           - ")
    print(" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
    print(" ")
    print("Linventif Library is missing ! Please install it !")
    print(" ")
    print("You can download the latest version here : https://github.com/linventif/gmod-lib")
    print("Or you can download it directly from the workshop : https://steamcommunity.com/sharedfiles/filedetails/?id=2882747990")
    print("If you have any questions, you can join my discord : https://linventif.fr/discord")
    print("If you don't download it, you won't be able to use my creations.")
    print(" ")
    print(" ")
    return
end

// -- // -- // -- // -- // -- // -- // -- // -- // -- //

local folder = "ng_reroll"
local name = "New Gen Reroll"
local license = "Commercial"
local version = "0.1.8"

NGReroll = {}
NGReroll.Config = {}
LinvLib.Install["new-gen-reroll"] = version

// -- // -- // -- // -- // -- // -- // -- // -- // -- //

LinvLib.LoadStr(name, version, license)
LinvLib.Load(name, folder, {"sh_config.lua", "sh_language.lua"})
LinvLib.Loader(folder .. "/shared", name)
LinvLib.Loader(folder .. "/server", name)
LinvLib.Loader(folder .. "/client", name)

print(" ")
print(" ")