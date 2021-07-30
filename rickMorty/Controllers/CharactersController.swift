//
//  CharactersController.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import UIKit
import LUAutocompleteView
class CharactersController: UIViewController {
    @IBOutlet private weak var charColl: UICollectionView!
    @IBOutlet private weak var season: UILabel!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var airDate: UILabel!
    @IBOutlet private weak var searchField: UITextField!
    private let charactersViewModel = CharactersViewModel()
    private let filterVm = FilterVmChar()
    private let autoCompView = LUAutocompleteView()
    var charIds = [Int]()
    private var characters = [CharactersM]()
    private var filtered = [CharactersM]()
    var episode: EpisodeRes!
    private var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(autoCompView)
       Assign()
        loadData()
        AssignLayout()
    }
    private func Assign() {
        self.charColl.delegate = self
        self.charColl.dataSource = self
        self.airDate.text = episode.airDate
        self.season.text = episode.episode
        self.name.text = episode.name
        autoCompView.textField = searchField
        autoCompView.delegate = self
        autoCompView.dataSource = self
        autoCompView.autocompleteCell = CustomAutocompleteTableViewCell.self
        autoCompView.rowHeight = 45
        autoCompView.maximumHeight = 300
    }
    private func AssignLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.width / 2) - 32, height: 270)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        charColl.collectionViewLayout = layout
    }
    private func loadData() {
        charactersViewModel.fetch(charIds) { (chars) in
            self.characters.append(contentsOf: chars)
            DispatchQueue.main.async {
                self.charColl.reloadData()
            }
        }
    }
    @IBAction private func Back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let DetailsVc = segue.destination as? DetailsController{
            DetailsVc.charDetail = characters[selectedIndex]
            DetailsVc.episodesLinks = characters[selectedIndex].episode
        }
    }
    @IBAction private func searchText(_ sender: UITextField) {
        if sender.text?.isEmpty == false {
            filterVm.fetch(sender.text!) { (result) in
                self.filtered.removeAll()
                self.filtered.append(contentsOf: result.results)
            }
        }
        else {
            self.filtered.removeAll()
        }
    }
    
}
extension CharactersController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "goDetails", sender: nil)
    }
    
}
extension CharactersController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "charCell", for: indexPath) as! CharactersCell
        characters[indexPath.row].image.downloadImage { (image) in
            DispatchQueue.main.async {
                cell.charImg.image = image
            }
        }
        cell.charName.text = characters[indexPath.row].name
        if characters[indexPath.row].status != "Alive" {
            cell.charStatus.textColor = .red
            
        } else {
            cell.charStatus.textColor = .green
        }
        cell.charStatus.text = characters[indexPath.row].status
        return cell
    }
    
    
}
extension CharactersController: LUAutocompleteViewDataSource {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String, completion: @escaping ([String]) -> Void) {
        let elementsThatMatchInput = filtered.map{$0.name}.filter { $0.lowercased().contains(text.lowercased()) }
        completion(elementsThatMatchInput)
    }
}

// MARK: - LUAutocompleteViewDelegate
extension CharactersController: LUAutocompleteViewDelegate {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        characters = filtered
        selectedIndex = filtered.firstIndex(where: {$0.name == text})!
        print(text + " was selected from autocomplete view")
       performSegue(withIdentifier: "goDetails", sender: nil)
    }
}
