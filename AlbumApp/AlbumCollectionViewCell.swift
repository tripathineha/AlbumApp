//
//  AlbumCollectionViewCell.swift
//  AlbumApp
//
//  Created by Neha Tripathi on 28/12/17.
//  Copyright © 2017 Neha Tripathi. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc func edit(_ sender : Any!){
        let collectionView = getCollectionView()
        guard let indexPath = collectionView.indexPath(for: self) else {
            fatalError("Edit could not be called!")
        }
        collectionView.delegate?.collectionView?(collectionView, performAction: #selector(edit), forItemAt: indexPath, withSender: sender)
    }
    override func delete(_ sender: Any?) {
        let collectionView = getCollectionView()
        guard let indexPath = collectionView.indexPath(for: self) else {
           fatalError("Delete could not be called!")
        }
        collectionView.delegate?.collectionView?(collectionView, performAction: #selector(delete), forItemAt: indexPath, withSender: sender)
    }
    
    /// return the collection view to which the cell belongs
    ///
    /// - Returns: Get the collection view to which the cell belongs
    func getCollectionView() -> UICollectionView{
        var view : UIView = self
        repeat{
            view = view.superview!
        }while !(view is UICollectionView)
        let collectionView = view as! UICollectionView
        return collectionView
    }
}

