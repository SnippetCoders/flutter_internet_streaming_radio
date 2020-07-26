import 'package:flutter/material.dart';
import 'package:internet_radio/services/player_provider.dart';
import 'package:internet_radio/utils/hex_color.dart';
import 'package:provider/provider.dart';

class NowPlayingTemplate extends StatelessWidget {
  final String radioTitle;
  final String radioImageURL;

  NowPlayingTemplate({Key key, this.radioTitle, this.radioImageURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: new HexColor("#182545")),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _nowPlayingText(context, this.radioTitle, this.radioImageURL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nowPlayingText(BuildContext context, String title, String imageURL) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
      child: ListTile(
        title: new Text(
          title,
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            color: HexColor("#ffffff"),
          ),
        ),
        subtitle: new Text(
          "Now Playing",
          textScaleFactor: 0.8,
          style: new TextStyle(
            color: HexColor("#ffffff"),
          ),
        ),
        leading: _image(imageURL, size: 50.0),
        trailing: Wrap(
          spacing: -10.0,
          children: <Widget>[
            _buildStopIcon(context),
            _buildShareIcon(),
          ],
        ),
      ),
    );
  }

  Widget _image(url, {size}) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(url),
      ),
      height: size == null ? 55 : size,
      width: size == null ? 55 : size,
      decoration: BoxDecoration(
        color: HexColor("#FFE5EC"),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }

  Widget _buildStopIcon(BuildContext context) {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    return IconButton(
      icon: Icon(Icons.stop),
      color: HexColor("#9097A6"),
      onPressed: () {
        playerProvider.stopRadio();
      },
    );
  }

  Widget _buildShareIcon() {
    return IconButton(
      icon: Icon(Icons.share),
      color: HexColor("#9097A6"),
      onPressed: () {},
    );
  }
}
