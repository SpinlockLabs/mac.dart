import Foundation
import Cocoa
import AppKit

var args = [String](Process.arguments)

args.removeAtIndex(0)

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
    println(" -server: Start Server")
    println(" -command: Run Single Server Command")
    exit(1)
}

if args.count == 1 && args.first! == "-server" {
    startServer()
    exit(0)
}

if args.count == 2 && args.first! == "-command" {
    executeServerCommand(JSON(string: args.last!))
    exit(0)
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