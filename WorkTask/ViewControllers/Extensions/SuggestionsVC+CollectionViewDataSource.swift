//
//  ViewController + CollectionViewDelegate.swift
//  WorkTask
//
//  Created by Алекс Ломовской on 10.12.2020.
//

import UIKit

extension SuggestionsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.recommendationsCollectionView {
            return SuggestionsViewController.films.count

        } else if collectionView == self.genreCollectionView {
            return self.genres.count
        }
        return Int()
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.genreCollectionView {
            return CGSize(width: collectionView.frame.width * 0.3, height: collectionView.frame.height * 0.6)
            
        } else if collectionView == self.recommendationsCollectionView {
            return CGSize(width: view.frame.width - 125, height: collectionView.frame.size.height * 0.8)
        }
        return CGSize()
    }
    
    //    DistanceBetween Cells
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.recommendationsCollectionView {
            return 34
            
        } else if collectionView == self.genreCollectionView {
            return 10
            
        }
        return CGFloat()
    }
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.recommendationsCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationsCollectionViewCell.reuseIdentifier,for: indexPath) as? RecommendationsCollectionViewCell {
                let film = SuggestionsViewController.films[indexPath.row]
                let defaultImage = #imageLiteral(resourceName: "1024px-No_image_available.svg")
                let poster = UIImage(data: film.poster!)
                let newPoster = poster?.resizeImageUsingVImage(size: CGSize.init(width: 200,
                                                                                 height: 200))
                DispatchQueue.main.async {
                    cell.configureCell(image: newPoster ?? defaultImage, title: film.title ?? "Неизвестно", originalTitle: film.originalTitle ?? "Неизвестно", releaseDate: film.releaseDate ?? "Неизвестно", rating: film.rating )
                }
                return cell
            }
            
        } else if collectionView == self.genreCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.reuseIdentifier, for: indexPath) as? GenreCollectionViewCell {
                let genre = self.genres[indexPath.row]
                cell.backgroundColor = .systemGray4
                cell.layer.cornerRadius = 10
                cell.configureTheCell(genreLabel: genre)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.genreCollectionView {
            
        } else if collectionView == self.recommendationsCollectionView {
            let cell = collectionView.cellForItem(at: indexPath)
               let previewVC = PreviewViewController()

               UIView.animate(withDuration: 0.2,
                              animations: {
                               //Fade-out
                               cell?.alpha = 0.5
               }) { (completed) in
                   UIView.animate(withDuration: 0.2,
                                  animations: {
                                   //Fade-out
                                   cell?.alpha = 1
                   })
               }
               navigationController?.present(previewVC, animated: true)
               let film = SuggestionsViewController.films[indexPath.row]
               let poster = UIImage(data: film.poster!)
               let resizedPoster = poster?.resizeImageUsingVImage(size: CGSize.init(width: view.frame.width,
                                                                                    height: view.frame.height * 0.6))
               
               previewVC.imageView.image = resizedPoster
               previewVC.titleLabel.text = film.title
               previewVC.yearLabel.text = film.releaseDate
               previewVC.overviewText.text = film.overview
            }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //настройка ползунка при прокручивании
        if #available(iOS 13, *) {
            (scrollView.subviews[(scrollView.subviews.count - 1)].subviews[0]).backgroundColor = UIColor.white
            //verticalIndicator
            (scrollView.subviews[(scrollView.subviews.count - 2)].subviews[0]).isHidden = true
            //horizontalIndicator
        } else {
            if let verticalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 1)] as? UIImageView) {
                verticalIndicator.backgroundColor = UIColor.systemGray6
            }
            
            if let horizontalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 2)] as? UIImageView) {
                horizontalIndicator.isHidden = true
            }
        }
        
    }
    
}
