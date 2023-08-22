//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by midDeveloper on 22.08.2023.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var descLabel: UITextField!
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let imgSelectGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(imgSelectGestureRecognizer)
    }
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        
        let mediaFolder = storageReferance.child("media")
        let uuid  = UUID().uuidString
        
        
        if let data = image.image?.jpegData(compressionQuality: 0.5) {
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            
            imageReferance.putData(data,metadata: nil) { metadata, err in
                if err != nil{
                    print("error:")
                    print(err?.localizedDescription)
                }else{
                    imageReferance.downloadURL { url, err in
                        if err == nil {
                            let imageUrl = url?.absoluteString
                            print(imageUrl)
                        }
                    }
                }
            }
            
        }
        
        
    }
    
}
