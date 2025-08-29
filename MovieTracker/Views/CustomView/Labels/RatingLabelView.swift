import UIKit

final class RatingLabelView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemYellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: SFSymbols.starFill)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .systemYellow
        return imageView
    }()

    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 12
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false

        addSubviews(starImageView, label)

        NSLayoutConstraint.activate([
            // Star image
            starImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            starImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            starImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            starImageView.widthAnchor.constraint(equalToConstant: 16),
            starImageView.heightAnchor.constraint(equalTo: starImageView.widthAnchor),

            // Label
            label.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
}
