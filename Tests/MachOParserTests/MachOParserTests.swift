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

            let fp: UnsafeRawPointer
            var segmentContext: SegmentContext?

            init(_ fp: UnsafeRawPointer) {
                self.fp = fp
            }
            
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
                let segname = String(fixedLengthString: section.segname)
                let sectname = String(fixedLengthString: section.sectname)
                print(segname)
                print(sectname)
                print(section)
            }
            
            func visit(_ section: section) {}
            
            func visit(_ command: symtab_command) {}

            func visit<LC: LoadCommand>(_ command: LC) {
                print(type(of: command))
            }
        }
        let url = fixtures.appendingPathComponent("hello.o").path
        let fp = NSData(contentsOfFile: url)!.bytes
        let parser = MachOParser(fp)
        let visitor = Visitor(fp)
        parser.parse(with: visitor)
    }

    func testFixedLengthString() {
        let chars: (CChar, CChar, CChar, CChar, CChar, CChar)
            = (0x68, 0x65, 0x6c, 0x6c, 0x6f, 0x00)
        let value = String(fixedLengthString: chars)
        XCTAssertEqual(value, "hello")
    }
}
