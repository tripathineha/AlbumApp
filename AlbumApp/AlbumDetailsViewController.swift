//
//  AlbumDetailsViewController.swift
//  AlbumApp
//
//  Created by Neha Tripathi on 28/12/17.
//  Copyright © 2017 Neha Tripathi. All rights reserved.
//

import UIKit
import os.log

class AlbumDetailsViewController: UIViewController {

    var album : Album!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumUrlTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
       
        albumUrlTextView.text = album.url
        albumTitleLabel.text = album.title
        artistNameLabel.text = album.artist
        
        if let albumImage = album.albumImage,
            let url = URL(string : albumImage)
        {
            DispatchQueue.main.async {() -> Void in
                if let data = try? Data(contentsOf: url) {
                    self.albumImageView.image = UIImage(data : data)
                }
            }
        }
        else {
            self.albumImageView.image = UIImage(named: "defaultAlbum")
        }
        
        if let thumbnailImage = album.thumbnailImage,
            let url = URL(string : thumbnailImage)
            
        {
            DispatchQueue.main.async {() -> Void in
                if let data = try? Data(contentsOf: url) {
                    self.thumbnailImageView.image = UIImage(data : data)
                }
            }
        }
        else {
            self.thumbnailImageView.image = UIImage(named: "defaultthumbnail")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
