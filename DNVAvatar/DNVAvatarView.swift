//
//  DNVAvatarView.swift
//  DNVAvatar
//
//  Created by Alexey Demin on 18/11/14.
//  Copyright (c) 2014 Alexey Demin. All rights reserved.
//

import UIKit

struct DNVAvatar {
    var image: UIImage?
    var initials: NSString
    var color = UIColor.white
    var backgroundColor: UIColor
    
    init(initials: NSString, backgroundColor: UIColor) {
        self.initials = initials
        self.backgroundColor = backgroundColor
    }
}

class DNVAvatarView: UIView {

    var avatar: DNVAvatar?
    var avatars: (DNVAvatar, DNVAvatar)?
    
    class func imageWithInitials(_ initials: NSString, color: UIColor, backgroundColor: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width, height: size.height), true, 0)
        
        let context = UIGraphicsGetCurrentContext()
        backgroundColor.setFill()
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let font = UIFont(name: "Helvetica Bold", size: size.height / CGFloat(initials.length + 1))!
        let style = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        style.alignment = NSTextAlignment.center
        let attributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: style]
        let height = initials.size(attributes: attributes).height
        initials.draw(in: CGRect(x: 0, y: (size.height - height) / 2.0, width: size.width, height: height), withAttributes: attributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    /*
    class func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        let scale = max(width / image.size.width, height / image.size.height)
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), true, 0)
        image.drawInRect(CGRectMake(-(image.size.width * scale - width) / 2, -(image.size.height * scale - height) / 2, image.size.width * scale, image.size.height * scale))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    */
    class func resizeImage(_ image: UIImage, size: CGSize, offset: CGPoint) -> UIImage {
        let scale = max((size.width + abs(offset.x)) / image.size.width, (size.height + abs(offset.y)) / image.size.height)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width, height: size.height), true, 0)
        image.draw(in: CGRect(x: -(image.size.width * scale - size.width) / 2.0 + offset.x / 2.0, y: -(image.size.height * scale - size.height) / 2.0 + offset.y / 2.0, width: image.size.width * scale, height: image.size.height * scale))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    class func roundAvatarWithImages(_ images: (UIImage, (UIImage, UIImage)?), diameter: CGFloat) -> UIImage {
        var avatar : UIImage
        
        if let multipleImages = images.1 {
            let spacing = diameter / 60.0
            let image1 = resizeImage(images.0, size: CGSize(width: diameter / 2 - spacing / 2, height: diameter), offset: CGPoint(x: diameter / 30, y: 0))
            let image2 = resizeImage(multipleImages.0, size: CGSize(width: diameter / 2 - spacing / 2, height: diameter / 2 - spacing / 2), offset: CGPoint(x: -diameter / 20, y: diameter / 20))
            let image3 = resizeImage(multipleImages.1, size: CGSize(width: diameter / 2 - spacing / 2, height: diameter / 2 - spacing / 2), offset: CGPoint(x: -diameter / 20, y: -diameter / 20))
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
            image1.draw(at: CGPoint(x: 0, y: 0))
            image2.draw(at: CGPoint(x: diameter / 2 + spacing / 2, y: 0))
            image3.draw(at: CGPoint(x: diameter / 2 + spacing / 2, y: diameter / 2 + spacing / 2))
            avatar = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        else {
            avatar = resizeImage(images.0, size: CGSize(width: diameter, height: diameter), offset: CGPoint.zero)
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        path.addClip()
        avatar.draw(at: CGPoint.zero)
        avatar = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return avatar
    }
    /*
    class func roundAvatarWithImage(image: UIImage) -> UIImage {
        let side = min(image.size.width, image.size.height)
        UIGraphicsBeginImageContext(CGSizeMake(side, side))
        let path = UIBezierPath(ovalInRect: CGRectMake(0, 0, side, side))
        path.addClip()
        image.drawAtPoint(CGPointMake(-(image.size.width - side) / 2, -(image.size.height - side) / 2))
        let avatar = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return avatar
    }
    */
    override func draw(_ rect: CGRect) {
        var image: UIImage
        var images: (UIImage, UIImage)?
        
        if let avatar = self.avatar {
            image = avatar.image ?? DNVAvatarView.imageWithInitials(avatar.initials, color: avatar.color, backgroundColor: avatar.backgroundColor, size: rect.size)
        }
        else {
            return
        }
        
        if let avatars = self.avatars {
            images = (avatars.0.image ?? DNVAvatarView.imageWithInitials(avatars.0.initials, color: avatars.0.color, backgroundColor: avatars.0.backgroundColor, size: rect.size),
                      avatars.1.image ?? DNVAvatarView.imageWithInitials(avatars.1.initials, color: avatars.1.color, backgroundColor: avatars.1.backgroundColor, size: rect.size))
        }
        
        let avatar = DNVAvatarView.roundAvatarWithImages((image, images), diameter: max(rect.size.width, rect.size.height))
        avatar.draw(in: rect)
    }
}
