//
//  ViewController.swift
//  AlbumApp
//
//  Created by Neha Tripathi on 28/12/17.
//  Copyright © 2017 Neha Tripathi. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController{
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    var albumList = [Album]()
    let itemsPerRow : CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAlbums()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedIndexPath = albumCollectionView.indexPathsForSelectedItems{
            for indexPath in selectedIndexPath {
                albumCollectionView.deselectItem(at: indexPath, animated: false)
            }
        }
    }
}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"AlbumCollectionViewCell" , for: indexPath) as! AlbumCollectionViewCell
        let album = albumList[indexPath.row]
        cell.albumNameLabel.text = album.title
        cell.artistNameLabel.text = album.artist
        
       if album.albumImage != nil
       {
           DispatchQueue.main.async {() -> Void in
            let url = URL(string : album.albumImage!)
            let data = try? Data(contentsOf: url!)
            os_log("Inside async task! Loading image..")
                if let data = data {
                    cell.albumImageView.image = UIImage(data : data)
                }
            }
        }
       else {
        cell.albumImageView.image = UIImage(named: "defaultAlbum")
        }
        if album.thumbnailImage != nil
        {
            DispatchQueue.main.async {() -> Void in
                let url = URL(string : album.thumbnailImage!)
                let data = try? Data(contentsOf: url!)
                os_log("Inside async task! Loading thumbnail image..")
                if let data = data {
                    cell.thumbnailImageView.image = UIImage(data : data)
            }
        }
       }
        else {
            cell.thumbnailImageView.image = UIImage(named: "defaultThumbnail")
        }
        return cell
    }
}

// Class extension for methods of UICollectionViewDelegate
extension ViewController : UICollectionViewDelegate {
    
    private func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
}

// Class extension for methods of UICollectionViewDelegateFlowLayout
extension ViewController : UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let width = (view.frame.width - 16.0 * itemsPerRow) / itemsPerRow
//        print (width)
//        return CGSize(width: width ,height : 180.0)
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// Class extension for custom methods
extension ViewController  {
    func loadAlbums(){
        let albumurl = URL(string: "https://rallycoding.herokuapp.com/api/music_albums")
        do{
            let data = try Data(contentsOf: albumurl!)
            let allAlbums = try JSONSerialization.jsonObject(with: data, options: []) as! [[String:String]]
            for array in allAlbums {
                if let album = Album(json : array){
                    albumList.append(album)
                }
            }
        } catch{
            print("JSON data is not in proper format!")
        }
    }
}

// Class extension for navigation
extension ViewController {
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier ?? "" {
            
        case "Add album":
            os_log("Add album")
            let destinationViewController = segue.destination as! AlbumViewController
           destinationViewController.delegate = self
            
        case "ShowAlbumDetails":
            os_log("show")
            let album1 = albumList[albumCollectionView.indexPathsForSelectedItems![0].row]
            let destinationViewController = segue.destination as! AlbumDetailsViewController
            destinationViewController.album = album1
            
        default:
            os_log("default")
        }
    }
}

//Class extension for OperationPerformedDelegate
extension AlbumCollectionViewController : AlbumViewControllerDelegate{
    func saveData(album: Album,newAlbum: Bool) {
        os_log("Album updation!")
        let containsAlbum = albumList.contains(where: ({ (album1: Album) -> Bool in
            if album1.title == album.title {
                return true
            }
            else{
                return false
            }}))
        
        //  Check whether new Album being added does not clashes with any other Album in list
        if containsAlbum && !newAlbum  {
            let index = albumList.index(where: { (album1: Album) -> Bool in
                if album1.title == album.title && album1.artist == album.artist {
                    return true
                }
                else{
                    return false
                }})
            if  index != nil{
                os_log("Album updated!")
                albumList[index!] = album
            }
        }
        else if containsAlbum && newAlbum{
            let errorAlert : UIAlertController = UIAlertController(title: "Repeated Album", message: "Album already exists! ", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlert,animated: true)
        }
        else {
            os_log("Album appended!")
            self.albumList.append(album)
        }
        albumCollectionView.reloadData()
    }
    
}

//Class extension for @IBAction methods
extension ViewController {
    @IBAction func onEditButtonTapped(_ sender: UIBarButtonItem) {
       
        
    }
    
}


