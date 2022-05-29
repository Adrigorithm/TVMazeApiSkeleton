import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test_1/components/shared.dart';
import 'package:flutter_test_1/entities/show.dart';
import 'package:flutter_test_1/main.dart';
import 'package:html/parser.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final Show show;
    if (args["show"] == null) {
      show = Show(-1, "Film not found", [], "", <String, dynamic>{"average": 0},
          <String, dynamic>{}, "How did you get here?", false);
    } else {
      show = args["show"];
    }

    return Scaffold(
      appBar: SharedWidgets(context).mainAppBar,
      body: GestureDetector(
        child: Stack(children: [
          DecoratedBox(
            child: FittedBox(
              child: Image.network(show.image["original"],
                  errorBuilder: (context, error, stackTrace) {
                return Image.file(File("images/coverFullDefault.png"));
              }),
              fit: BoxFit.cover,
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                  Colors.black87,
                  Colors.black.withAlpha(0)
                ])),
            position: DecorationPosition.foreground,
          ),
          Column(children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: show.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                TextSpan(text: "Description " + parse(show.summary).outerHtml),
                TextSpan(text: "" + show.rating["average"].toString())
              ], style: TextStyle(color: scheme.onSecondary)),
            ),
            Row(children: getRatingIcons(show.rating["average"] ?? -1))
          ])
        ], fit: StackFit.expand),
        onTap: () {
          Navigator.of(context).pushReplacementNamed("/");
        },
      ),
    );
  }

  List<Widget> getRatingIcons(dynamic rating) {
    List<Widget> ratingIcons = List.empty(growable: true);
    var localRating = rating * 0.5;
    Color iconColour = Colors.red;

    if (rating >= 9.5) {
      iconColour = Colors.yellow;
    } else if (rating >= 6) {
      iconColour = Colors.green;
    } else if (rating >= 3) {
      iconColour = Colors.orange;
    }

    while (localRating > 0) {
      if (localRating - 1 >= -0.25) {
        localRating -= 1;
        ratingIcons.add(Icon(Icons.star_rounded, color: iconColour));
      } else if (localRating - 0.5 >= -0.25) {
        localRating -= 0.5;
        ratingIcons.add(Icon(Icons.star_half_rounded, color: iconColour));
      } else {
        break;
      }
    }

    return (ratingIcons.isEmpty)
        ? [
            const Icon(Icons.star_border_rounded, color: Colors.grey),
            const Icon(Icons.star_border_rounded, color: Colors.grey),
            const Icon(Icons.star_border_rounded, color: Colors.grey),
            const Icon(Icons.star_border_rounded, color: Colors.grey),
            const Icon(Icons.star_border_rounded, color: Colors.grey)
          ]
        : ratingIcons;
  }
}