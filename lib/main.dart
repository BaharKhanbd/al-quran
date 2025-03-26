import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PDFViewerPage(),
    );
  }
}

class PDFViewerPage extends StatefulWidget {
  const PDFViewerPage({super.key});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  late TextEditingController _searchController;
  late PdfViewerController _pdfViewerController;
  int currentPage = 1;
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _pdfViewerController = PdfViewerController();

    // Add listener for real-time navigation
    _searchController.addListener(() {
      final text = _searchController.text;
      if (text.isNotEmpty) {
        final pageNumber = int.tryParse(text) ?? 1;
        if (pageNumber > 0) {
          _pdfViewerController.jumpToPage(pageNumber + 0);
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hafizi Al Quran"),
        actions: [
          if (!_showSearch)
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.green,
                  size: 24,
                ),
                onPressed: _toggleSearch,
              ),
            ),
        ],
        flexibleSpace: _showSearch
            ? Padding(
                padding: const EdgeInsets.only(top: 35, left: 200),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  height: 35,
                  width: 90,
                  child: TextFormField(
                    controller: _searchController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.search,
                                size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      hintText: 'Page number',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      contentPadding: const EdgeInsets.only(left: 14),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.green.withOpacity(0.2),
                      isDense: true,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.close, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          _toggleSearch();
                        },
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: SfPdfViewer.asset(
        "assets/al_quran.pdf", // Replace with your PDF file path
        controller: _pdfViewerController,
        pageLayoutMode: PdfPageLayoutMode.single,
        enableDoubleTapZooming: true,
        canShowScrollStatus: true,
        canShowPaginationDialog: true,
        scrollDirection: PdfScrollDirection.horizontal,
      ),
    );
  }
}
