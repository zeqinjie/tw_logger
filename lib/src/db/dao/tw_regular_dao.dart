import 'package:floor/floor.dart';
import 'package:tw_logger/src/db/table/tw_regular.dart';

@dao
abstract class TWRegularDao {
  @Query('SELECT * FROM TWRegular WHERE id = :id')
  Future<TWRegular?> findItemById(int id);

  @Query('SELECT * FROM TWRegular')
  Future<List<TWRegular>> findAllItems();

  @Query('SELECT * FROM TWRegular')
  Stream<List<TWRegular>> findAllItemsAsStream();

  @Query('DELETE FROM TWRegular')
  Future<void> deleteAllItems();

  @Query('DELETE FROM TWRegular WHERE id = :id')
  Future<void> deleteItemById(int id);

  @insert
  Future<void> insertItem(TWRegular item);

  @insert
  Future<void> insertItems(List<TWRegular> items);

  @update
  Future<void> updateItem(TWRegular item);

  @update
  Future<void> updateItems(List<TWRegular> items);

  @delete
  Future<void> deleteItem(TWRegular item);

  @delete
  Future<void> deleteItems(List<TWRegular> items);
}
