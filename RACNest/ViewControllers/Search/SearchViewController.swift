//
//  SearchViewController.swift
//  RACNest
//
//  Created by Rui Peres on 20/01/2016.
//  Copyright © 2016 Rui Peres. All rights reserved.
//

import UIKit
import ReactiveCocoa

final class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerReusableCell(GenericTableCell)
                
        viewModel.result.producer.observeOn(QueueScheduler.mainQueueScheduler).startWithNext {[weak self] text in
            self?.tableView.reloadData()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText.value = searchText
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.result.value.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: GenericTableCell = tableView.dequeueReusableCell(indexPath: indexPath)

        let searchResultItem = viewModel.result.value[indexPath.row]
        let searchCellItem = SearchCellItem(title: searchResultItem, textBeingSearched: viewModel.searchText.value)
        
        cell.configure(searchCellItem)
        
        return cell
    }
}
