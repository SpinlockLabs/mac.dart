import Foundation
import Cocoa
import AppKit

var args = [String](Process.arguments)

args.removeAtIndex(0)

func getApplications() -> [String] {
    let fileManager = NSFileManager.defaultManager()
    let enumerator:NSDirectoryEnumerator  = fileManager.enumeratorAtPath("/Applications/")!
    
    var apps = [String]()
    while let element: NSString = enumerator.nextObject() as? NSString {
        var s = split(element as String) { $0 == "/" }
        var name = (s.last!) as String
        
        if s.count > 2 {
            enumerator.skipDescendents()
        }
        
        if !name.hasSuffix(".app") {
            continue
        }
 
        var range:Range = name.rangeOfString(".app")!
        
        apps.append(name.substringToIndex(range.generate().startIndex))
    }
    return removeDuplicates(apps)
}

func getRunningApplications() -> [AnyObject] {
    let workspace = NSWorkspace.sharedWorkspace()
    let running:[NSRunningApplication] = workspace.runningApplications as [NSRunningApplication]
    var info = [Dictionary<String, AnyObject>]()
    
    for app in running {
        var i:[String:AnyObject] = [:]
        
        i["name"] = app.localizedName!
        i["hidden"] = app.hidden
        i["ownsMenuBar"] = app.ownsMenuBar
        i["active"] = app.active
        
        info.append(i)
    }
    
    return info
}

func getSystemInfo() -> [String:AnyObject] {
    var pinfo = NSProcessInfo.processInfo()
    var vinfo = pinfo.operatingSystemVersion
    var memory = Int(pinfo.physicalMemory)
    var processorCount = pinfo.processorCount
    var activeProcessorCount = pinfo.activeProcessorCount
    var version = "\(vinfo.majorVersion).\(vinfo.minorVersion).\(vinfo.patchVersion)"
    
    return [
        "os": [
            "version": [
                "full": version,
                "major": vinfo.majorVersion,
                "minor": vinfo.minorVersion,
                "patch": vinfo.patchVersion
            ]
        ],
        "cpu": [
            "processors": processorCount,
            "active processors": activeProcessorCount
        ],
        "memory": [
            "physical": memory
        ]
    ]
}

let opts:[String:String] = [
    "-sysinfo": "Gets System Information",
    "-apps": "Get Installed Apps",
    "-running": "Get Running Apps"
]

if args.count == 0 {
    println("Usage: osx-helper <option>")
    for option in opts.keys {
        println(" \(option): \(opts[option]!)")
    }
    exit(1)
}

var output = [String:AnyObject]()

for arg in [String](args) {
    if arg == "-all" {
        args = opts.keys.array
        break
    }
}

for arg in args {
    switch arg {
    case "-sysinfo":
        output["sysinfo"] = getSystemInfo()
    case "-apps":
        output["apps"] = getApplications()
    case "-running":
        output["running"] = getRunningApplications()
    default:
        println("Invalid Option: \(arg)")
        exit(1)
    }
}

var json = JSON(output)
println(json.toString(pretty: true))