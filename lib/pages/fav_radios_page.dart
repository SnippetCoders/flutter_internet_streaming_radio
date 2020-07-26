import 'package:flutter/material.dart';

import 'radio_page.dart';

class FavRadiosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new RadioPage(isFavouriteOnly: true);
  }
}