//
//  FileManager+ExtendedAttributes.swift
//  DNVAvatar
//
//  Created by Alexey Demin on 2017-07-20.
//  Copyright © 2017 Alexey Demin. All rights reserved.
//

import Foundation

extension FileManager {
    
    open func extendedAttribute(_ name: String, ofItemAt url: URL) throws -> Data {
        
        let path = url.relativePath
        var size = getxattr(path, name, nil, 0, 0, 0)
        if size == -1 { throw FileManager.posixError() }
        
        var value = Data(count: size)
        var localValue = value
        size = localValue.withUnsafeMutableBytes{ getxattr(path, name, $0, value.count, 0, 0) }
        if size == -1 { throw FileManager.posixError() }
        
        return value
    }
    
    open func setExtendedAttribute(_ name: String, value: Data?, ofItemAt url: URL) throws {
        
        let path = url.relativePath
        if let value = value {
            let size = value.withUnsafeBytes{ setxattr(path, name, $0, value.count, 0, 0) }
            if size == -1 { throw FileManager.posixError() }
        }
        else {
            let size = removexattr(path, name, 0)
            if size == -1 { throw FileManager.posixError() }
        }
    }
    
    
    private static func posixError() -> Error {
        return NSError(domain: NSPOSIXErrorDomain, code: Int(errno), userInfo: [NSLocalizedDescriptionKey: String(cString: strerror(errno))])
    }
    
    
    private static let tagAttributeName = "Tag"
    
    open func tagOfItemAt(_ url: URL) -> String? {
        
        guard let data = try? extendedAttribute(FileManager.tagAttributeName, ofItemAt: url) else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
    
    open func setTag(_ tag: String?, ofItemAt url: URL) {
        
        try? setExtendedAttribute(FileManager.tagAttributeName, value: tag?.data(using: .utf8), ofItemAt: url)
    }
    
    
    private static let timeAttributeName = "Time"
    
    open func timeOfItemAt(_ url: URL) -> TimeInterval? {
        
        guard let data = try? extendedAttribute(FileManager.timeAttributeName, ofItemAt: url) else { return nil }
        
        return data.withUnsafeBytes{ $0.pointee }
    }
    
    open func setTime(_ time: TimeInterval?, ofItemAt url: URL) {
        var data: Data?
        if var time = time {
            data = Data(bytes: &time, count: MemoryLayout<TimeInterval>.size)
        }
        try? setExtendedAttribute(FileManager.timeAttributeName, value: data, ofItemAt: url)
    }
}
