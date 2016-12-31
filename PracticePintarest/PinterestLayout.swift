//
//  PinterestLayout.swift
//  PracticePinterest
//
//  Created by NishiokaKohei on 2016/11/19.
//  Copyright © 2016年 Kohey. All rights reserved.
//

import UIKit

// MARK: - Protocol

protocol PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat
    func collectionView(_ collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth width: CGFloat) -> CGFloat

}

// MARK: - UICollectionViewLayoutAttributes

class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {

    var photoHeight: CGFloat = 0.0

    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as? PinterestLayoutAttributes
        copy!.photoHeight = photoHeight
        return copy!
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let attributes = object as? PinterestLayoutAttributes else {
            return false
        }
        if attributes.photoHeight == photoHeight {
            return false
        }
        return super.isEqual(object)
    }

}

// MARK: - UICollectionViewLayout

class PinterestLayout: UICollectionViewLayout {

    public var delegate: PinterestLayoutDelegate?

    fileprivate var numberOfColumns = 2
    fileprivate var cellPadding: CGFloat = 6.0
    fileprivate var cache = [PinterestLayoutAttributes]()
    fileprivate var contentHeight: CGFloat = 0.0
    fileprivate var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
//        return collectionView!.bounds) - ( insets.left + insets.right )
        return collectionView!.bounds.width - ( insets.left + insets.right )
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override class var layoutAttributesClass: AnyClass {
        return PinterestLayoutAttributes.self
    }

    override func prepare() {
        guard cache.isEmpty else {
            return
        }

        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth )
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let width = columnWidth - cellPadding * 2
            let photoHeight
                = delegate?.collectionView(collectionView!,
                                                      heightForPhotoAtIndexPath: indexPath,
                                                      withWidth:width)
            let annotationHeight
                = delegate?.collectionView(collectionView!,
                                          heightForAnnotationAtIndexPath: indexPath,
                                          withWidth: width)
            let height = cellPadding +  photoHeight! + annotationHeight! + cellPadding
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = PinterestLayoutAttributes(forCellWith: indexPath)
            attributes.photoHeight = photoHeight!
            attributes.frame = insetFrame
            cache.append(attributes)
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            column = column >= (numberOfColumns - 1) ? 0 : column + 1
        }
    }

    override func layoutAttributesForElements(in rect: CGRect)
                -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }

}
