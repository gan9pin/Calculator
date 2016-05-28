//
//  ViewController.swift
//  Caluclator
//
//  Created by YutoTani on 2016/05/26.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var numberCollectionView: UICollectionView!
    let caluclatorElements:[String] = ["AC","+/-","%","÷","7","8","9","×","4","5","6","-","1","2","3","+","0",".","="]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resultLabel.textColor = UIColor.whiteColor()
    }

    override func viewDidLayoutSubviews() {
        numberCollectionView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //NumberCellの設定
        let numberCell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("NumberCell", forIndexPath: indexPath)
        
        let numberLabel:UILabel = numberCell.contentView.viewWithTag(1) as! UILabel
        numberLabel.text = caluclatorElements[indexPath.row]
        
        return numberCell
    }
    
    // Screenサイズに応じたセルサイズを返す
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var cellWidth:CGFloat
        if(indexPath.row == 16){
            cellWidth = collectionView.frame.size.width / 2 - 1
        }else{
            cellWidth = collectionView.frame.size.width / 4 - 1
        }
        let cellHeight:CGFloat = collectionView.frame.height / 5
        // 正方形で返すためにwidth,heightを同じにする
        return CGSizeMake(cellWidth, cellHeight)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 要素数を入れる、要素以上の数字を入れると表示でエラーとなる
        print(collectionView.tag)
        return 19;
    }


}

