
import 'dart:math';

import 'package:demo_data_entry_app/src/blocs/home_bloc.dart';
import 'package:demo_data_entry_app/src/models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;
  int c = 9;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.black,
      body: body(),
    );
  }

  Widget body() {
    return Container(
      child: Column(
        children: [
          createItem(),
         Expanded(child: itemList())

        ],
      ),
    );
  }

  Widget createItem() {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      color: Colors.red,
      child: TextField(
      controller: _controller,
      textInputAction: TextInputAction.done,
      cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: "Add item",
        hintStyle: TextStyle(color: Colors.white),
      ),
      onSubmitted: (String value) async{
        HomeBloc().insertItems(Item(name: value,status: 1));
        bloc.getItems();
        _controller.clear();
      },
      ),
    );
  }

  Widget itemList() {
    return StreamBuilder<List<Item>>(
        stream: bloc.items,
        builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot){

          return snapshot.hasData ?  Container(
            child: RefreshIndicator(
              onRefresh: _pullList,
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    if(index == 0){
                      c = 9;
                    }
                    else if(c == 1){
                      c=9;
                    }
                    else{c--;}

                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {

                        if(direction == DismissDirection.endToStart) {
                          bloc.deleteItem(snapshot.data![index].id!);

                        }
                        else if(direction == DismissDirection.startToEnd) {
                          bloc.updateItems(Item(id:snapshot.data![index].id, name: snapshot.data![index].name, status: 0));
                        }
                        bloc.getItems();
                      },
                      background: slideRightBackground(),
                      secondaryBackground: slideLeftBackground(),
                      child: ListTile(
                        tileColor: snapshot.data![index].status == 0 ? Colors.black : Colors.red[100 * c],
                        title: Text(snapshot.data![index].name,
                          style: snapshot.data![index].status == 0 ? const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey) : TextStyle(decoration: TextDecoration.none, color: Colors.white),
                        ),
                      ),
                    );

                  }),
            )

          ) : Container();
        });
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.done,
              color: Colors.white,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
  Future<Null> _pullList() async{
    print('refreshing stocks...');

  }

}