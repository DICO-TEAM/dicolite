import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/pages/dao/dao.dart';
import 'package:dicolite/pages/ico/ico.dart';
import 'package:dicolite/pages/lbp/lbp.dart';
import 'package:dicolite/pages/swap/swap.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/me.dart';
import 'package:dicolite/store/app.dart';

import 'package:dicolite/widgets/loading_widget.dart';

class HomeNavItem {
  String text;
  Widget icon;
  Widget iconActive;
  Widget content;
  HomeNavItem(
      {required this.text,
      required this.icon,
      required this.iconActive,
      required this.content});
}

class Home extends StatefulWidget {
  Home(this.store);

  final AppStore store;
  static String route = "/";
  @override
  _HomePageState createState() => new _HomePageState(store);
}

class _HomePageState extends State<Home> {
  _HomePageState(this.store);

  final AppStore store;
  int _tabIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  List<BottomNavigationBarItem> _buildNavItems(List<HomeNavItem> items) {
    return items.map((e) {
      return BottomNavigationBarItem(
        icon: Container(
          padding: EdgeInsets.all(2),
          child: e.icon,
          width: Adapt.px(50),
          height: Adapt.px(50),
        ),
        activeIcon: Container(
          padding: EdgeInsets.all(2),
          child: e.iconActive,
          width: Adapt.px(50),
          height: Adapt.px(50),
        ),
        label: e.text,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<HomeNavItem> pages = [
      HomeNavItem(
        text: "ICO",
        content: Ico(store),
        icon: Image.asset("assets/images/dico/ICO.png"),
        iconActive: Image.asset("assets/images/dico/ICO-select.png"),
      ),
      HomeNavItem(
        text: "DAO",
        content: Dao(store),
        icon: Image.asset("assets/images/dico/DAO.png"),
        iconActive: Image.asset("assets/images/dico/DAO-select.png"),
      ),
      HomeNavItem(
        text: "LBP",
        content: Lbp(store),
        icon: Image.asset("assets/images/dico/LBP.png"),
        iconActive: Image.asset("assets/images/dico/LBP-select.png"),
      ),
      HomeNavItem(
        text: "SWAP",
        content: Swap(store),
        icon: Image.asset("assets/images/dico/SWAP.png"),
        iconActive: Image.asset("assets/images/dico/SWAP-select.png"),
      ),
      HomeNavItem(
        text: S.of(context).me,
        content: Me(store),
        icon: Image.asset("assets/images/dico/Me.png"),
        iconActive: Image.asset("assets/images/dico/Me-select.png"),
      ),
    ];
    return Observer(builder: (_) {
      if (store.account == null ||
          store.account!.currentAccountPubKey.isEmpty) {
        return Scaffold(
          body: Center(
            child: LoadingWidget(),
          ),
        );
      }
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _tabIndex,
          iconSize: Adapt.px(40),
          onTap: (index) {
            setState(() {
              _tabIndex = index;
            });
            _pageController.jumpToPage(index);
          },
          type: BottomNavigationBarType.fixed,
          items: _buildNavItems(pages),
        ),
        body: Container(
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: <Widget>[
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _tabIndex = index;
                  });
                },
                children: pages.map((e) => e.content).toList(),
              ),
            ],
          ),
        ),
      );
    });
  }
}
