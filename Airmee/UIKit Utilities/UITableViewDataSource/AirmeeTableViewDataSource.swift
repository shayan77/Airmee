//
//  AirmeeTableViewDataSource.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/1/21.
//

import UIKit

/*
 
 This is AirmeeTableViewDataSource responsible for data source of simple tableViews.
 
 You can easily add new datas to array by confirming your tableViewCell to AirmeeTableViewCell.
 
 */

public protocol AirmeeTableViewDelegate: AnyObject {
    func tableView(cellForRowAt: IndexPath, cell: UITableViewCell)
    func tableView(willDisplay cellIndexPath: IndexPath, cell: UITableViewCell)
    func tableView(didEndDisplaying cellIndexPath: IndexPath, cell: UITableViewCell)
    func tableView(didSelectRowAt index: IndexPath)
    func tableView<T>(didSelectModelAt model: T)
}

extension AirmeeTableViewDelegate {
    func tableView(cellForRowAt: IndexPath, cell: UITableViewCell) { }
    func tableView(willDisplay cellIndexPath: IndexPath, cell: UITableViewCell) { }
    func tableView(didEndDisplaying cellIndexPath: IndexPath, cell: UITableViewCell) { }
    func tableView(didSelectRowAt index: IndexPath) { }
    func tableView<T>(didSelectModelAt model: T) { }
}

public class AirmeeTableViewDataSource<T: AirmeeTableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    /// return nil  or 0 for automaticDimension
    var cellHeight: CGFloat?
    
    var items: [T.CellViewModel]
    
    var tableView: UITableView
    
    public var cellAnimation: CellAnimationType
    
    public var shouldShowAnimationOncePerCell: Bool = true
    
    private var animatedCells: [Int] = []
    
    weak var delegate: AirmeeTableViewDelegate?
    
    public init(cellHeight: CGFloat?, items: [T.CellViewModel] = [], tableView: UITableView, delegate: AirmeeTableViewDelegate, animationType: CellAnimationType = .none) {
        self.cellHeight = cellHeight
        self.items = items
        self.tableView = tableView
        self.cellAnimation = animationType
        if cellHeight == 0 || cellHeight == nil {
            self.tableView.estimatedRowHeight = UITableView.automaticDimension
            self.tableView.rowHeight = UITableView.automaticDimension
        }
        
        // Register cell to TableView
        self.tableView.register(UINib(nibName: String.init(describing: T.self), bundle: nil), forCellReuseIdentifier: String.init(describing: T.self))
        
        self.delegate = delegate
    }
    
    // UITableViewDataSource and UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: T.self), for: indexPath) as! T
        cell.selectionStyle = .none
        cell.configureCellWith(items[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableView(didSelectModelAt: items[indexPath.row])
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let cell = cell as! T
        // Animate Cell
        if animatedCells.contains(indexPath.row) == false && shouldShowAnimationOncePerCell {
            CellAnimator.animateCellUsing(type: cellAnimation, cell: cell)
            animatedCells.append(indexPath.row)
        }
        // Delegate Call
        delegate?.tableView(willDisplay: indexPath, cell: cell)
    }
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.tableView(didEndDisplaying: indexPath, cell: cell)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellheight = cellHeight, cellHeight != 0 else { return UITableView.automaticDimension }
        return cellheight
    }
    
    public func appendItemsToTableView(_ newItems: [T.CellViewModel]) {
    
        guard newItems.count != 0 else {
            print("WARNING: YOU ARE ADDING EMPTY LIST TO TABLE VIEW")
            return
        }
        // append to last of list
        self.items.append(contentsOf: newItems)
        // Now performing insert
        // Get the last row index (numberOfRows - 1)
        var lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if lastRowIndex < 0 {
            lastRowIndex = 0
            self.tableView.reloadData()
        } else {
            // TODO: This NEEDS TO be more safer
            let indexPaths = newItems.enumerated().map { (index, _) -> IndexPath in
                IndexPath(item: items.count - 1 - index, section: 0)
            }
            if #available(iOS 11.0, *) {
                self.tableView.performBatchUpdates({
                    self.tableView.insertRows(at: indexPaths, with: .none)
                }, completion: nil)
            } else {
                self.tableView.insertRows(at: indexPaths, with: .none)
            }
        }
    }
    /// remove multiple items from tableView
    public func removeItemFromTableView(row: Int) {
        
        guard items.count != 0 else {
            print("WARNING: YOUR TABLE VIEW IS ALREADY EMPTY")
            return
        }
        guard row >= 0 else {
            assertionFailure("can't remove item at \(row)")
            return
        }
        // remove from datasource
        self.items.remove(at: row)
        let indexPathToRemove = IndexPath(row: row, section: 0)
        self.tableView.deleteRows(at: [indexPathToRemove], with: .fade)
    }
    
    public func refreshWithNewItems(_ newItems: [T.CellViewModel]) {
        self.animatedCells.removeAll()
        self.items = newItems
        self.tableView.reloadData()
    }
    
}
