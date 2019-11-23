import MachO.loader

public protocol MachOVisitor {
    func visit(_ header: mach_header)
    func visit(_ header: mach_header_64)
    func visit(_ command: build_version_command)
    func visit(_ command: dyld_info_command)
    func visit(_ command: dylib_command)
    func visit(_ command: dylinker_command)
    func visit(_ command: dysymtab_command)
    func visit(_ command: encryption_info_command)
    func visit(_ command: encryption_info_command_64)
    func visit(_ command: entry_point_command)
    func visit(_ command: fvmfile_command)
    func visit(_ command: fvmlib_command)
    func visit(_ command: ident_command)
    func visit(_ command: linkedit_data_command)
    func visit(_ command: linker_option_command)
    func visit(_ command: load_command)
    func visit(_ command: note_command)
    func visit(_ command: prebind_cksum_command)
    func visit(_ command: prebound_dylib_command)
    func visit(_ command: routines_command)
    func visit(_ command: routines_command_64)
    func visit(_ command: rpath_command)
    func visit(_ command: segment_command)
    func visit(_ command: segment_command_64)
    func visit(_ command: source_version_command)
    func visit(_ command: sub_client_command)
    func visit(_ command: sub_framework_command)
    func visit(_ command: sub_library_command)
    func visit(_ command: sub_umbrella_command)
    func visit(_ command: symseg_command)
    func visit(_ command: symtab_command)
    func visit(_ command: thread_command)
    func visit(_ command: twolevel_hints_command)
    func visit(_ command: uuid_command)
    func visit(_ command: version_min_command)
    
    func visit(_ section: section_64)
    func visit(_ section: section)
}

public protocol LoadCommand {
    var cmdsize: UInt32 { get }
    func accept<V: MachOVisitor>(visitor: V, ptr: UnsafeRawPointer)
}

extension LoadCommand {
    static func load(_ ptr: UnsafeRawPointer) -> Self {
        return ptr.load(as: Self.self)
    }
}

extension build_version_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension dyld_info_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension dylib_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension dylinker_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension dysymtab_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension encryption_info_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension encryption_info_command_64: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension entry_point_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension fvmfile_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension fvmlib_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension ident_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension linkedit_data_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension linker_option_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension load_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension note_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension prebind_cksum_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension prebound_dylib_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension routines_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension routines_command_64: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension rpath_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension segment_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor {
        visitor.visit(self)
        let parser = MachOSegmentParser(segment_command: ptr, is64Bit: false)
        parser.parse(visitor: visitor)
    }
}
extension segment_command_64: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor {
        visitor.visit(self)
        let parser = MachOSegmentParser(segment_command: ptr, is64Bit: true)
        parser.parse(visitor: visitor)
    }
}
extension source_version_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension sub_client_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension sub_framework_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension sub_library_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension sub_umbrella_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension symseg_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension symtab_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension thread_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension twolevel_hints_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension uuid_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}
extension version_min_command: LoadCommand {
    public func accept<V>(visitor: V, ptr: UnsafeRawPointer) where V : MachOVisitor { visitor.visit(self) }
}

protocol MachOSection {}

extension MachOSection {
    static func load(_ ptr: UnsafeRawPointer) -> Self {
        return ptr.load(as: Self.self)
    }
}

extension section: MachOSection {}
extension section_64: MachOSection {}
