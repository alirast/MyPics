//
//  DetailViewController.swift
//  MyPics
//
//  Created by n on 13.09.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var picture: Picture?
    
//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = picture?.caption ?? "Unknown"
        navigationItem.largeTitleDisplayMode = .never
        
        let imagePath = Directory.getDocumentsDirectory().appendingPathComponent(picture!.image)
        imageView.image = UIImage(named: imagePath.path)
    }
//MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
//MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
