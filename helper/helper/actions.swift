import Foundation
import AppKit

func activate(app: String) {
    let workspace = NSWorkspace.sharedWorkspace()
    let running:[NSRunningApplication] = workspace.runningApplications as [NSRunningApplication]
    
    for p in running {
        if p.localizedName == app {
            p.activateWithOptions(NSApplicationActivationOptions.ActivateIgnoringOtherApps)
            break
        }
    }
}

func quit(app: String) {
    let workspace = NSWorkspace.sharedWorkspace()
    let running:[NSRunningApplication] = workspace.runningApplications as [NSRunningApplication]
    
    for p in running {
        if p.localizedName == app {
            p.terminate()
            break
        }
    }
}
