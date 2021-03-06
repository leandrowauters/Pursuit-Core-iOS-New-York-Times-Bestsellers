//
//  BestSellersViewController.swift
//  NYTBestsellers
//
//  Created by Leandro Wauters on 1/25/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class BestSellersViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIPickerViewDataSource,UIPickerViewDelegate {
    var listNames = [BookListName.resultsWrapper]() {
        didSet{
            bestSellerVC.myPickerView.reloadAllComponents()
        }
    }
    let bestSellerVC = BestSellersView()
    var bestSellerBooks = [BestSellerBook.ResultsWrapper](){
        didSet{
            DispatchQueue.main.async {
                self.bestSellerVC.myCollectionView.reloadData()
            }
        }
    }
    
//    lazy var urlString = String()
////    var googleData = [BookImage.ItemsWrapper]() {
////        didSet{
////            urlString = googleData[0].volumeInfo.imageLinks.smallThumbnail
////            print(urlString)
//////            urlString = googleData[0].volumeInfo.imageLinks.smallThumbnail
////        }
////    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Best Sellers"
        view.addSubview(bestSellerVC)
        bestSellerVC.myPickerView.delegate = self
        bestSellerVC.myPickerView.dataSource = self
        bestSellerVC.myCollectionView.dataSource = self
        bestSellerVC.myCollectionView.delegate = self
        if let row = UserDefaults.standard.object(forKey: "Row") as? Int {
            bestSellerVC.myPickerView.selectRow(row, inComponent: 0, animated: true)
        }
        if let listName = UserDefaults.standard.object(forKey: UserdefaultKeys.listNames) as? String{
           getBooks(listName: listName)
        } else {
            getBooks(listName: "Manga")
        }
        
    }

    func getCategories(){
        APIClient.getListNames { (appError, listNames) in
            if let appError = appError{
                print(appError)
            }
            if let listNames = listNames{
                self.listNames = listNames
                DataPersistenceModel.save(data: listNames)
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if let row = UserDefaults.standard.object(forKey: "Row") as? Int {
            bestSellerVC.myPickerView.selectRow(row, inComponent: 0, animated: true)
        }
        if let listName = UserDefaults.standard.object(forKey: UserdefaultKeys.listNames) as? String{
            getBooks(listName: listName)
        } else {
            getBooks(listName: "Manga")
        }
        listNames = DataPersistenceModel.getListNames()
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    func getBooks(listName: String){
        APIClient.getBookDetails(listName: listName) { (appError, data) in
            if let appError = appError{
                print(appError)
            }
            if let data = data{
                self.bestSellerBooks = data
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bestSellerBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellersCell", for: indexPath) as? BestSellersCollectionViewCell else {return UICollectionViewCell()}
        let bookToSet = bestSellerBooks[indexPath.row]
        cell.bookNameLabel.text = "\(bookToSet.weeksOnList) weeks on best seller list"
        cell.bookDescription.text = bookToSet.bookDetails[0].description
        APIClient.getGoogleData(isbn: bookToSet.bookDetails[0].primaryIsbn10) { (appError, data) in
            if let appError = appError {
                print(appError)
                DispatchQueue.main.async {
                    cell.bookImage.image = UIImage(named: "bookPlaceholderSmall")
                }
            }
            if let data = data{
                if let image = ImageHelper.fetchImageFromCache(urlString: data[0].volumeInfo.imageLinks.smallThumbnail){
                    DispatchQueue.main.async {
                        cell.bookImage.image = image
                    }
                } else {
                    ImageHelper.fetchImageFromNetwork(urlString: data[0].volumeInfo.imageLinks.smallThumbnail) { (appError, image) in
                        if let appError = appError {
                            print(appError.errorMessage())
                        } else if let image = image{
                            cell.bookImage.image = image                 
                        }
                    }
                }
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bookToSend = bestSellerBooks[indexPath.row]
        let detail = BestSellerDetailViewController.init(isbn: bookToSend.bookDetails[0].primaryIsbn10, description: bookToSend.bookDetails[0].description, bookName: bookToSend.bookDetails[0].title, bookAuthor: bookToSend.bookDetails[0].author,amazonLink: bookToSend.amazonProductUrl,author: bookToSend.bookDetails[0].author)
        navigationController?.pushViewController(detail, animated: true)
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listNames.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listNames[row].listName
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedListName = listNames[row].listName
        APIClient.getBookDetails(listName: selectedListName) { (appError, data) in
            if let appError = appError{
                print(appError)
            }
            if let data = data{
                self.bestSellerBooks = data
            }
        }
//       UserDefaults.standard.set(row, forKey: "Row")
    }
}
    
    

