//
//  SearchVC+TableViewDataSource.swift
//  WorkTask
//
//  Created by Алекс Ломовской on 03.02.2021.
//

import UIKit

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  self.filmResponse?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let film = self.filmResponse?.results[indexPath.row]
        cell.textLabel?.text = film?.title
        cell.imageView?.image = #imageLiteral(resourceName: "1024px-No_image_available.svg")
        cell.backgroundColor = .clear
        cell.imageView?.clipsToBounds =  true
        cell.imageView?.layer.cornerRadius = 20
        
        let posterUrlString = imagePath + (film?.posterPath)!
        guard let posterURL = URL(string: posterUrlString) else { return }
        DispatchQueue.global(qos: .utility).async {
            let imageData = try? Data(contentsOf: posterURL)
            let poster = UIImage(data: imageData!)
            let resizedPoster = poster?.resizeImageUsingVImage(size: CGSize.init(width: 50, height: 50))
            DispatchQueue.main.async {
                cell.imageView?.image = resizedPoster
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let film = self.filmResponse?.results[indexPath.row]
        let selectedFilmVC = SelectedFilmViewController()
        let posterUrlString = imagePath + (film?.posterPath)!
        guard let posterURL = URL(string: posterUrlString) else { return }
        DispatchQueue.global(qos: .utility).async {
            let imageData = try? Data(contentsOf: posterURL)
            let poster = UIImage(data: imageData!)
            
            //TODO: work with GSD
            DispatchQueue.main.async {
                let resizedPoster = poster?.resizeImageUsingVImage(size: CGSize.init(width: selectedFilmVC.view.frame.width, height: selectedFilmVC.view.frame.height * 0.5))
                selectedFilmVC.imageView.image = resizedPoster
                self.navigationController?.pushViewController(selectedFilmVC, animated: true)
            }
         
        }

      
    }
    
}
