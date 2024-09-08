import 'package:flutter/material.dart';
import 'package:tw_logger/src/db/table/tw_crash.dart';
import 'package:tw_logger/src/db/table/tw_label.dart';
import 'package:tw_logger/src/helper/tw_crash_helper.dart';
import 'package:tw_logger/src/helper/tw_label_helper.dart';
import 'package:tw_logger/src/helper/tw_loger_helper.dart';
import 'package:tw_logger/src/ui/tw_search_base.dart';
import 'package:grouped_list/grouped_list.dart' as grouped_list;

class TWCrashSearch extends TWSearchBase<TWCrash> {
  const TWCrashSearch({super.key});

  @override
  State<TWSearchBase<TWCrash>> createState() => _TWCrashSearchState();
}

class _TWCrashSearchState extends TWSearchBaseState<TWCrash> {
  @override
  Widget buildGroupedListView(List<TWCrash> filteredResults) {
    return grouped_list.GroupedListView<TWCrash, String>(
      elements: filteredResults,
      groupBy: (element) => fetchDate(element.time),
      itemComparator: (item1, item2) => item1.time.compareTo(item2.time),
      order: grouped_list.GroupedListOrder.DESC,
      groupHeaderBuilder: (element) => buildGroupHeader(element),
      itemBuilder: (context, element) => buildCard(element),
      useStickyGroupSeparators: true,
    );
  }

  Widget buildGroupHeader(TWCrash element) {
    return Container(
      color: bgColor,
      alignment: Alignment.center,
      height: 30,
      child: Text(
        fetchDate(element.time),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildCard(TWCrash element) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TWCrashDetail(
            element: element,
            bgColor: bgColor,
          ),
        ),
      ),
      onLongPress: () => TWLoggerHelper.clipboard(
        context,
        '${element.error}\n${element.stacktrace}',
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    size: 20,
                    Icons.error,
                  ),
                  const Spacer(),
                  Text(
                    fetchTime(element.time),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                element.error ?? '',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool matchesQuery(TWCrash item, String query) {
    final error = item.error?.toLowerCase() ?? '';
    final time = fetchDate(item.time).toLowerCase();
    final stacktrace = item.stacktrace.toString().toLowerCase();
    return error.contains(query) ||
        time.contains(query) ||
        stacktrace.contains(query);
  }

  @override
  Future deleteAllItems() async {
    await TWCrashHelper.deleteAllItems();
  }

  @override
  Future<List<TWCrash>> fetchAllItems() async {
    return TWCrashHelper.findAllItems();
  }

  @override
  String get fetchTitle => "Crash Search";

  @override
  Future<List<TWLabel>> fetchLabels() async {
    return TWLabelHelper.findAllItemsByType('crash');
  }

  @override
  Future<bool> handleLabelCache(String label) async {
    return TWLabelHelper.handleLabelCache(label, 'crash');
  }

  @override
  Future<bool> removeLabelCache(String label) async {
    return TWLabelHelper.handleRemoveLabelCache(label, 'crash');
  }
}

class TWCrashDetail extends StatefulWidget {
  final TWCrash element;
  final Color bgColor;
  const TWCrashDetail({
    super.key,
    required this.element,
    required this.bgColor,
  });

  @override
  State<TWCrashDetail> createState() => _TWNetworkDetailState();
}

class _TWNetworkDetailState extends State<TWCrashDetail> {
  TWCrash get element => widget.element;
  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  Widget buildBody() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crash Detail'),
        centerTitle: true,
        backgroundColor: widget.bgColor,
      ),
      backgroundColor: widget.bgColor,
      body: SafeArea(
        child: GestureDetector(
          onLongPress: () => TWLoggerHelper.clipboard(
            context,
            '${element.error}\n${element.stacktrace}',
          ),
          child: Card(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      element.error ?? '',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      element.stacktrace ?? '',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
