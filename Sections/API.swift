import Foundation

private extension Collection {
  func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}

struct API {
  static func fetchFavorites(completion: @escaping ([String])-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
      let selected = Array(["Red", "Blue", "Aquamarine", "'Seafoam'", "Oak", "A Sunset From Your Childhood"].choose(3))
      
      completion(selected)
    }
  }
  
  static func fetchOther(completion: @escaping ([String])-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
      let selected = Array(["Pink", "Green", "Ugly Seafoam", "Really, Really Pink", "Everything but Blue", "Grass During a Really Good Time in a Park", "The Clouds on Sad Day", "The Moon on Your Last Night At Camp, When You Talked With Your Crush For Hours", "Rosso corsa"].choose(3))
      
      completion(selected)
    }
  }
}
