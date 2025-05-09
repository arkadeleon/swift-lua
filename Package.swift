// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-lua",
    products: [
        .library(
            name: "Lua",
            targets: ["Lua"]),
    ],
    targets: [
        .target(
            name: "Lua",
            cSettings: [
                .headerSearchPath("lua"),
                .headerSearchPath("luacompact53"),
                .headerSearchPath("luadec"),
            ]),
        .testTarget(
            name: "LuaTests",
            dependencies: ["Lua"],
            resources: [
                .copy("Resources/iteminfo.lub"),
                .copy("Resources/jobinheritlist.lub"),
                .copy("Resources/skillid.lub"),
                .copy("Resources/skillinfolist.lub"),
                .copy("Resources/skilldescript.lub"),
                .copy("Resources/accessoryid.lub"),
                .copy("Resources/accname.lub"),
            ]),
    ]
)
