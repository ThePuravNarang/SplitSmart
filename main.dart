import 'dart:io';

class Member {
  String name;
  int totalPaid;
  double shareOwed;

  Member(this.name, {this.totalPaid = 0, this.shareOwed = 0});
}

class Expense {
  String title;
  int amount;
  String paidBy;
  String category;
  List<String> splitBetween;

  Expense({
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.category,
    required this.splitBetween,
  });

  double get sharePerPerson => amount / splitBetween.length;
}

class ExpenseGroup {
  final List<Member> members = [];
  final List<Expense> expenses = [];

  void addMember(String name) {
    String cleanName = name.trim();

    if (cleanName.isEmpty) {
      throw Exception('Member name cannot be empty.');
    }

    if (findMember(cleanName) != null) {
      throw Exception('A member named "$cleanName" already exists.');
    }

    members.add(Member(cleanName));
  }

  Member? findMember(String name) {
    for (Member member in members) {
      if (member.name.toLowerCase() == name.trim().toLowerCase()) {
        return member;
      }
    }
    return null;
  }

  void addExpense({
    required String title,
    required int amount,
    required String paidBy,
    required String category,
    required List<String> splitBetween,
  }) {
    if (title.trim().isEmpty) {
      throw Exception('Expense title cannot be empty.');
    }

    if (amount <= 0) {
      throw Exception('Expense amount must be greater than zero.');
    }

    if (findMember(paidBy) == null) {
      throw Exception('The payer "$paidBy" is not in this group.');
    }

    if (splitBetween.isEmpty) {
      throw Exception('Select at least one participant.');
    }

    for (String participant in splitBetween) {
      if (findMember(participant) == null) {
        throw Exception('The participant "$participant" is not in this group.');
      }
    }

    Set<String> uniqueParticipants = {};
    for (String participant in splitBetween) {
      uniqueParticipants.add(participant.toLowerCase());
    }

    if (uniqueParticipants.length != splitBetween.length) {
      throw Exception('A participant cannot be added more than once.');
    }

    Expense expense = Expense(
      title: title.trim(),
      amount: amount,
      paidBy: findMember(paidBy)!.name,
      category: category.trim().isEmpty ? 'Other' : category.trim(),
      splitBetween: splitBetween.map((name) => findMember(name)!.name).toList(),
    );

    expenses.add(expense);
    findMember(paidBy)!.totalPaid += amount;

    double share = expense.sharePerPerson;
    for (String participant in expense.splitBetween) {
      findMember(participant)!.shareOwed += share;
    }
  }

  void listExpenses() {
    if (expenses.isEmpty) {
      print('No expenses have been added yet.');
      return;
    }

    print('\n--- All Expenses ---');
    for (int i = 0; i < expenses.length; i++) {
      Expense expense = expenses[i];
      print(
        '${i + 1}. ${expense.title} | INR ${expense.amount} | '
        'Paid by: ${expense.paidBy} | Category: ${expense.category} | '
        'Split between: ${expense.splitBetween.join(', ')}',
      );
    }
  }

  void filterExpensesByMember(String name) {
    if (findMember(name) == null) {
      print('Unknown member: $name');
      return;
    }

    bool found = false;
    print('\n--- Expenses involving $name ---');

    for (Expense expense in expenses) {
      bool isPayer = expense.paidBy.toLowerCase() == name.toLowerCase();
      bool isParticipant = expense.splitBetween.any(
        (participant) => participant.toLowerCase() == name.toLowerCase(),
      );

      if (isPayer || isParticipant) {
        print('${expense.title} | INR ${expense.amount} | ${expense.category}');
        found = true;
      }
    }

    if (!found) {
      print('No expenses found for $name.');
    }
  }

  void filterExpensesByCategory(String category) {
    bool found = false;
    print('\n--- Expenses in category: $category ---');

    for (Expense expense in expenses) {
      if (expense.category.toLowerCase() == category.trim().toLowerCase()) {
        print('${expense.title} | INR ${expense.amount} | Paid by: ${expense.paidBy}');
        found = true;
      }
    }

    if (!found) {
      print('No expenses found in this category.');
    }
  }

  void printBalances() {
    print('\n--- Member Balances ---');

    for (Member member in members) {
      double balance = member.totalPaid - member.shareOwed;
      String status;

      if (balance > 0) {
        status = 'should receive INR ${balance.toStringAsFixed(2)}';
      } else if (balance < 0) {
        status = 'owes INR ${(-balance).toStringAsFixed(2)}';
      } else {
        status = 'is settled up';
      }

      print(
        '${member.name}: Paid INR ${member.totalPaid}, '
        'share INR ${member.shareOwed.toStringAsFixed(2)}, $status.',
      );
    }
  }
}

void main() {
  final group = ExpenseGroup();

  // Add the group members.
  group.addMember('Asha');
  group.addMember('Ravi');
  group.addMember('Neha');

  // Add expenses with different payers.
  group.addExpense(
    title: 'Dinner',
    amount: 900,
    paidBy: 'Asha',
    category: 'Food',
    splitBetween: ['Asha', 'Ravi', 'Neha'],
  );

  group.addExpense(
    title: 'Cab',
    amount: 300,
    paidBy: 'Ravi',
    category: 'Travel',
    splitBetween: ['Asha', 'Ravi', 'Neha'],
  );

  // Show the results.
  group.listExpenses();
  group.printBalances();

  // Examples of filtering.
  group.filterExpensesByMember('Asha');
  group.filterExpensesByCategory('Food');
}
