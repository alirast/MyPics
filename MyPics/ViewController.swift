//
//  ViewController.swift
//  MyPics
//
//  Created by n on 13.09.2022.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pictures = [Picture]()

//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "My Pics"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPicture))
        
        DispatchQueue.global().async { [weak self] in
            self?.pictures = Picture.recievePicFromUserDefaults()
            DispatchQueue.main.async {
                self!.tableView.reloadData()
            }
        }
    }
//MARK: - numOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
//MARK: - cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) as? PictureCell else { fatalError("Unable to dequeue PictureCell.") }
        let picture = pictures[indexPath.row]
        cell.caption.text = picture.caption
        let path = Directory.getDocumentsDirectory().appendingPathComponent(picture.image)
        cell.pictureSmall.image = UIImage(contentsOfFile: path.path)
        cell.pictureSmall.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.pictureSmall.layer.borderWidth = 2
        cell.pictureSmall.layer.cornerRadius = 10
        cell.layer.cornerRadius = 3
        return cell
    }
    
//MARK: - didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Choose the action", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Edit caption", style: .default) { _ in
            self.editCaption(alertController: ac, indexPath: indexPath)
        })
        ac.addAction(UIAlertAction(title: "Show picture", style: .default) { _ in
            self.showPicture(index: indexPath.row)
        })
        ac.addAction(UIAlertAction(title: "Delete picture", style: .default) { _ in
            self.deletePicture(indexPath: indexPath)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
//MARK: - addNewPicture
    @objc func addNewPicture() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
//MARK: - didFinishPickinMedia
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = Directory.getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Write a caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default) { [weak self, weak ac] action in
            guard let newCaption = ac?.textFields![0].text else { return }
            let picture = Picture(caption: newCaption, image: imageName)
            self?.pictures.append(picture)
            
            DispatchQueue.global().async {
                Picture.savePicsToUserDefaults(pictures: self!.pictures)
                
                DispatchQueue.main.async {
                    self!.tableView.reloadData()
                }
            }
        })
        present(ac, animated: true)
    }
    
//MARK: - showPicture
    func showPicture(index: Int) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.picture = pictures[index]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
//MARK: - deletePicture
    func deletePicture(indexPath: IndexPath) {
        self.pictures.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        DispatchQueue.global().async {
            Picture.savePicsToUserDefaults(pictures: self.pictures)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
//MARK: - editCaption
    func editCaption(alertController: UIAlertController, indexPath: IndexPath) {
        let pic = pictures[indexPath.row]
        let ac = UIAlertController(title: "Write a new caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default) { [weak self, weak ac] action in
            guard let newCaption = ac?.textFields?[0].text else { return }
            pic.caption = newCaption
            
            DispatchQueue.global().async {
                Picture.savePicsToUserDefaults(pictures: self!.pictures)
                
                DispatchQueue.main.async {
                    self!.tableView.reloadData()
                }
            }
        })
        present(ac, animated: true)
    }
}

