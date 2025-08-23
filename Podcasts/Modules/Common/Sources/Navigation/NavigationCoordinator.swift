//
//  NavigationCoordinator.swift
//  Common
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

public protocol NavigationCoordinator {
    func push(_ path: any Routable)
    func popLast()
    func popToRoot()
}
