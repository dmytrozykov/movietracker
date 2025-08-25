import UIKit

final class MTPopularMoviesViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

        let padding: CGFloat = 24
        let spacing: CGFloat = 12
        let totalSpacing = spacing + padding
        let width = (view.frame.width - totalSpacing) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.5)

        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(PopularMovieCell.self, forCellWithReuseIdentifier: PopularMovieCell.identifier)
        collectionView.dataSource = self
        return collectionView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        title = NSLocalizedString("popular_movies_screen_title", comment: "Popular movies screen title")
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupUI()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupUI() {
        view.addSubview(collectionView)
    }

    private func fetchData() {
        Task {
            do {
                let response = try await TMDbService.shared.fetchPopularMovies()
                print(response.results)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

extension MTPopularMoviesViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        5
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PopularMovieCell.identifier,
            for: indexPath
        ) as? PopularMovieCell else { return UICollectionViewCell() }
        cell.titleLabel.text = "The Shawshank Redemption"
        return cell
    }
}
