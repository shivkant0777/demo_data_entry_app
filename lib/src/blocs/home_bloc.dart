
import 'dart:async';

import 'package:demo_data_entry_app/src/database_helper.dart';
import 'package:demo_data_entry_app/src/models/item.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {

  HomeBloc() {
    getItems();
  }

  final _items = BehaviorSubject<List<Item>>();
  get items => _items.stream;


  dispose() {
    _items.close();
  }

  getItems() async {
    _items.sink.add(await DatabaseHelper().getItemList());
  }

  insertItems(Item item)  {
    DatabaseHelper().insertItem(item);

  }

  updateItems(Item item) async{
    await DatabaseHelper().updateItem(item);
  }

  deleteItem(int id) async {
    await DatabaseHelper().deleteItem(id);
  }


}

final bloc = HomeBloc();