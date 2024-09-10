import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:tw_logger/src/db/table/tw_label.dart';
import 'package:tw_logger/tw_logger.dart';

abstract class TWSearchBase<T> extends StatefulWidget {
  const TWSearchBase({super.key});

  @override
  State<TWSearchBase<T>> createState();
}

abstract class TWSearchBaseState<T> extends State<TWSearchBase<T>> {
  TextEditingController searchController = TextEditingController();
  List<T> resultList = [];
  late StreamController<List<T>> _searchController;
  bool isLoading = false;
  List<String> labels = [];
  String get searchText => searchController.text;

  @override
  void initState() {
    super.initState();
    fetchLabelCache();
    fetchCache();
    _searchController = StreamController<List<T>>.broadcast();

    searchController.addListener(() {
      _searchController.sink.add(fetchSearch());
    });

    if (TWLoggerConfigure().isUpdateDatabase) {
      Timer.periodic(
        TWLoggerConfigure().updateDuration,
        (timer) {
          fetchCache(showLoading: false);
        },
      );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _searchController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  Widget buildBody() {
    return KeyboardVisibilityProvider(
      child: KeyboardDismissOnTap(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: bgColor,
            title: Text(fetchTitle),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () async {
                  await deleteAllItems();
                  fetchCache();
                },
                icon: const Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () {
                  fetchCache();
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          backgroundColor: bgColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSearchField(),
              buildLabelChip(),
              if (isLoading) const Center(child: CircularProgressIndicator()),
              Expanded(
                child: buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabelChip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        spacing: 2,
        children: labels.map((it) {
          return GestureDetector(
            onTap: () => searchController.text = it,
            child: Chip(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: bgColor, width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.zero,
              label: Text(it),
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              onDeleted: () => handleRemoveLabel(it),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildLabelButton(context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => handleAddLabel(context),
          child: Icon(
            Icons.label,
            color: bgColor,
          ),
        ),
        IconButton(
          onPressed: () {
            searchController.clear();
          },
          icon: const Icon(Icons.clear),
        )
      ],
    );
  }

  Widget buildContent() {
    return StreamBuilder<List<T>>(
      stream: _searchController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData && !isLoading) {
          return buildTip();
        }
        final filteredResults = snapshot.data ?? [];
        if (filteredResults.isEmpty) {
          return buildTip();
        }
        return buildGroupedListView(filteredResults);
      },
    );
  }

  Widget buildSearchField() {
    return Container(
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              autocorrect: false,
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black26,
                ),
                border: InputBorder.none,
                hintText: "Enter keyword to search",
              ),
            ),
          ),
          StreamBuilder<List<T>>(
            stream: _searchController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${snapshot.data!.length} results'),
                    const SizedBox(width: 2),
                    if (searchText.isNotEmpty) buildLabelButton(context),
                  ],
                );
              }
              if (searchText.isNotEmpty) return buildLabelButton(context);
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget buildTip() {
    return const Center(child: Text("No data available"));
  }

  Widget buildGroupedListView(List<T> filteredResults);

  void handleAddLabel(context) async {
    final query = searchText.trim();
    if (query.isNotEmpty) {
      final res = await handleLabelCache(query);
      if (!res) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Label is existed'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      setState(() {
        labels.add(query);
      });
    }
  }

  void handleRemoveLabel(String label) async {
    await removeLabelCache(label);
    setState(() {
      labels.remove(label);
    });
  }

  Future<void> fetchLabelCache() async {
    final res = await fetchLabels();
    setState(() {
      labels = res
          .where(
            (it) => it.title != null,
          )
          .map((it) => it.title!)
          .toList();
    });
  }

  Future<bool> removeLabelCache(String label);

  fetchCache({
    bool showLoading = true,
  }) async {
    if (showLoading) {
      setState(() {
        isLoading = true;
      });
    }
    final res = await fetchAllItems();
    setState(() {
      resultList = res.toList();
      _searchController.sink.add(fetchSearch());
      if (showLoading) {
        isLoading = false;
      }
    });
  }

  List<T> fetchSearch() {
    final query = searchText.toLowerCase();
    return resultList.where((it) {
      return matchesQuery(it, query);
    }).toList();
  }

  Color get bgColor {
    final bgColor = TWLoggerConfigure().themeColor;
    return bgColor;
  }

  String fetchDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  String fetchTime(DateTime date) {
    return '${date.hour}:${date.minute}:${date.second}';
  }

  String get fetchTitle;

  Future<bool> handleLabelCache(String label);

  bool matchesQuery(T item, String query);

  Future<List<T>> fetchAllItems();

  Future<void> deleteAllItems();

  Future<List<TWLabel>> fetchLabels();
}
