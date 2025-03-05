import 'dart:io';
import 'dart:math';
void main(){
TicTacToe game = TicTacToe();
  game.startGame();

}
class TicTacToe {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ' '));
  String player = 'X';
  bool againstComputer = false;

  void startGame() {
    print("Welcome to Tic-Tac-Toe!");
    print("Do you want to play against the computer? (yes/no): ");
    String choice = stdin.readLineSync()!.toLowerCase();
    againstComputer = choice == 'yes';
    play();
  }

  void play() {
    while (true) {
      printBoard();
      if (againstComputer && player == 'O') {
        computerMove();
      } else {
        playerMove();
      }
      if (checkWin()) {
        printBoard();
        print("Player $player wins!");
        return;
      }
      if (isDraw()) {
        printBoard();
        print("It's a draw!");
        return;
      }
      player = player == 'X' ? 'O' : 'X';
    }
  }

  void playerMove() {
    print("Player $player, enter row and column (0-2): ");
    int row = int.parse(stdin.readLineSync()!);
    int col = int.parse(stdin.readLineSync()!);
    if (board[row][col] == ' ') {
      board[row][col] = player;
    } else {
      print("Cell already taken, try again");
      playerMove();
    }
  }

  void computerMove() {
    print("Computer is making a move...");
    Random random = Random();
    int row, col;
    do {
      row = random.nextInt(3);
      col = random.nextInt(3);
    } while (board[row][col] != ' ');
    board[row][col] = 'O';
  }

  void printBoard() {
    for (var row in board) {
      print(row.join(' | '));
    }
  }

  bool checkWin() {
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0] != ' ') return true;
      if (board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i] != ' ') return true;
    }
    if (board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0] != ' ') return true;
    if (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2] != ' ') return true;
    return false;
  }

  bool isDraw() {
    for (var row in board) {
      if (row.contains(' ')) return false;
    }
    return true;
  }
}