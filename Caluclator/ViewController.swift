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
    @IBOutlet weak var scientificCollectionView: UICollectionView!
    let mCaluclation:Calculation = Calculation()
    let caluclatorElements:[String] = ["AC","+/-","%","÷","7","8","9","×","4","5","6","-","1","2","3","+","0",".","="]
    let scientificElements:[String] = "( ) mc m+ m- mr 2nd x² x³ x^y e^x 10^x 1/x ²√x ³√x y√x ln log10 x! sin cos tan e EE Rad sinh cosh tanh π Rand".characters.split(" ").map{String($0)}
    let liteGrayGroup:[Int] = [3,7,11,15,18]
    var operatorCells:Dictionary<String,UICollectionViewCell> = Dictionary<String, UICollectionViewCell>()
    var isFirst:Bool = true
    var previousLabelText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resultLabel.textColor = UIColor.whiteColor()
        resultLabel.text = "0"
    }
    override func viewDidAppear(animated: Bool) {
        
        // 端末の向きがかわったらNotificationを呼ばす設定.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    // 端末の向きがかわったら呼び出される.
    func onOrientationChange(notification: NSNotification){
        
        isFirst = true
        operatorCells.removeAll()
        numberCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 現在のデバイスの向きを取得.
        let deviceOrientation: UIDeviceOrientation!  = UIDevice.currentDevice().orientation
        
        var countNumber = previousLabelText.stringByReplacingOccurrencesOfString(",", withString: "")
        countNumber = countNumber.stringByReplacingOccurrencesOfString(".", withString: "")
        
        if (UIDeviceOrientationIsPortrait(deviceOrientation)){
            if (countNumber.characters.count > 9){
                resultLabel.text = String.convertIndex(resultLabel.text!)
            }
        }
        else{
            if(countNumber.characters.count < 17){
                resultLabel.text = previousLabelText
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //NumberCellの設定
        if(collectionView.restorationIdentifier == "numberCollection"){
            
            let numberCell:UICollectionViewCell
            
            if(caluclatorElements[indexPath.row].isMatch("[+\\-×÷=]") && caluclatorElements[indexPath.row].characters.count == 1){
                numberCell = collectionView.dequeueReusableCellWithReuseIdentifier("OperatorCell", forIndexPath: indexPath)
                if(isFirst){
                    operatorCells[caluclatorElements[indexPath.row]] = numberCell
                    numberCell.layer.borderColor = UIColor.blackColor().CGColor
                    numberCell.layer.borderWidth = 0
                    if(operatorCells.count == 4){isFirst = false}
                }
            }
            else if(caluclatorElements[indexPath.row].isMatch("[0-9\\.]")){
                numberCell = collectionView.dequeueReusableCellWithReuseIdentifier("NumberCell", forIndexPath: indexPath)
            }
            else{
                numberCell = collectionView.dequeueReusableCellWithReuseIdentifier("OtherCell", forIndexPath: indexPath)
            }
            
            let numberLabel:UILabel = numberCell.contentView.viewWithTag(1) as! UILabel
            numberCell.tag = indexPath.row
            numberLabel.text = caluclatorElements[indexPath.row]
            return numberCell
        }
        //ScientificCellの設定
        else{
            let scientificCell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ScientificCell", forIndexPath: indexPath)
            
            let scientificLabel:UILabel = scientificCell.contentView.viewWithTag(1) as! UILabel
            scientificLabel.text = scientificElements[indexPath.row]
            
            return scientificCell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        borderClear()
        if (collectionView.tag == 1){
            
            if(caluclatorElements[indexPath.row].isMatch("[0-9]")){
                resultLabel.text = mCaluclation.addNumber(caluclatorElements[indexPath.row])
            }
            else if(caluclatorElements[indexPath.row].isMatch("\\.")){
                resultLabel.text = mCaluclation.addPoint()
            }
            else if(caluclatorElements[indexPath.row].isMatch("\\+\\/\\-")){
                resultLabel.text = mCaluclation.addSign()
            }
            else if(caluclatorElements[indexPath.row].isMatch("[+\\-×÷]{1}")){
                resultLabel.text = mCaluclation.addOperator(caluclatorElements[indexPath.row])
                let cell = collectionView.cellForItemAtIndexPath(indexPath)
                cell?.layer.borderWidth = 1
                
                
            }
            else if(caluclatorElements[indexPath.row].isMatch("=")){
                resultLabel.text = mCaluclation.equal()
            }
            else if(caluclatorElements[indexPath.row].isMatch("AC")){
                resultLabel.text = mCaluclation.clear()
            }
            else if(caluclatorElements[indexPath.row].isMatch("%")){
                resultLabel.text = mCaluclation.persent()
            }
        }
        else if(collectionView.tag == 2){
            resultLabel.text = mCaluclation.scientificFunction(scientificElements[indexPath.row], labelValue: resultLabel.text!)
        }
            
        if(resultLabel.text == "inf" || resultLabel.text == "nan"){
            resultLabel.text = "エラー"
            mCaluclation.clear()
        }
        previousLabelText = resultLabel.text!
        
    }
    
    func borderClear(){
        for cell in operatorCells.values{
            cell.layer.borderWidth = 0
        }
    }
    
    // Screenサイズに応じたセルサイズを返す
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // numberCollectionの設定
        var cellWidth:CGFloat
        let cellHeight:CGFloat
            // 正方形で返すためにwidth,heightを同じにする
        if(collectionView.tag == 1){
            
            if(indexPath.row == 16){//数字の0は幅が違うので0だけ別設定（indexpathが16）
                cellWidth = collectionView.frame.size.width / 2 - 1
            }else{
                cellWidth = collectionView.frame.size.width / 4 - 1
            }
            let cellHeight:CGFloat = collectionView.frame.height / 5
            
            return CGSizeMake(cellWidth, cellHeight)
        }// scientifiCollectionの設定
        else{
            cellWidth = collectionView.frame.size.width / 6 - 1
            cellHeight = collectionView.frame.size.height / 5
            return CGSizeMake(cellWidth, cellHeight)
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // numberCollectionの設定
        if(collectionView.tag == 1){
            return 19
        }// scientifiCollectionの設定
        else{
            return 30
        }
    }


}

