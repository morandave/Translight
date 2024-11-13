import 'package:best_flutter_ui_templates/nanjing_museum/calendar_popup_view.dart';
import 'package:best_flutter_ui_templates/nanjing_museum/collection_list_view.dart';
import 'package:best_flutter_ui_templates/nanjing_museum/model/collection_list_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../data_model.dart';
import '../db.dart';
import '../design_course/design_course_app_theme.dart';
import 'filters_screen.dart';
import 'collection_app_theme.dart';

class NanjingHomeScreen extends StatefulWidget {
  @override
  _NanjingHomeScreenState createState() => _NanjingHomeScreenState();
}

class _NanjingHomeScreenState extends State<NanjingHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<CollectionListData> hotelList = [];
  List<CollectionListData> originalHotelList = [];
  int collectionNum = 9760;
  String? selectedPeriodRange;
  String? selectedCategoryRange;
  final ScrollController _scrollController = ScrollController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
    fetchData(); //initState()不允许async，得用一个saync函数在里面
  }
  String extractIdFromUrl(String url) {
    RegExp regExp = RegExp(r'id=(\d+)');
    Match? match = regExp.firstMatch(url);
    return match != null ? match.group(1)! : "未找到 ID";
  }
  Future<List<CollectionListData>> convertToCollectionListData(
      List<Collection> futureCollections) async {
    // 等待 futureCollections 完成，并获取 List<Collection> 的值
    final List<Collection> collections = await futureCollections;

    // 将 List<Collection> 转换为 List<CollectionListData>
    return collections.map((collection) {
      return CollectionListData(
        id: extractIdFromUrl(collection.image),
        name: collection.name,
        category: collection.category,
        period: collection.period,
        existingLocation: collection.existingLocation,
        dimension: collection.dimensions,
        introduction: collection.introduction,
      );
    }).toList();
  }
  void fetchData() async {
    CollectionDatabase xz_ch =
    CollectionDatabase('nanjing_chinese.sqlite');
    List<CollectionListData> result = await convertToCollectionListData(await xz_ch.collections());
    setState(() {
      hotelList = result;
      collectionNum = result.length;
      originalHotelList = result;
    });
  }

  Future<bool> getData() async {
    // await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: <Widget>[
                    getAppBarUI(),
                    Expanded(
                      child: NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Column(
                                  children: <Widget>[
                                    getSearchBarUI(),
                                    getTimeDateUI(),
                                  ],
                                );
                              }, childCount: 1),
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              floating: true,
                              delegate: ContestTabHeader(
                                getFilterBarUI(),
                              ),
                            ),
                          ];
                        },
                        body: Container(
                          color:
                              HotelAppTheme.buildLightTheme().backgroundColor,
                          child: ListView.builder(
                            itemCount: hotelList.length,
                            padding: const EdgeInsets.only(top: 8),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              final int count =
                                  hotelList.length > 10 ? 10 : hotelList.length;
                              final Animation<double> animation =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                      CurvedAnimation(
                                          parent: animationController!,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn)));
                              animationController?.forward();
                              return HotelListView(
                                callback: () {},
                                hotelData: hotelList[index],
                                animation: animation,
                                animationController: animationController!,
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getListUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, -2),
              blurRadius: 8.0),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 156 - 50,
            child: FutureBuilder<bool>(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  return ListView.builder(
                    itemCount: hotelList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      final int count =
                          hotelList.length > 10 ? 10 : hotelList.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn)));
                      animationController?.forward();

                      return HotelListView(
                        callback: () {},
                        hotelData: hotelList[index],
                        animation: animation,
                        animationController: animationController!,
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget getHotelViewList() {
    final List<Widget> hotelListViews = <Widget>[];
    for (int i = 0; i < hotelList.length; i++) {
      final int count = hotelList.length;
      final Animation<double> animation =
          Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController!,
          curve: Interval((1 / count) * i, 1.0, curve: Curves.fastOutSlowIn),
        ),
      );
      hotelListViews.add(
        HotelListView(
          callback: () {},
          hotelData: hotelList[i],
          animation: animation,
          animationController: animationController!,
        ),
      );
    }
    animationController?.forward();
    return Column(
      children: hotelListViews,
    );
  }

  Widget getTimeDateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      // setState(() {
                      //   isDatePopupOpen = true;
                      // });
                      showDemoDialog(context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          DropdownButton<String>(
                            value: selectedPeriodRange,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedPeriodRange = newValue;
                                if (selectedPeriodRange != null) {
                                  hotelList = originalHotelList
                                      .where((data) => data.period
                                          .toLowerCase()
                                          .contains(selectedPeriodRange!.toLowerCase()))
                                      .toList();
                                }
                              });
                            },
                            hint: Text(
                              '朝代', // 设置提示文字
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                              ),
                            ),
                            items: <String>[
                          
                              '新石器时代',
                              '唐',
                              '宋',
                              // Add more options as needed
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value, // Ensure each value is unique
                                child: Row(
                                  children: [
                                    Text(
                                      value,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toSet().toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 1,
              height: 42,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          DropdownButton<String>(
                            value: selectedCategoryRange,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCategoryRange = newValue;
                                if (selectedCategoryRange != null) {
                                  hotelList = originalHotelList
                                      .where((data) => data.category
                                          .toLowerCase()
                                          .contains(selectedCategoryRange!.toLowerCase()))
                                      .toList();
                                }
                              });
                            },
                            hint: Text(
                              '种类', // 设置提示文字
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                              ),
                            ),
                            items: <String>[
                              '玉石',
                              '陶器',
                              '瓷器',
                              '金银器',
                              '书画',
                              // Add more options as needed
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value, // Ensure each value is unique
                                child: Row(
                                  children: [
                                    Text(
                                      value,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toSet().toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


    Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HotelAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {
                      setState(() {
                        if (txt.isEmpty) {
                          // 如果输入框内容为空，则清空筛选条件，显示所有数据
                          hotelList = originalHotelList;
                        } else {
                          // 否则，根据输入框内容进行筛选
                          hotelList = originalHotelList
                              .where((data) => data.name.toLowerCase().contains(txt.toLowerCase()))
                              .toList();
                        }
                      });
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'London...',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: HotelAppTheme.buildLightTheme().primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(FontAwesomeIcons.magnifyingGlass,
                      size: 20,
                      color: HotelAppTheme.buildLightTheme().backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: HotelAppTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: HotelAppTheme.buildLightTheme().backgroundColor,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${collectionNum}件藏品',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 0.27,
                        color: DesignCourseAppTheme.grey,
                      ),
                    ),
                  ),
                ),
                // Material(
                //   color: Colors.transparent,
                //   child: InkWell(
                //     focusColor: Colors.transparent,
                //     highlightColor: Colors.transparent,
                //     hoverColor: Colors.transparent,
                //     splashColor: Colors.grey.withOpacity(0.2),
                //     borderRadius: const BorderRadius.all(
                //       Radius.circular(4.0),
                //     ),
                //     onTap: () {
                //       FocusScope.of(context).requestFocus(FocusNode());
                //       Navigator.push<dynamic>(
                //         context,
                //         MaterialPageRoute<dynamic>(
                //             builder: (BuildContext context) => FiltersScreen(),
                //             fullscreenDialog: true),
                //       );
                //     },
                //     child: Padding(
                //       padding: const EdgeInsets.only(left: 8),
                //       child: Row(
                //         children: <Widget>[
                //           Text(
                //             'Filter',
                //             style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 18,
                //               letterSpacing: 0.27,
                //               color: DesignCourseAppTheme.grey,
                //             ),
                //           ),
                //           Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Icon(Icons.sort,
                //                 color: HotelAppTheme.buildLightTheme()
                //                     .primaryColor),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  void showDemoDialog({BuildContext? context}) {
    showDialog<dynamic>(
      context: context!,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            startDate = startData;
            endDate = endData;
          });
        },
        onCancelClick: () {},
      ),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '南京博物院',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.favorite_border),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(FontAwesomeIcons.locationDot),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
