// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tw_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $TWDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $TWDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $TWDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<TWDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorTWDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $TWDatabaseBuilderContract databaseBuilder(String name) =>
      _$TWDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $TWDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$TWDatabaseBuilder(null);
}

class _$TWDatabaseBuilder implements $TWDatabaseBuilderContract {
  _$TWDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $TWDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $TWDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<TWDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$TWDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$TWDatabase extends TWDatabase {
  _$TWDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TWRegularDao? _regularInstance;

  TWCrashDao? _crashInstance;

  TWNetworkDao? _networkInstance;

  TWLabelDao? _labelInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TWRegular` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `time` INTEGER NOT NULL, `message` TEXT, `stacktrace` TEXT, `level` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TWCrash` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `time` INTEGER NOT NULL, `stacktrace` TEXT, `error` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TWNetwork` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `requestUri` TEXT, `requestTime` INTEGER NOT NULL, `requestMethod` TEXT, `requestHeaders` TEXT, `requestData` TEXT, `responseTime` INTEGER NOT NULL, `responseHeaders` TEXT, `responseStatusCode` INTEGER, `responseStatusMessage` TEXT, `responseData` TEXT, `error` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TWLabel` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT, `type` TEXT, `time` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TWRegularDao get regular {
    return _regularInstance ??= _$TWRegularDao(database, changeListener);
  }

  @override
  TWCrashDao get crash {
    return _crashInstance ??= _$TWCrashDao(database, changeListener);
  }

  @override
  TWNetworkDao get network {
    return _networkInstance ??= _$TWNetworkDao(database, changeListener);
  }

  @override
  TWLabelDao get label {
    return _labelInstance ??= _$TWLabelDao(database, changeListener);
  }
}

class _$TWRegularDao extends TWRegularDao {
  _$TWRegularDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _tWRegularInsertionAdapter = InsertionAdapter(
            database,
            'TWRegular',
            (TWRegular item) => <String, Object?>{
                  'id': item.id,
                  'time': _dateTimeConverter.encode(item.time),
                  'message': item.message,
                  'stacktrace': item.stacktrace,
                  'level': item.level
                },
            changeListener),
        _tWRegularUpdateAdapter = UpdateAdapter(
            database,
            'TWRegular',
            ['id'],
            (TWRegular item) => <String, Object?>{
                  'id': item.id,
                  'time': _dateTimeConverter.encode(item.time),
                  'message': item.message,
                  'stacktrace': item.stacktrace,
                  'level': item.level
                },
            changeListener),
        _tWRegularDeletionAdapter = DeletionAdapter(
            database,
            'TWRegular',
            ['id'],
            (TWRegular item) => <String, Object?>{
                  'id': item.id,
                  'time': _dateTimeConverter.encode(item.time),
                  'message': item.message,
                  'stacktrace': item.stacktrace,
                  'level': item.level
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TWRegular> _tWRegularInsertionAdapter;

  final UpdateAdapter<TWRegular> _tWRegularUpdateAdapter;

  final DeletionAdapter<TWRegular> _tWRegularDeletionAdapter;

  @override
  Future<TWRegular?> findItemById(int id) async {
    return _queryAdapter.query('SELECT * FROM TWRegular WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TWRegular(
            row['id'] as int?,
            _dateTimeConverter.decode(row['time'] as int),
            row['message'] as String?,
            row['level'] as String?,
            row['stacktrace'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<TWRegular>> findAllItems() async {
    return _queryAdapter.queryList('SELECT * FROM TWRegular',
        mapper: (Map<String, Object?> row) => TWRegular(
            row['id'] as int?,
            _dateTimeConverter.decode(row['time'] as int),
            row['message'] as String?,
            row['level'] as String?,
            row['stacktrace'] as String?));
  }

  @override
  Stream<List<TWRegular>> findAllItemsAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM TWRegular',
        mapper: (Map<String, Object?> row) => TWRegular(
            row['id'] as int?,
            _dateTimeConverter.decode(row['time'] as int),
            row['message'] as String?,
            row['level'] as String?,
            row['stacktrace'] as String?),
        queryableName: 'TWRegular',
        isView: false);
  }

  @override
  Future<void> deleteAllItems() async {
    await _queryAdapter.queryNoReturn('DELETE FROM TWRegular');
  }

  @override
  Future<void> deleteItemById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM TWRegular WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertItem(TWRegular item) async {
    await _tWRegularInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertItems(List<TWRegular> items) async {
    await _tWRegularInsertionAdapter.insertList(
        items, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(TWRegular item) async {
    await _tWRegularUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItems(List<TWRegular> items) async {
    await _tWRegularUpdateAdapter.updateList(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(TWRegular item) async {
    await _tWRegularDeletionAdapter.delete(item);
  }

  @override
  Future<void> deleteItems(List<TWRegular> items) async {
    await _tWRegularDeletionAdapter.deleteList(items);
  }
}

class _$TWCrashDao extends TWCrashDao {
  _$TWCrashDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _tWCrashInsertionAdapter = InsertionAdapter(
            database,
            'TWCrash',
            (TWCrash item) => <String, Object?>{
                  'id': item.id,
                  'time': _dateTimeConverter.encode(item.time),
                  'stacktrace': item.stacktrace,
                  'error': item.error
                },
            changeListener),
        _tWCrashUpdateAdapter = UpdateAdapter(
            database,
            'TWCrash',
            ['id'],
            (TWCrash item) => <String, Object?>{
                  'id': item.id,
                  'time': _dateTimeConverter.encode(item.time),
                  'stacktrace': item.stacktrace,
                  'error': item.error
                },
            changeListener),
        _tWCrashDeletionAdapter = DeletionAdapter(
            database,
            'TWCrash',
            ['id'],
            (TWCrash item) => <String, Object?>{
                  'id': item.id,
                  'time': _dateTimeConverter.encode(item.time),
                  'stacktrace': item.stacktrace,
                  'error': item.error
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TWCrash> _tWCrashInsertionAdapter;

  final UpdateAdapter<TWCrash> _tWCrashUpdateAdapter;

  final DeletionAdapter<TWCrash> _tWCrashDeletionAdapter;

  @override
  Future<TWCrash?> findItemById(int id) async {
    return _queryAdapter.query('SELECT * FROM TWCrash WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TWCrash(
            row['id'] as int?,
            _dateTimeConverter.decode(row['time'] as int),
            row['stacktrace'] as String?,
            row['error'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<TWCrash>> findAllItems() async {
    return _queryAdapter.queryList('SELECT * FROM TWCrash',
        mapper: (Map<String, Object?> row) => TWCrash(
            row['id'] as int?,
            _dateTimeConverter.decode(row['time'] as int),
            row['stacktrace'] as String?,
            row['error'] as String?));
  }

  @override
  Stream<List<TWCrash>> findAllItemsAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM TWCrash',
        mapper: (Map<String, Object?> row) => TWCrash(
            row['id'] as int?,
            _dateTimeConverter.decode(row['time'] as int),
            row['stacktrace'] as String?,
            row['error'] as String?),
        queryableName: 'TWCrash',
        isView: false);
  }

  @override
  Future<void> deleteAllItems() async {
    await _queryAdapter.queryNoReturn('DELETE FROM TWCrash');
  }

  @override
  Future<void> deleteItemById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM TWCrash WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertItem(TWCrash item) async {
    await _tWCrashInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertItems(List<TWCrash> items) async {
    await _tWCrashInsertionAdapter.insertList(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(TWCrash item) async {
    await _tWCrashUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItems(List<TWCrash> items) async {
    await _tWCrashUpdateAdapter.updateList(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(TWCrash item) async {
    await _tWCrashDeletionAdapter.delete(item);
  }

  @override
  Future<void> deleteItems(List<TWCrash> items) async {
    await _tWCrashDeletionAdapter.deleteList(items);
  }
}

class _$TWNetworkDao extends TWNetworkDao {
  _$TWNetworkDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _tWNetworkInsertionAdapter = InsertionAdapter(
            database,
            'TWNetwork',
            (TWNetwork item) => <String, Object?>{
                  'id': item.id,
                  'requestUri': item.requestUri,
                  'requestTime': _dateTimeConverter.encode(item.requestTime),
                  'requestMethod': item.requestMethod,
                  'requestHeaders': item.requestHeaders,
                  'requestData': item.requestData,
                  'responseTime': _dateTimeConverter.encode(item.responseTime),
                  'responseHeaders': item.responseHeaders,
                  'responseStatusCode': item.responseStatusCode,
                  'responseStatusMessage': item.responseStatusMessage,
                  'responseData': item.responseData,
                  'error': item.error
                },
            changeListener),
        _tWNetworkUpdateAdapter = UpdateAdapter(
            database,
            'TWNetwork',
            ['id'],
            (TWNetwork item) => <String, Object?>{
                  'id': item.id,
                  'requestUri': item.requestUri,
                  'requestTime': _dateTimeConverter.encode(item.requestTime),
                  'requestMethod': item.requestMethod,
                  'requestHeaders': item.requestHeaders,
                  'requestData': item.requestData,
                  'responseTime': _dateTimeConverter.encode(item.responseTime),
                  'responseHeaders': item.responseHeaders,
                  'responseStatusCode': item.responseStatusCode,
                  'responseStatusMessage': item.responseStatusMessage,
                  'responseData': item.responseData,
                  'error': item.error
                },
            changeListener),
        _tWNetworkDeletionAdapter = DeletionAdapter(
            database,
            'TWNetwork',
            ['id'],
            (TWNetwork item) => <String, Object?>{
                  'id': item.id,
                  'requestUri': item.requestUri,
                  'requestTime': _dateTimeConverter.encode(item.requestTime),
                  'requestMethod': item.requestMethod,
                  'requestHeaders': item.requestHeaders,
                  'requestData': item.requestData,
                  'responseTime': _dateTimeConverter.encode(item.responseTime),
                  'responseHeaders': item.responseHeaders,
                  'responseStatusCode': item.responseStatusCode,
                  'responseStatusMessage': item.responseStatusMessage,
                  'responseData': item.responseData,
                  'error': item.error
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TWNetwork> _tWNetworkInsertionAdapter;

  final UpdateAdapter<TWNetwork> _tWNetworkUpdateAdapter;

  final DeletionAdapter<TWNetwork> _tWNetworkDeletionAdapter;

  @override
  Future<TWNetwork?> findItemById(int id) async {
    return _queryAdapter.query('SELECT * FROM TWNetwork WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TWNetwork(
            row['id'] as int?,
            _dateTimeConverter.decode(row['requestTime'] as int),
            row['requestUri'] as String?,
            row['requestMethod'] as String?,
            row['requestHeaders'] as String?,
            row['requestData'] as String?,
            row['responseHeaders'] as String?,
            row['responseStatusCode'] as int?,
            row['responseStatusMessage'] as String?,
            row['responseData'] as String?,
            _dateTimeConverter.decode(row['responseTime'] as int),
            row['error'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<TWNetwork>> findAllItems() async {
    return _queryAdapter.queryList('SELECT * FROM TWNetwork',
        mapper: (Map<String, Object?> row) => TWNetwork(
            row['id'] as int?,
            _dateTimeConverter.decode(row['requestTime'] as int),
            row['requestUri'] as String?,
            row['requestMethod'] as String?,
            row['requestHeaders'] as String?,
            row['requestData'] as String?,
            row['responseHeaders'] as String?,
            row['responseStatusCode'] as int?,
            row['responseStatusMessage'] as String?,
            row['responseData'] as String?,
            _dateTimeConverter.decode(row['responseTime'] as int),
            row['error'] as String?));
  }

  @override
  Stream<List<TWNetwork>> findAllItemsAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM TWNetwork',
        mapper: (Map<String, Object?> row) => TWNetwork(
            row['id'] as int?,
            _dateTimeConverter.decode(row['requestTime'] as int),
            row['requestUri'] as String?,
            row['requestMethod'] as String?,
            row['requestHeaders'] as String?,
            row['requestData'] as String?,
            row['responseHeaders'] as String?,
            row['responseStatusCode'] as int?,
            row['responseStatusMessage'] as String?,
            row['responseData'] as String?,
            _dateTimeConverter.decode(row['responseTime'] as int),
            row['error'] as String?),
        queryableName: 'TWNetwork',
        isView: false);
  }

  @override
  Future<void> deleteAllItems() async {
    await _queryAdapter.queryNoReturn('DELETE FROM TWNetwork');
  }

  @override
  Future<void> deleteItemById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM TWNetwork WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertItem(TWNetwork item) async {
    await _tWNetworkInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertItems(List<TWNetwork> items) async {
    await _tWNetworkInsertionAdapter.insertList(
        items, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(TWNetwork item) async {
    await _tWNetworkUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItems(List<TWNetwork> items) async {
    await _tWNetworkUpdateAdapter.updateList(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(TWNetwork item) async {
    await _tWNetworkDeletionAdapter.delete(item);
  }

  @override
  Future<void> deleteItems(List<TWNetwork> items) async {
    await _tWNetworkDeletionAdapter.deleteList(items);
  }
}

class _$TWLabelDao extends TWLabelDao {
  _$TWLabelDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _tWLabelInsertionAdapter = InsertionAdapter(
            database,
            'TWLabel',
            (TWLabel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'type': item.type,
                  'time': _dateTimeConverter.encode(item.time)
                },
            changeListener),
        _tWLabelUpdateAdapter = UpdateAdapter(
            database,
            'TWLabel',
            ['id'],
            (TWLabel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'type': item.type,
                  'time': _dateTimeConverter.encode(item.time)
                },
            changeListener),
        _tWLabelDeletionAdapter = DeletionAdapter(
            database,
            'TWLabel',
            ['id'],
            (TWLabel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'type': item.type,
                  'time': _dateTimeConverter.encode(item.time)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TWLabel> _tWLabelInsertionAdapter;

  final UpdateAdapter<TWLabel> _tWLabelUpdateAdapter;

  final DeletionAdapter<TWLabel> _tWLabelDeletionAdapter;

  @override
  Future<TWLabel?> findItemById(int id) async {
    return _queryAdapter.query('SELECT * FROM TWLabel WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TWLabel(
            row['id'] as int?,
            row['title'] as String?,
            row['type'] as String?,
            _dateTimeConverter.decode(row['time'] as int)),
        arguments: [id]);
  }

  @override
  Future<List<TWLabel>> findAllItemsByType(String type) async {
    return _queryAdapter.queryList('SELECT * FROM TWLabel WHERE type = ?1',
        mapper: (Map<String, Object?> row) => TWLabel(
            row['id'] as int?,
            row['title'] as String?,
            row['type'] as String?,
            _dateTimeConverter.decode(row['time'] as int)),
        arguments: [type]);
  }

  @override
  Future<TWLabel?> findItemByTypeAndTitle(
    String type,
    String title,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM TWLabel WHERE type = ?1 AND title = ?2',
        mapper: (Map<String, Object?> row) => TWLabel(
            row['id'] as int?,
            row['title'] as String?,
            row['type'] as String?,
            _dateTimeConverter.decode(row['time'] as int)),
        arguments: [type, title]);
  }

  @override
  Future<List<TWLabel>> findAllItems() async {
    return _queryAdapter.queryList('SELECT * FROM TWLabel',
        mapper: (Map<String, Object?> row) => TWLabel(
            row['id'] as int?,
            row['title'] as String?,
            row['type'] as String?,
            _dateTimeConverter.decode(row['time'] as int)));
  }

  @override
  Stream<List<TWLabel>> findAllItemsAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM TWLabel',
        mapper: (Map<String, Object?> row) => TWLabel(
            row['id'] as int?,
            row['title'] as String?,
            row['type'] as String?,
            _dateTimeConverter.decode(row['time'] as int)),
        queryableName: 'TWLabel',
        isView: false);
  }

  @override
  Future<void> deleteAllItems() async {
    await _queryAdapter.queryNoReturn('DELETE FROM TWLabel');
  }

  @override
  Future<void> deleteItemById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM TWLabel WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteItemByTypeAndTitle(
    String type,
    String title,
  ) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM TWLabel WHERE type = ?1 AND title = ?2',
        arguments: [type, title]);
  }

  @override
  Future<void> insertItem(TWLabel item) async {
    await _tWLabelInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertItems(List<TWLabel> items) async {
    await _tWLabelInsertionAdapter.insertList(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(TWLabel item) async {
    await _tWLabelUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItems(List<TWLabel> items) async {
    await _tWLabelUpdateAdapter.updateList(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(TWLabel item) async {
    await _tWLabelDeletionAdapter.delete(item);
  }

  @override
  Future<void> deleteItems(List<TWLabel> items) async {
    await _tWLabelDeletionAdapter.deleteList(items);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
