//
//  ViewController.swift
//  Rajeev_Task
//
//  Created by Gemini on 7/19/18.
//  Copyright © 2018 Gemini. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let KDataCollectionView = "DataCollectionViewCell"
    static let KPlaceholedrImage = "noImageicon"
    
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var factsDataArray = NSMutableArray()
    let  flowLayout=UICollectionViewFlowLayout()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadCollectionView()
        setNavigation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Private Methods
    // Load CollectionView
    func loadCollectionView(){
        collectionView.frame = self.view.frame;
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.contentInsetAdjustmentBehavior = .always
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.itemSize =  CGSize(width: screenWidth, height: 300)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        self.view.addSubview(collectionView)
        registerCell();
        getLocaldata()
        // Delaying servicecall for one sec to check the internet.
        self.perform(#selector(serviceCall), with: nil, afterDelay: 1)
        
    };
    
    //Set Navigation Button
    func setNavigation(){
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        let item = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(addTapped))
        navigationController?.navigationBar.largeTitleTextAttributes = [ kCTForegroundColorAttributeName : UIColor.red] as [NSAttributedStringKey : Any]
        let attributes = [kCTForegroundColorAttributeName : UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedStringKey : Any]
        
        item.tintColor = UIColor.red
        self.navigationItem.rightBarButtonItem = item
    }
    @objc func addTapped(){
        self.serviceCall()
    }
    /*
     Registering the collectionView cell nib classes.
     */
    func registerCell() {
        collectionView.register(DataCoustomCollectionViewCell.self, forCellWithReuseIdentifier:ViewController.KDataCollectionView)
    }
    // Fetch the data fron DB to populate on UI
    func getLocaldata(){
        do {
            if factsDataArray.count > 0 {
                factsDataArray.removeAllObjects()
            }
            let localDB:NSArray = try
                context.fetch(Facts.fetchRequest()) as NSArray
            factsDataArray.addObjects(from:localDB as! [Any])
            self.collectionView.reloadData()
        }
        catch {
        }
    }
    
    // MARK: Service call
    /*
     This Method is used to make Service call to get the facts details
     */
    @objc func serviceCall()
    {
        let dataString = getTextFrom(URL.init(string:ObjectManager.sharedObjectManager().serviceURL)!)
        let responseData = dataString?.data(using: .utf8)
        let json = try! JSONSerialization.jsonObject(with: responseData!, options: .mutableContainers) as? Dictionary<String, AnyObject?>
        if let dictionaryArray = json {
            self.title = dictionaryArray["title"]! as? String
            guard let Object = dictionaryArray["rows"] as? NSArray else { return }
            self.resetAllRecords(in:"Facts")
            for factsDetails in Object {
                _ = ResponseObject.init(ResponseDictionary: factsDetails as! [String : Any])
            }
            getLocaldata()
        }
    }
    
    // Delete the available data on DB, to insert latest data into it.
    func resetAllRecords(in entity : String){
        let context = self.context
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do{
            try context.execute(deleteRequest)
            try context.save()
        }
        catch{
            print("Failed")
        }
    }
    
    func getTextFrom(_ url: URL) -> String?  {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        print(data)
        return String(data: data, encoding: .utf8) ??
            String(data: data, encoding: .isoLatin1)
    }
}

// CollectionView delegate methods
extension ViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return factsDataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewController.KDataCollectionView, for: indexPath) as! DataCoustomCollectionViewCell
        let factsObjects = factsDataArray.object(at: indexPath.row) as! Facts
        cell.titleLabel.text = factsObjects.factsTitle
        cell.descriptionLabel.text = factsObjects.factsDescription
        cell.showCaseImageView.sd_setImage(with: URL(string: factsObjects.factsImage!), placeholderImage: UIImage(named: ViewController.KPlaceholedrImage))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UICollectionViewFlowLayoutAutomaticSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
