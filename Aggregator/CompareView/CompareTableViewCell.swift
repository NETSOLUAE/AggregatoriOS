//
//  CompareTableViewCell.swift
//  Aggregator
//
//  Created by Mac Mini on 9/16/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit

protocol BuyDelegate: class {
    func didBuyButtonPrssed(params: String)
}

class CompareTableViewCell : UITableViewCell {
    weak var buyDelegate: BuyDelegate?
    var selectedCompanyProductID = [String]()
    var selectedCovers = [String]()
    var coverPremiumTextArray = [String]()
    var covertext = ""
    var coverSelected = false
    var attributeHeight = 0
    var feeHeight = 0
    var coverPremiumHeight = 0
    var selectedCompanyDetails = [COMPANY_DETAILS]()
    let constants = Constants()
    let webserviceManager = WebserviceManager();
    
    var coverArray = [UIStackView?](repeating: nil, count: 30)
//    var tasks = [URLSessionDataTask?](repeating: nil, count: 30)
    
    @IBOutlet weak var collectionView: UICollectionView!
}

extension CompareTableViewCell : UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCompanyDetails.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = 0
        if (indexPath.row == 0) {
            width = 120
        } else {
            width = 240
        }
        let height = 315+(attributeHeight*18)+(coverPremiumHeight*18)+(feeHeight*18)+((selectedCovers.count * 15) + (selectedCovers.count * 5))
        let size = CGSize(width: width, height: height)
        return size
        
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths{
            requestView(forIndex: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompareCell", for: indexPath) as! CompareCellView
        cell.attributeHeightConstraint.constant = CGFloat(attributeHeight * 18)
        cell.feesHeightConstraint.constant = CGFloat(feeHeight * 18)
        cell.coverPremiumHeightConstraint.constant = CGFloat(coverPremiumHeight * 18)
        cell.coverHeightConstraint.constant = CGFloat((selectedCovers.count * 15) + (selectedCovers.count * 5))
        let indexCount = indexPath.row
        print(indexCount)
        if (indexPath.row == 0) {
            cell.companyName.font = UIFont.systemFont(ofSize: 12.0)
            cell.companyName.text = "Company Name"
            cell.productName.text = "Product Name"
            cell.primium.text = "Primium"
            cell.coverHeading.text = "Covers"
            cell.attributes.text = "Attributes"
            cell.fees.text = "Fees"
            cell.tax.text = "Tax"
            cell.coverPremium.text = "Cover Premium"
            
            cell.coverHeading.isHidden = false
            cell.buyButton.isHidden = true
            cell.covers.isHidden = true
        } else {
            cell.coverHeading.isHidden = true
            cell.buyButton.isHidden = false
            cell.covers.isHidden = false
            cell.companyName.font = UIFont.boldSystemFont(ofSize: 12.0)
            let company = selectedCompanyDetails[indexPath.row-1 ] as COMPANY_DETAILS
            cell.companyName.text = company.insurerName
            cell.productName.text = company.productName
            if (coverSelected) {
                cell.primium.text = "\(company.totalPremium!)\(" OMR")"
            } else {
                cell.primium.text = "\(company.premiumAmount!)\(" OMR")"
            }
            cell.attributes.text = company.attribute
            cell.fees.text = company.fees
            cell.tax.text = company.tax
            cell.coverPremium.text = coverPremiumTextArray[indexPath.row - 1]
            cell.cellDelegate = self
            cell.buyButton.tag = indexPath.row-1
            
            if let stackView = coverArray[indexPath.row] {
                cell.covers.addSubview(stackView)
                stackView.topAnchor.constraint(equalTo: cell.covers.topAnchor,
                                                                constant: 5).isActive=true
                stackView.leftAnchor.constraint(equalTo: cell.covers.leftAnchor, constant: -5).isActive = true
            }
            else {
                requestView(forIndex: indexPath)
            }
        }
        return cell;
    }
    
    func requestView(forIndex: IndexPath) {
        if coverArray[forIndex.row] != nil {
            // Image is already loaded
            return
        }
        getTask(indexPath: forIndex)
    }
    
    
    func getTask(indexPath: IndexPath) -> Void {
        DispatchQueue.main.async() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let compareController = storyboard.instantiateViewController(withIdentifier: "CompareViewController") as! CompareViewController
            let company = self.selectedCompanyDetails[indexPath.row-1 ] as COMPANY_DETAILS
            compareController.getCoverNames(productID: company.productID!)
            let covers = compareController.coverController.fetchedObjects
            //Stack View Vertical
            let stackViewV   = UIStackView()
            stackViewV.tag = indexPath.row
            stackViewV.axis  = UILayoutConstraintAxis.vertical
            stackViewV.distribution  = UIStackViewDistribution.equalSpacing
            stackViewV.alignment = UIStackViewAlignment.center
            stackViewV.spacing   = 5.0
            stackViewV.translatesAutoresizingMaskIntoConstraints = false
            
            var j = 0
            for selectedCover in self.selectedCovers {
                let coverName = selectedCover
                var exist = false
                let stringValue = String(indexPath.row) + String(j)
                
                //Image View
                let imageView = UIImageView()
                imageView.backgroundColor = UIColor.clear
                imageView.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
                imageView.widthAnchor.constraint(equalToConstant: 12.0).isActive = true
                
                for cover in covers! {
                    let covername = cover.coverName
                    if (covername == coverName) {
                        exist = true
                        break
                    }
                }
                if (exist) {
                    imageView.image = UIImage(named: "right")
                } else {
                    imageView.image = UIImage(named: "wrong")
                }
//                if (self.selectedCovers.count == covers?.count){
//                    imageView.image = UIImage(named: "right")
//                } else {
//                    for cover in covers! {
//                        let covername = cover.coverName
//                        if (covername == coverName) {
//                            exist = true
//                            break
//                        }
//                    }
//                    if (exist) {
//                        imageView.image = UIImage(named: "right")
//                    } else {
//                        imageView.image = UIImage(named: "wrong")
//                    }
//                }
                
                //Text Label
                let textLabel = UILabel()
                textLabel.backgroundColor = UIColor.clear
                textLabel.font = UIFont.systemFont(ofSize: 12.0)
                textLabel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
                textLabel.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
                textLabel.text  = coverName
                textLabel.textAlignment = .left
                
                //Stack View Horizontal
                let stackView   = UIStackView()
                stackView.tag = Int(stringValue)!
                stackView.axis  = UILayoutConstraintAxis.horizontal
                stackView.distribution  = UIStackViewDistribution.equalSpacing
                stackView.alignment = UIStackViewAlignment.center
                stackView.spacing   = 8.0
                
                stackView.addArrangedSubview(imageView)
                stackView.addArrangedSubview(textLabel)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                
                stackViewV.addArrangedSubview(stackView)
                stackViewV.translatesAutoresizingMaskIntoConstraints = false
                
                stackViewV.addSubview(stackView)
                j = j + 1;
            }
            self.coverArray[indexPath.row] = stackViewV
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
}

extension CompareTableViewCell : CompareDelegate {
    func didPressButton(sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let compareController = storyboard.instantiateViewController(withIdentifier: "CompareViewController") as! CompareViewController
        LoadingIndicatorView.show("Fetching...")
        let indexPath = IndexPath(item: sender.tag, section: 0)
        var company: COMPANY_DETAILS;
        company = selectedCompanyDetails[indexPath.row] as COMPANY_DETAILS
        print("I have pressed a button with a tag: \(sender.tag)")
        
        currentCompanySelected.companyName = company.insurerName!
        currentCompanySelected.companyProductID = company.productID!
        currentCompanySelected.totalPremium = company.totalPremium!
        
        let userId = compareController.getUserId(nationalID: currentSelection.nationalID)
        var params = ""
        params = params + "\(constants.BASE_URL)\("savePolicy&id=")\(userId)\("&company_id=")\(company.productID ?? "")"
        compareController.getCoverNames(productID: company.productID!)
        let covers = compareController.coverController.fetchedObjects
        var appendedCover = ""
        var i = 0
        for cover in covers! {
            let coverId = cover.coverID ?? ""
            let coverName = cover.coverName ?? ""
            appendedCover = appendedCover + "\("&add_ons[")\(i)\("][add_on_id]=")\(coverId)\("&add_ons[")\(i)\("][title]=")\(coverName)\("&add_ons[")\(i)\("][status]=Yes"))"
            i = i + 1
        }
        params = params + appendedCover
        let encodedHost = NSString(format: params as NSString).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        buyDelegate?.didBuyButtonPrssed(params: encodedHost)
    }
}
