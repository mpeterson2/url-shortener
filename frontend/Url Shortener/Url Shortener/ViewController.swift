//
//  ViewController.swift
//  Url Shortener
//
//  Created by Michael Peterson on 11/14/15.
//  Copyright © 2015 Michael Peterson. All rights reserved.
//

import UIKit
import JLToast

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let BASE_URL = "http://localhost:3000"
    let URL_TABLE_CELL_IDENTIFIER = "UrlTableCell"
    var knownUrls: [Url] = []

    @IBOutlet weak var newUrlTextField: UITextField!
    @IBOutlet weak var newUrlButton: UIButton!
    @IBOutlet weak var knownUrlsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newUrlButton.addTarget(self, action: "newUrl", forControlEvents: .TouchUpInside);
        
        knownUrlsTableView.registerNib(UINib(nibName: URL_TABLE_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: URL_TABLE_CELL_IDENTIFIER)
        knownUrlsTableView.delegate = self
        knownUrlsTableView.dataSource = self
        
        knownUrlsTableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "longPressedCell:"))
        knownUrlsTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tappedCell:"))
        loadShortUrls()
    }
    
    func loadShortUrls() {
        let storage = NSUserDefaults.standardUserDefaults()
        guard let knownShortUrls = storage.stringArrayForKey("knownShortUrls") else {
            return
        }
        
        for url in knownShortUrls {
            let newUrl = Url()
            newUrl.shortUrl = url
            self.knownUrls.append(newUrl)
            newUrl.getInfo(BASE_URL, callback: self.knownUrlsTableView.reloadData)
        }
    }
    
    func saveShortUrls() {
        let storage = NSUserDefaults.standardUserDefaults()
        var knownShortUrls: [String] = []
        for url in knownUrls {
            knownShortUrls.append(url.shortUrl)
        }
        
        storage.setObject(knownShortUrls, forKey: "knownShortUrls")
    }
    
    func newUrl() {
        guard let originalUrl = newUrlTextField.text else {
            return
        }
        
        Url.putNewUrl(BASE_URL, originalUrl: originalUrl, callback: {newUrl in
            self.knownUrls.append(newUrl)
            self.knownUrlsTableView.reloadData()
            self.saveShortUrls()
        })
    }
    
    func longPressedCell(gesture: UILongPressGestureRecognizer) {
        if let url = urlFromGestureRecognizer(gesture) {
            UIPasteboard.generalPasteboard().string = url.getFullShortUrl(BASE_URL)
            JLToast.makeText("Copied short url").show()
        }
    }
    
    func tappedCell(gesture: UITapGestureRecognizer) {
        if let url = urlFromGestureRecognizer(gesture) {
            if let nsUrl = NSURL(string: url.getFullShortUrl(BASE_URL)) {
                UIApplication.sharedApplication().openURL(nsUrl)
                url.numClicks++
                knownUrlsTableView.reloadData()
            }
        }
    }
    
    func urlFromGestureRecognizer(gesture: UIGestureRecognizer) -> Url? {
        let location = gesture.locationInView(knownUrlsTableView)
        if let index = knownUrlsTableView.indexPathForRowAtPoint(location) {
            return knownUrls[index.row]
        }
        
        return nil
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return knownUrls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = knownUrlsTableView.dequeueReusableCellWithIdentifier(URL_TABLE_CELL_IDENTIFIER) as? UrlTableCell {
            cell.setUrl(knownUrls[indexPath.row], baseUrl: BASE_URL)
            return cell
        }
        return UITableViewCell()
    }
}

