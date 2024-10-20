//
//  ReusableProtocol.swift
//  VideoTrackView
//
//  Created by Jinyoung Yoo on 10/20/24.
//

import Foundation

protocol IdentifierProtocol {
    static var identifier: String { get }
}

extension NSObject: IdentifierProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

