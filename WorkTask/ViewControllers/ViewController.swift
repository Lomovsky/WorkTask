//
//  ViewController.swift
//  WorkTask
//
//  Created by Алекс Ломовской on 05.12.2020.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
//MARK: Declarations
    let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=ru-RU&sort_by=popularity.desc&include_adult=true&include_video=false&page=1"
    static var films: [CurrentFilm] = []
    lazy var refreshControl = UIRefreshControl()
    var filmResponse: FilmResponse? = nil
    

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .init(x: 0, y: 178, width: 0, height: 0), collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCellReuseIdentifier")
        return cv
        
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let networkStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView()
        act.translatesAutoresizingMaskIntoConstraints = false
        return act
    }()
    
    
// MARK: ViewDidLoad -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(label)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(scrollView)

        let coreDataManager = CoreDataManager()
        if Reachability.isConnectedToNetwork() {
            coreDataManager.deleteAllData()
            downloadFilms()
            
        } else {
            coreDataManager.fetchData()
            self.label.textColor = .red
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
//MARK: ViewWillApear
    override func viewWillAppear(_ animated: Bool) {
        setupLabel()
        setupCollectionView()
        setupNavigationController()
        setupActivityIndicator()
        setupScrollView()
        setGradientBackground()
        
    }
    
//MARK:Set up funcs -  
    private func setGradientBackground() {
        let colorTop =  UIColor.systemBlue.cgColor
        let colorBottom = UIColor.systemTeal.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    private func setupNavigationController() {
        title = "Фильмы"
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    
    private func setupScrollView() {
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        scrollView.addSubview(collectionView)
        scrollView.addSubview(label)
        scrollView.addSubview(activityIndicator)
    }
    
    private func setupLabel() {
        
        label.text  = "Загрузка"
        label.textColor = .black
        label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        label.font = .systemFont(ofSize: 16)
    }
    
    private func setupCollectionView() {
        collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        collectionView.accessibilityScroll(.left)
        collectionView.backgroundColor = .clear
        // отступ первой и последней ячейки
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 36, bottom: 0, right: 150) 
        
    }
    
    private func setupNetworkStatusLabel() {
        networkStatusLabel.text = "Сеть недоступна"
        networkStatusLabel.isHidden = true
        
    }
    
    private func setupActivityIndicator() {
        activityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        activityIndicator.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        activityIndicator.startAnimating()
    }
    
    
}
