//
//  PaletteView.swift
//  MosaicSample
//
//  Created by SFurlani on 8/15/15.
//  Copyright © 2015 Strong Fortress. All rights reserved.
//

import UIKit

class PaletteView: UIView {

    typealias StrategyType = (rect: CGRect, colors: [UIColor], widths: [CGFloat]) -> ()
    
    override func awakeFromNib() {
        self.strategy = bayesianStrategy
    }
    
    var palette: Palette? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var strategy: StrategyType? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var reverse: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        guard let palette = self.palette else {
            print("PaletteView has no palette")
            return
        }
        
        guard let strategy = self.strategy else {
            print("PaletteView has no strategy")
            return
        }
        let colors = reverse ? palette.colors.reverse() : palette.colors
        let widths = reverse ? palette.colorWidths.reverse() : palette.colorWidths
        strategy(rect: self.bounds, colors: colors, widths: widths)
    }
    
    
    /// Fills the view by halving the rect for each color, alternating height/width
    func bayesianStrategy(rect: CGRect, colors: [UIColor], widths: [CGFloat]) -> () {
        
        let context = UIGraphicsGetCurrentContext()
        
        var current = rect
        var halveWidth = true
        var halver: CGFloat = 0.5
        for n in 0..<colors.count {
            let color = colors[n]
            let width = widths[n] - (1.0 / CGFloat(colors.count))
            halver *= (1.0 - width)
            
            // fill current
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextFillRect(context, current)
            
            // set Next
            if halveWidth {
                current = CGRect(
                    x: current.minX,
                    y: current.minY,
                    width: current.width * halver,
                    height: current.height)
            }
            else {
                current = CGRect(
                    x: current.minX,
                    y: current.minY,
                    width: current.width,
                    height: current.height * halver)
            }
            halveWidth = !halveWidth
        }
    }
    
    func verticalStrategy(rect: CGRect, colors: [UIColor], widths: [CGFloat]) -> () {
        let context = UIGraphicsGetCurrentContext()
        
        var current = rect
        var percent: CGFloat = 1.0
        for n in 0..<colors.count {
            let color = colors[n]
            let width = widths[n]
            // fill current
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextFillRect(context, current)
            
            // set Next
            percent -= width
            current = CGRect(
                x: rect.minX,
                y: rect.minY,
                width: rect.width,
                height: rect.height * percent)
            
        }
    }
    
    func circularStrategy(rect: CGRect, colors: [UIColor], widths: [CGFloat]) -> () {
        let context = UIGraphicsGetCurrentContext()
        
        var current = rect
        
        CGContextSetFillColorWithColor(context, colors.first!.CGColor)
        CGContextFillRect(context, current)

        let fullWidth = max(current.width, current.height)
        var percent: CGFloat = 1.0
        for n in 1..<colors.count {
            let color = colors[n]
            let width = widths[n-1]
            
            // set Next
            percent = max(percent - width, 0.1)
            let diameter = fullWidth * percent
            let radius = diameter / 2.0
            current = CGRect(
                x: rect.midX - radius,
                y: rect.midY - radius,
                width: diameter,
                height: diameter)
            
            // fill current
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextFillEllipseInRect(context, current)
        }
    }
    

}
