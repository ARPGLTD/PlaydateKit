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

public enum Console {
	public static func log(_ buffer: StaticStringBuffer) {
        logToConsole(Playdate.playdateAPI.system, buffer.bytes)
	}
}
