import UIKit

final class MTCollectionViewFlowLayout: UICollectionViewFlowLayout {
    init(
        frame: CGRect,
        columnCount: Int = 2,
        spacing: CGFloat,
        padding: CGFloat,
        itemAspectRatio: CGFloat = 1.5,
        itemHeightOffset: CGFloat = 0
    ) {
        super.init()

        minimumLineSpacing = spacing
        minimumInteritemSpacing = spacing
        sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)

        let totalHorizontalSpacing = sectionInset.left + sectionInset.right + spacing * CGFloat(columnCount - 1)
        let itemWidth = (frame.width - totalHorizontalSpacing) / CGFloat(columnCount)
        let itemHeight = itemWidth * itemAspectRatio + itemHeightOffset
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
