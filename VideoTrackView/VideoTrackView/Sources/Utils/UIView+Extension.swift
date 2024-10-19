//
//  UIView+Extension.swift
//  VideoTrackView
//
//  Created by Jinyoung Yoo on 10/14/24.
//

import UIKit

extension UIView {
    
    @discardableResult
    func topAnchor(_ top: NSLayoutYAxisAnchor, padding value : CGFloat = .zero) -> Self {
        if (self.translatesAutoresizingMaskIntoConstraints) { self.translatesAutoresizingMaskIntoConstraints.toggle() }

        self.topAnchor.constraint(equalTo: top, constant: value).isActive = true
        return self
    }
    
    @discardableResult
    func bottomAnchor(_ bottom: NSLayoutYAxisAnchor, padding value : CGFloat = .zero) -> Self {
        if (self.translatesAutoresizingMaskIntoConstraints) { self.translatesAutoresizingMaskIntoConstraints.toggle() }

        self.bottomAnchor.constraint(equalTo: bottom, constant: value).isActive = true
        return self
    }

    @discardableResult
    func leadingAnchor(_ leading: NSLayoutXAxisAnchor, padding value : CGFloat = .zero) -> Self {
        if (self.translatesAutoresizingMaskIntoConstraints) { self.translatesAutoresizingMaskIntoConstraints.toggle() }

        self.leadingAnchor.constraint(equalTo: leading, constant: value).isActive = true
        return self
    }
    
    @discardableResult
    func trailingAnchor(_ trailing: NSLayoutXAxisAnchor, padding value : CGFloat = .zero) -> Self {
        if (self.translatesAutoresizingMaskIntoConstraints) { self.translatesAutoresizingMaskIntoConstraints.toggle() }

        self.trailingAnchor.constraint(equalTo: trailing, constant: value).isActive = true
        return self
    }
    
    @discardableResult
    func centerXAnchor(_ centerX: NSLayoutXAxisAnchor, constant: CGFloat = .zero) -> Self {
        if (self.translatesAutoresizingMaskIntoConstraints) { self.translatesAutoresizingMaskIntoConstraints.toggle() }

        self.centerXAnchor.constraint(equalTo: centerX, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func centerYAnchor(_ centerY: NSLayoutYAxisAnchor, constant: CGFloat = .zero) -> Self {
        if (self.translatesAutoresizingMaskIntoConstraints) { self.translatesAutoresizingMaskIntoConstraints.toggle() }

        self.centerYAnchor.constraint(equalTo: centerY, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func widthAnchor(_ width: NSLayoutAnchor<NSLayoutDimension>, constant: CGFloat = .zero) -> Self {
        if (self.translatesAutoresizingMaskIntoConstraints) { self.translatesAutoresizingMaskIntoConstraints.toggle() }
        
        self.widthAnchor.constraint(equalTo: width, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func widthAnchor(_ width: NSLayoutDimension, multiplier value: CGFloat) -> Self {
        if (self.translatesAutoresizingMaskIntoConstraints) { self.translatesAutoresizingMaskIntoConstraints.toggle() }
        
        self.widthAnchor.constraint(equalTo: width, multiplier: value).isActive = true
        return self
    }
    
    @discardableResult
    func widthAnchor(equalToConstant constant: CGFloat) -> Self {
        if (self.translatesAutoresizingMaskIntoConstraints) { self.translatesAutoresizingMaskIntoConstraints.toggle() }
        
        self.widthAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }

    @discardableResult
    func heightAnchor(_ height: NSLayoutAnchor<NSLayoutDimension>, constant: CGFloat = .zero) -> Self {
        if (self.translatesAutoresizingMaskIntoConstraints) { self.translatesAutoresizingMaskIntoConstraints.toggle() }
        
        self.heightAnchor.constraint(equalTo: height, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func heightAnchor(_ height: NSLayoutDimension, multiplier value: CGFloat) -> Self {
        if (self.translatesAutoresizingMaskIntoConstraints) { self.translatesAutoresizingMaskIntoConstraints.toggle() }
        
        self.heightAnchor.constraint(equalTo: height, multiplier: value).isActive = true
        return self
    }
    
    @discardableResult
    func heightAnchor(equalToConstant constant: CGFloat) -> Self {
        if (self.translatesAutoresizingMaskIntoConstraints) { self.translatesAutoresizingMaskIntoConstraints.toggle() }
        
        self.heightAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }
}

extension UIView {
    @discardableResult
    func size(_ value: CGSize) -> Self {
        if (self.translatesAutoresizingMaskIntoConstraints) { self.translatesAutoresizingMaskIntoConstraints.toggle() }
        
        if value.width != 0 {
            self.widthAnchor.constraint(equalToConstant: value.width).isActive = true
        }
        
        if value.height != 0 {
            self.heightAnchor.constraint(equalToConstant: value.height).isActive = true
        }
        
        return self
    }
}

