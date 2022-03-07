import 'package:dicolite/config/config.dart';
import 'package:dicolite/config/country_code_english.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

class SelectMultArea extends StatefulWidget {
  const SelectMultArea({Key? key}) : super(key: key);
  static String route = "/ico/SelectMultArea";
  @override
  _SelectMultAreaState createState() => _SelectMultAreaState();
}

class SelectListModel {
  String code = '';
  String name = '';
  bool isSelect = false;
  SelectListModel(this.name, this.code);
}

class _SelectMultAreaState extends State<SelectMultArea> {
  List<SelectListModel> list = countryCodeEnglish
      .map((e) => SelectListModel(e["name"]!, e["code"]!))
      .toList();
  List<String> selectList = [];
  String template1ListString = Config.template1List.join(",");
  String template2ListString = Config.template2List.join(",");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var res = ModalRoute.of(context)!.settings.arguments as List<String>;

      setState(() {
        selectList = List<String>.from(res);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    S dic = S.of(context);
    list.forEach((e) {
      e.isSelect = selectList.contains(e.code);
    });

    return Scaffold(
        appBar: myAppBar(context, dic.selectArea, actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(selectList);
            },
            child: Text(
              dic.ok,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ]),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(dic.selected + ":"),
                    ],
                  ),
                  Text(selectList.join(", ")),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: selectList.join(",") == template1ListString
                          ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).primaryColor,
                            )
                          : Icon(Icons.circle_outlined),
                      style: ButtonStyle().copyWith(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black87),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellow)),
                      onPressed: () {
                        setState(() {
                          selectList = List<String>.from(Config.template1List);
                        });
                      },
                      label: Text(dic.template1),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: selectList.join(",") == template2ListString
                          ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).primaryColor,
                            )
                          : Icon(Icons.circle_outlined),
                      style: ButtonStyle().copyWith(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blueAccent)),
                      onPressed: () {
                        setState(() {
                          selectList = List<String>.from(Config.template2List);
                        });
                      },
                      label: Text(dic.template2),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(list[index].name + "(${list[index].code})"),
                      selected: list[index].isSelect,
                      trailing: list[index].isSelect
                          ? Icon(
                              Icons.check_box,
                              color: Theme.of(context).primaryColor,
                            )
                          : Icon(Icons.check_box_outline_blank),
                      onTap: () {
                        List<String> listNew = selectList;
                        if (list[index].isSelect) {
                          listNew.remove(list[index].code);
                        } else {
                          listNew.add(list[index].code);
                        }
                        setState(() {
                          selectList = listNew;
                        });
                      },
                    );
                  }),
            ),
          ],
        ));
  }
}
