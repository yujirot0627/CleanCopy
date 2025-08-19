import AppKit

final class CleanCopy: ObservableObject{
    private var lastChangeCount = NSPasteboard.general.changeCount
    var shouldSkipBundleIDs: Set<String> = []
    private var timer: DispatchSourceTimer?
    @Published var isEnabled: Bool = true{
        didSet {isEnabled ? startTimer() : stopTimer() }
    }
    var allowlist: Set<String> = []
    
    func start(){ isEnabled = true}
    func stop(){isEnabled = false}
    
    private func startTimer(){
        guard timer == nil else { return }
            
        lastChangeCount = NSPasteboard.general.changeCount
        
        let t = DispatchSource.makeTimerSource(queue: .global(qos: .utility))
        t.schedule(deadline: .now(), repeating: .milliseconds(500))
        t.setEventHandler{[weak self] in self?.tick()}
        t.resume()
        timer = t
    }
    
    private func stopTimer(){
        timer?.cancel()
        timer = nil
    }
    
    private func tick(){
        guard isEnabled else {return}
        
        if let bid = NSWorkspace.shared.frontmostApplication?.bundleIdentifier, shouldSkipBundleIDs.contains(bid) {return}
        
        let pb = NSPasteboard.general
        guard pb.changeCount != lastChangeCount else {return}
        lastChangeCount = pb.changeCount
        
        let types = pb.types ?? []
        if types.contains(.fileURL) || types.contains(.png) || types.contains(.tiff) {return}
        if types.count == 1 && types.contains(.string) {return}
        
        if let attr = pb.readObjects(forClasses: [NSAttributedString.self])?.first as? NSAttributedString {
                    writePlain(attr.string, to: pb); return
        }
        if let html = pb.data(forType: .html),
            let attr = NSAttributedString(html: html, options: [:], documentAttributes: nil) {
                    writePlain(attr.string, to: pb); return
        }
        if let rtf = pb.data(forType: .rtf),
                   let attr = NSAttributedString(rtf: rtf, documentAttributes: nil) {
                    writePlain(attr.string, to: pb); return
                }
        if let s = pb.string(forType: .string) { writePlain(s, to: pb) }
    }
    
    private func writePlain(_ s: String, to pb: NSPasteboard) {
            let normalized = s.replacingOccurrences(of: "\r\n", with: "\n").replacingOccurrences(of: "\r", with: "\n")
            pb.clearContents()
            pb.setString(normalized, forType: .string)
            lastChangeCount = pb.changeCount
        }
}
