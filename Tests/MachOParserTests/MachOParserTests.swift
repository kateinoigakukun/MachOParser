@testable import MachOParser
import XCTest

class MachOParserTests: XCTestCase {
    func testParseHeader() {
        class Visitor: MachOVisitor {
            func visit(_ header: mach_header) {
                XCTAssertEqual(header.magic, MH_MAGIC)
            }

            func visit(_ header: mach_header_64) {
                XCTAssertEqual(header.magic, MH_MAGIC_64)
            }

            func visit<LC: LoadCommand>(_ command: LC) {
                print(type(of: command))
            }
        }
        let url = fixtures.appendingPathComponent("hello.o").path
        let parser = MachOParser(NSData(contentsOfFile: url)!.bytes)
        let visitor = Visitor()
        parser.parse(with: visitor)
    }
}
