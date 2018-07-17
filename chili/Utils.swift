import Cocoa

func getTemperature () -> Int? {
    do {
        try SMCKit.open()
        let temp = try SMCKit.temperature(FourCharCode(fromStaticString: "TC0P"))
        SMCKit.close()
        return Int(temp)
    } catch {
        return Optional.none
    }
}
