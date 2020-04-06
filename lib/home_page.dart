import 'package:flutter/material.dart';
import 'package:snake/snake_body.dart';
import 'dart:math';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SnakeBody snake;
  int gameGridSize = 10;
  List<int> buttons = [1, 3, 5, 7];

  @override
  void initState(){
    super.initState();
    snake = setUpSnake();
  }

  SnakeBody setUpSnake(){
    return new SnakeBody([[1,1]], 'right');

  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Snake"),
      ),

      body: new Column(
        children: <Widget>[

          // Game Area
          Expanded(
            child: AspectRatio(
              child: GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gameGridSize,
                  childAspectRatio: 1.0, // ensures each cell is a square
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                  ),
                itemCount: pow(gameGridSize, 2),
                itemBuilder: (context, i) => new Container(
                  child: Center(
                      child: Text(getCords(i).toString())
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
                itemBuilder: (context, i) => new RaisedButton(
                  color: buttons.contains(i) ? Colors.red: Colors.grey[100],
                  onPressed: setDirection,
                  child: Text(i.toString()),
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
void setDirection(){
    return null;
}


Color getCellColor(int i){
    List<int> loc = getCords(i);
    if(snake.at(getCords(i))) {
      return Colors.black;
    }else{
      return Colors.grey[100];
    }
}

void moveSnake(){
}

}