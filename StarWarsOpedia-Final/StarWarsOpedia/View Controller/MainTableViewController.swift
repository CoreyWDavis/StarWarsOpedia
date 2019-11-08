/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class MainTableViewController: UITableViewController {
  
  var films: [Film] = []
  var selectedItem: Any?
  var starships: [Starship] = []
  var isSearching = false
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    fetchFilms()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isSearching ? starships.count : films.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
    if !isSearching {
      let film = films[indexPath.row]
      cell.textLabel?.text = film.title
      cell.detailTextLabel?.text = "Episode \(film.id)"
    } else {
      let starship = starships[indexPath.row]
      cell.textLabel?.text = starship.name
      cell.detailTextLabel?.text = starship.model
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if !isSearching {
      selectedItem = films[indexPath.row]
    } else {
      selectedItem = starships[indexPath.row]
    }
    return indexPath
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let destinationVC = segue.destination as? DetailViewController else {
      return
    }
    destinationVC.data = selectedItem
  }
}

// MARK: - UISearchBarDelegate
extension MainTableViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let shipName = searchBar.text else { return }
    isSearching = true
    searchStarships(for: shipName)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    isSearching = false
    searchBar.text = nil
    searchBar.resignFirstResponder()
    tableView.reloadData()
  }
}

// MARK: - SWAPI
extension MainTableViewController {
  func fetchFilms() {
    SWAPI.fetch(SWAPI.baseEndpoint + "films") { [weak self] (films: Films?) in
      self?.films = films?.all ?? [Film]()
      self?.tableView.reloadData()
    }
  }
  
  func searchStarships(for name: String) {
    SWAPI.searchForStarships(name: name) { [weak self] (starships) in
      if let starships = starships {
        self?.starships = starships
      }
      self?.tableView.reloadData()
    }
  }
}
