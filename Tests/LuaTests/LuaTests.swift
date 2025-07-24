//
//  LuaTests.swift
//  LuaTests
//
//  Created by Leon Li on 2023/12/29.
//

import XCTest
@testable import Lua

// luac5.1.exe -o test.lub test.lua

final class LuaTests: XCTestCase {
    func testLuaDecompiler() throws {
        let url = Bundle.module.url(forResource: "test", withExtension: "lub")!
        let data = try Data(contentsOf: url)

        let decompiler = LuaDecompiler()
        let decompiledData = decompiler.decompileData(data)
        XCTAssertNotNil(decompiledData)

        let decompiledString = String(data: decompiledData!, encoding: .utf8)!
        XCTAssertTrue(decompiledString.contains("globalVar"))
    }

    func testLuaContext() throws {
        let url = Bundle.module.url(forResource: "test", withExtension: "lua")!
        let string = try String(contentsOf: url, encoding: .utf8)

        let context = LuaContext()
        try context.parse(string)

        XCTAssertEqual(context["globalVar"] as! Array<Double>, [0.0, 1.0])

        XCTAssertEqual(try context.call("myFunction", with: [0.5]) as! Bool, true)

        context.setObject([0.2, 0.4], forKeyedSubscript: "globalVar" as NSString)
        XCTAssertEqual(try context.call("myFunction", with: [0.5]) as! Bool, false)
    }

    func testLubContext() throws {
        let url = Bundle.module.url(forResource: "test", withExtension: "lub")!
        let data = try Data(contentsOf: url)

        let context = LuaContext()
        try context.load(data)

        XCTAssertEqual(context["globalVar"] as! Array<Double>, [0.0, 1.0])

        XCTAssertEqual(try context.call("myFunction", with: [0.5]) as! Bool, true)
    }
}
