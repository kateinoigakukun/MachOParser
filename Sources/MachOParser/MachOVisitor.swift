import MachO.loader

public protocol MachOVisitor {
    func visit(_ header: UnsafePointer<mach_header>)
    func visit(_ header: UnsafePointer<mach_header_64>)
    func visit(_ command: UnsafePointer<build_version_command>)
    func visit(_ command: UnsafePointer<dyld_info_command>)
    func visit(_ command: UnsafePointer<dylib_command>)
    func visit(_ command: UnsafePointer<dylinker_command>)
    func visit(_ command: UnsafePointer<dysymtab_command>)
    func visit(_ command: UnsafePointer<encryption_info_command>)
    func visit(_ command: UnsafePointer<encryption_info_command_64>)
    func visit(_ command: UnsafePointer<entry_point_command>)
    func visit(_ command: UnsafePointer<fvmfile_command>)
    func visit(_ command: UnsafePointer<fvmlib_command>)
    func visit(_ command: UnsafePointer<ident_command>)
    func visit(_ command: UnsafePointer<linkedit_data_command>)
    func visit(_ command: UnsafePointer<linker_option_command>)
    func visit(_ command: UnsafePointer<load_command>)
    func visit(_ command: UnsafePointer<note_command>)
    func visit(_ command: UnsafePointer<prebind_cksum_command>)
    func visit(_ command: UnsafePointer<prebound_dylib_command>)
    func visit(_ command: UnsafePointer<routines_command>)
    func visit(_ command: UnsafePointer<routines_command_64>)
    func visit(_ command: UnsafePointer<rpath_command>)
    func visit(_ command: UnsafePointer<segment_command>)
    func visit(_ command: UnsafePointer<segment_command_64>)
    func visit(_ command: UnsafePointer<source_version_command>)
    func visit(_ command: UnsafePointer<sub_client_command>)
    func visit(_ command: UnsafePointer<sub_framework_command>)
    func visit(_ command: UnsafePointer<sub_library_command>)
    func visit(_ command: UnsafePointer<sub_umbrella_command>)
    func visit(_ command: UnsafePointer<symseg_command>)
    func visit(_ command: UnsafePointer<symtab_command>)
    func visit(_ command: UnsafePointer<thread_command>)
    func visit(_ command: UnsafePointer<twolevel_hints_command>)
    func visit(_ command: UnsafePointer<uuid_command>)
    func visit(_ command: UnsafePointer<version_min_command>)
    
    func visit(_ section: UnsafePointer<section_64>)
    func visit(_ section: UnsafePointer<section>)
}

public protocol LoadCommand {
    var cmdsize: UInt32 { get }
    static func accept<V: MachOVisitor>(visitor: V, ptr: UnsafePointer<Self>)
}

extension LoadCommand {
    static func load(_ ptr: UnsafeRawPointer) -> Self {
        return ptr.load(as: Self.self)
    }
}

extension UnsafePointer where Pointee: LoadCommand {
    func accept<V>(visitor: V) where V: MachOVisitor {
        Pointee.accept(visitor: visitor, ptr: self)
    }
}

extension build_version_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension dyld_info_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension dylib_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension dylinker_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension dysymtab_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension encryption_info_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension encryption_info_command_64: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension entry_point_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension fvmfile_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension fvmlib_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension ident_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension linkedit_data_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension linker_option_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension load_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension note_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension prebind_cksum_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension prebound_dylib_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension routines_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension routines_command_64: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension rpath_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension segment_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor {
        visitor.visit(ptr)
        let parser = MachOSegmentParser(segment_command: ptr, is64Bit: false)
        parser.parse(visitor: visitor)
    }
}
extension segment_command_64: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor {
        visitor.visit(ptr)
        let parser = MachOSegmentParser(segment_command: ptr, is64Bit: true)
        parser.parse(visitor: visitor)
    }
}
extension source_version_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension sub_client_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension sub_framework_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension sub_library_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension sub_umbrella_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension symseg_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension symtab_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension thread_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension twolevel_hints_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension uuid_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}
extension version_min_command: LoadCommand {
    public static func accept<V>(visitor: V, ptr: UnsafePointer<Self>) where V : MachOVisitor { visitor.visit(ptr) }
}

protocol MachOSection {}

extension MachOSection {
    static func load(_ ptr: UnsafeRawPointer) -> Self {
        return ptr.load(as: Self.self)
    }
}

extension section: MachOSection {}
extension section_64: MachOSection {}
