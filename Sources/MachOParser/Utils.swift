extension String {
    public init<T>(fixedLengthString: T) {
        self = withUnsafeBytes(of: fixedLengthString) { ptr in
            String(cString: ptr.bindMemory(to: CChar.self).baseAddress!)
        }
    }
}
