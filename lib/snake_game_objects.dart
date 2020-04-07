import 'package:flutter/material.dart';


class Food {
  List<int> xyCords;

  List<int> get loc {
    return xyCords;
  }

  Food(
    this.xyCords,
  );

  bool at(List<int> point) {
    return (xyCords[0] == point[0] && xyCords[1] == point[1]);
  }
}

class SnakeBody {
  List<List<int>> xyList;
  String dir;

  List<int> get head {
    return xyList.last;
  }

  List<int> get tail {
    return xyList.first;
  }

  int get length {
    return xyList.length;
  }

  List<int> get direction {
    if(dir == 'up') return [0, -1];
    if(dir == 'right') return [1, 0];
    if(dir == 'down') return [0, 1];
    if(dir == 'left') return [-1, 0];

    // if no direction is valid, return no direction
    return [0, 0];
  }

  SnakeBody(
    this.xyList,
    this.dir,
  );

  void changeDirection(newDirection) {
    // check that new dir is valid (ie not a 180 turn)
    if (newDirection == 'up' && dir != 'down') dir = newDirection;
    if (newDirection == 'right' && dir != 'left') dir = newDirection;
    if (newDirection == 'down' && dir != 'up') dir = newDirection;
    if (newDirection == 'left' && dir != 'right') dir = newDirection;
  }

  List<int> nextLoc(){
    return [
      xyList.last[0] + this.direction[0],
      xyList.last[1] + this.direction[1]
    ];
  }

  void grow(List<int> xy) {
    xyList.add(xy);
    return;
  }

  void move() {
    xyList.add(this.nextLoc());
    xyList.removeAt(0);
    return;
  }

  bool at(List<int> point){
    for(var loc in xyList) {
      if (loc[0] == point[0] && loc[1] == point[1]) return true;
    }
    return false;
  }

  bool stuffed(List<int> point){
    int numOcc = 0;
    for (var loc in xyList) {
      if (loc[0] == point[0] && loc[1] == point[1]) numOcc++;
    }

    if(numOcc > 1) return true;
    else return false;
  }

  String toString(){
    String output = '';

    output = 'Snake\n\tHeading: ' + dir.toString();
    output = output + '\n\tBody: ';
    for(var loc in xyList){
      output = output + '\n\t\t' + loc.toString();
    }

    return output;
  }
}