//
//  PinterestLayout.swift
//  PracticePinterest
//
//  Created by NishiokaKohei on 2016/11/19.
//  Copyright © 2016年 Kohey. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: NSIndexPath,
                        withWidth: CGFloat) -> CGFloat
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: NSIndexPath,
                        withWidth width: CGFloat) -> CGFloat

}

class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {
    var photoHeight: CGFloat = 0.0
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as? PinterestLayoutAttributes
        copy!.photoHeight = photoHeight
        return copy!
    }
    override func isEqual(object: AnyObject?) -> Bool {
        guard let attributes = object as? PinterestLayoutAttributes else {
            return false
        }
        if attributes.photoHeight == photoHeight {
            return false
        }
        return super.isEqual(object)
    }

}

class PinterestLayout: UICollectionViewLayout {
    var delegate: PinterestLayoutDelegate!
    private var numberOfColumns = 2
    private var cellPadding: CGFloat = 6.0
    private var cache = [PinterestLayoutAttributes]()
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
//        return collectionView!.bounds) - ( insets.left + insets.right )
        return collectionView!.bounds.width - ( insets.left + insets.right )
    }
    override func prepareLayout() {
        if cache.isEmpty {
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            var column = 0
            var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
            for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                let width = columnWidth - cellPadding * 2
                let photoHeight = delegate.collectionView(collectionView!,
                                                          heightForPhotoAtIndexPath: indexPath,
                                                          withWidth:width)
                let annotationHeight
                    = delegate.collectionView(collectionView!,
                                              heightForAnnotationAtIndexPath: indexPath,
                                              withWidth: width)
                let height = cellPadding +  photoHeight + annotationHeight + cellPadding
                let frame = CGRect(x: xOffset[column],
                                   y: yOffset[column],
                                   width: columnWidth,
                                   height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                let attributes = PinterestLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.photoHeight = photoHeight
                attributes.frame = insetFrame
                cache.append(attributes)
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                column = column >= (numberOfColumns - 1) ? 0 : column + 1
            }
        }
    }
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    override func layoutAttributesForElementsInRect(rect: CGRect)
                -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    override class func layoutAttributesClass() -> AnyClass {
        return PinterestLayoutAttributes.self
    }

}
