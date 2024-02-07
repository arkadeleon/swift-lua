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
        let data = try Data(contentsOf: url)

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

    func testItemDescription() throws {
        let iteminfoURL = Bundle.module.url(forResource: "iteminfo", withExtension: "lub")!
        let iteminfo = try Data(contentsOf: iteminfoURL)

        let context = LuaContext()
        try context.load(iteminfo)
        try context.parse("""
        function itemDescription(itemID)
            return tbl[itemID]["identifiedDescriptionName"]
        end
        """)

        let redPortion = try context.call("itemDescription", with: [501]) as! [String]
        XCTAssertEqual(redPortion.count, 3)
    }

    func testSkillDescription() throws {
        let jobinheritlistURL = Bundle.module.url(forResource: "jobinheritlist", withExtension: "lub")!
        let jobinheritlist = try Data(contentsOf: jobinheritlistURL)

        let skillidURL = Bundle.module.url(forResource: "skillid", withExtension: "lub")!
        let skillid = try Data(contentsOf: skillidURL)

        let skillinfolistURL = Bundle.module.url(forResource: "skillinfolist", withExtension: "lub")!
        let skillinfolist = try Data(contentsOf: skillinfolistURL)

        let skilldescriptURL = Bundle.module.url(forResource: "skilldescript", withExtension: "lub")!
        let skilldescript = try Data(contentsOf: skilldescriptURL)

        let context = LuaContext()
        try context.load(jobinheritlist)
        try context.load(skillid)
        try context.load(skillinfolist)
        try context.load(skilldescript)
        try context.parse("""
        function skillDescription(skillID)
            return SKILL_DESCRIPT[skillID]
        end
        """)

        let basicSkill = try context.call("skillDescription", with: [1]) as! [String]
        XCTAssertEqual(basicSkill.count, 23)
    }

    func testAccessoryName() throws {
        let accessoryidURL = Bundle.module.url(forResource: "accessoryid", withExtension: "lub")!
        let accessoryid = try Data(contentsOf: accessoryidURL)

        let accnameURL = Bundle.module.url(forResource: "accname", withExtension: "lub")!
        let accname = try Data(contentsOf: accnameURL)

        let context = LuaContext()
        try context.load(accessoryid)
        try context.load(accname)
        try context.parse("""
        function accessoryName(accessoryID)
            return AccNameTable[accessoryID]
        end
        """)

        let nameOfGoggles = try context.call("accessoryName", with: [1]) as! String
        let convertedNameOfGoggles = nameOfGoggles.data(using: .isoLatin1)?.string(using: .korean)
        XCTAssertEqual(convertedNameOfGoggles, "_고글")
    }
}

extension String.Encoding {
    static let japanese = String.Encoding(codepage: 932)
    static let chinese = String.Encoding(codepage: 936)
    static let korean = String.Encoding(codepage: 949)
    static let cyrillic = String.Encoding(codepage: 1251)
    static let ansi = String.Encoding(codepage: 1252)

    init(codepage: UInt32) {
        let cfStringEncoding = CFStringConvertWindowsCodepageToEncoding(codepage)
        let nsStringEncoding = CFStringConvertEncodingToNSStringEncoding(cfStringEncoding)
        self.init(rawValue: nsStringEncoding)
    }
}

extension Data {
    func string(using encoding: String.Encoding) -> String? {
        String(data: self, encoding: encoding)
    }
}
