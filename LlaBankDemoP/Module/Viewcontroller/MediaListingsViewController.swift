//
//  MediaListingsViewController.swift
//  LlaBankDemoP
//
//  Created by Niraj Paul on 16/11/21.
//

import UIKit

class MediaListingsViewController: UIViewController {
    
    var viewModel: MediaListingViewModel?
    // Array setUp
    private var contents: [Content] = []
    private var mainContent: [Content] = []
    
    // View Outlet
    @IBOutlet private weak var viewCarousal: UIView!
    @IBOutlet private weak var tableV: UITableView!
    @IBOutlet private weak var collectionV: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var scrollV: UIScrollView!
    @IBOutlet private weak var constraintCarusalHeight: NSLayoutConstraint!
    private var pages: Int?
    var isCarousalIsScrolled: Bool = false
    
    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    // ViewController Lift cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.callAPIGetMediaData()
        self.tableViewReload()
    }
    
    // ViewModel initailization and Api called
    func callAPIGetMediaData(){
        viewModel = MediaListingViewModel()
        viewModel?.delegate = self
        viewModel?.getMediaData(fileName: "CONTENTLIST")
    }
    
    // Reload Tableview and CollectionView
    func tableViewReload(){
        self.tableV.dataSource = self
        self.tableV.delegate = self
        self.collectionV.dataSource = self
        self.collectionV.delegate = self
        
    }
    
    // Checking TableView index cell 0 is visiable our not
    func isRowZeroVisible() -> Bool {
        let indexes = self.tableV.indexPathsForVisibleRows
        if let index = indexes {
            for idx in index {
                if idx.row  == 0{
                    return true
                }
            }
        }
        return false
    }
    
    // Get collectionView current page
    func getCurrentPage() -> Int {
        let visibleRect = CGRect(origin: collectionV.contentOffset, size: collectionV.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = collectionV.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        return currentPage
    }
    
}

// SearchBar Delagate Method
extension MediaListingsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        mainContent = textSearched.isEmpty ? contents : contents.filter{ $0.name.range(of: textSearched, options: .caseInsensitive) != nil }
        self.tableV.reloadData()
    }
    
}

// Data response delegate
extension MediaListingsViewController: MediaListingResponseDelegate {
    func mediaListingResonse(media: MediaListingBO){
        let contents = media.page.contentItems.content
        for content in contents {
            self.contents.append(content)
        }
        self.mainContent = self.contents
        pageControl.numberOfPages = contents.count
        self.tableV.reloadData()
        self.collectionV.reloadData()
        
    }
}

// Tableview datasource and delegate
extension MediaListingsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaListTableViewCell", for: indexPath)
            as! MediaListTableViewCell
        let content = mainContent[indexPath.row]
        cell.dataLoad(data: content)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let searchBar:UISearchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        headerView.addSubview(searchBar)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

// CollectionView datasource and delegate
extension MediaListingsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if indexPath.row == 0 {
            return CGSize(width: self.collectionV.frame.size.width-40, height: self.collectionV.frame.size.height)
        }
        return CGSize(width: self.collectionV.frame.size.width, height: self.collectionV.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarousalViewCollectionViewCell", for: indexPath)
            as? CarousalViewCollectionViewCell
        let content = contents[indexPath.row]
        cell?.setupCell(data: content)
        return cell ?? UICollectionViewCell()
    }
}

// Scrollview delegate method
extension MediaListingsViewController {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentPage = getCurrentPage()
        
        isCarousalIsScrolled = false
        if scrollView == self.collectionV {
            isCarousalIsScrolled = true
            self.mainContent.shuffle()
            self.tableV.reloadData()
        }
        
        if !isCarousalIsScrolled {
            if scrollView == self.tableV {
                UIView.animate(withDuration: 0.5) {
                    self.constraintCarusalHeight.constant = 0
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.mainContent.count<15 {
            return
        }
        let status  = self.isRowZeroVisible()
        if status {
            UIView.animate(withDuration: 0.3) {
                self.constraintCarusalHeight.constant = 300
                self.view.superview?.layoutIfNeeded()
            }
        }
    }
}
