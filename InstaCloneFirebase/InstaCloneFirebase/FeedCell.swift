//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by midDeveloper on 23.08.2023.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    
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
        likeFunc()
    }
    @IBAction func likeAction(_ sender: Any) {
        likeFunc()
    }
    func likeFunc(){
        startHeartAnimation()
    }
    func startHeartAnimation() {
        
        let now = Date()
            // Eğer lastTapTime değeri nil değilse ve son tıklama ile arasındaki zaman farkı 1 saniyeden az ise
            if let lastTapTime = lastTapTime, now.timeIntervalSince(lastTapTime) < 1 {
        
        let heartImageView = UIImageView(image: UIImage(named: "heart.png"))
        heartImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50) // İkona uygun boyut ve konum ayarlayın
        heartImageView.center = self.center
        self.addSubview(heartImageView)
        UIView.animate(withDuration: 1.0, animations: {
            heartImageView.alpha = 0.0
            // İstediğiniz diğer animasyon değişikliklerini ekleyebilirsiniz
        }) { _ in
            heartImageView.removeFromSuperview()
        }
                
            }
            lastTapTime = now
    }






    
}
