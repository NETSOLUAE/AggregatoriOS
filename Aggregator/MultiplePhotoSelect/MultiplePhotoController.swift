//
//  MultiplePhotoController.swift
//  Aggregator
//
//  Created by Mac Mini on 9/6/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import Photos
import CoreData
import Foundation

class MultiplePhotoController: UIViewController, UINavigationControllerDelegate {
    
    var selectedphotos = [UIImage]()
    var allPhotos: PHFetchResult<PHAsset> = PHFetchResult()
    var finalPhotos = [UIImage]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Photos"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if let nav = self.navigationController {
            var stacks = nav.viewControllers
            for stack in stacks {
                if (stack is ImageAttachmentController ) {
                    if let index = stacks.index(of: stack) {
                        stacks.remove(at: index)
                        nav.setViewControllers(stacks, animated: true)
                    }
                }
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func awakeFromNib() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    @IBAction func selectPhotos(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let compareController = storyboard.instantiateViewController(withIdentifier: "ImageAttachmentController") as! ImageAttachmentController
        compareController.selectedphotos = selectedphotos
        if (finalPhotos.count > 0) {
            compareController.finalphotos = finalPhotos
        }
        compareController.fromMultiSelect = true
        compareController.allPhotos = allPhotos
        self.show(compareController, sender: self)
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
}

extension MultiplePhotoController : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiplePhoto", for: indexPath) as! MultiplePhotoCollection
        let result = self.allPhotos[indexPath.row]
//        let img: UIImage = self.getAssetThumbnail(asset: result)
//        img.accessibilityIdentifier = "\(indexPath.row)"
        cell.image.image = self.getAssetThumbnail(asset: result)
        if (cell.checkBox.isSelected) {
            cell.checkBox.setBackgroundImage(UIImage(named: "checkbox-selected.png"), for: .normal)
            cell.checkBox.isSelected = true
        } else {
            cell.checkBox.setBackgroundImage(UIImage(named: "checkbox.png"), for: .normal)
            cell.checkBox.isSelected = false
        }
        cell.checkBox.tag = indexPath.row
        cell.image.tag = indexPath.row
        cell.cellDelegate = self
        return cell;
    }
}

extension MultiplePhotoController : MultiplePhotoDelegate {
    func didPressButton(sender: UIButton, image: UIImageView) {
        if (sender.tag < self.allPhotos.count) {
//            let result = self.allPhotos[sender.tag]
            if (sender.isSelected) {
                sender.setBackgroundImage(UIImage(named: "checkbox.png"), for: .normal)
                sender.isSelected = false
                if let index = selectedphotos.index(of: image.image!) {
                    selectedphotos.remove(at: index)
                }
            } else {
                sender.setBackgroundImage(UIImage(named: "checkbox-selected.png"), for: .normal)
                sender.isSelected = true
                self.selectedphotos.append(image.image!)
            }
        }
    }
}
