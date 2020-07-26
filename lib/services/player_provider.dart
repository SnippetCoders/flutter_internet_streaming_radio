import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:internet_radio/models/radio.dart';
import 'package:internet_radio/services/db_download_service.dart';
import 'package:internet_radio/utils/db_service.dart';

enum RadioPlayerState { LOADING, STOPPED, PLAYING, PAUSED, COMPLETED }

class PlayerProvider with ChangeNotifier {
  AudioPlayer _audioPlayer;
  RadioModel _radioDetails;

  List<RadioModel> _radiosFetcher;
  List<RadioModel> get allRadio => _radiosFetcher;
  int get totalRecords => _radiosFetcher != null ? _radiosFetcher.length : 0;
  RadioModel get currentRadio => _radioDetails;

  getPlayerState() => _playerState;
  getAudioPlayer() => _audioPlayer;
  getCurrentRadio() => _radioDetails;

  RadioPlayerState _playerState = RadioPlayerState.STOPPED;
  StreamSubscription _positionSubscription;

  PlayerProvider() {
    _initStreams();
  }

  void _initStreams() {
    _radiosFetcher = List<RadioModel>();
    if (_radioDetails == null) {
      _radioDetails = new RadioModel(id: 0);
    }
  }

  void resetStreams() {
    _initStreams();
  }

  void initAudioPlugin() {
    if (_playerState == RadioPlayerState.STOPPED) {
      _audioPlayer = new AudioPlayer();
    } else {
      _audioPlayer = getAudioPlayer();
    }
  }

  setAudioPlayer(RadioModel radio) async {
    _radioDetails = radio;

    await initAudioPlayer();
    notifyListeners();
  }

  initAudioPlayer() async {
    updatePlayerState(RadioPlayerState.LOADING);

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((Duration p) {      
      if (_playerState == RadioPlayerState.LOADING &&
          p.inMilliseconds > 0) {
        updatePlayerState(RadioPlayerState.PLAYING);        
      }

      notifyListeners();
    });

    _audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) async {
      print("Flutter : state : " + state.toString());
      if (state == AudioPlayerState.PLAYING) {
        //updatePlayerState(RadioPlayerState.PLAYING);
        //notifyListeners();
      } else if (state == AudioPlayerState.STOPPED || state == AudioPlayerState.COMPLETED) {
        updatePlayerState(RadioPlayerState.STOPPED);
        notifyListeners();
      }
    });
  }

  playRadio() async {
    await _audioPlayer.play(currentRadio.radioURL, stayAwake: true);
  }

  stopRadio() async {
    if (_audioPlayer != null) {
      _positionSubscription?.cancel();
      updatePlayerState(RadioPlayerState.STOPPED);
      await _audioPlayer.stop();
    }
    //await _audioPlayer.dispose();
  }

  bool isPlaying() {
    return getPlayerState() == RadioPlayerState.PLAYING;
  }

  bool isLoading() {
    return getPlayerState() == RadioPlayerState.LOADING;
  }

  bool isStopped() {
    return getPlayerState() == RadioPlayerState.STOPPED;
  }

  fetchAllRadios({
    String searchQuery = "",
    bool isFavouriteOnly = false,
  }) async {
    _radiosFetcher = await DBDownloadService.fetchLocalDB(
      searchQuery: searchQuery,
      isFavouriteOnly: isFavouriteOnly,
    );
    notifyListeners();
  }

  void updatePlayerState(RadioPlayerState state) {
    _playerState = state;
    notifyListeners();
  }

  Future<void> radioBookmarked(int radioID, bool isFavourite,
      {bool isFavouriteOnly = false}) async {
    int isFavouriteVal = isFavourite ? 1 : 0;
    await DB.init();
    await DB.rawInsert(
      "INSERT OR REPLACE INTO radios_bookmarks (id, isFavourite) VALUES ($radioID, $isFavouriteVal)",
    );

    fetchAllRadios(isFavouriteOnly: isFavouriteOnly);
  }
}
