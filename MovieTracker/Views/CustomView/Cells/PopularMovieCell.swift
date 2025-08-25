import UIKit

private enum Layout {
    static let cornerRadius: CGFloat = 8
    static let padding: CGFloat = 12
    static let spacing: CGFloat = 8

    enum StarImage {
        static let size: CGFloat = 20
    }
}

final class PopularMovieCell: UICollectionViewCell {
    static let identifier = String(describing: PopularMovieCell.self)

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: SFSymbols.starFill)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .systemYellow
        return imageView
    }()

    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.layer.cornerRadius = Layout.cornerRadius
        contentView.backgroundColor = .secondarySystemBackground

        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(starImageView)
        contentView.addSubview(ratingLabel)

        NSLayoutConstraint.activate([
            // Title label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.padding),

            // Year label
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Layout.spacing),
            yearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.padding),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.padding),

            // Star image
            starImageView.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: Layout.spacing),
            starImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.padding),
            starImageView.widthAnchor.constraint(equalToConstant: Layout.StarImage.size),
            starImageView.heightAnchor.constraint(equalTo: starImageView.widthAnchor),

            // Rating label
            ratingLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: Layout.spacing),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.padding)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: movie.releaseDate)
        ratingLabel.text = String(movie.voteAverage)
    }
}
