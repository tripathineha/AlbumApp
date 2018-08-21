//
//  Album.swift
//  AlbumApp
//
//  Created by Neha Tripathi on 28/12/17.
//  Copyright © 2017 Neha Tripathi. All rights reserved.
//

import Foundation

class Album{
    var title : String
    var artist :  String
    var url : String?
    var albumImage : String?
    var thumbnailImage : String?
    
    init(title : String, artist :  String, url : String?, albumImage : String?, thumbnailImage : String?) {
        self.title = title
        self.artist = artist
        if let albumImage = albumImage{
            self.albumImage = albumImage
        }
        if let url = url{
            self.url = url        }
        if let thumbnailImage = thumbnailImage{
            self.thumbnailImage = thumbnailImage
        }
    }
    init?(json : [String : String])
    {
        guard let title = json["title"],
            let artist = json["artist"],
            let url = json["url"],
            let albumImage = json["image"],
            let thumbnailImage = json["thumbnail_image"]
            else
        {
            return nil
        }
        
        self.title = title
        self.artist = artist
        self.albumImage = albumImage
        self.url = url
        self.thumbnailImage = thumbnailImage
    }
}


