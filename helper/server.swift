import Foundation

let standardInput = NSFileHandle.fileHandleWithStandardInput()
let standardOutput = NSFileHandle.fileHandleWithStandardOutput()

func startServer() {
    loop: while true {
        let data:NSData = standardInput.availableData
        let string:NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
        let json:JSON = JSON(string: string)
        let type:String = json["type"].asString!
        
        switch type {
        case "sysinfo":
            writeJSON(getSystemInfo())
        case "apps":
            writeJSON(getApplications())
        case "running":
            writeJSON(getRunningApplications())
        case "stop":
            break loop
        default:
            writeJSON([
                "error": "type.invalid"
            ])
        }
    }
}

func writeJSON(input: AnyObject) {
    standardOutput.writeData(JSON(input).toString().dataUsingEncoding(NSUTF8StringEncoding)!)
    standardOutput.writeData("\n".dataUsingEncoding(NSUTF8StringEncoding)!)
}