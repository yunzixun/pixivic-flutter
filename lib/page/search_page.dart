import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:requests/requests.dart';

import '../widget/papp_bar.dart';
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
  List suggestions;

  @override
  void initState() {
    searchKeywords = widget.searchKeywordsIn;
    picPage = PicPage.search(searchKeywords: searchKeywords);
    _loadSuggestions().then((value) {
      setState(() {
        suggestions = value;
      });
    });
    super.initState();
  }

  @override
  void didUpdateWidget(SearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
  
  @override
  Widget build(BuildContext context) {
    picPage = PicPage.search(searchKeywords: searchKeywords);

    return Scaffold(
      appBar: PappBar.search(
              contentHeight: ScreenUtil().setHeight(38),
              searchKeywordsIn: searchKeywords, 
              searchFucntion: _onSearch,
            ),
      body: ListView(
        children: <Widget>[
          suggestionBar(),
          Center(
            child: Container(
              width: ScreenUtil().setWidth(324),
              height: ScreenUtil().setHeight(500),
              color: Colors.white,
              child: picPage,
            ),
          ),
        ],
      ),
    );
  }

  Widget suggestionBar() {
    if(suggestions != null) {
      return Container(
        height: ScreenUtil().setHeight(50),
        width: ScreenUtil().setWidth(324),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            var keywordsColumn;
            if (suggestions[index]['keywordTranslated'] != '') {
              keywordsColumn = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  suggestionsKeywordsText(suggestions[index]['keyword']),
                  suggestionsKeywordsText(suggestions[index]['keywordTranslated']),
                ]
              );
            } else {
              keywordsColumn = suggestionsKeywordsText(suggestions[index]['keyword']);
            }

            return GestureDetector(
              onTap: () {
                searchKeywords = suggestions[index]['keyword'];
                setState(() {
                  _onSearch(searchKeywords);
                });
              },
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(4)),
                  color: Colors.teal[200],
                ),
                // width: ScreenUtil().setWidth(80),
                padding: EdgeInsets.all(8),
                child: Center(child: keywordsColumn,),
              ),
            );
          }
        ),
      );
    }
    else {
      return Center();
    }
    
  }

  Widget suggestionsKeywordsText(String suggestions) {
    return Text(
      suggestions, 
      strutStyle: StrutStyle(
        fontSize: 10,
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: 10
      ),
    );
  }
  

  _onSearch(String value) {
    searchKeywords = value;
    _loadSuggestions().then((value){
      setState(() {
        suggestions = value;
      });
    });
  }

  _loadSuggestions() async {
    List jsonList;
    var requests;
    String urlPixiv = 'https://api.pixivic.com/keywords/$searchKeywords/pixivSuggestions';
    String urlPixivic = 'https://api.pixivic.com/keywords/$searchKeywords/suggestions';
    requests = await Requests.get(urlPixiv);
    requests.raiseForStatus();
    jsonList = jsonDecode(requests.content())['data'];
    requests = await Requests.get(urlPixivic);
    requests.raiseForStatus();
    jsonList = jsonList + jsonDecode(requests.content())['data'];
    return jsonList;
  }
}