import 'package:flutter/material.dart';

//  bool operator ==(o) => o is
//    GridCell && o.xy[0] == loc[0] && o.xy[1] == loc[1];

class SnakeBody {
  List<List<int>> xyList;
  String dir;

  List<int> get head {
    return xyList.last;
  }

  List<int> get tail {
    return xyList.first;
  }

  List<int> get direction {
    if(dir == 'up') return [0, -1];
    if(dir == 'right') return [1, 0];
    if(dir == 'down') return [0, 1];
    if(dir == 'left') return [-1, 0];
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
    print('my direction: ' + dir);
  }

  void newHead(List<int> xy) {
    xyList.add(xy);
    return;
  }

  void dropTail() {
    xyList.removeAt(0);
    return;
  }

  bool at(List<int> point){
    for(var loc in xyList) {
      if (loc[0] == point[0] && loc[1] == point[1]) return true;
    }
    return false;

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