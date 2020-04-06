import 'package:flutter/material.dart';

//  bool operator ==(o) => o is
//    GridCell && o.xy[0] == loc[0] && o.xy[1] == loc[1];

class SnakeBody {
  String direction;
  List<List<int>> xyList;

  List<int> get head {
    return xyList.first;
  }

  List<int> get tail {
    return xyList.last;
  }

  void set dir(newDirection) {
    direction = newDirection;
  }

  String get dir {
    return direction;
  }

  SnakeBody({
    this.xyList,
    this.direction,
  });

  void newHead(List<int> xy) {
    xyList.add(xy);
    return;
  }

  void dropTail() {
    xyList.removeLast();
    return;
  }

  bool at([x, y]){
    for(var loc in xyList){
      if(loc[0] == x && loc[1] == y) {
        return true;
      } else {
        return false;
      }
    }
  }
}