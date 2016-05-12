//
//  FeedVC.swift
//  justonejess-social
//
//  Created by Jess Rascal on 27/04/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import Material

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var toolbar: JOJMainToolbar! // NEEDED???
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    var imageSelected = false
    static var imageCache = NSCache()
    
//    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 400
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            
            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
//                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            cell.request?.cancel()
            
            var img: UIImage?
            
            //If there is a url for an image, try and get it from the local cache first
            //before we attempt to download it
            if let url = post.imageUrl {
                img = FeedVC.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post, img: img)
            
            return cell
        } else {
            return PostCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        if post.imageUrl == nil {
            return 150
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectorImage.image = image
        imageSelected = true
    }
    
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func placeButtonTapped() {
        performSegueWithIdentifier(SEGUE_SEARCH_VIEW, sender: nil) // CUSTOM TRANSITION TO MAKE IT SLIDE IN FROM THE RIGHT INSTEAD OF FROM BELOW?
    }
    
    @IBAction func newPostTapped(sender: AnyObject) {
        performSegueWithIdentifier(SEGUE_NEW_POST, sender: nil)
    }
    
    
//    @IBAction func makePost(sender: AnyObject) {
//        if let txt = postField.text where txt != "" {
//            if let img = imageSelectorImage.image where imageSelected == true {
//                let urlStr = "http://post.imageShack.us/upload_api.php"
//                let url = NSURL(string: urlStr)!
//                let imgData = UIImageJPEGRepresentation(img, 0.2)!
//                let keyData = "12DJKPSU5fc3afbd01b1630cc718cae3043220f3".dataUsingEncoding(NSUTF8StringEncoding)!
//                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
//                
//                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
//                    
//                    multipartFormData.appendBodyPart(data: keyData, name: "key")
//                    multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
//                    multipartFormData.appendBodyPart(data: keyJSON, name: "format")
//                    
//                    }, encodingCompletion: { encodingResult in
//                        
//                        switch encodingResult {
//                        case .Success(let upload, _, _):
//                            upload.responseJSON { response in
//                                if let info = response.result.value as? Dictionary<String, AnyObject> {
//                                    
//                                    if let links = info["links"] as? Dictionary<String, AnyObject> {
//                                        if let imgLink = links["image_link"] as? String {
//                                            print("LINK: \(imgLink)")
//                                            self.postToFirebase(imgLink)
//                                        }
//                                    }
//                                }
//                            } case .Failure(let error):
//                                print(error)
//                        }
//                })
//            } else {
//                self.postToFirebase(nil)
//            }
//        }
//    }
    
//    func postToFirebase(imgUrl: String?) {
//        var post: Dictionary<String, AnyObject> = [
//            "description": postField.text!,
//            "likes": 0,
//        ]
//        
//        if imgUrl != nil {
//            post["imageUrl"] = imgUrl!
//        }
//        
//        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
//        firebasePost.setValue(post)
//        
//        postField.text = ""
//        imageSelectorImage.image = UIImage(named: "camera")
//        imageSelected = false
//        
//        tableView.reloadData()
//    }
}
