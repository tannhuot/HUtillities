// Extenstions.swift 
// HUtillities 
//
// Created by Khouv Tannhuot on 10/11/22. 
// Copyright (c) 2022 Khouv Tannhuot. All rights reserved. 
//

import UIKit

//MARK: - UIView
extension UIView {
    // Anchor
    public func anchor(top: NSLayoutYAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    // Center
    public func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    // CenterX
    public func centerX(inView view: UIView,
                        topAnchor: NSLayoutYAxisAnchor? = nil,
                        paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    // CenterY
    public func centerY(inView view: UIView,
                        leftAnchor: NSLayoutXAxisAnchor? = nil,
                        paddingLeft: CGFloat = 0,
                        constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    // Set Dimensions
    public func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    // Set Dimensions
    public func setDimensions(height: NSLayoutDimension,
                              heightMultiplier: CGFloat,
                              width: NSLayoutDimension,
                              widthMultiplier: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: height, multiplier: heightMultiplier).isActive = true
        widthAnchor.constraint(equalTo: width, multiplier: widthMultiplier).isActive = true
    }
    
    // Set Height
    public func setHeight(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    // Set Width
    public func setWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    // Set Max Width
    public func setMaxWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(lessThanOrEqualToConstant: width).isActive = true
    }
    
    // Fill View
    public func fillIn(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: view.topAnchor,
               bottom: view.bottomAnchor,
               left: view.leftAnchor,
               right: view.rightAnchor)
    }
    
    // Fill SuperView
    public func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { return }
        anchor(top: view.topAnchor,
               bottom: view.bottomAnchor,
               left: view.leftAnchor,
               right: view.rightAnchor)
    }
}

// MARK: - UIApplication
extension UIApplication {
    public static var getSafeAreaInsets: UIEdgeInsets  {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first?.safeAreaInsets ?? .zero
    }
}

// MARK: - Encodable
extension Encodable {
    public func asDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            let json = try JSONSerialization.jsonObject(with: data,
                                                        options: .allowFragments) as? [String: Any]
            return json
        } catch {
            return nil
        }
    }
}

// MARK: - Decodable
extension Decodable {
    public init?(with dictionary: [String: Any]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            self = try JSONDecoder().decode(Self.self, from: data)
        } catch {
            return nil
        }
    }
}
