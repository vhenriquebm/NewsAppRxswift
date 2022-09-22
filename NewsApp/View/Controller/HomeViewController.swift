//
//  ViewController.swift
//  NewsApp
//
//  Created by Vitor Henrique Barreiro Marinho on 21/09/22.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    let bag = DisposeBag()
    var newsList: [Article] = []
    
    // MARK: - Outlet
    
    @IBOutlet weak var newsTable: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        populateNews()
    }
    
    // MARK: - Private methods
    
    private func configureTableView () {
        newsTable.delegate = self
        newsTable.dataSource = self
    }
    
    private func populateNews() {
        
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=72f5c13cdb6a4ed198ff69bafc8852eb") else {return}
        
        let resource = Resource<ArticlesList>(url: url)
        
        URLRequest.load(resource: resource).subscribe(onNext: { [weak self] result in
            
            guard let result = result else {return}
            
            self?.newsList = result.articles
            
            DispatchQueue.main.async {
                self?.newsTable.reloadData()
            }
        }).disposed(by: bag)
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsTable.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return newsList.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = newsTable.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell else {return UITableViewCell()}
        
        cell.titleLabel.text = newsList[indexPath.row].title
        cell.descriptionLabel.text = newsList[indexPath.row].description
        
        return cell
    }
}










//        Observable.just(url)
//            .flatMap { url -> Observable<Data> in
//                let request = URLRequest(url: url)
//                return  URLSession.shared.rx.data(request: request)
//            }.map { data -> [Article]? in
//                return try JSONDecoder().decode(ArticlesList.self, from: data).articles
//
//            }.subscribe(onNext: { [weak self] articles in
//
//                if let articles = articles {
//                    self?.newsList = articles
//                    print (articles)
//
//                    DispatchQueue.main.async {
//                        self?.newsTable.reloadData()
//                    }
//                }
//
//            }, onError: { error in
//                print (error)
//            }).disposed(by: bag)
