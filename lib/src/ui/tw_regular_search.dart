import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tw_logger/src/db/table/tw_label.dart';
import 'package:tw_logger/src/db/table/tw_regular.dart';
import 'package:tw_logger/src/helper/tw_label_helper.dart';
import 'package:tw_logger/src/helper/tw_loger_helper.dart';
import 'package:tw_logger/src/helper/tw_regular_helper.dart';
import 'package:tw_logger/src/ui/tw_search_base.dart';
import 'package:grouped_list/grouped_list.dart' as grouped_list;

class TWRegularSearch extends TWSearchBase<TWRegular> {
  const TWRegularSearch({super.key});

  @override
  State<TWSearchBase<TWRegular>> createState() => _TWRegularSearchState();
}

class _TWRegularSearchState extends TWSearchBaseState<TWRegular> {
  @override
  Widget buildGroupedListView(List<TWRegular> filteredResults) {
    return grouped_list.GroupedListView<TWRegular, String>(
      elements: filteredResults,
      groupBy: (element) => fetchDate(element.time),
      itemComparator: (item1, item2) => item1.time.compareTo(item2.time),
      order: grouped_list.GroupedListOrder.DESC,
      groupHeaderBuilder: (element) => buildGroupHeader(element),
      itemBuilder: (context, element) => buildCard(element),
      useStickyGroupSeparators: true,
    );
  }

  Widget buildGroupHeader(TWRegular element) {
    return Container(
      alignment: Alignment.center,
      color: bgColor,
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

  Widget buildCard(TWRegular element) {
    return GestureDetector(
      onLongPress: () => TWLoggerHelper.clipboard(
        context,
        '${element.message}\n${element.stacktrace}',
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    element.level ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
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
                element.message ?? '',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                element.stacktrace ?? '',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool matchesQuery(TWRegular item, String query) {
    final message = item.message?.toLowerCase() ?? '';
    final time = fetchDate(item.time).toLowerCase();
    final level = item.level.toString().toLowerCase();
    return message.contains(query) ||
        time.contains(query) ||
        level.contains(query);
  }

  @override
  Future deleteAllItems() async {
    await TWRegularHelper.deleteAllItems();
  }

  @override
  Future<List<TWRegular>> fetchAllItems() async {
    return TWRegularHelper.findAllItems();
  }

  @override
  String get fetchTitle => "Regular Log Search";

  @override
  Future<List<TWLabel>> fetchLabels() async {
    return TWLabelHelper.findAllItemsByType('regular');
  }

  @override
  Future<bool> handleLabelCache(String label) async {
    return TWLabelHelper.handleLabelCache(label, 'regular');
  }

  @override
  Future<bool> removeLabelCache(String label) async {
    return TWLabelHelper.handleRemoveLabelCache(label, 'regular');
  }
}
