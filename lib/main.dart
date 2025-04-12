import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';

void main() {
  runApp(const MaterialApp(
    home: WebCSVWithPagination(),
    debugShowCheckedModeBanner: false,
  ));
}

class WebCSVWithPagination extends StatefulWidget {
  const WebCSVWithPagination({super.key});

  @override
  State<WebCSVWithPagination> createState() => _WebCSVWithPaginationState();
}

class _WebCSVWithPaginationState extends State<WebCSVWithPagination> {
  List<List<dynamic>> _csvData = [];
  int _currentPage = 0;
  final int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadFromLocalStorage();
  }

  void _loadFromLocalStorage() {
    final saved = html.window.localStorage['savedCSV'];
    if (saved != null) {
      final csv = const CsvToListConverter().convert(saved);
      setState(() {
        _csvData = csv;
      });
    }
  }

  void _pickCSVFile() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
      ..accept = '.csv';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final file = uploadInput.files!.first;
      final reader = html.FileReader();

      reader.readAsText(file);
      reader.onLoadEnd.listen((e) {
        final content = reader.result as String;

        html.window.localStorage['savedCSV'] = content;

        final csv = const CsvToListConverter().convert(content);
        setState(() {
          _csvData = csv;
          _currentPage = 0;
        });
      });
    });
  }

  void _clearCSV() {
    html.window.localStorage.remove('savedCSV');
    setState(() {
      _csvData = [];
      _currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalRows = _csvData.length > 1 ? _csvData.length - 1 : 0;
    final totalPages = (totalRows / _rowsPerPage).ceil();

    // חישוב השורות של העמוד הנוכחי בלבד
    final start = _currentPage * _rowsPerPage + 1;
    final end = (_currentPage + 1) * _rowsPerPage + 1;
    final pageData = _csvData.length > 1
        ? _csvData.sublist(start, end.clamp(1, _csvData.length))
        : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV Viewer with Paging'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: "מחק קובץ",
            onPressed: _csvData.isNotEmpty ? _clearCSV : null,
          ),
        ],
      ),
      body: _csvData.isEmpty
          ? const Center(
              child: Text('לא נטען קובץ CSV. לחץ על ➕ כדי לבחור אחד'),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(
                        Colors.amber.shade200,
                      ),
                      columns: [
                        const DataColumn(
                          label: Text(
                            'Index',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ..._csvData[0]
                            .map((e) => DataColumn(
                                  label: Text(
                                    e.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ))
                            .toList(),
                      ],
                      rows: pageData.asMap().entries.map((entry) {
                        final index =
                            entry.key + 1 + (_currentPage * _rowsPerPage);
                        final row = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(Text(index.toString())),
                            ...row
                                .map((e) => DataCell(Text(e.toString())))
                                .toList(),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (totalPages > 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        if (_currentPage > 0)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _currentPage--;
                              });
                            },
                            child: const Text("<< הקודם"),
                          ),
                        ...List.generate(
                          totalPages,
                          (pageIndex) => TextButton(
                            onPressed: () {
                              setState(() {
                                _currentPage = pageIndex;
                              });
                            },
                            child: Text(
                              '${pageIndex + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: _currentPage == pageIndex
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _currentPage == pageIndex
                                    ? Colors.amber
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        if (_currentPage < totalPages - 1)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _currentPage++;
                              });
                            },
                            child: const Text("הבא >>"),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickCSVFile,
        tooltip: "בחר קובץ CSV",
        backgroundColor: Colors.amber,
        child: const Icon(Icons.upload_file),
      ),
    );
  }
}
