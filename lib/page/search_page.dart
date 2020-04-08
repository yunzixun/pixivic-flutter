import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/papp_bar.dart';
import '../widget/suggestion_bar.dart';
import 'pic_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();

  final String searchKeywordsIn;

  SearchPage({
    @required this.searchKeywordsIn,
  });

}

class _SearchPageState extends State<SearchPage> {
  String searchKeywords;
  PicPage picPage;
  SuggestionBar suggestionBar;
  List suggestions;
  bool searchManga = false;
  GlobalKey<PappBarState> pappbarKey = GlobalKey();

  GlobalKey<SuggestionBarState> _suggestionBarKey = GlobalKey();

  @override
  void initState() {
    searchKeywords = widget.searchKeywordsIn;
    suggestionBar = SuggestionBar(searchKeywords, _onSearch, _suggestionBarKey);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    picPage = PicPage.search(searchKeywords: searchKeywords, searchManga: searchManga,);

    return Scaffold(
      appBar: PappBar.search(
              searchKeywordsIn: searchKeywords, 
              searchFucntion: _onSearch,
              key: pappbarKey,
            ),
      body: ListView(
        children: <Widget>[
          suggestionBar,
          Center(
            child: Container(
              width: ScreenUtil().setWidth(324),
              height: ScreenUtil().setHeight(576),
              color: Colors.white,
              child: picPage,
            ),
          ),
        ],
      ),
    );
  }

  _onSearch(String value) {
    setState(() {
      searchKeywords = value;
    });
    _suggestionBarKey.currentState.reloadSearchWords(value);
  }

}