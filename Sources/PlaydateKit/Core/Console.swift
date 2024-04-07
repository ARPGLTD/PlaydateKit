//
//  Console.swift
//  
//
//  Created by pcbeard on 4/2/24.
//

#if swift(>=6.0)
import CPlaydate
#else
public import CPlaydate
#endif

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
