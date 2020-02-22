import AndroidSwiftLogcat
import CAndroidSwiftTrace
import Foundation

public class ScopedNativeTraceSection {
    public static let TAG = "AndroidSwiftTrace"

    private var mSectionName: String

    // note: auto lazy init for global var.
    // but "lazy for static var" is not real lazy,
    // see [Swift 的坑：static var 的初始化时机并不确定](https://www.jianshu.com/p/eb8f1963e3ef)
    public static let sdkVersion: Int = ScopedNativeTraceSection.getSdkVersion()

    public init(_ sectionName: String) {
        mSectionName = sectionName
        ScopedNativeTraceSection.beginTrace(sectionName)
    }

    deinit {
        ScopedNativeTraceSection.endTrace(mSectionName)
    }

    private static func getSdkVersion() -> Int {
        let capacity = Int(PROP_VALUE_MAX)
        let pointer: UnsafeMutablePointer<Int8> = UnsafeMutablePointer<Int8>.allocate(capacity: capacity)
        pointer.initialize(repeating: 0, count: capacity)
        defer {
            pointer.deinitialize(count: capacity)
            pointer.deallocate()
        }

        let valueStrLen = __system_property_get("ro.build.version.sdk", pointer)

        guard valueStrLen > 0 else {
            return -1
        }

        guard let valueStr = String(validatingUTF8: pointer) else {
            return -1
        }

        return Int(valueStr) ?? -1
    }

    /**
     * Returns true if tracing is enabled. Use this signal to avoid expensive computation only necessary
     * when tracing is enabled.
     */
    public static func isNativeTraceEnabled() -> Bool {
        if ScopedNativeTraceSection.sdkVersion >= 23 {
            return ATrace_isEnabled()
        } else {
            return false
        }
    }

    /**
     * Writes a tracing message to indicate that the given section of code has begun. This call must be
     * followed by a corresponding call to endSection() on the same thread.
     *
     * Note: At this time the vertical bar character '|' and newline character '\n' are used internally
     * by the tracing mechanism. If sectionName contains these characters they will be replaced with a
     * space character in the trace.
     */
    public static func beginTrace(_ sectionName: String) {
        if ScopedNativeTraceSection.sdkVersion >= 23 {
            // AndroidLogcat.i(ScopedNativeTraceSection.TAG, "beginTrace(\"\(sectionName)\")")
            ATrace_beginSection(sectionName)
        }
    }

    /**
     * Writes a tracing message to indicate that a given section of code has ended. This call must be
     * preceeded by a corresponding call to beginSection(char*) on the same thread. Calling this method
     * will mark the end of the most recently begun section of code, so care must be taken to ensure
     * that beginSection / endSection pairs are properly nested and called from the same thread.
     */
    public static func endTrace(_ sectionName: String) {
        if ScopedNativeTraceSection.sdkVersion >= 23 {
            ATrace_endSection()
            // AndroidLogcat.i(ScopedNativeTraceSection.TAG, "endTrace(\"\(sectionName)\")")
        }
    }
}
