import 'package:floor/floor.dart';
import 'package:tw_logger/src/db/table/tw_label.dart';

@dao
abstract class TWLabelDao {
  @Query('SELECT * FROM TWLabel WHERE id = :id')
  Future<TWLabel?> findItemById(int id);

  @Query('SELECT * FROM TWLabel WHERE type = :type')
  Future<List<TWLabel>> findAllItemsByType(String type);

  @Query('SELECT * FROM TWLabel WHERE type = :type AND title = :title')
  Future<TWLabel?> findItemByTypeAndTitle(String type, String title);

  @Query('SELECT * FROM TWLabel')
  Future<List<TWLabel>> findAllItems();

  @Query('SELECT * FROM TWLabel')
  Stream<List<TWLabel>> findAllItemsAsStream();

  @Query('DELETE FROM TWLabel')
  Future<void> deleteAllItems();

  @Query('DELETE FROM TWLabel WHERE id = :id')
  Future<void> deleteItemById(int id);

  @Query('DELETE FROM TWLabel WHERE type = :type AND title = :title')
  Future<void> deleteItemByTypeAndTitle(String type, String title);

  @insert
  Future<void> insertItem(TWLabel item);

  @insert
  Future<void> insertItems(List<TWLabel> items);

  @update
  Future<void> updateItem(TWLabel item);

  @update
  Future<void> updateItems(List<TWLabel> items);

  @delete
  Future<void> deleteItem(TWLabel item);

  @delete
  Future<void> deleteItems(List<TWLabel> items);
}
