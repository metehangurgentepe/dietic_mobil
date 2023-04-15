import 'dart:async';

import 'package:dietic_mobil/config/theme/theme.dart';
import 'package:dietic_mobil/model/search_model.dart';
import 'package:dietic_mobil/service/search/search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final storage = FlutterSecureStorage();
  TextEditingController _searchWord = TextEditingController();
  bool _clickedButton = false;

  SearchService _search = SearchService();

  List<SearchModel>? data=[];

  var _listController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Column(children: [
      _clickedButton
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: TextFormField(
                cursorColor: AppColors.colorAccent,
                controller: _searchWord,
              decoration: InputDecoration(
                hintText: 'How much calories',
                suffixIcon: IconButton(
                  icon:Icon(Icons.close),
                  color: Colors.black, onPressed: () {
                    _searchWord.clear();
                    setState((){
                      _clickedButton =false;
                      data!.clear();
                    });
                },)
              ),
                ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 100, horizontal: 50),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'How much calories'
                ),
                controller: _searchWord,
              ),
            ),
      _clickedButton
          ? Container() : ElevatedButton(
              onPressed: () async {
                void deleteArray() {
                  Timer(Duration(minutes: 15), () {
                    data!.clear();
                  });
                }
                setState(() {
                  _search.searchCall();
                  _clickedButton = true;
                });
                await storage.write(key: 'searchWord' ,value: _searchWord.text);

              },
              child: Text('Search Food'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorAccent),
            ),
          Expanded(
                child: FutureBuilder(
                  future: _search.searchCall(),
                    builder: (context,snapshot){
                      data = snapshot.data;
                    if(!snapshot.hasData){
                      if(_clickedButton==true){
                      return Text('Food not found',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),);}
                      if(_clickedButton==false){
                        return Container();
                      }
                    }
                    return ListView.builder(
                      controller:_listController,

                      itemCount: data!.length,
                        itemBuilder: (context,index){
                      return Card(
                        child: ListTile(
                          title: Text(snapshot.data![index].description!),
                          subtitle: Text(snapshot.data![index].energy!.toString()+' kcal'),
                          trailing: Text('Protein: '+snapshot.data![index].protein!.toString()+'g'),
                        ),
                      );
                    });
                    }),
              )
    ]));
  }
}
