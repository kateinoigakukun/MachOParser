@testable import MachOParser
import XCTest

class MachOParserTests: XCTestCase {
    func testParseIntermediateObjectFile() throws {
        class Visitor: MachOVisitor {
            class SegmentContext {
                let segment: segment_command_64
                var totalSize: Int = MemoryLayout<segment_command_64>.size
                var count: UInt32 = 0
                init(_ segment: segment_command_64) { self.segment = segment }
            }

            let fp: UnsafeRawPointer
            var segmentContext: SegmentContext?
            var segments: [segment_command_64] = []
            var sections: [section_64] = []
            var commandSize: UInt32?
            var symbolTableSize: UInt32?
            var dynamicSymbolTableSize: UInt32?

            var relocationInfoBySection: [String: [relocation_info]] = [:]

            var actualCommandSize: UInt32 = 0

            var symbolTable: [String] = []

            init(_ fp: UnsafeRawPointer) {
                self.fp = fp
            }
            
            func visit(_ header: UnsafePointer<mach_header>) {
                XCTAssertEqual(header.pointee.magic, MH_MAGIC)
            }

            func visit(_ header: UnsafePointer<mach_header_64>) {
                XCTAssertEqual(header.pointee.magic, MH_MAGIC_64)
                commandSize = header.pointee.sizeofcmds
            }
            
            func visit(_ command: UnsafePointer<segment_command_64>) {
                // For compactness, intermediate object files doesn't have name
                XCTAssertTrue(String(fixedLengthString: command.pointee.segname).isEmpty)
                XCTAssertNil(segmentContext)
                segmentContext = SegmentContext(command.pointee)
                segments.append(command.pointee)
                actualCommandSize += command.pointee.cmdsize
            }
            
            func visit(_ section: UnsafePointer<section_64>) {
                guard let context = segmentContext else { XCTFail(); return }
                context.count += 1
                context.totalSize += MemoryLayout<section_64>.size
                if context.count == context.segment.nsects {
                    XCTAssertEqual(context.segment.cmdsize, UInt32(context.totalSize))
                    segmentContext = nil
                }
                sections.append(section.pointee)

                let type = section.pointee.flags & UInt32(SECTION_TYPE)

                XCTAssertNotEqual(type, UInt32(S_NON_LAZY_SYMBOL_POINTERS))
                var relocPtr = fp.advanced(by: Int(section.pointee.reloff))
                var relocInfo: [relocation_info] = []
                for _ in 0..<section.pointee.nreloc {
                    let info = relocPtr.load(as: relocation_info.self)
                    relocInfo.append(info)
                    relocPtr = relocPtr.advanced(by: MemoryLayout<relocation_info>.size)
                }
                relocationInfoBySection[String(fixedLengthString: section.pointee.sectname)] = relocInfo
            }
            
            func visit(_ section: UnsafePointer<section>) {}

            func visit(_ command: UnsafePointer<symtab_command>) {
                symbolTableSize = command.pointee.strsize + UInt32(MemoryLayout<nlist_64>.size) * command.pointee.nsyms
                actualCommandSize += command.pointee.cmdsize

                let stringsPtr = fp.advanced(by: Int(command.pointee.stroff))
                var symPtr = fp.advanced(by: Int(command.pointee.symoff))
                for _ in 0..<command.pointee.nsyms {
                    let sym = symPtr.load(as: nlist_64.self)
                    let name = stringsPtr
                        .advanced(by: Int(sym.n_un.n_strx) * MemoryLayout<CChar>.size)
                        .assumingMemoryBound(to: CChar.self)
                    let str = String(cString: name)
                    symbolTable.append(str)
                    symPtr = symPtr.advanced(by: MemoryLayout<nlist_64>.size)
                }
            }

            func visit(_ command: UnsafePointer<dysymtab_command>) {
                actualCommandSize += command.pointee.cmdsize
            }

            func visit<LC: LoadCommand>(_ command: UnsafePointer<LC>) {
                print(type(of: command))
                actualCommandSize += command.pointee.cmdsize
            }

            func visit(_ command: UnsafePointer<linker_option_command>) {
                command
            }
        }
        let url = fixtures.appendingPathComponent("hello.o").path
        let data = NSData(contentsOfFile: url)!
        let fp = data.bytes
        let parser = MachOParser(fp)
        let visitor = Visitor(fp)
        parser.parse(with: visitor)

        XCTAssertEqual(visitor.commandSize, visitor.actualCommandSize)
        let totalSize = UInt32(MemoryLayout<mach_header_64>.size)
            + visitor.commandSize!
            + UInt32(visitor.relocationInfoBySection.reduce(0, {
                $0 + $1.value.reduce(0, { $0 + $1.r_length})
            }))
            + UInt32(visitor.sections.reduce(0, { $0 + $1.size }))
            + visitor.symbolTableSize!
        XCTAssertEqual(totalSize, UInt32(data.length))
    }

    func testFixedLengthString() {
        let chars: (CChar, CChar, CChar, CChar, CChar, CChar)
            = (0x68, 0x65, 0x6c, 0x6c, 0x6f, 0x00)
        let value = String(fixedLengthString: chars)
        XCTAssertEqual(value, "hello")
    }
}
