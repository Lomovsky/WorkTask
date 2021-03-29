//
//  GenreCollectionViewViewModelType.swift
//  WorkTask
//
//  Created by Алекс Ломовской on 29.03.2021.
//

import Foundation

protocol GenreCollectionViewViewModelType {
    
    func numberOfItems() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> GenreCollectionViewCellViewModelType?
    func fetchGenres(indexPath: IndexPath) -> Genre
}
