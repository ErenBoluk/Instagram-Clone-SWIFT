//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by midDeveloper on 22.08.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    // Post Model
    var postArray = [PostModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false // Hücre seçimini engelle
        getDataFromFirestore()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(postArray.count)
        return postArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        let post = postArray[indexPath.row]
        
        cell.commentLabel.text = post.desc
        cell.likeLabel.text = "\(post.like)"
        cell.userImageView.image = UIImage(named: "select-image.png")
        cell.userImageView.sd_setImage(with: URL(string: post.imageUrl))
        cell.userEmailLabel.text = post.user
        cell.postId.text = post.postId
        
      
       
        
        return cell
    }
    
    
    func getDataFromFirestore() {
        let firestore = Firestore.firestore()
        
        
        print("SETTING")
        //  print(settings)
        firestore.collection("Posts")
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, err in
            if err != nil{
                print("err @-1")
            }else{
                if snapshot?.isEmpty != true && snapshot != nil{
                    let datas = snapshot?.documents
                    self.postArray = []
                    for data in datas!  {
                        let docId = data.documentID 
                        let image = data.get("imageUrl") as! String
                        let user = data.get("user") as! String
                        let desc = data.get("description") as! String
                        let like = data.get("like") as! Int
                        
                        let post = PostModel(postId: docId,user: user, imageUrl: image, like: like, desc: desc)
                        
                        self.postArray.append(post)
                        
                    }
                    
                        self.tableView.reloadData()
                }
            }
        }
        
    }
    
}
