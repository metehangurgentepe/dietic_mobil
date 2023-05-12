import 'dart:async';
import 'dart:developer';

import 'package:dietic_mobil/config/theme/theme.dart';
import 'package:dietic_mobil/model/search_model.dart';
import 'package:dietic_mobil/service/search/search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:getwidget/getwidget.dart';

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

  List<SearchModel>? foodList = [];

  var _listController;
  final GFBottomSheetController _controller = GFBottomSheetController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: [
      _clickedButton
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: TextFormField(
                cursorColor: AppColors.colorAccent,
                controller: _searchWord,
                decoration: InputDecoration(
                    hintText: 'How much calories',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      color: Colors.black,
                      onPressed: () {
                        _searchWord.clear();
                        setState(() {
                          _clickedButton = false;
                          foodList!.clear();
                        });
                      },
                    )),
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 100, horizontal: 50),
              child: TextField(
                decoration: InputDecoration(hintText: 'How much calories'),
                controller: _searchWord,
              ),
            ),
      _clickedButton
          ? Container()
          : ElevatedButton(
              onPressed: () async {
                void deleteArray() {
                  Timer(Duration(minutes: 15), () {
                    foodList!.clear();
                  });
                }

                setState(() {
                  _search.searchCall(_searchWord.text);
                  _clickedButton = true;
                });
                await storage.write(key: 'searchWord', value: _searchWord.text);
              },
              child: Text('Search Food'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorAccent),
            ),
      Expanded(
        child: FutureBuilder(
            future: _search.searchCall(_searchWord.text),
            builder: (context, snapshot) {
              foodList = snapshot.data;
              print(foodList);
              if (!snapshot.hasData) {
                if (_clickedButton == true) {
                  return Column(
                    children: [
                      Text(
                        'Food not found',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          void deleteArray() {
                            Timer(Duration(minutes: 15), () {
                              foodList!.clear();
                            });
                          }

                          setState(() {
                            _search.searchCall(_searchWord.text);
                            _clickedButton = true;
                          });
                          await storage.write(
                              key: 'searchWord', value: _searchWord.text);
                        },
                        child: Text('Search Food'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorAccent),
                      ),
                    ],
                  );
                }
                if (_clickedButton == false) {
                  return Container();
                }
              }
              return ListView.builder(
                  controller: _listController,
                  itemCount: foodList!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 300,
                              // Add your content for the bottom sheet here
                              child: Text('${foodList![index].description}'),
                            );
                          },
                        );
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(snapshot.data![index].description!),
                          subtitle: Text(
                              snapshot.data![index].energy!.toString() +
                                  ' kcal'),
                          trailing: Text('Protein: ' +
                              snapshot.data![index].protein!.toString() +
                              'g'),
                        ),
                      ),
                    );
                  });
            }),
      )
    ]));
  }
}
