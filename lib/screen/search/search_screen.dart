import 'dart:async';
import 'dart:developer';

import 'package:Dietic/config/theme/theme.dart';
import 'package:Dietic/model/search_model.dart';
import 'package:Dietic/service/search/search_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grock/grock.dart';

import '../../service/diet_plan/diet_plan_service.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final storage = FlutterSecureStorage();
  TextEditingController _searchWord = TextEditingController();
  bool _clickedButton = false;
  TextEditingController portion = TextEditingController();
  TextEditingController details = TextEditingController();

  SearchService _search = SearchService();
  final service = DietPlanService();

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
                              height: 1000,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "Cheat Foods",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: GFListTile(
                                        title: Text(
                                          '${foodList![index].description}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subTitle: Text(
                                            'Kcal: ${foodList![index].energy}'),
                                        description: Text(
                                            'Protein: ${foodList![index].protein}g'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CupertinoTextField.borderless(
                                              controller: details,
                                              padding: EdgeInsets.only(
                                                  left: 65,
                                                  top: 10,
                                                  right: 6,
                                                  bottom: 10),
                                              prefix: Text('Give a detail'),
                                            ),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.black,
                                            ),
                                            CupertinoTextField.borderless(
                                              controller: portion,
                                              padding: EdgeInsets.only(
                                                  left: 15,
                                                  top: 10,
                                                  right: 6,
                                                  bottom: 10),
                                              prefix:
                                                  Text('How much eat portion'),
                                              placeholder: 'Required',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0),
                                      child: GFButton(
                                          text: 'Add Foods',
                                          color: Colors.deepOrange,
                                          shape: GFButtonShape.pills,
                                          onPressed: () {
                                            if (foodList != null) {
                                              try {
                                                service.postDietPlan(
                                                    foodList![index].foodId!,
                                                    double.parse(portion.text),
                                                    details.text);
                                                Grock.snackBar(
                                                    title: "Successful",
                                                    description:
                                                        "Cheat Meal Added");
                                                        Navigator.pop(context);
                                              } catch (e) {
                                                Grock.snackBar(
                                                  title: 'Invalid text field',
                                                  description:
                                                      'Portion must be number',
                                                );
                                              }
                                            }
                                          }),
                                    )
                                  ],
                                ),
                              ),
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
