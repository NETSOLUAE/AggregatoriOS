//
//  ImageAttachmentController.swift
//  Aggregator
//
//  Created by Mac Mini on 9/6/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import Photos
import CoreData
import Foundation

class ImageAttachmentController: UIViewController, UINavigationControllerDelegate {
    
    var fromCamera = false
    var fromMultiSelect = false
    var fromThumbNail = false
    var finalphotos = [UIImage]()
    var selectedphotos = [UIImage]()
    var allPhotos: PHFetchResult<PHAsset> = PHFetchResult()
    
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var thumbNailCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (fromCamera) {
            if (finalphotos.count > 0){
                self.thumbNailCollection.reloadData()
            }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self.show(imagePicker, sender: true)
            }else{
                let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        } else if(fromMultiSelect){
            if (selectedphotos.count > 0) {
                for selectedPhoto in selectedphotos {
                    self.finalphotos.append(selectedPhoto)
                }
                self.thumbNailCollection.reloadData()
            }
            fromMultiSelect = false
        } else if (fromThumbNail){
            if (finalphotos.count > 0){
                self.thumbNailCollection.reloadData()
                fromThumbNail = false
            }
        } else {
            if (finalphotos.count > 0){
                self.thumbNailCollection.reloadData()
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let compareController = storyboard.instantiateViewController(withIdentifier: "MultiplePhotoController") as! MultiplePhotoController
            compareController.allPhotos = allPhotos
            if (self.finalphotos.count > 0) {
                compareController.finalPhotos = self.finalphotos
            }
            self.show(compareController, sender: self)
        }
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
                if (stack is MultiplePhotoController) {
                    if let index = stacks.index(of: stack) {
                        stacks.remove(at: index)
                        nav.setViewControllers(stacks, animated: true)
                    }
                }
                
            }
        }
    }
    
    override func awakeFromNib() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    @IBAction func upload(_ sender: Any) {
        
        if let nav = self.navigationController {
            var stacks = nav.viewControllers
            for stack in stacks {
                if (stack is OwnerDetailsController) {
                    if let index = stacks.index(of: stack) {
                        stacks.remove(at: index)
                        nav.setViewControllers(stacks, animated: true)
                    }
                }
                
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let compareController = storyboard.instantiateViewController(withIdentifier: "OwnerDetailsController") as! OwnerDetailsController
        compareController.finalphotos = finalphotos
        self.show(compareController, sender: self)
    }
    @IBAction func deletePhoto(_ sender: Any) {
        if let index = finalphotos.index(of: imagePicked.image!) {
            finalphotos.remove(at: index)
            if (finalphotos.count > 0) {
                if (index == self.finalphotos.count) {
                    imagePicked.image = finalphotos[index-1]
                } else {
                    imagePicked.image = finalphotos[index]
                }
            } else {
                imagePicked.image = UIImage(named: "imagePlaceholder.png")
            }
        }
        self.thumbNailCollection.reloadData()
    }
}

extension ImageAttachmentController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.image = image
        self.finalphotos.append(image)
        self.thumbNailCollection.reloadData()
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ImageAttachmentController : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.finalphotos.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! ThumbNailCollection
        if (indexPath.row == self.finalphotos.count) {
            cell.image.setBackgroundImage(UIImage(named: "button-add"), for: .normal)
        } else if (self.finalphotos.count > 0){
            let result = self.finalphotos[indexPath.row]
            cell.image.setBackgroundImage(result, for: .normal)
            if (indexPath.row == 0) {
                imagePicked.image = result
            }
        }
        cell.image.tag = indexPath.row
        cell.cellDelegate = self
        return cell;
    }
}

extension ImageAttachmentController : ThumbNailDelegate {
    func didPressButton(sender: UIButton) {
        if (sender.tag < self.finalphotos.count) {
            let result = self.finalphotos[sender.tag]
            imagePicked.image = result
        } else if (sender.tag == self.finalphotos.count) {
            if (fromCamera) {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera;
                    imagePicker.allowsEditing = false
                    self.show(imagePicker, sender: true)
                }else{
                    let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let compareController = storyboard.instantiateViewController(withIdentifier: "MultiplePhotoController") as! MultiplePhotoController
                compareController.allPhotos = allPhotos
                if (self.finalphotos.count > 0) {
                    compareController.finalPhotos = self.finalphotos
                }
                self.show(compareController, sender: self)
            }
        }
    }
}
