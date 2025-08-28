import UIKit

private enum Layout {
    static let cornerRadius: CGFloat = 8
    static let padding: CGFloat = 12
    static let spacing: CGFloat = 8

    enum Poster {
        static let aspectRatio: CGFloat = 1.5
    }

    enum Rating {
        static let symbolSize: CGFloat = 20
        static let bottomPadding: CGFloat = 12
    }
}

final class PopularMovieCell: UICollectionViewCell {
    static let identifier = String(describing: PopularMovieCell.self)

    let posterView = MTPosterView()

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

        contentView.addSubview(posterView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(starImageView)
        contentView.addSubview(ratingLabel)

        NSLayoutConstraint.activate([
            // Poster view
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.padding),
            posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.padding),
            posterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.padding),
            posterView.heightAnchor.constraint(equalTo: posterView.widthAnchor, multiplier: Layout.Poster.aspectRatio),

            // Title label
            titleLabel.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: Layout.padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.padding),

            // Year label
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Layout.spacing),
            yearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.padding),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.padding),

            // Star image
            starImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.padding),
            starImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Layout.Rating.bottomPadding
            ),
            starImageView.widthAnchor.constraint(equalToConstant: Layout.Rating.symbolSize),
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
        if let posterPath = movie.posterPath {
            posterView.configure(with: posterPath)
        }
        titleLabel.text = movie.title

        if let releaseDate = movie.releaseDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            yearLabel.text = formatter.string(from: releaseDate)
        } else {
            yearLabel.text = "-"
        }

        ratingLabel.text = String(format: "%.1f", movie.voteAverage)
    }
}
