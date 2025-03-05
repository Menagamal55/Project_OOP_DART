import 'dart:io';

class Account {
  int accountNumber;
  int accountPassword;
  String accountName;
  double accountBalance;

//Named constructor
  Account({
    required this.accountNumber,
    required this.accountPassword,
    required this.accountName,
    required this.accountBalance,
  });

  void deposit(double amount) {
    accountBalance += amount;
  }

  bool withdraw(double amount) {
    if (accountBalance >= amount) {
      accountBalance -= amount;
      return true;
    }
    return false;
  }
}

abstract class Transaction {
  final int transactionId;
  Transaction(this.transactionId);
  double execute(Account account);
}

class Deposit extends Transaction {
  final double amount;
  Deposit(this.amount, super.transactionId);

  @override
  double execute(Account account) {
    account.deposit(amount);
    print("\nDeposit of \$${amount.toStringAsFixed(2)} to account ${account.accountNumber} completed.");
    print("New balance: \$${account.accountBalance.toStringAsFixed(2)}\n");
    return account.accountBalance;
  }
}

class Withdraw extends Transaction {
  final double amount;
  Withdraw(super.transactionId, this.amount);

  @override
  double execute(Account account) {
    if (account.withdraw(amount)) {
      print("\nWithdrawal of \$${amount.toStringAsFixed(2)} from account ${account.accountNumber} completed.");
      print("New balance: \$${account.accountBalance.toStringAsFixed(2)}\n");
    } else {
      print("\nTransaction failed: Insufficient balance.\n");
    }
    return account.accountBalance;
  }
}

class BalanceInquiry extends Transaction {
  BalanceInquiry(super.transactionId);

  @override
  double execute(Account account) {
    print("\nBalance Inquiry:");
    print("Account Number: ${account.accountNumber}");
    print("Current Balance: \$${account.accountBalance.toStringAsFixed(2)}\n");
    return account.accountBalance;
  }
}

class Transfer extends Transaction {
  final double amount;
  final Account recipient;

  Transfer(super.transactionId, this.amount, this.recipient);

  @override
  double execute(Account sender) {
    if (sender.withdraw(amount)) {
      recipient.deposit(amount);
      print("\nTransfer of \$${amount.toStringAsFixed(2)} from account ${sender.accountNumber} to account ${recipient.accountNumber} completed.");
      print("Sender's new balance: \$${sender.accountBalance.toStringAsFixed(2)}");
      print("Recipient's new balance: \$${recipient.accountBalance.toStringAsFixed(2)}\n");
    } else {
      print("\nTransfer failed: Insufficient balance.\n");
    }
    return sender.accountBalance;
  }
}

Account? login(List<Account> accounts) {
  print("\nWelcome to the Bank System. Please log in.");

  stdout.write("Enter your account number: ");
  int? enteredNumber = int.tryParse(stdin.readLineSync() ?? '');

  stdout.write("Enter your password: ");
  int? enteredPassword = int.tryParse(stdin.readLineSync() ?? '');

  for (var account in accounts) {
    if (account.accountNumber == enteredNumber &&
        account.accountPassword == enteredPassword) {
      print("\nLogin successful. Welcome, ${account.accountName}.\n");
      return account;
    }
  }

  print("\nInvalid account number or password. Please try again.\n");
  return null;
}

Account? findAccount(List<Account> accounts, int accountNumber) {
  return accounts.firstWhere(
    (account) => account.accountNumber == accountNumber,
    orElse: () => Account(accountNumber: -1, accountPassword: 0, accountName: "", accountBalance: 0),
  );
}

void main() {
  List<Account> accounts = [
    Account(accountNumber: 2006, accountPassword: 55555, accountName: "Menna Gamal", accountBalance: 5000),
    Account(accountNumber: 1234, accountPassword: 11111, accountName: "mohamed gamal", accountBalance: 3000),
    Account(accountNumber: 5678, accountPassword: 22222, accountName: "hema gamal", accountBalance: 7000),
  ];

  Account? account;
  
  while (account == null) {
    account = login(accounts);
  }

  bool running = true;
  while (running) {
    print("\nSelect a transaction:");
    print("1: Deposit");
    print("2: Withdraw");
    print("3: Balance Inquiry");
    print("4: Transfer Money");
    print("5: Exit");

    stdout.write("Your choice: ");
    String choice = stdin.readLineSync() ?? '5';

    switch (choice) {
      case '1':
        stdout.write("Enter amount to deposit: ");
        double amount = double.tryParse(stdin.readLineSync() ?? '0') ?? 0;
        if (amount > 0) {
          Transaction deposit = Deposit(amount, 1);
          deposit.execute(account);
        } else {
          print("\nInvalid amount. Please enter a positive number.\n");
        }
        break;

      case '2':
        stdout.write("Enter amount to withdraw: ");
        double amount = double.tryParse(stdin.readLineSync() ?? '0') ?? 0;
        if (amount > 0) {
          Transaction withdraw = Withdraw(1, amount);
          withdraw.execute(account);
        } else {
          print("\nInvalid amount. Please enter a positive number.\n");
        }
        break;

      case '3':
        Transaction balanceInquiry = BalanceInquiry(1);
        balanceInquiry.execute(account);
        break;

      case '4':
        stdout.write("Enter the recipient's account number: ");
        int? recipientNumber = int.tryParse(stdin.readLineSync() ?? '');

        if (recipientNumber == null) {
          print("\nInvalid account number.\n");
          break;
        }

        Account recipient = findAccount(accounts, recipientNumber)!;
        if (recipient.accountNumber == -1) {
          print("\nAccount not found.\n");
          break;
        }

        stdout.write("Enter amount to transfer: ");
        double amount = double.tryParse(stdin.readLineSync() ?? '0') ?? 0;
        if (amount > 0) {
          Transaction transfer = Transfer(1, amount, recipient);
          transfer.execute(account);
        } else {
          print("\nInvalid amount. Please enter a positive number.\n");
        }
        break;

      case '5':
        running = false;
        print("\nExiting... Thank you for using our bank system.\n");
        break;

      default:
        print("\nInvalid choice. Please select a valid option.\n");
    }
  }
}
