import MachO.loader

public class MachOParser {
    let fp: UnsafeRawPointer
    
    var offset: UInt64 = 0
    
    public init(_ fp: UnsafeRawPointer) {
        self.fp = fp
    }

    public func parse<V: MachOVisitor>(with visitor: V) {
        let ncmds = parseHeader(visitor: visitor)
        parseLoadCommands(ncmds: ncmds, visitor: visitor)
    }

    private func parseHeader<V: MachOVisitor>(visitor: V) -> UInt32 {
        let magic = fp.load(as: mach_header.self).magic
        switch magic {
        case MH_MAGIC:
            let header = fp.load(as: mach_header.self)
            visitor.visit(header)
            advance(mach_header.self)
            return header.ncmds
        case MH_MAGIC_64:
            let header = fp.load(as: mach_header_64.self)
            visitor.visit(header)
            advance(mach_header_64.self)
            return header.ncmds
        case MH_CIGAM, MH_CIGAM_64:
            fatalError("unsupported")
        default:
            fatalError("unreachable")
        }
    }
    
    private func parseLoadCommands<V: MachOVisitor>(ncmds: UInt32, visitor: V) {
        func load<T: LoadCommand>(_ ptr: UnsafeRawPointer, _: T.Type) -> T {
            let cmd = ptr.load(as: T.self)
            return cmd
        }
        let dispatchTable: [UInt32: LoadCommand.Type] = [
            LC_LOAD_WEAK_DYLIB: dylib_command.self,
            LC_RPATH: rpath_command.self,
            LC_DYLD_INFO_ONLY: dyld_info_command.self,
            LC_LOAD_UPWARD_DYLIB: dylib_command.self,
            LC_REEXPORT_DYLIB: dylib_command.self,
            LC_MAIN: entry_point_command.self,
            LC_DYLD_EXPORTS_TRIE: linkedit_data_command.self,
            LC_DYLD_CHAINED_FIXUPS: linkedit_data_command.self,
            UInt32(LC_SEGMENT): segment_command.self,
            UInt32(LC_SYMTAB): symtab_command.self,
            UInt32(LC_SYMSEG): symseg_command.self,
            UInt32(LC_THREAD): thread_command.self,
            UInt32(LC_UNIXTHREAD): thread_command.self,
            UInt32(LC_LOADFVMLIB): fvmlib_command.self,
            UInt32(LC_IDFVMLIB): fvmlib_command.self,
            UInt32(LC_IDENT): ident_command.self,
            UInt32(LC_FVMFILE): fvmfile_command.self,
            UInt32(LC_PREPAGE): load_command.self,
            UInt32(LC_DYSYMTAB): dysymtab_command.self,
            UInt32(LC_LOAD_DYLIB): dylib_command.self,
            UInt32(LC_ID_DYLIB): dylib_command.self,
            UInt32(LC_LOAD_DYLINKER): dylinker_command.self,
            UInt32(LC_ID_DYLINKER): dylinker_command.self,
            UInt32(LC_PREBOUND_DYLIB): prebound_dylib_command.self,
            UInt32(LC_ROUTINES): routines_command.self,
            UInt32(LC_SUB_FRAMEWORK): sub_framework_command.self,
            UInt32(LC_SUB_UMBRELLA): sub_umbrella_command.self,
            UInt32(LC_SUB_CLIENT): sub_client_command.self,
            UInt32(LC_SUB_LIBRARY): sub_library_command.self,
            UInt32(LC_TWOLEVEL_HINTS): twolevel_hints_command.self,
            UInt32(LC_PREBIND_CKSUM): prebind_cksum_command.self,
            UInt32(LC_SEGMENT_64): segment_command_64.self,
            UInt32(LC_ROUTINES_64): routines_command_64.self,
            UInt32(LC_UUID): uuid_command.self,
            UInt32(LC_CODE_SIGNATURE): linkedit_data_command.self,
            UInt32(LC_SEGMENT_SPLIT_INFO): linkedit_data_command.self,
            UInt32(LC_LAZY_LOAD_DYLIB): dylib_command.self,
            UInt32(LC_ENCRYPTION_INFO): encryption_info_command.self,
            UInt32(LC_DYLD_INFO): dyld_info_command.self,
            UInt32(LC_VERSION_MIN_MACOSX): version_min_command.self,
            UInt32(LC_VERSION_MIN_IPHONEOS): version_min_command.self,
            UInt32(LC_FUNCTION_STARTS): linkedit_data_command.self,
            UInt32(LC_DYLD_ENVIRONMENT): dylinker_command.self,
            UInt32(LC_DATA_IN_CODE): linkedit_data_command.self,
            UInt32(LC_SOURCE_VERSION): source_version_command.self,
            UInt32(LC_DYLIB_CODE_SIGN_DRS): linkedit_data_command.self,
            UInt32(LC_ENCRYPTION_INFO_64): encryption_info_command_64.self,
            UInt32(LC_LINKER_OPTION): linkedit_data_command.self,
            UInt32(LC_LINKER_OPTIMIZATION_HINT): linkedit_data_command.self,
            UInt32(LC_VERSION_MIN_TVOS): version_min_command.self,
            UInt32(LC_VERSION_MIN_WATCHOS): version_min_command.self,
            UInt32(LC_NOTE): note_command.self,
            UInt32(LC_BUILD_VERSION): build_version_command.self,
        ]
        for _ in 0..<ncmds {
            let ptr = fp.advanced(by: Int(offset))
            let ld_cmd = ptr.load(as: load_command.self)
            guard let cmd_t = dispatchTable[ld_cmd.cmd] else {
                fatalError()
            }
            cmd_t.load(ptr).accept(visitor: visitor, ptr: ptr)
            offset += UInt64(ld_cmd.cmdsize)
        }
    }

    private func advance<T>(_: T.Type) {
        let size = UInt64(MemoryLayout<T>.size)
        offset += size
    }
}

class MachOSegmentParser {
    let fp: UnsafeRawPointer
    let cmd: segment_command_64
    let is64Bit: Bool
    
    init(segment_command: UnsafeRawPointer, is64Bit: Bool) {
        self.cmd = segment_command.load(as: segment_command_64.self)
        self.fp = UnsafeRawPointer(segment_command)
        self.is64Bit = is64Bit
    }
    
    func parse<V: MachOVisitor>(visitor: V) {
        var p = fp
        for _ in 0..<cmd.nsects {
            if is64Bit {
                let sec = p.load(as: section_64.self)
                visitor.visit(sec)
                p = p.advanced(by: MemoryLayout<section_64>.size)
            } else {
                let sec = p.load(as: section.self)
                visitor.visit(sec)
                p = p.advanced(by: MemoryLayout<section>.size)
            }
        }
    }
}
