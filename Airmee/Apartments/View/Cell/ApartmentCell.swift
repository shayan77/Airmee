//
//  ApartmentCell.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/2/21.
//

import UIKit

protocol ApartmentCellDetailButtonDelegate: AnyObject {
    func apartmentDetail(for apartment: Apartment)
}

class ApartmentCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var idLbl: UILabel!
    @IBOutlet var bedCountsLbl: UILabel!
    @IBOutlet var detailBtn: UIButton!
    
    weak var apartmentDetailButtonDelegate: ApartmentCellDetailButtonDelegate?
    var apartment: Apartment!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    private func setupView() {
        
        // detailBtn
        detailBtn.layer.cornerRadius = 6.0
        detailBtn.addTarget(self, action: #selector(didSelectDetailButton), for: .touchUpInside)
        
        // cellView
        cellView.layer.borderWidth = 1.0
        cellView.layer.cornerRadius  = 15.0
        cellView.layer.borderColor = UIColor.opaqueSeparator.cgColor
    }
    
    @objc func didSelectDetailButton() {
        self.apartmentDetailButtonDelegate?.apartmentDetail(for: apartment)
    }
}

extension ApartmentCell: AirmeeTableViewCell {
    func configureCellWith(_ item: Apartment) {
        self.apartment = item
        
        nameLbl.text = item.name ?? ""
        idLbl.text = "id: \(item.id ?? "")"
        if let bedrooms = item.bedrooms {
            bedCountsLbl.text = "\(bedrooms) bed"
            if bedrooms > 1 {
                bedCountsLbl.text?.append("s")
            }
        }
    }
}
