//
//  Console.swift
//  
//
//  Created by pcbeard on 4/2/24.
//

public import CPlaydate

public extension StaticStringInterpolation {
    mutating func appendInterpolation(_ error: Playdate.Error) {
        if let text = error.humanReadableText {
            appendInterpolation(text)
        }
    }
}

public enum Console {
	public static func log(_ buffer: StaticStringBuffer) {
        logToConsole(Playdate.playdateAPI.system, buffer.bytes)
	}
    
    public static func error(_ buffer: StaticStringBuffer) {
        errorToConsole(Playdate.playdateAPI.system, buffer.bytes)
    }
}
