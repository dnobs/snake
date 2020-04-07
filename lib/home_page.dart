import 'package:flutter/material.dart';
import 'package:snake/snake_game_objects.dart';
import 'dart:math';
import 'dart:async';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int gameGridSize;
  List<int> buttons;
  SnakeBody snake;
  Food food;
  var random;
  var speed;
  Timer snakeMover;
  int highScore = 0;

  @override
  void initState(){
    // initalize variables
    random = Random();
    gameGridSize = 20;
    buttons = [1, 3, 5, 7];
    super.initState();
    speed = Duration(milliseconds: 500);

    // start game & put food out there!
    newGame();
    food = placeFood();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Snake            High Score: " + highScore.toString()),
      ),

      body: Column(
        children: <Widget>[

          // Game Area
          Expanded(
            child: AspectRatio(
              child: GridView.builder(
                padding: const EdgeInsets.all(30.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gameGridSize,
                  childAspectRatio: 1.0, // ensures each cell is a square
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                  ),
                itemCount: pow(gameGridSize, 2),
                itemBuilder: (context, i) => Container(
                  child: Center(
                  ),
                  color: getCellColor(i),
                ),
              ),
              aspectRatio: 1,
            ),
            flex: 3,
          ),

          // Controls Area
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1,
                ),
                itemCount: 9,
                itemBuilder: (context, i) => RaisedButton(
                  color: buttons.contains(i) ? Colors.red: Colors.grey[100],
                  onPressed: (){updateDirection(i);},
                )
              ),
            ),
            flex: 2,
          )

        ],
        mainAxisSize: MainAxisSize.max,
      )
    );
  }

  // get xy co-ordiates for a given cell and grid size
  List<int> getCords(int i){
    var loc = [i % gameGridSize, (i / gameGridSize).floor()];
    return loc;
  }

  // button controls
  void updateDirection(int button){
    if(button == 1) snake.changeDirection('up');
    if(button == 5) snake.changeDirection('right');
    if(button == 7) snake.changeDirection('down');
    if(button == 3) snake.changeDirection('left');

    // for testing:
    if(button == 4) moveSnake();
    if(button == 8) snake = SnakeBody([snake.head], snake.dir);
    if(button == 2) {
      snakeMover.cancel();
      speed = Duration(milliseconds: 200);
      snakeMover = Timer.periodic(speed, (Timer t) => moveSnake());
    }
  }

  Food placeFood(){
    List<int> loc;
    do {
      loc = [
        random.nextInt(gameGridSize),
        random.nextInt(gameGridSize)
      ];

    } while (snake.at(loc)); //ie until snake is not at the location of the food

    return Food(loc);
  }

  void moveSnake(){
    // update graphics
    setState((){
      // move head forwards
      List<int> newHead = snake.nextLoc();

      // if the snake will go off the board or hit itself, end game
      if(!onBoard(newHead) || snake.at(newHead)){
        gameOver();
      } else {
        // if everything is ok, continue moving
        snake.move();

        // if found food
        if (snake.at(food.loc)) {
          snake.grow(food.loc);
          // place new food on the board
          food = placeFood();
          // update speed
          //        snakeMover = Timer.periodic(speed, (Timer t) => moveSnake());
        }
      }
    });
  }

  Color getCellColor(int i){
    if (snake.stuffed(getCords(i))) {
      return Colors.red[900];
    } else if (snake.at(getCords(i))){
      return Colors.red;
    } else if (food.at(getCords(i))) {
      return Colors.green;
    } else {
      return Colors.grey[200];
    }
  }

  bool onBoard(List<int> point){
    return (
        (point[0] >= 0) &&
        (point[1] >= 0) &&
        (point[0] < gameGridSize ) &&
        (point[1] < gameGridSize)
    );
  }

  void gameOver(){
    snakeMover.cancel();
    updateHighScore(snake.length);
    print("game over");
    _showWinDialog(score: snake.length.toString());
  }

  void _showWinDialog({String score}){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('GAME OVER! YOUR SCORE: ' + score),
          actions: <Widget>[
            FlatButton(
              child: Text('Play Again!'),
              onPressed: (){
                newGame();
                Navigator.of(context).pop();
              }
            )
          ]

        );
      }
    );
  }

  void newGame(){
    List<List<int>> start = [[
      random.nextInt(gameGridSize),
      random.nextInt(gameGridSize)
    ]];

    int i = random.nextInt(3);
    List<String> directions = ['up', 'right', 'down', 'left'];
    String randomDirection = directions[i];

    snake = SnakeBody(start, randomDirection);
    speed = Duration(milliseconds: 200);
    snakeMover = Timer.periodic(speed, (Timer t) => moveSnake());
  }

  void updateHighScore(newScore){
    if(newScore > highScore) highScore = newScore;
  }

}