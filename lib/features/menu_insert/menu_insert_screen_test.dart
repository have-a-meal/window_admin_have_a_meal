import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:window_have_a_meal/models/menu_model.dart';

class MenuInsertScreen extends StatefulWidget {
  const MenuInsertScreen({super.key});

  @override
  State<MenuInsertScreen> createState() => _MenuInsertScreenState();
}

class _MenuInsertScreenState extends State<MenuInsertScreen> {
  Map<String, Map<String, List<MenuModel>>> _meals = {
    "조식": {
      "A": [],
      "B": [],
      "C": [],
    },
    "중식": {
      "A": [],
      "B": [],
      "C": [],
    },
    "석식": {
      "A": [],
      "B": [],
      "C": [],
    },
  };

  // Future<void> readExcel() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['xlsx'],
  //     allowMultiple: false,
  //   );

  //   if (result != null) {
  //     File file = File(result.files.single.path!);
  //     final bytes = file.readAsBytesSync();
  //     final decoder = SpreadsheetDecoder.decodeBytes(bytes);

  //     String sheetName;
  //     for (var table in decoder.tables.keys) {
  //       print('Sheet: $table');
  //       sheetName = table;
  //       for (var row in decoder.tables[table]!.rows) {
  //         for (var column = 1; column < decoder.tables[table]!.rows.length; column++) {
  //           print('$row');
  //           // _meals 변수에 데이터 저장
  //         }
  //       }
  //     }
  //   } else {
  //     // 사용자가 파일 선택을 취소했을 때의 처리
  //     print('파일 선택이 취소되었습니다.');
  //   }
  //   setState(() {});
  // }

  Future<void> _readExcel() async {
    _meals = {
      "조식": {
        "A": [],
        "B": [],
        "C": [],
      },
      "중식": {
        "A": [],
        "B": [],
        "C": [],
      },
      "석식": {
        "A": [],
        "B": [],
        "C": [],
      },
    };

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
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
                var dateParts = dateCell.split(' ');
                var date = DateTime(
                    2024,
                    int.parse(dateParts[0].substring(0, 2)),
                    int.parse(dateParts[0].substring(3, 5)));
                var menuList = cellData.split('\n');
                MenuModel menuModel = MenuModel(
                    date: date, courseName: courseType, menuList: menuList);
                _meals[sheetName]![courseType]!.add(menuModel);
              }
            }
          }
        }
      }
      setState(() {});
    } else {
      print('파일 선택이 취소되었습니다.');
    }
  }

  Future<void> _refreshExcel() async {
    _meals = {
      "조식": {
        "A": [],
        "B": [],
        "C": [],
      },
      "중식": {
        "A": [],
        "B": [],
        "C": [],
      },
      "석식": {
        "A": [],
        "B": [],
        "C": [],
      },
    };
    setState(() {});
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: _readExcel,
                    icon: const Icon(Icons.add),
                    label: const Text("액셀 등록"),
                  ),
                  const Gap(10),
                  ElevatedButton.icon(
                    onPressed: _refreshExcel,
                    icon: const Icon(Icons.refresh),
                    label: const Text("초기화"),
                  ),
                ],
              ),
              const Gap(10),
              const Text(
                '조식',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildMealTable('조식'),
              const SizedBox(height: 20),
              const Text(
                '중식',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildMealTable('중식'),
              const SizedBox(height: 20),
              const Text(
                '석식',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildMealTable('석식'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealTable(String mealType) {
    // 해당 식사 타입에 대한 데이터가 비어있는지 확인합니다.
    bool isEmpty = true;
    _meals[mealType]?.forEach((key, value) {
      if (value.isNotEmpty) {
        isEmpty = false;
      }
    });

    if (isEmpty) {
      return Text('$mealType 데이터가 없습니다.');
    }

    // 데이터가 있는 경우, DataTable을 생성합니다.
    return DataTable(
      border: TableBorder.all(color: Colors.grey),
      headingRowColor:
          MaterialStateColor.resolveWith((states) => Colors.grey.shade300),
      columns: const <DataColumn>[
        DataColumn(label: Text('날짜')),
        DataColumn(label: Text('코스')),
        DataColumn(label: Text('메뉴')),
      ],
      rows: _meals[mealType]!
          .entries
          .expand(
            (entry) => entry.value.map(
              (menuModel) => DataRow(
                cells: <DataCell>[
                  DataCell(
                    Text(
                      DateFormat('yyyy-MM-dd(E)', 'ko_KR')
                          .format(menuModel.date),
                    ),
                  ),
                  DataCell(
                    Text(menuModel.courseName),
                  ),
                  DataCell(
                    Text(
                      menuModel.menuList.join(', '),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
