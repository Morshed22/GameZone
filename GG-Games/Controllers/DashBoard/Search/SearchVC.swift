//
//  SearchVC.swift
//  GG-Games
//
//  Created by Morshed Alam on 3/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa
import RxDataSources

class SearchVC: UIViewController, StoryboardSceneBased, Stepper, BindableType {
    
static let sceneStoryboard = UIStoryboard(name: "Search", bundle: nil)
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    let disposeBag =  DisposeBag()
     var viewModel:SearchViewModeling!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addSearchController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addSearchController(){
       
       // self.tableView.separatorStyle = .none
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar
        tableView.rowHeight = 70
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        searchController.searchBar.placeholder = "Search Games"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.setValue("Done", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .white
        _ = searchController.searchBar.subviews[0].subviews.filter({$0.isKind(of: UITextField.self)}).map(
            {$0.tintColor = .lightGray})
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func bindViewModel() {
        
//        Observable.from(optional: GameData().game)
//            .filter{$0 != nil}
//             .map{$0!}
//            .map {games in games.filter{$0.favorite == 1}}
//            .subscribe(onNext:{ games in
//                print("******************************************")
//                print(games.count)
//            }).disposed(by: disposeBag)
//
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, SearchTableViewCellModeling>>(configureCell: {
            dataSource, tableView, indexPath, searchCellViewModel in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
            cell.viewModel = searchCellViewModel
            cell.selectionStyle = .none
            return cell
            
        })
        
        viewModel.gameListCell
            .asObservable()
            .map{[SectionModel(model: "SearchItem", items: $0)]}
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
//        Observable.from(optional: CategoryList.catergories)
//            .map{[SectionModel(model: "SearchItem", items: $0)]}
//            .bind(to: tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)

        
        
   }

}


extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchQuery.accept(searchController.searchBar.text ?? "")
    }
    
    
}

