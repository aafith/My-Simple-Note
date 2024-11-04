import '../services/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  late DbHelper _dbHelper;

  Repository() {
    _dbHelper = DbHelper();
  }

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _dbHelper.setDatabase();
      return _database;
    }
  }

  // Insert data to the table
  insertData(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  // Read data from the table
  readData(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  // Read data from the table by ID
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection?.query(table, where: 'id = ?', whereArgs: [itemId]);
  }

  // Update data in the table
  updateData(table, data) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: 'id = ?', whereArgs: [data['id']]);
  }

  // Delete data from the table
  deleteData(table, itemId) async {
    var connection = await database;
    return await connection?.rawDelete('DELETE FROM $table WHERE id = $itemId');
  }
}
