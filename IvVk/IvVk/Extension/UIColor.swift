//  UIColor.swift
//  IvVk
//  Created by Iv on 07.11.2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

extension UIColor {
    static let myLightGreen = UIColor(red: 170.0 / 255.0, green: 235.0 / 255.0, blue: 159.0 / 255.0, alpha: 1.0)
    static let myLightBlue = rgba(76.0, 117.0, 163.0, 1.0)
    static let myDarkBlue = rgba(59.0, 92.0, 129.0, 1.0)

    private static var colorsCache: [String: UIColor] = [:]
    
    public static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        let key = "\(r)\(g)\(b)\(a)"
        if let cachedColor = self.colorsCache[key] {
            return cachedColor
        }
        self.clearColorsCacheIfNeeded()
        let color = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
        self.colorsCache[key] = color
        return color
    }
    
    private static func clearColorsCacheIfNeeded() {
        let maxObjectsCount = 100
        guard self.colorsCache.count >= maxObjectsCount else { return }
        colorsCache = [:]
    }
}
