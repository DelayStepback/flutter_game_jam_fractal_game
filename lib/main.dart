import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/wild_territory_game.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: WildTerritoryGame()),
          Padding(
            padding: EdgeInsets.all(24),
            child: InkWell(
              onTap: (){
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: Text("Success"),
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    content: SizedBox(
                      height: 200,
                      width: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('select your class')
                            ,Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(height: 40,width: 40,color: Colors.blue,),
                                Container(height: 40,width: 40,color: Colors.green,),
                                Container(height: 40,width: 40,color: Colors.grey,)
                              ],
                            ),
                          ],

                        ),
                      ),
                    ),
                  );
                });
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    color: Colors.black, borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
