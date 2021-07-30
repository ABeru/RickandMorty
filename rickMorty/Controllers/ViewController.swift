//
//  ViewController.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import UIKit
import LUAutocompleteView
class ViewController: UIViewController {
    @IBOutlet private weak var searchName: UITextField!
    @IBOutlet private weak var epCollection: UICollectionView!
    private let autoCompView = LUAutocompleteView()
    private let epsViewModel = EpsViewModel()
    var episodes = [EpisodeRes]()
    private var characterIds = [[Int]]()
    private var selectedIndex = 0
    private let filtervm = FilterVmEp()
    private var filtered = [EpisodeRes]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(autoCompView)
    Assign()
    AssignLayout()
          }
    private func Assign() {
        epCollection.delegate = self
        epCollection.dataSource = self
        autoCompView.textField = searchName
        autoCompView.delegate = self
        autoCompView.dataSource = self
        autoCompView.autocompleteCell = CustomAutocompleteTableViewCell.self
        autoCompView.rowHeight = 45
        autoCompView.maximumHeight = 300
        loadEpisodes()
    }
    private func AssignLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.width / 2) - 32, height: 140)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        epCollection.collectionViewLayout = layout
    }
    private func loadEpisodes() {
        epsViewModel.fetch() { (result) in
            self.episodes.append(contentsOf: result.results)
            DispatchQueue.main.async {
                self.epCollection.reloadData()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let CharVc = segue.destination as? CharactersController{
            let lastChar = self.episodes[0].characters[0].lastIndex(of: "/")
            let tempArr = self.episodes.map{$0.characters.map{$0.substring(from: lastChar!).dropFirst()}}
            CharVc.charIds = tempArr[selectedIndex].map{Int($0)!}
            CharVc.episode = episodes[selectedIndex]
        }
    }
    @IBAction private func searchTextChanged(_ sender: UITextField) {
        if sender.text?.isEmpty == false {
            filtervm.fetch(sender.text!) { (result) in
                self.filtered.removeAll()
                self.filtered.append(contentsOf: result.results)
            }
        }
            else {
                self.filtered.removeAll()
            }
        }
    }
    
    
extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "goChar", sender: self)
    }
}
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episodesCell", for: indexPath) as! epCollCell
        cell.episode.text = episodes[indexPath.row].episode
        cell.name.text = episodes[indexPath.row].name
        cell.airDate.text = episodes[indexPath.row].airDate
        return cell
        
    }
    
    
}
extension ViewController: LUAutocompleteViewDataSource {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String, completion: @escaping ([String]) -> Void) {
        let elementsThatMatchInput = filtered.map{$0.name}.filter { $0.lowercased().contains(text.lowercased()) }
        completion(elementsThatMatchInput)
    }
}

// MARK: - LUAutocompleteViewDelegate
extension ViewController: LUAutocompleteViewDelegate {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        episodes = filtered
        selectedIndex = filtered.firstIndex(where: {$0.name == text})!
        print(text + " was selected from autocomplete view")
        performSegue(withIdentifier: "goChar", sender: nil)
    }
}
