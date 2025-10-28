import AppKit

final class WriteToConsoleCommand: NSScriptCommand {
    
    override func performDefaultImplementation() -> Any? {
        
        guard let message = self.directParameter as? String else {
            self.scriptErrorNumber = OSAMissingParameter
            self.scriptErrorOffendingObjectDescriptor = NSAppleEventDescriptor(string: "message")
            return false
        }
        
        let arguments = self.evaluatedArguments ?? [:]
        let title = (arguments["title"] as? Bool) ?? true
        let timestamp = (arguments["timestamp"] as? Bool) ?? true
        
        let options = Console.DisplayOptions()
            .union(title ? .title : [])
            .union(timestamp ? .timestamp : [])
        
        // showWindow(nil) を削除 → バックグラウンドで処理
        Task { @MainActor in
            let log = Console.Log(message: message, title: ScriptManager.shared.currentScriptName)
            ConsolePanelController.shared.append(log: log, options: options)
            // ConsolePanelController.shared.showWindow(nil) ← 削除！
        }
        
        return true
    }
}
