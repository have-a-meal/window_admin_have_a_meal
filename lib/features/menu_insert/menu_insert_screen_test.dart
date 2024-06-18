import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:window_have_a_meal/constants/http_ip.dart';
import 'package:window_have_a_meal/models/menu_model.dart';
import 'package:http/http.dart' as http;

class MenuInsertScreen extends StatefulWidget {
  const MenuInsertScreen({super.key});

  @override
  State<MenuInsertScreen> createState() => _MenuInsertScreenState();
}

class _MenuInsertScreenState extends State<MenuInsertScreen> {
  Map<String, Map<String, List<MenuModel>>> _meals = {};
  late File _excelFile;

  Future<void> _readExcel() async {
    _meals = {};

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        allowMultiple: false,
      );

      if (result == null) return;
      File file = File(result.files.single.path!);
      _excelFile = File(result.files.single.path!);
      final bytes = file.readAsBytesSync();
      final decoder = SpreadsheetDecoder.decodeBytes(bytes);

      for (var sheetName in decoder.tables.keys) {
        var table = decoder.tables[sheetName]!;
        for (var rowIndex = 1; rowIndex < table.rows.length; rowIndex++) {
          var row = table.rows[rowIndex];
          var courseType = row[0]; // A, B, 또는 C 코스
          if (courseType != null) {
            for (var columnIndex = 1; columnIndex < row.length; columnIndex++) {
              var cellData = row[columnIndex];
              if (cellData != null && cellData != "null") {
                var dateCell = table.rows[0][columnIndex];
                // var dateParts = dateCell.split(' ');
                // var year = DateTime.now().year; // 현재의 해를 가져옵니다.
                // var dateString =
                //     "$year-${dateParts[0].substring(0, 2)}-${dateParts[0].substring(3, 5)}";

                var menuList = cellData.split('\n');
                MenuModel menuModel = MenuModel(
                  date: dateCell,
                  menuTime: sheetName,
                  menuCourse: courseType,
                  menuList: menuList,
                );

                _meals.putIfAbsent(
                    dateCell,
                    () => {
                          "조식": [],
                          "중식": [],
                          "석식": [],
                        });
                _meals[dateCell]![sheetName]!.add(menuModel);
              }
            }
          }
        }
      }
      setState(() {});
    } catch (e) {
      print(e);
      print('파일 선택이 취소되었습니다.');
    }
  }

  Future<void> _refreshExcel() async {
    _meals = {};
    setState(() {});
  }

  Future<void> _onInsertMenu() async {
    // final url = Uri.parse("${HttpIp.apiUrl}/manager/excel");

    // 파일 경로를 통해 formData 생성
    var dio = Dio();
    var formData = FormData.fromMap(
        {'file': await MultipartFile.fromFile(_excelFile.path)});

    // 업로드 요청
    final response =
        await dio.post("${HttpIp.apiUrl}/manager/excel", data: formData);

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      print(response);

      // context.replaceNamed(NavigationScreen.routeName);
    } else {
      if (!mounted) return;
      HttpIp.errorPrint(
        context: context,
        title: "통신 오류",
        message: "파일 전송 실패!",
      );
    }

    // // Multipart request 생성
    // var request = http.MultipartRequest('POST', url)
    //   ..files.add(await http.MultipartFile.fromPath('file', _excelFile.path));

    // // 요청 보내기
    // var response = await request.send();

    // if (response.statusCode >= 200 && response.statusCode < 300) {
    //   print(response);

    //   // context.replaceNamed(NavigationScreen.routeName);
    // } else {
    //   if (!mounted) return;
    //   HttpIp.errorPrint(
    //     context: context,
    //     title: "통신 오류",
    //     message: "파일 전송 실패!",
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _readExcel,
                        icon: const Icon(Icons.add),
                        label: const Text("액셀 등록"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _refreshExcel,
                        icon: const Icon(Icons.refresh),
                        label: const Text("초기화"),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: _onInsertMenu,
                    icon: const Icon(Icons.refresh),
                    label: const Text("메뉴 등록"),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              ..._buildMealTables(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMealTables() {
    List<Widget> mealTables = [];

    _meals.forEach((date, meals) {
      mealTables.add(
        Text(
          "[${date.split('T')[0]}]",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      mealTables.add(_buildMealTable(meals, date));
      mealTables.add(const Divider());
    });

    return mealTables;
  }

  Widget _buildMealTable(Map<String, List<MenuModel>> meals, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: meals.entries
          .where((entry) => entry.value.isNotEmpty) // 빈 리스트를 건너뛰기 위해 추가
          .map((entry) {
        String mealType = entry.key;
        List<MenuModel> menuModels = entry.value;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mealType,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: mealType == "조식"
                      ? Colors.lightGreen
                      : mealType == "중식"
                          ? Colors.lightBlue
                          : Colors.purple,
                ),
              ),
              DataTable(
                border: TableBorder.all(color: Colors.grey),
                headingRowColor: WidgetStateColor.resolveWith(
                    (states) => Colors.grey.shade300),
                columns: const <DataColumn>[
                  DataColumn(label: Text('코스')),
                  DataColumn(label: Text('메뉴')),
                ],
                rows: menuModels
                    .map(
                      (menuModel) => DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text(menuModel.menuCourse),
                          ),
                          DataCell(
                            Text(
                              menuModel.menuList.join(', '),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
