//
//  AlbumViewController.swift
//  AlbumApp
//
//  Created by Neha Tripathi on 28/12/17.
//  Copyright © 2017 Neha Tripathi. All rights reserved.
//

import UIKit
import os.log

protocol AlbumViewControllerDelegate{
    func saveData(album: Album,newAlbum: Bool)
}

class AlbumViewController: UIViewController {
    
    var delegate : AlbumViewControllerDelegate?
    var album : Album?
    var newAlbum : Bool = true
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var albumTitleTextField: UITextField!
    @IBOutlet weak var artistNameTextField: UITextField!
    @IBOutlet weak var albumUrlTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let album = album {
            newAlbum = false
            albumTitleTextField.text = album.title
            albumTitleTextField.isUserInteractionEnabled = false
            artistNameTextField.text = album.artist
            albumUrlTextField.text = album.url
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
// Class extension for @IBAction methods
extension AlbumViewController {
    @IBAction func onCancelButtonTapped(_ sender: Any) {
        let isPresentingModally = presentingViewController is UINavigationController
        if isPresentingModally{
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
    }
    @IBAction func onSaveButtonTapped(_ sender: UIBarButtonItem) {
        guard sender == saveButton else {
            os_log("Save button not pressed!")
            return
        }
        
        // Check whether fields are empty
        guard
            let albumTitle = albumTitleTextField.text,
            let artistName = artistNameTextField.text,
            let albumUrl = albumUrlTextField.text,
            !albumTitle.isEmpty,
            !artistName.isEmpty,
            !albumUrl.isEmpty else{
            let errorAlert = Utilities.sharedInstance.createAlert(title: "No Input", message: "Some fields are empty!", hasCancelAction: false)
            self.present(errorAlert,animated: true)
            return
        }
        
        let tempAlbum = Album(title: albumTitle, artist: artistName, url: albumUrl, albumImage: album?.albumImage, thumbnailImage: album?.thumbnailImage)
        self.presentingViewController?.dismiss(animated: true, completion:nil)
        self.delegate?.saveData(album : tempAlbum,newAlbum: newAlbum)
    }
}
