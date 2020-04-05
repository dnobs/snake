import 'package:flutter/material.dart';
import 'package:snake/grid_cell.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
List<GridCell> myGrid;

  @override
  void initState(){
    super.initState();
    myGrid = doInit(gridSize: 100);
  }

List<GridCell> doInit({gridSize}){
    var grid = new List<GridCell>();
    for(int x = 0; x < gridSize; x++){
      for(int y = 0; y < gridSize; y++){
        grid.add(new GridCell(loc : [x, y]));
      }
    }
    return grid;
}

@override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Snake"),
      ),

      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
                childAspectRatio: 1.0,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
                ),
              itemCount: myGrid.length,
              itemBuilder: (context, i) => new SizedBox(
                width: 10.0,
                height: 10.0,

                // this defines the individual game cells
                child: new RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white,
                  onPressed: myFunction,
                ),

              ),
            )
          )
        ],
      )
    );
}

void myFunction(){
    return null;
}


}