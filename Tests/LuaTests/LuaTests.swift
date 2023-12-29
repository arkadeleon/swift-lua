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

    func testLuaContext() throws {
        let context = LuaContext()
        try context.parse("""
        globalVar = { 0.0, 1.0 }

        function myFunction(parameter)
            if parameter >= globalVar[1] and parameter <= globalVar[2] then
                return 1
            else
                return 0
            end
        end
        """)

        XCTAssertEqual(context["globalVar"] as! Array<Double>, [0.0, 1.0])

        XCTAssertEqual(try context.call("myFunction", with: [0.5]) as! Bool, true)

        context.setObject([0.2, 0.4], forKeyedSubscript: "globalVar" as NSString)
        XCTAssertEqual(try context.call("myFunction", with: [0.5]) as! Bool, false)
    }

    func testSkillDescription() throws {
        let jobinheritlistURL = Bundle.module.url(forResource: "jobinheritlist", withExtension: "lua")!
        let jobinheritlist = try! String(contentsOf: jobinheritlistURL)

        let skillidURL = Bundle.module.url(forResource: "skillid", withExtension: "lua")!
        let skillid = try! String(contentsOf: skillidURL)

        let skillinfolistURL = Bundle.module.url(forResource: "skillinfolist", withExtension: "lua")!
        let skillinfolist = try! String(contentsOf: skillinfolistURL)

        let skilldescriptURL = Bundle.module.url(forResource: "skilldescript", withExtension: "lua")!
        let skilldescript = try! String(contentsOf: skilldescriptURL)

        let context = LuaContext()
        try context.parse(jobinheritlist)
        try context.parse(skillid)
        try context.parse(skillinfolist)
        try context.parse(skilldescript)
        try context.parse("""
        function skillDescription(skillID)
            return SKILL_DESCRIPT[skillID]
        end
        """)

        let basicSkill = try context.call("skillDescription", with: [1]) as! [String]
        XCTAssertEqual(basicSkill.count, 23)
    }
}
