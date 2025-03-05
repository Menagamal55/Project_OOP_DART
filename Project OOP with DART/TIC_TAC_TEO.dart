import 'dart:io';

class TicTacToe {
  //🔹 List.generate(length, (index) => value)
 //🔹 List.filled(length, value, growable: false)

  List<List<String>> board = List.generate(3, (_) => List.filled(3, ' ', growable: false));
  String currentPlayer = 'X';

  void printBoard() {
    for (var row in board) {
      print(row.join(' | '));
      print('---------');
    }
  }

  bool makeMove(int row, int col) {
    if (row < 0 || row >= 3 || col < 0 || col >= 3 || board[row][col] != ' ') {
      print("Invalid move! Try again.");
      return false;
    }
    board[row][col] = currentPlayer;
    return true;
  }

  bool checkWinner() {
    // Check rows and columns
    for (int i = 0; i < 3; i++) {
      if (board[i][0] != ' ' && board[i][0] == board[i][1] && board[i][1] == board[i][2] ||
          board[0][i] != ' ' && board[0][i] == board[1][i] && board[1][i] == board[2][i]) {
        return true;
      }
    }
    // Check diagonals
    if (board[0][0] != ' ' && board[0][0] == board[1][1] && board[1][1] == board[2][2] ||
        board[0][2] != ' ' && board[0][2] == board[1][1] && board[1][1] == board[2][0]) {
      return true;
    }
    return false;
  }

  bool isBoardFull() {
    for (var row in board) {
      if (row.contains(' ')) return false;
    }
    return true;
  }

  void switchPlayer() {
    currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
  }

  void play() {
    while (true) {
      printBoard();
      print("Player $currentPlayer, enter your move (row and column: 0, 1, or 2):");
      int row = int.tryParse(stdin.readLineSync() ?? '') ?? -1;
      int col = int.tryParse(stdin.readLineSync() ?? '') ?? -1;

      if (!makeMove(row, col)) continue;

      if (checkWinner()) {
        printBoard();
        print("Player $currentPlayer wins!");
        break;
      }

      if (isBoardFull()) {
        printBoard();
        print("It's a draw!");
        break;
      }

      switchPlayer();
    }
  }
}

void main() {
  TicTacToe game = TicTacToe();
  game.play();
}


