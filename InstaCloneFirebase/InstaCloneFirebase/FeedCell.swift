//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by midDeveloper on 23.08.2023.
//

import UIKit
import FirebaseFirestore

class FeedCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var postId: UILabel!
    
    var lastTapTime: Date?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImageView.isUserInteractionEnabled = true
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(likeGestureRecFunc))
        // Configure the view for the selected state
        userImageView.addGestureRecognizer(gestureRec)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @objc func likeGestureRecFunc() {
            startHeartAnimation()
    }
    @IBAction func likeAction(_ sender: Any) {
        increaseLikeToFirebase()
    }
    
    func increaseLikeToFirebase() {
        let postId = postId.text!
        
        let firestoreDb = Firestore.firestore()
        
        firestoreDb.collection("Posts").document(postId).getDocument { doc, err in
            if err == nil{
                if let likeCount = doc?.get("like") as? Int {
                    let likeStore = ["like" : likeCount + 1 ] as! [String : Any]
                    firestoreDb.collection("Posts")
                        .document(postId)
                        .setData(likeStore,merge: true)
                }
                
            }else{
                print("Like Error : \(String(describing: err?.localizedDescription))")
            }
        }
        
        
        
    }
    
    
    func startHeartAnimation() {
        let now = Date()
            
            // Time check
        if let lastTapTime = lastTapTime, now.timeIntervalSince(lastTapTime) < 1 {
            
            

        let heartImageView = UIImageView(image: UIImage(named: "heart.png"))
        heartImageView.frame = CGRect(x: 0, y: 0, width: 75, height: 75) // Icon size
        heartImageView.center = contentView.center
        contentView.addSubview(heartImageView)

            
            
        likeLabel.text = String(Int(likeLabel.text!)! + 1)
        UIView.animate(withDuration: 1.0, animations: {
            heartImageView.alpha = 0.0
        }) { _ in
            heartImageView.removeFromSuperview()
            self.increaseLikeToFirebase()
        }
        
            
            
        
            
          
        } // end if
        
        lastTapTime = now
    }







    
}
