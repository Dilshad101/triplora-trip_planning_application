class Expenses {
  int? totalexpense;
  int? balance;
  int? tripId;
  int? food;
  int? transport;
  int? hotel;
  int? other;
  Expenses(
      {this.totalexpense,
      this.food,
      this.hotel,
      this.other,
      this.transport,
      this.balance,
      this.tripId});

  Map<String, dynamic> toMap(Expenses expense) {
    return {
      'totalexpense': expense.totalexpense,
      'tripId': expense.tripId,
      'food': expense.food,
      'transport': expense.transport,
      'hotel': expense.hotel,
      'other': expense.other,
      'balance': expense.balance,
    };
  }
}