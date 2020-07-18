import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'allcountdetail.dart';
import 'allcountitem.dart';
import 'allcountshim.dart';
import 'country_detail.dart';

class AllCountries extends StatefulWidget {
  final List<CountryDetail> allCountriesDetailsList;
  CountryDetail mainDetails1;

  AllCountries({this.allCountriesDetailsList, this.mainDetails1});

  @override
  _AllCountriesState createState() => _AllCountriesState();
}

class _AllCountriesState extends State<AllCountries> {
  Future _allCountriesFuture;
  Client client = Client();
  CountryDetail mainDetails;
  List<CountryDetail> _allCountriesDetailsList;
  List<CountryDetail> _filteredCountriesDetailsList = List();
  TextEditingController _searchController = TextEditingController();

  String searchText, country;

  @override
  void initState() {
    super.initState();

    if (widget.allCountriesDetailsList != null) {
      _allCountriesFuture = getList();
    } else {
      _allCountriesFuture = getAllCountries();
    }
  }

  Future getList() async {
    _allCountriesDetailsList = widget.allCountriesDetailsList;
    return _allCountriesDetailsList;
  }

  Future getAllCountries() async {
    final response =
        await client.get('https://corona.lmao.ninja/v3/covid-19/countries');

    if (response.statusCode == 200) {
      List parsedJson = json.decode(response.body);
      List<CountryDetail> tempList = [];

      for (var res in parsedJson) {
        CountryDetail allCountriesName = CountryDetail(res);
        tempList.add(allCountriesName);
      }
      _allCountriesDetailsList = tempList;
    } else {
      throw Exception('Failed to get all countries names');
    }
    return _allCountriesDetailsList;
  }

  void _sendToCountryDetail(CountryDetail countryDetail, double width) {
    int k = 0;
    print(countryDetail.country);
    country = countryDetail.country;
    for (var res in _allCountriesDetailsList) {
      if (countryDetail.country == res.country) {
        mainDetails = _allCountriesDetailsList[k];
      }
      k += 1;
    }
    print(mainDetails);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryDetails(
          countryDetail: countryDetail,
          width: width,
          mainDetails: mainDetails,
        ),
      ),
    );
  }

  filterCountries() async {
    if (_filteredCountriesDetailsList.length != 0) {
      _filteredCountriesDetailsList.clear();
    }
    for (var item in _allCountriesDetailsList) {
      if (item.country.toLowerCase().contains(searchText)) {
        _filteredCountriesDetailsList.add(item);
      }
    }

    // print(_filteredCountriesDetailsList);

    return _filteredCountriesDetailsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F3360),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              onChanged: (val) {
                // print(val);
                setState(() {
                  searchText = val.toLowerCase();
                  _allCountriesFuture = filterCountries();
                });
              },
              controller: _searchController,
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
              textInputAction: TextInputAction.search,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(13.0),
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Ubuntu',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
                fillColor: Color(0xFF235770),
                filled: true,
                hintText: 'Search country',
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Expanded(
            child: FutureBuilder(
              future: _allCountriesFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: 20.0,
                    ),
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0, top: 5.0),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Shimmer.fromColors(
                        period: Duration(milliseconds: 800),
                        baseColor: Colors.grey.withOpacity(0.5),
                        highlightColor: Colors.black.withOpacity(0.5),
                        child: AllCountriesShimmer(),
                      );
                    },
                  );
                } else {
                  if (snapshot.data.length == 0) {
                    return Center(
                      child: Text(
                        'No Countries Found',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: 25.0,
                    ),
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0, top: 5.0),
                    physics: BouncingScrollPhysics(),
                    // addAutomaticKeepAlives: true,
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: false,
                    itemBuilder: (context, index) {
                      print(index);
                      return GestureDetector(
                        onTap: () {
                          _sendToCountryDetail(snapshot.data[index],
                              MediaQuery.of(context).size.width);
                        },
                        child: AllCountriesItem(
                          countryDetail: snapshot.data[index],
                          countryCode: snapshot.data[index].countryInfo['iso2']
                              .toString()
                              .toLowerCase(),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
