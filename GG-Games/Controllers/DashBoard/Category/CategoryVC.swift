//
//  CategoryVC.swift
//  GG-Games
//
//  Created by Morshed Alam on 23/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFlow
import RxDataSources

class CategoryVC: UIViewController,Stepper {

   
    let disposeBag = DisposeBag()
    private var caterGory:Category!

    var tableView: UITableView!
    
    var fullView: CGFloat = 0
    var partialView: CGFloat {
        return UIScreen.main.bounds.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        self.view.addSubview(tableView)
        tableView.register(cellType: CateGoryTableViewCell.self)
        tableView.allowsMultipleSelection = false
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(CategoryVC.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        tableView.contentInsetAdjustmentBehavior = .never
        bindingTableview()
        
    }
    
    func bindingTableview(){
        
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Category>>(configureCell: {
           dataSource, tableView, indexPath, category in
            
        let cell = tableView.dequeueReusableCell(for: indexPath) as CateGoryTableViewCell
        cell.gameTitle.text = category.title
        cell.gameImageView.image = category.image
        cell.selectionStyle = .none
        return cell
        
    })
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.from(optional: CategoryList.catergories)
            .map{[SectionModel(model: "Category", items: $0)]}
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        UserDefaults.standard.rx.observe(Int.self, Category.key)
            .map{$0!}.subscribe(onNext: { [unowned self] index in
                self.caterGory = CategoryList.catergories[index]
            }).disposed(by: disposeBag)

    
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                UserDefaults.standard.set(indexPath.row, forKey: Category.key)
            }).disposed(by: disposeBag)
        
        
        tableView.rx.itemDeselected
            .subscribe(onNext: { [unowned self] indexPath in
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
            }).disposed(by: disposeBag)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if (y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y , width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y  < 0 ? Double((y - fullView ) / -velocity.y) : Double((partialView / velocity.y) )
            
            
           // print(duration)
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView * 2 , width: self.view.frame.width, height: self.view.frame.height)
                    
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView , width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: { [weak self] _ in
                if ( velocity.y < 0 ) {
                    self?.tableView?.isScrollEnabled = true
                }
                if velocity.y >= 0 {
                    self?.step.accept(AppStep.gameCategoryComplete(category: (self?.caterGory)!))
                }
            })
        }
    }
    
    

    
    
    
}

extension CategoryVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0,y: 0,width: self.tableView.frame.width, height: 70))
        
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = headerView.bounds
        let colorTop = UIColor(red:0.44, green:0.42, blue:0.89, alpha:1.0).cgColor
        let colorBottom = UIColor(red:0.25, green:0.68, blue:0.99, alpha:1.0).cgColor
        gradient.colors = [colorTop, colorBottom]
        headerView.layer.insertSublayer(gradient, at: 0)
        
        
        
        let headerLabel = UILabel(frame: CGRect(x: 30,y: 20,width: self.tableView.frame.width,height: 25))
        headerLabel.textColor = UIColor.white
        headerLabel.font = UIFont(name: "Arial", size: 20)
        headerLabel.text = "Select Game Category"
        headerView.addSubview(headerLabel)
        
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }

}


extension CategoryVC: UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        if (y == fullView && tableView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
            tableView.isScrollEnabled = false
        } else {
            tableView?.isScrollEnabled = true
        }
        
        return false
    }
}
