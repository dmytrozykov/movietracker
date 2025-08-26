import UIKit

final class MTPosterView: UIImageView {
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 8
        contentMode = .scaleAspectFill
        clipsToBounds = true
        image = UIImage(resource: .noPoster)
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    func configure(with posterPath: String) {
        Task {
            guard let image = await TMDbService.shared.fetchImage(from: posterPath, size: .w342) else { return }
            await MainActor.run { self.image = image }
        }
    }
}
