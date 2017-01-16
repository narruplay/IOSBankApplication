//
//  MasterViewController.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 13.12.16.
//  Copyright © 2016 Adel Khaziakhmetov. All rights reserved.
//

import UIKit

let MASTER_DETAIL_SEGUE = "showDetail"

class MasterViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate{
    
    var detailViewController : UINavigationController?
    var masterModel : MasterViewModel = MasterViewModel()
    
    var searchController : UISearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        
        detailViewController = self.splitViewController?.viewControllers.last as? UINavigationController
        
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = .gray
        self.refreshControl?.addTarget(self, action: #selector(reloadTableData), for: UIControlEvents.valueChanged)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        
        self.title = "Список банков"
        
        self.tableView.register(TableCustomCell.self, forCellReuseIdentifier: "Cell")
    
        updateTable()
    
    }
    
    func reloadTableData(){
        
        if DataManager.sharedInstance.isUpdatable{
            ServiceProvider.sharedInstance.bankListIndex = 1
            ServiceProvider.sharedInstance.getBankList { (call) in
                if call.object != nil{
                    self.masterModel.bankArray = call.object!
                    MainThreadExecuter.execute {
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                }else{
                    AlertController.sharedInstance.handleCallbackError(error: call.error!, retryAction: {self.reloadTableData()})
                    MainThreadExecuter.execute {
                         self.refreshControl?.endRefreshing()
                    }
                }
            }
        }
        
       
    }
    
    func updateTable(){
        ServiceProvider.sharedInstance.getBankList { (call) in
            if call.object != nil{
                self.masterModel.bankArray = call.object!
                MainThreadExecuter.execute {
                    self.tableView.reloadData()
                }
            }else{
                AlertController.sharedInstance.handleCallbackError(error: call.error!, retryAction: {self.updateTable()})
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController){
        
        let call = DataManager.sharedInstance.getBankFor(searchString: (searchController.searchBar.text)!)
        
        guard call.error != CallbackError.DataBaseReadError else{
            AlertController.sharedInstance.handleCallbackError(error: call.error!, retryAction : nil)
            return
        }
        
        if call.error == nil {
            masterModel.bankSearchArray = call.object!
            tableView.reloadData()
        }else if searchController.searchBar.text != ""{
            masterModel.bankSearchArray = [BankModel]()
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        tableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MASTER_DETAIL_SEGUE{
            let destination = (segue.destination as? UINavigationController)?.topViewController
            
            let row = tableView.indexPathForSelectedRow?.row
            if searchController.isActive && (searchController.searchBar.text != ""){
                destination?.title = masterModel.bankSearchArray[row!].bankName;
                (destination as! DetailViewController).bankModel = masterModel.bankSearchArray[row!];
            }else{
                destination?.title = masterModel.bankArray[row!].bankName;
                (destination as! DetailViewController).bankModel = masterModel.bankArray[row!];
            }
           
            destination?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            destination?.navigationItem.leftItemsSupplementBackButton = true
            (destination as? DetailViewController)!.isShown = true
        }
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && (searchController.searchBar.text != ""){
            return masterModel.bankSearchArray.count
        }else{
            return masterModel.bankArray.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if searchController.isActive && (searchController.searchBar.text != ""){
            cell.textLabel?.text = masterModel.bankSearchArray[indexPath.row].bankName;
            cell.detailTextLabel?.text = masterModel.bankSearchArray[indexPath.row].bankBIK;
        }else{
            cell.textLabel?.text = masterModel.bankArray[indexPath.row].bankName;
            cell.detailTextLabel?.text = masterModel.bankArray[indexPath.row].bankBIK;
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: MASTER_DETAIL_SEGUE, sender: self)
    
    }

}




