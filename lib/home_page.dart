import 'package:flutter/material.dart';
import 'package:snake/snake_game_objects.dart';
import 'dart:math';
import 'dart:async';
import 'dart:core';

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
  int speed;
  Timer snakeMover;
  int highScore;
  // TODO: implement persistent high score
  // TODO: implement settings page
  // TODO: examine performance, eg frames per second for different board sizes

  @override
  void initState(){
    // initalize variables
    speed = 300;
    highScore = 0;
    random = Random();
    gameGridSize = 10;
    buttons = [1, 3, 5, 7];
    super.initState();

    // start game & put food out there!
    newGame();
    food = placeFood();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("SNAKE GAME"),
        actions: <Widget>[
          IconButton(
            onPressed: newGame,
            icon: Icon(Icons.refresh),
          ),
          IconButton(
              onPressed: (){
                print('pressed');
              },
              icon: Icon(Icons.settings),
          )
        ],
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
            child: Center(
              child: AspectRatio(
                child: Draggable(
                  child: Container(
                    color: Colors.blue[200],
                  ),
                  feedback: Container(
                    color: Colors.black,
                  ),
                  onDragEnd: (details){
                    updateDirection(details);
                    },
                ),
                aspectRatio: 1.0,
              ),
            ),
            flex: 2,
          ),

          SizedBox(
            height: 50,
          ),

          AppBar(
            title: Text("HIGH SCORE: " + highScore.toString()),
            actions: <Widget>[
              IconButton(
                  onPressed: (){
                    snakeMover.isActive ? resumeGame() : pauseGame();
                  },
                  icon: snakeMover.isActive ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              )
            ],

          ),
        ],
      )
    );
  }

  // get xy co-ordiates for a given cell and grid size
  List<int> getCords(int i){
    var loc = [i % gameGridSize, (i / gameGridSize).floor()];
    return loc;
  }

  // button controls
  void updateDirection(DraggableDetails dragDetails){
    List<double> velocity = [
      dragDetails.velocity.pixelsPerSecond.dx,
      dragDetails.velocity.pixelsPerSecond.dy
    ];

    if(velocity[0] == 0 && velocity[1] == 0)
      // no drag, do nothing
      return;
    if (velocity[0].abs() > velocity[1].abs()){
      if(velocity[0] > 0) snake.changeDirection('right');
      else                snake.changeDirection('left');
    } else {
      if(velocity[1] > 0) snake.changeDirection('down');
      else                snake.changeDirection('up');
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
      barrierDismissible: true,
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

  List<int> generateRandomPoint(){
    return [
      random.nextInt(gameGridSize),
      random.nextInt(gameGridSize)
    ];
  }

  String generateRandomDirection(){
    List<String> directions = ['up', 'right', 'down', 'left'];
    int i = random.nextInt(3);
    return directions[i];
  }

  void newGame(){

    // Avoid games that result in immediate loss
    do{
      snake = SnakeBody(
          [generateRandomPoint()],
          generateRandomDirection()
      );
    } while (!onBoard(snake.nextLoc()));

    snakeMover = Timer.periodic(
        Duration(milliseconds: speed),
        (Timer t) => moveSnake()
    );
  }

  void pauseGame(){
    snakeMover.cancel();
  }

  void resumeGame(){
    snakeMover = Timer.periodic(
        Duration(milliseconds: speed),
            (Timer t) => moveSnake()
    );
  }

  void updateHighScore(newScore){
    if(newScore > highScore) highScore = newScore;
  }

}