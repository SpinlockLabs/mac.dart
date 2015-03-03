import Foundation
import Cocoa
import AppKit

func activate(app: String) -> Bool {
    let workspace = NSWorkspace.sharedWorkspace()
    let running:[NSRunningApplication] = workspace.runningApplications as [NSRunningApplication]
    
    for p in running {
        if p.localizedName == app {
            p.activateWithOptions(NSApplicationActivationOptions.ActivateIgnoringOtherApps)
            return true
        }
    }
    return false
}

func quit(app: String) -> Bool {
    let workspace = NSWorkspace.sharedWorkspace()
    let running:[NSRunningApplication] = workspace.runningApplications as [NSRunningApplication]
    
    for p in running {
        if p.localizedName == app {
            p.terminate()
            return true
        }
    }
    return false
}
