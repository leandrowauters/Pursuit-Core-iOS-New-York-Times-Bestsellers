//
//  FavoritesViewController.swift
//  NYTBestsellers
//
//  Created by Leandro Wauters on 1/25/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    
    
    var favoritesView = FavoritesView()
    var favoriteBooks = DataPersistenceModel.getFavoriteBooks() {
        didSet{
            print("DidSet work")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(favoritesView)
        title = "Favorites (\(favoriteBooks.count))"
        favoritesView.favoritesCollectionView.dataSource = self
        favoritesView.favoritesCollectionView.delegate = self
        reload()
    }
    
    func reload(){
        favoriteBooks = DataPersistenceModel.getFavoriteBooks()
        favoritesView.favoritesCollectionView.reloadData()
        title = "Favorites (\(favoriteBooks.count))"
        
    }
    override func viewDidAppear(_ animated: Bool) {
        favoritesView.favoritesCollectionView.reloadData()
        favoriteBooks = DataPersistenceModel.getFavoriteBooks()
        title = "Favorites (\(favoriteBooks.count))"
    }
    @objc func buttonPressed(sender: UIButton){
        let index = sender.tag
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (UIAlertAction) in
            DataPersistenceModel.deleteFavoriteBook(atIndex: index)
            UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseIn], animations: {
                
                let indexPath = IndexPath.init(row: index, section: 0)
                self.favoritesView.favoritesCollectionView.reloadItems(at: [indexPath])
                guard let cell = self.favoritesView.favoritesCollectionView.cellForItem(at: indexPath) as? FavoriteCell else {return}
//                cell.transform = CGAffineTransform.init(scaleX: -10, y: -10)
                cell.alpha = 0
                
            }, completion: { (done) in
                self.favoriteBooks = DataPersistenceModel.getFavoriteBooks()
                self.favoritesView.favoritesCollectionView.reloadData()
            })

        }
        let seeOnAmazon = UIAlertAction(title: "See On Amazon", style: .default) { (UIAlertAction) in
            let amazonURL = self.favoriteBooks[index].amazonURL
            self.openAmazonWebView(url: amazonURL)
        }
        actionSheet.addAction(seeOnAmazon)
        actionSheet.addAction(delete)
        self.present(actionSheet, animated: true, completion: nil)
    }
    func openAmazonWebView(url: URL){
        let amazonVC = AmazonViewController()
        amazonVC.modalPresentationStyle = .overCurrentContext
        amazonVC.amazonURL = url
            self.present(amazonVC, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCell else {return UICollectionViewCell()}
        let bookToSet = favoriteBooks[indexPath.row]
        cell.favoriteLabel.text = bookToSet.bookName
        cell.favoriteDetailsTextView.text = bookToSet.description
        cell.actionButton.tag = indexPath.row
        cell.actionButton.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        if let image = UIImage(data: bookToSet.imageData){
            cell.favoriteImage.image = image
        }
        return cell
        
    }

}
