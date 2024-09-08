import 'package:floor/floor.dart';
import 'package:tw_logger/src/db/table/tw_crash.dart';

@dao
abstract class TWCrashDao {
  @Query('SELECT * FROM TWCrash WHERE id = :id')
  Future<TWCrash?> findItemById(int id);

  @Query('SELECT * FROM TWCrash')
  Future<List<TWCrash>> findAllItems();

  @Query('SELECT * FROM TWCrash')
  Stream<List<TWCrash>> findAllItemsAsStream();

  @Query('DELETE FROM TWCrash')
  Future<void> deleteAllItems();

  @Query('DELETE FROM TWCrash WHERE id = :id')
  Future<void> deleteItemById(int id);

  @insert
  Future<void> insertItem(TWCrash item);

  @insert
  Future<void> insertItems(List<TWCrash> items);

  @update
  Future<void> updateItem(TWCrash item);

  @update
  Future<void> updateItems(List<TWCrash> items);

  @delete
  Future<void> deleteItem(TWCrash item);

  @delete
  Future<void> deleteItems(List<TWCrash> items);
}
