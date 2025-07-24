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
                .copy("Resources/test.lua"),
                .copy("Resources/test.lub"),
            ]),
    ]
)
