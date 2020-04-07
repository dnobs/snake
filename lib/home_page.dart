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
            child: GestureDetector(
              child: Draggable(
                child: SizedBox(
                  child: Container(
                    color: Colors.blue[200],
                  ),
                  height: 100,
                  width: 100,
                ),
                feedback: SizedBox(
                  child: Container(
                    color: Colors.black,
                  ),
                  height: 100,
                  width: 100,
                ),
                onDragEnd: (details){
                  updateDirection(details);
                  },
              ),
            ),
          ),
          
          // Padding on bottom of screen
          SizedBox(
            height: 200,
            width: 200,
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
  void updateDirection(DraggableDetails dragDetails){
    print(dragDetails.velocity.toString());
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

    speed = Duration(milliseconds: 1000);
    snakeMover = Timer.periodic(speed, (Timer t) => moveSnake());
  }

  void updateHighScore(newScore){
    if(newScore > highScore) highScore = newScore;
  }

}