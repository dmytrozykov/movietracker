import UIKit

private enum Layout {
    static let padding: CGFloat = 24
    static let spacing: CGFloat = 12
    static let columnCount: Int = 2
    static let itemAspectRatio: Double = 1.5
}

final class MTPopularMoviesViewController: UIViewController {
    private var nextPage: Int = 1
    private var totalPages: Int = 1
    private var movies: [Movie] = []

    private var dataSource: DataSource?

    private lazy var collectionView: UICollectionView = {
        let layout = MTCollectionViewFlowLayout(
            frame: view.bounds,
            columnCount: Layout.columnCount,
            spacing: Layout.spacing,
            padding: Layout.padding,
            itemAspectRatio: Layout.itemAspectRatio
        )
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(PopularMovieCell.self, forCellWithReuseIdentifier: PopularMovieCell.identifier)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
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
        configureDataSource()
        fetchData()
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupUI() {
        view.addSubview(collectionView)
    }

    private func fetchData() {
        guard nextPage <= totalPages else { return }

        Task {
            do {
                let response = try await TMDbService.shared.fetchPopularMovies(page: nextPage)
                nextPage = response.page + 1
                totalPages = response.totalPages
                movies.append(contentsOf: response.results)
                updateSnapshot()
            } catch {
                presentErrorAlert(for: error)
            }
        }
    }
}

extension MTPopularMoviesViewController {
    enum Section { case main }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>

    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, movie in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PopularMovieCell.identifier,
                for: indexPath
            ) as? PopularMovieCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: movie)
            return cell
        })
    }

    @MainActor private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension MTPopularMoviesViewController: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate _: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        let hasMorePages = nextPage <= totalPages
        if offsetY > contentHeight - height, hasMorePages {
            fetchData()
        }
    }
}
