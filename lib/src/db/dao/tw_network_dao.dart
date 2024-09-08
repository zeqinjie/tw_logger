import 'package:floor/floor.dart';
import 'package:tw_logger/src/db/table/tw_network.dart';

@dao
abstract class TWNetworkDao {
  @Query('SELECT * FROM TWNetwork WHERE id = :id')
  Future<TWNetwork?> findItemById(int id);

  @Query('SELECT * FROM TWNetwork')
  Future<List<TWNetwork>> findAllItems();

  @Query('SELECT * FROM TWNetwork')
  Stream<List<TWNetwork>> findAllItemsAsStream();

  @Query('DELETE FROM TWNetwork')
  Future<void> deleteAllItems();

  @Query('DELETE FROM TWNetwork WHERE id = :id')
  Future<void> deleteItemById(int id);

  @insert
  Future<void> insertItem(TWNetwork item);

  @insert
  Future<void> insertItems(List<TWNetwork> items);

  @update
  Future<void> updateItem(TWNetwork item);

  @update
  Future<void> updateItems(List<TWNetwork> items);

  @delete
  Future<void> deleteItem(TWNetwork item);

  @delete
  Future<void> deleteItems(List<TWNetwork> items);
}
