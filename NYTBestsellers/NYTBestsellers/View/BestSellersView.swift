//
//  BestSellersView.swift
//  NYTBestsellers
//
//  Created by Leandro Wauters on 1/25/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class BestSellersView: UIView{

    
   
    var imageSelecte = String()

    var imageData = [BookImage.ItemsWrapper]()
    
    lazy var myPickerView: UIPickerView = {
        var pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        return pickerView
    }()
   
    lazy var myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 225, height: 350)
        layout.sectionInset = UIEdgeInsets.init(top: 20, left: 10, bottom: 20, right: 10)
        layout.scrollDirection = .horizontal
//        layout.scrollDirection = .horizontal
        var collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
//        listNames = DataPersistenceModel.getListNames(
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .white
        setupViews()
        self.myCollectionView.register(BestSellersCollectionViewCell.self, forCellWithReuseIdentifier: "BestSellersCell")


    }
    
}

extension BestSellersView {
    private func setupViews() {
        setPickerView()
        setUpCollectionView()
    }
    private func setPickerView() {
        addSubview(myPickerView)
        myPickerView.translatesAutoresizingMaskIntoConstraints = false
        myPickerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        myPickerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        myPickerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        myPickerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
    }
    private func setUpCollectionView() {
       addSubview(myCollectionView)
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        myCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        myCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        myCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
    }
    
    
}
