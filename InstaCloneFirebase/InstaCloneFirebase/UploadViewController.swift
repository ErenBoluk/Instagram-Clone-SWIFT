//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by midDeveloper on 22.08.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

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
            picker.allowsEditing = true // Kullanıcıya kırpma seçeneğini sunar
            present(picker, animated: true, completion: nil)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                image.image = editedImage // Kırpılmış resmi görüntüle
            } else if let originalImage = info[.originalImage] as? UIImage {
                image.image = originalImage // Kırpılmamış resmi görüntüle
            }
            self.dismiss(animated: true, completion: nil)
        }

        @IBAction func shareAction(_ sender: Any) {
            let storage = Storage.storage()
            let storageReference = storage.reference()

            let mediaFolder = storageReference.child("media")
            let uuid = UUID().uuidString
        
        if let data = image.image?.jpegData(compressionQuality: 0.1) {
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            
            imageReferance.putData(data,metadata: nil) { metadata, err in
                if err == nil{
                    imageReferance.downloadURL { url, err in
                        if err == nil {
                            let imageUrl = url?.absoluteString
                                // database
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            
                            let firestorePost = [
                                "imageUrl" : imageUrl!,
                                "user" : Auth.auth().currentUser!.email! ,
                                "description" : self.descLabel.text!,
                                "date" : FieldValue.serverTimestamp(),
                                "like" : 0
                            ] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (err) in
                                if err != nil {
                                    self.makeAlert(LabelInput: "Error !", DescInput: err!.localizedDescription ?? "Error")
                                }else{
                                    self.image.image = UIImage(named: "select-image.png")
                                    self.descLabel.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                                
                        }
                    }
                }
            }
            
        }
        
        
    }
    
    
    func makeAlert(LabelInput: String, DescInput: String) {
        let alert = UIAlertController(title: LabelInput, message: DescInput, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okBtn)
        self.present(alert, animated: true)
    }
    
}
