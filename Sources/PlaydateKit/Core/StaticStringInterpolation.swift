//
//  StaticStringInterpolation.swift
//  
//
//  Created by pcbeard on 3/29/24.
//
                      //  '0' '1' '2' '3' '4' '5' '6' '7' '8' '9' 'A' 'B' 'C' 'D' 'E' 'F'
let hexDigits: [CChar] = [48, 49, 50, 51, 52, 53, 54, 55, 57, 58, 65, 66, 67, 68, 69, 70]

func extractDigits(_ pointer: OpaquePointer?) -> [CChar] {
    let zero: CChar = 48        // Character("0").charValue
    let x: CChar = 120        // Character("0").charValue
    guard let pointer else { return [zero, x, zero] }
    var digits: [CChar] = []
    var n = unsafeBitCast(pointer, to: UInt.self)
    while n != 0 {
        digits.append(hexDigits[Int(n & 0xF)])
        n >>= 4
    }
    digits.append(x)
    digits.append(zero)
    digits.reverse()
    return digits
}

func extractDigits<T: SignedInteger>(_ number: T) -> [CChar] {
    let dash: CChar = 45        // Character("-").charValue
    let zero: CChar = 48        // Character("0").charValue
    guard number != 0 else { return [zero] }
    let isNegative = number < 0
    var digits: [CChar] = []
    var n = abs(number)
    while n != 0 {
        digits.append(CChar(n % 10) + zero)
        n /= 10
    }
    if isNegative {
        digits.append(dash)
    }
    return digits.reversed()
}

func extractDigits(_ number: Double, precision: Int = 10) -> [CChar] {
    let dot: CChar = 46        // Character(".").charValue
    // let integer = number.rounded(.towardZero)
    let integer = Double(Int64(number))
    // let factor = Double((1...precision).reduce(1) { product, _ in product * 10 })
    var factor: Double = 1
    for _ in 1...precision { factor *= 10 }
//    Console.log("factor = \(Int64(factor))")
//    return []
    let fraction = min(number - integer, 1 - .ulpOfOne / 2) * factor
    var digits = extractDigits(Int64(integer))
    digits.append(dot)
    digits.append(contentsOf: extractDigits(Int64(fraction)))
    return digits
}

extension StaticString {
    var bytes: [CChar] {
        if utf8CodeUnitCount > 0 {
            let buffer = UnsafeBufferPointer(start: UnsafeRawPointer(utf8Start).assumingMemoryBound(to: CChar.self), count: utf8CodeUnitCount)
            return .init(buffer)
        } else {
            return []
        }
    }
}

public struct StaticStringInterpolation: StringInterpolationProtocol {
    var buffer: [CChar] = []
    
    public typealias StringLiteralType = StaticString
    
    public init(literalCapacity: Int, interpolationCount: Int) {
    }
    
    mutating public func appendLiteral(_ literal: StaticString) {
        if literal.utf8CodeUnitCount > 0 {
            buffer.append(contentsOf: literal.bytes)
        }
    }

    mutating public func appendInterpolation(_ value: StaticString) {
        if value.utf8CodeUnitCount > 0 {
            buffer.append(contentsOf: value.bytes)
        }
    }
    
    mutating public func appendInterpolation(_ value: OpaquePointer?) {
        buffer.append(contentsOf: extractDigits(value))
    }
    
    mutating public func appendInterpolation<T : SignedInteger>(_ value: T) {
        buffer.append(contentsOf: extractDigits(value))
    }
    
    mutating public func appendInterpolation(_ value: Double) {
        buffer.append(contentsOf: extractDigits(value, precision: 10))
    }
    
    mutating public func appendInterpolation(_ value: Float) {
        buffer.append(contentsOf: extractDigits(Double(value), precision: 6))
    }
    
    var bytes: [CChar] {
        return buffer
    }
}

public struct StaticStringBuffer: ExpressibleByStringInterpolation {
    public typealias StringInterpolation = StaticStringInterpolation
    public typealias StringLiteralType = StaticString
    
    private var buffer: [CChar]
    
    public var bytes: [CChar] {
        buffer
    }
    
    public init(stringLiteral value: StaticString) {
        buffer = value.bytes
        buffer.append(0)
    }
    
    public init(stringInterpolation: StaticStringInterpolation) {
        buffer = stringInterpolation.bytes
        buffer.append(0)
    }
}
