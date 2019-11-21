@testable import MachOParser
import XCTest

class MachOParserTests: XCTestCase {
    func testParseHeader() {
        class Visitor: MachOVisitor {
            class SegmentContext {
                let segment: segment_command_64
                var totalSize: Int = MemoryLayout<segment_command_64>.size
                var count: UInt32 = 0
                init(_ segment: segment_command_64) { self.segment = segment }
            }
            
            var segmentContext: SegmentContext?
            
            func visit(_ header: mach_header) {
                XCTAssertEqual(header.magic, MH_MAGIC)
            }

            func visit(_ header: mach_header_64) {
                XCTAssertEqual(header.magic, MH_MAGIC_64)
            }
            
            func visit(_ command: segment_command_64) {
                XCTAssertNil(segmentContext)
                segmentContext = SegmentContext(command)
            }
            
            func visit(_ section: section_64) {
                guard let context = segmentContext else { XCTFail(); return }
                context.count += 1
                context.totalSize += MemoryLayout<section_64>.size
                if context.count == context.segment.nsects {
                    XCTAssertEqual(context.segment.cmdsize, UInt32(context.totalSize))
                    segmentContext = nil
                }
                let name = withUnsafeBytes(of: section.sectname) { ptr in
                    String(cString: ptr.bindMemory(to: CChar.self).baseAddress!)
                }
                print(name)
            }
            
            func visit(_ section: section) {}
            
            func visit(_ command: symtab_command) {}

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
