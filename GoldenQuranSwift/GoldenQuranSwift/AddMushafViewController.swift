//
//  AddMus7afViewController.swift
//  GoldenQuranSwift
//
//  Created by Omar Fraiwan on 2/21/17.
//  Copyright © 2017 Omar Fraiwan. All rights reserved.
//

import UIKit

class AddMushafViewController: UIViewController  {

    @IBOutlet weak var segmentLanguageControl: GQSegmentedControl!
    @IBOutlet weak var mushafListCollectionView: UICollectionView!
    
    let defaultMus7afArray = DBManager.shared.getDefaultMus7afs()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if UIApplication.isAr() {
            self.segmentLanguageControl.selectedSegmentIndex = 1
        } else {
            self.segmentLanguageControl.selectedSegmentIndex = 0
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func languageSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // English
            LanguageManager.changeLanguageTo(lang: .en)
        } else {
            // Arabic
            LanguageManager.changeLanguageTo(lang: .ar)
        }
        
        
        let mainWindow: UIWindow = (UIApplication.shared.delegate?.window!)!
        mainWindow.rootViewController = self.storyboard?.instantiateInitialViewController()
        
        UIView.transition(with: mainWindow, duration: 0.5, options: .transitionFlipFromLeft, animations: { () -> Void in }) { _ -> Void in }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "AddName" {
            let addMushafNameVC = segue.destination as! AddMushafNameViewController
            addMushafNameVC.modalPresentationStyle = .custom
            addMushafNameVC.defaultMushaf = sender as? Mus7af
            addMushafNameVC.delegate = self
        
        }
    }
 

    
    
}

//MARK: Collection View Delegate
extension AddMushafViewController:UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        Mus7afManager.shared.currentMus7af = defaultMus7afArray![indexPath.row]
        self.performSegue(withIdentifier: "AddName", sender: defaultMus7afArray![indexPath.row])
        
        
    }
}

extension AddMushafViewController:AddMushafNameViewControllerDelegate{
    func mushafAddedSuccessfully() {
//        let mushafList = self.storyboard?.instantiateViewController(withIdentifier: "MushafListViewController") as! MushafListViewController
//        self.navigationController?.pushViewController(mushafList, animated: true)
        self.performSegue(withIdentifier: "GoToList", sender: nil)
//        self.present(mushafList, animated: true, completion: nil)
    }
}
//MARK: Collection View DataSource
extension AddMushafViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let mus7afArray = defaultMus7afArray{
            return mus7afArray.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMushafCollectionViewCell", for: indexPath) as! AddMus7afCollectionViewCell
        let mushaf = defaultMus7afArray?[indexPath.row]
        cell.fillFromMushaf(mushaf: mushaf!)
        
        return cell
    }
    
}

//MARK: Collection View FlowLayoutDelegate
extension AddMushafViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:collectionView.frame.size.width, height:140)
    
    }
    
}
