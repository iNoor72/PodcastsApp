//
//  AnyRoutable.swift
//  Common
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Foundation
import SwiftUI

public struct AnyRoutable: Routable {
    public let id: UUID = UUID()
    private let base: any Routable
    private let equals: (any Routable) -> Bool

    public init<T: Routable>(_ routable: T) {
        base = routable
        equals = { other in
            guard let otherBase = other as? T else { return false }
            return routable == otherBase
        }
    }

    public func makeView() -> AnyView {
        self.base.makeView()
    }

    public func hash(into hasher: inout Hasher) {
        self.base.hash(into: &hasher)
    }

    public static func == (lhs: AnyRoutable, rhs: AnyRoutable) -> Bool {
        lhs.equals(rhs.base)
    }
}
