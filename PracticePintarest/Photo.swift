//
//  Photo.swift
//  PracticePinterest
//
//  Created by NishiokaKohei on 2016/11/19.
//  Copyright © 2016年 Kohey. All rights reserved.
//

import UIKit

class Photo {

    // MARK: Class Method
    class func allPhotos() -> [Photo]? {
        var photos = [Photo]()
        guard let URL = Bundle.main
            .url(forResource: "photos", withExtension: "plist") else {
            return photos
        }
        guard let photoFromPlist = NSDictionary(contentsOf: URL)?
            .value(forKey: "photos") as? NSArray else {
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

    // MARK: Instance property
    var caption: String
    var comment: String
    var image: UIImage

    //
    init(caption: String, comment: String, image: UIImage) {
        self.caption = caption
        self.comment = comment
        self.image = image
    }

    // MARK: Instance Method
    convenience init(dictionary: Dictionary<String, Any>) {
        let caption = dictionary["caption"] as? String
        let comment = dictionary["comment"] as? String
        let photo = dictionary["image"] as? String
        let image = UIImage(named: photo!)?.decompressedImage
        self.init(caption: caption!, comment: comment!, image: image!)
    }

    func heightForComment(_ font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: comment)
            .boundingRect(with: CGSize(width: width,
                                    height: CGFloat(MAXFLOAT)),
                                    options: .usesLineFragmentOrigin,
                                    attributes: [NSFontAttributeName: font],
                                    context: nil)
        return ceil(rect.height)
    }

}
