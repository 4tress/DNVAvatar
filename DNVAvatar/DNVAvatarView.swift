//
//  DNVAvatarView.swift
//  DNVAvatar
//
//  Created by Alexey Demin on 18/11/14.
//  Copyright (c) 2014 Alexey Demin. All rights reserved.
//

import UIKit


public class DNVAvatar: NSObject {
    
    public var image: UIImage? {
        didSet {
            onImageLoad?()
        }
    }
    
    var onImageLoad: (() -> ())?
    
    public let initials: String
    public let color: UIColor
    public let backgroundColor: UIColor
    
    
    public init(initials: String, color: UIColor? = nil, backgroundColor: UIColor) {
        
        self.initials = initials
        
        var white: CGFloat = 0
        backgroundColor.getWhite(&white, alpha: nil)
        self.color = color ?? (white < 0.9 ? .white : .black)
        
        self.backgroundColor = backgroundColor
    }
    
    
    public convenience init(initials: String, colorSeed: Int, paletteSize: Int = 10) {
        
        let color = UIColor(hue: CGFloat(colorSeed % paletteSize) / CGFloat(paletteSize), saturation: 0.5, brightness: 0.8, alpha: 1)
        
        self.init(initials: initials, backgroundColor: color)
    }
    
    
    public convenience init(name: String) {
        
        var initials = name.components(separatedBy: " ").reduce("") { result, component in
            
            if let unicodeScalar = component.unicodeScalars.first, CharacterSet.alphanumerics.contains(unicodeScalar), result.characters.count < 2 {
                return result + String(unicodeScalar)
            }
            else {
                return result
            }
        }
        if initials.characters.count == 0 {
            let unicodeScalar: UnicodeScalar = name.unicodeScalars.first() { CharacterSet.alphanumerics.contains($0) } ?? "?"
            initials = String(unicodeScalar)
        }
        
        let colorSeed = name.characters.count
        
        self.init(initials: initials, colorSeed: colorSeed)
    }
    
    
    static let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 10_000_000, diskCapacity: 100_000_000, diskPath: nil)
        // TODO: Implement reloadRevalidatingCacheData
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }()
    
    
    /// - Parameter size: Anywhere from 1px up to 2048px.
    public func loadImageFromGravatar(email: String, size: Int = 240) {
        
        let hash = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().md5
        guard let url = URL(string: "https://www.gravatar.com/avatar/\(hash)?s=\(size)&r=x&d=404") else { return }
        
        DNVAvatar.urlSession.dataTask(with: url) { [weak self] data, urlResponse, error in
//            print(urlResponse)
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.image = image
            }
            
        }.resume()
    }
    
    
    public func loadImageFromGoogle(email: String) {
        
        guard let email = email.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return }
        
        guard let url = URL(string: "https://picasaweb.google.com/data/entry/api/user/\(email)?alt=json") else { return }
        
        DNVAvatar.urlSession.dataTask(with: url) { data, urlResponse, error in
//            print(urlResponse)
            guard let data = data, let json = (try? JSONSerialization.jsonObject(with: data)) as? NSDictionary else { return }
            
            guard let entry = json["entry"] as? NSDictionary, let gphoto = entry["gphoto$thumbnail"] as? NSDictionary, let thumbnail = gphoto["$t"] as? String else { return }
            
            guard let url = URL(string: thumbnail) else { return }
            
            DNVAvatar.urlSession.dataTask(with: url) { [weak self] data, urlResponse, error in
//                print(urlResponse)
                guard let data = data, let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    self?.image = image
                }
                
            }.resume()
            
        }.resume()
    }
    
    
    /// - Parameter size: HR48x48 | HR64x64 | HR96X96 | HR120X120 | HR240X240 | HR360X360 | HR432X432 | HR504X504 | HR648X648.
    public func loadImageFromExchange(email: String, size: String = "HR240X240", host: String, user: String? = nil, password: String? = nil) {
        
        var auth = ""
        if let user = user?.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed), let password = password?.addingPercentEncoding(withAllowedCharacters: .urlPasswordAllowed) {
            auth = user + ":" + password + "@"
        }
        
        guard let host = host.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let email = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: "https://\(auth + host)/ews/Exchange.asmx/s/GetUserPhoto?email=\(email)&size=\(size)") else { return }
        
        DNVAvatar.urlSession.dataTask(with: url) { [weak self] data, urlResponse, error in
//            print(urlResponse)
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.image = image
            }
            
        }.resume()
    }
}



public class DNVAvatarView: UIView {

    public var avatar1: DNVAvatar? {
        didSet {
            setNeedsDisplay()
            avatar1?.onImageLoad = { [weak self] in
                self?.setNeedsDisplay()
            }
        }
    }
    
    public var avatar2: DNVAvatar? {
        didSet {
            setNeedsDisplay()
            avatar2?.onImageLoad = { [weak self] in
                self?.setNeedsDisplay()
            }
        }
    }
    
    public var avatar3: DNVAvatar? {
        didSet {
            setNeedsDisplay()
            avatar3?.onImageLoad = { [weak self] in
                self?.setNeedsDisplay()
            }
        }
    }
    
    public var avatar4: DNVAvatar? {
        didSet {
            setNeedsDisplay()
            avatar4?.onImageLoad = { [weak self] in
                self?.setNeedsDisplay()
            }
        }
    }
    
    
    public var showsImagesBorder = true {
        didSet {
            if showsImagesBorder != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    
    class func image(avatar: DNVAvatar, size: CGSize, offset: CGPoint) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        var image: UIImage
        
        if let avatarImage = avatar.image {
            image = avatarImage
        }
        else {
            let context = UIGraphicsGetCurrentContext()!
            avatar.backgroundColor.setFill()
            context.fill(CGRect(origin: CGPoint.zero, size: size))
            
            let font = UIFont(name: "Helvetica Bold", size: size.height * 1.2 / CGFloat(avatar.initials.characters.count + 1))!
            let style = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            style.alignment = .center
            let attributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: avatar.color, NSParagraphStyleAttributeName: style]
            let height = avatar.initials.size(attributes: attributes).height
            avatar.initials.draw(in: CGRect(x: 0, y: (size.height - height) / 2, width: size.width, height: height), withAttributes: attributes)
            
            image = UIGraphicsGetImageFromCurrentImageContext()!
        }
        
        let scale = max((size.width + abs(offset.x)) / image.size.width, (size.height + abs(offset.y)) / image.size.height)
        image.draw(in: CGRect(x: -(image.size.width * scale - size.width) / 2 + offset.x / 2, y: -(image.size.height * scale - size.height) / 2 + offset.y / 2, width: image.size.width * scale, height: image.size.height * scale))
        
        image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    func roundedAvatarImage() -> UIImage {
        
        let avatarImage: UIImage
        var image1, image2, image3, image4: UIImage?
        
        let diameter = min(bounds.width, bounds.height)
        let spacing = diameter / 60
        let border = showsImagesBorder ? spacing : 0
        let longSide = diameter - border * 2
        let shortSide = longSide / 2 - spacing / 2
        let fullSize = CGSize(width: longSide, height: longSide)
        let halfSize = CGSize(width: shortSide, height: longSide)
        let quarterSize = CGSize(width: shortSide, height: shortSide)
        let offset1 = diameter / 30
        let offset2 = diameter / 20
        
        if let avatar1 = avatar1 {
            if let avatar2 = avatar2 {
                if let avatar3 = avatar3 {
                    image2 = DNVAvatarView.image(avatar: avatar2, size: quarterSize, offset: CGPoint(x: -offset2, y: offset2))
                    image3 = DNVAvatarView.image(avatar: avatar3, size: quarterSize, offset: CGPoint(x: -offset2, y: -offset2))
                    if let avatar4 = avatar4 {
                        image1 = DNVAvatarView.image(avatar: avatar1, size: quarterSize, offset: CGPoint(x: offset2, y: offset2))
                        image4 = DNVAvatarView.image(avatar: avatar4, size: quarterSize, offset: CGPoint(x: offset2, y: -offset2))
                    }
                }
                else {
                    image2 = DNVAvatarView.image(avatar: avatar2, size: halfSize, offset: CGPoint(x: -offset1, y: 0))
                }
                
                if image1 == nil {
                    image1 = DNVAvatarView.image(avatar: avatar1, size: halfSize, offset: CGPoint(x: offset1, y: 0))
                }
            }
            else {
                image1 = DNVAvatarView.image(avatar: avatar1, size: fullSize, offset: CGPoint.zero)
            }
        }
        
        let size = CGSize(width: diameter, height: diameter)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let path = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: size))
        path.addClip()
        
        let context = UIGraphicsGetCurrentContext()!
        if let avatar = avatar1, showsImagesBorder {
            avatar.backgroundColor.set()
            context.fill(rect)
        }
        
        image1?.draw(at: CGPoint(x: border, y: border))
        image2?.draw(at: CGPoint(x: border + shortSide + spacing, y: border))
        image3?.draw(at: CGPoint(x: border + shortSide + spacing, y: border + shortSide + spacing))
        image4?.draw(at: CGPoint(x: border, y: border + shortSide + spacing))
        
        if showsImagesBorder {
            context.setLineWidth(border * 2)
            context.strokeEllipse(in: rect)
        }
        
        avatarImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return avatarImage
    }
    
    
    override public func draw(_ rect: CGRect) {
        
        let avatarImage = roundedAvatarImage()
        
        avatarImage.draw(at: CGPoint.zero)
    }
}
