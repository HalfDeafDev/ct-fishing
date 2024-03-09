fx_version "cerulean";
game "gta5";

description "CT-Fishing";
version "1.0.0"

dependencies {
    "PolyZone",
    "qb-target"
}

client_scripts {
    "@PolyZone/client.lua",
    "@PolyZone/BoxZone.lua",
    "@PolyZone/CircleZone.lua",
    "@PolyZone/ComboZone.lua",
    "client/cl_main.lua",
}

shared_scripts {
    "shared/sh_main.lua",
}

server_scripts {
    "server/sv_main.lua"
}