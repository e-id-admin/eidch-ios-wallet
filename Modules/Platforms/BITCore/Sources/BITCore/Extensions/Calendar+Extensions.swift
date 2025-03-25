import Foundation

extension Calendar {

  public func numberOfDaysBetween(_ from: Date, and to: Date) -> Int? {
    let fromDate = startOfDay(for: from)
    let toDate = startOfDay(for: to)
    let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
    return numberOfDays.day
  }
}
