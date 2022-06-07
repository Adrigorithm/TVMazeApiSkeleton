import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test_1/components/shared.dart';
import 'package:flutter_test_1/entities/show.dart';
import 'package:flutter_test_1/entities/tvmaze_client.dart';
import 'package:flutter_test_1/helpers/extensions.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  final Future<ShowList> showsCache = TVMazeClient().getShows();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String filter = "";
  List<Show> showsFiltered = List.empty();

  void _applyFilter(String showSelection) {
    setState(() {
      filter = showSelection;
    });
  }

  /// Async Builds home screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedWidgets(context).mainAppBar,
      body: FutureBuilder<ShowList>(
        future: widget.showsCache,
        builder: (BuildContext context, AsyncSnapshot<ShowList> snapshot) {
          if (snapshot.hasData) {
            showsFiltered = snapshot.data!.shows
                .where((show) => show.name.contains(filter))
                .toList();

            return Column(
              children: [
                Autocomplete<Show>(
                  optionsBuilder: (textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<Show>.empty();
                    }
                    return showsFiltered;
                  },
                  displayStringForOption: (Show show) => show.name,
                  initialValue: TextEditingValue(text: filter),
                  onSelected: (Show goodSelection) {
                    _applyFilter(goodSelection.name);
                  },
                ),
                Expanded(
                    child: CustomScrollView(slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _getShowWidget(showsFiltered[index]);
                      },
                      childCount: showsFiltered.length,
                    ),
                  )
                ])),
              ],
            );
          } else if (snapshot.hasError) {
            return const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            );
          } else {
            return const SizedBox(
                width: 60, height: 60, child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _getShowWidget(Show show) {
    return GestureDetector(
      child: Container(
        child: Row(
          children: [
            Image.network(show.image["medium"], height: 200,
                errorBuilder: (context, error, stackTrace) {
              return Image.file(File("images/coverDefault.png"));
            }),
            Column(
              children: [
                RichText(
                  text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                            text: show.name + "\n",
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold)),
                        TextSpan(text: show.rating["average"].toString())
                      ]),
                ),
                IconButton(
                  icon: Icon(
                      (show.isFavourite)
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: Colors.amber),
                  onPressed: () {
                    show.saveFavourite();
                  },
                )
              ],
            )
          ],
        ),
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      ),
      onTap: () {
        // Change state
        Navigator.of(context)
            .pushReplacementNamed("/details", arguments: {"show": show});
      },
    );
  }
}
