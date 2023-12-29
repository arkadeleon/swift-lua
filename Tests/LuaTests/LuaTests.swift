//
//  LuaTests.swift
//  LuaTests
//
//  Created by Leon Li on 2023/12/29.
//

import XCTest
@testable import Lua

final class LuaTests: XCTestCase {
    func testLuaDecompiler() throws {
        let url = Bundle.module.url(forResource: "iteminfo", withExtension: "lub")!
        let data = try! Data(contentsOf: url)

        let decompiler = LuaDecompiler()
        let decompiledData = decompiler.decompileData(data)
        XCTAssertNotNil(decompiledData)
    }
}
