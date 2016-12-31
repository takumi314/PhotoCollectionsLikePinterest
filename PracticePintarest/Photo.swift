//
//  Photo.swift
//  PracticePinterest
//
//  Created by NishiokaKohei on 2016/11/19.
//  Copyright © 2016年 Kohey. All rights reserved.
//

import UIKit

class Photo {

    // MARK: - Internal properties

    internal var caption: String
    internal var comment: String
    internal var image: UIImage

    // MARK: - Initializer

    init(caption: String, comment: String, image: UIImage) {
        self.caption = caption
        self.comment = comment
        self.image = image
    }

    convenience init(dictionary: Dictionary<String, Any>) {
        let caption = dictionary["caption"] as? String
        let comment = dictionary["comment"] as? String
        let photo = dictionary["image"] as? String
        let image = UIImage(named: photo!)?.decompressedImage
        self.init(caption: caption!, comment: comment!, image: image!)
    }

    // MARK: - Internal Class Methods

    internal class func allPhotos() -> [Photo]? {
        var photos = [Photo]()
        guard let URL = Bundle.main
            .url(forResource: "photos", withExtension: "plist") else {
            return photos
        }
        guard let photoFromPlist = NSDictionary(contentsOf: URL)?
            .value(forKey: "photos") as? Array<Any> else {
            return photos
        }
        for item in photoFromPlist {
            guard let dictionary = item as? Dictionary<String, Any> else {
                continue
            }
            let photo = Photo(dictionary: dictionary)
            photos.append(photo)
        }
        return photos
    }

    // MARK: - Internal Instance Methods

    internal func heightForComment(_ font: UIFont, width: CGFloat) -> CGFloat {
        let rect = String(comment)
                .boundingRect(with: CGSize(width: width,
                                    height: CGFloat(MAXFLOAT)),
                                    options: .usesLineFragmentOrigin,
                                    attributes: [NSFontAttributeName: font],
                                    context: nil)
        return ceil(rect.height)
    }

}
