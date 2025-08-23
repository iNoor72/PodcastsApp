//
//  ViewFactory.swift
//  Common
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Foundation
import SwiftUI

public protocol ViewFactory {
    var id: UUID { get }
    @MainActor func makeView() -> AnyView
}
