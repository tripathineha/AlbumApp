//
//  AlbumCollectionViewController.swift
//  AlbumApp
//
//  Created by Neha Tripathi on 29/12/17.
//  Copyright © 2017 Neha Tripathi. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "AlbumCollectionViewCell"
private let urlString = "https://rallycoding.herokuapp.com/api/music_albums"

class AlbumCollectionViewController: UICollectionViewController {
    
    var albumList = [Album]()
    var editMode : Bool = false
    
    //properties for menu
    @nonobjc private let deleteAction = #selector(UIResponderStandardEditActions.delete(_:))
    @nonobjc private let editAction = #selector(AlbumCollectionViewCell.edit(_:))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAlbums()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onEditButtonTapped(_:)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedIndexPath = collectionView?.indexPathsForSelectedItems{
            for indexPath in selectedIndexPath {
                collectionView?.deselectItem(at: indexPath, animated: false)
            }
        }
        navigationItem.leftBarButtonItem?.title = "Edit"
        editMode = false
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier : reuseIdentifier , for : indexPath) as? AlbumCollectionViewCell else {
            fatalError("Invalid index")
        }
        let album = albumList[indexPath.row]
        cell.artistNameLabel.text = album.artist
        cell.albumTitleLabel.text = album.title
        
        if let albumImage = album.albumImage,
            let url = URL(string : albumImage)
        {
            DispatchQueue.main.async {() -> Void in
                if let data = try? Data(contentsOf: url) {
                    cell.albumImageView.image = UIImage(data : data)
                }
            }
        }
        else {
            cell.albumImageView.image = UIImage(named: "defaultAlbum")
        }
        
        if let thumbnailImage = album.thumbnailImage,
            let url = URL(string : thumbnailImage)
        {
            DispatchQueue.main.async {() -> Void in
                if let data = try? Data(contentsOf: url) {
                    cell.thumbnailImageView.image = UIImage(data : data)
                }
            }
        }
        else {
            cell.thumbnailImageView.image = UIImage(named: "defaultThumbnail")
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        let editItem = UIMenuItem(title: "Edit", action: editAction)
        UIMenuController.shared.menuItems = [editItem]
        return editMode
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if !editMode {
            return false
        }
        else {
            return (action == deleteAction) || (action == editAction)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        switch action {
            
        case editAction :
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "AlbumViewController") as? AlbumViewController {
                viewController.delegate = self
                viewController.album = albumList[indexPath.row]
                self.present(viewController, animated: true, completion: nil)
            } 
            
        case deleteAction :
            albumList.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
        default:
            print("default Action")
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if (sourceIndexPath == destinationIndexPath){
            return
        }
        let movedAlbum = albumList[sourceIndexPath.row]
        albumList.remove(at: sourceIndexPath.row)
        albumList.insert(movedAlbum, at: destinationIndexPath.row)
    }
}

// Class extension for navigation
extension AlbumCollectionViewController {
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier ?? "" {
            
        case "Add album":
            guard let destinationViewController = segue.destination as? AlbumViewController else {
                fatalError("Could not open proper view controller!")
            }
            destinationViewController.delegate = self
            
        case "ShowAlbumDetails":
            guard let selectedIndexPaths = collectionView?.indexPathsForSelectedItems,
                let row = selectedIndexPaths.last?.row else {
                    let errorAlert = Utilities.sharedInstance.createAlert(title: "Invalid Index", message: "No item selected", hasCancelAction: false)
                    self.present(errorAlert,animated: true)
                    return
            }
            let album1 = albumList[row]
            let destinationViewController = segue.destination as? AlbumDetailsViewController
            destinationViewController?.album = album1
            
        default:
            print("default")
            
        }
    }
}

//MARK: - Album View Controller Delegate
extension AlbumCollectionViewController : AlbumViewControllerDelegate{
    func saveData(album: Album,newAlbum: Bool) {
        let containsAlbum = albumList.contains(where: ({ (album1: Album) -> Bool in
            if album1.title == album.title {
                return true
            }
            else{
                return false
            }}))
        
        //  Check whether new Album being added does not clash with any other Album in list
        if containsAlbum && !newAlbum  {
            let index = albumList.index(where: { (album1: Album) -> Bool in
                if album1.title == album.title {
                    return true
                }
                else{
                    return false
                }})
            if  let index = index{
                albumList[index] = album
                collectionView?.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
            
        }
        else if containsAlbum && newAlbum{
            let errorAlert = Utilities.sharedInstance.createAlert(title: "Repeated Album", message: "Album already exists! ", hasCancelAction: false)
            self.present(errorAlert,animated: true)
        }
        else {
            self.albumList.append(album)
            collectionView?.insertItems(at: [IndexPath(row: albumList.count-1, section: 0)])
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AlbumCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 8, left: 8, bottom: 8 , right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100 , height: 150)
    }
}

// MARK: - Custom methods
extension AlbumCollectionViewController  {
    func loadAlbums(){
        
        Alamofire.request(urlString).responseJSON { response in
            if let error = response.error {
                let errorAlert = Utilities.sharedInstance.createAlert(title: "System Error", message: "\(error.localizedDescription) ", hasCancelAction: false)
                self.present(errorAlert,animated: true)
                return
            }
            guard let allAlbums = response.result.value as? [[String:String]] else {
                let errorAlert = Utilities.sharedInstance.createAlert(title: "Network Error", message: "Invalid data received! ", hasCancelAction: false)
                self.present(errorAlert,animated: true)
                return
            }
            
            for array in allAlbums {
                if let album = Album(json : array){
                    self.albumList.append(album)
                }
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
}

//MARK: - Handler Methods
extension AlbumCollectionViewController{
    @objc func onEditButtonTapped(_ sender: UIBarButtonItem) {
        
        if (editMode){
            navigationItem.leftBarButtonItem?.title = "Edit"
            editMode = false
        }
        else {
            navigationItem.leftBarButtonItem?.title = "Cancel"
            editMode = true
        }
    }
}

