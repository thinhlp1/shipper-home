// ignore_for_file: avoid_print

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBTable {
  static const String customer = 'customer';
  static const String file = 'file';
  static const String customerFile = 'customer_file';
  static const String label = 'lable';
  static const String userLabel = 'user_lable';
}

class DBCustomerColumn {
  static const String id = 'id';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String note = 'note';
  static const String map = 'map';
  static const String address = 'address';
  static const String position = 'position';
  static const String isFavorite = 'is_favorite';
  static const String deleted = 'deleted';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class DBFileColumn {
  static const String id = 'id';
  static const String link = 'link';
  static const String name = 'name';
  static const String extention = 'extention';
  static const String size = 'size';
}

class DBCustomerFileColumn {
  static const String id = 'id';
  static const String customerId = 'customer_id';
  static const String fileId = 'file_id';
}

class DBLabelColumn {
  static const String id = 'id';
  static const String name = 'name';
  static const String icon = 'icon';
  static const String color = 'color';
  static const String editable = 'editable';
  static const String deletable = 'deletable';
  static const String deleted = 'deleted';
}

class DBUserLabelColumn {
  static const String id = 'id';
  static const String username = 'username';
  static const String labelId = 'lable_id';
}

class DatabaseService {
  static final DatabaseService instance = DatabaseService._contructor();

  static Database? _database;

  DatabaseService._contructor();

  final String _dbName = 'shipper_home.db';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await getDatabase();
    return _database!;
  }

  Future<Database> getDatabase() async {
    final dbDirPath = await getDatabasesPath();
    final dbPath = join(dbDirPath, _dbName);

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE ${DBTable.customer} (
          ${DBCustomerColumn.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DBCustomerColumn.name} TEXT,
          ${DBCustomerColumn.phone} TEXT,
          ${DBCustomerColumn.note} TEXT,
          ${DBCustomerColumn.map} TEXT,
          ${DBCustomerColumn.address} TEXT,
          ${DBCustomerColumn.position} INTEGER,
          ${DBCustomerColumn.isFavorite} INTEGER DEFAULT 0,
          ${DBCustomerColumn.deleted} INTEGER DEFAULT 0,
          ${DBCustomerColumn.createdAt} INTEGER DEFAULT (strftime('%s', 'now')),
          ${DBCustomerColumn.updatedAt} INTEGER DEFAULT (strftime('%s', 'now'))
        )
      ''');

        await db.execute('''
        CREATE TABLE ${DBTable.file} (
          ${DBFileColumn.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DBFileColumn.link} TEXT,
          ${DBFileColumn.name} TEXT,
          ${DBFileColumn.extention} TEXT,
          ${DBFileColumn.size} INTEGER
        )
      ''');

        await db.execute('''
        CREATE TABLE ${DBTable.customerFile} (
          ${DBCustomerFileColumn.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DBCustomerFileColumn.customerId} INTEGER,
          ${DBCustomerFileColumn.fileId} INTEGER,
          FOREIGN KEY (${DBCustomerFileColumn.customerId}) REFERENCES ${DBTable.customer}(${DBCustomerColumn.id}) ON DELETE CASCADE,
          FOREIGN KEY (${DBCustomerFileColumn.fileId}) REFERENCES ${DBTable.file}(${DBFileColumn.id}) ON DELETE CASCADE
        )
      ''');

        await db.execute('''
        CREATE TABLE ${DBTable.label} (
          ${DBLabelColumn.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DBLabelColumn.name} TEXT,
          ${DBLabelColumn.icon} TEXT,
          ${DBLabelColumn.color} TEXT,
          ${DBLabelColumn.editable} INTEGER DEFAULT 1,
          ${DBLabelColumn.deletable} INTEGER DEFAULT 1,
          ${DBLabelColumn.deleted} INTEGER DEFAULT 0
        )
      ''');

        await db.execute('''
        CREATE TABLE ${DBTable.userLabel} (
          ${DBUserLabelColumn.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DBUserLabelColumn.username} TEXT,
          ${DBUserLabelColumn.labelId} INTEGER,
          FOREIGN KEY (${DBUserLabelColumn.labelId}) REFERENCES ${DBTable.label}(${DBLabelColumn.id}) ON DELETE CASCADE
        )
      ''');

        // **Inser default data**
        // insertDefaultData(db);
      },
    );
  }

  /// Resets the database by deleting the existing database file if it exists
  /// and then recreating the database and its tables.
  ///
  /// This function performs the following steps:
  /// 1. Retrieves the path to the database directory.
  /// 2. Constructs the full path to the database file.
  /// 3. Checks if the database file exists.
  /// 4. If the database file exists, it deletes the file.
  /// 5. Recreates the database and its tables.
  ///
  /// This is useful for scenarios where you need to clear all data and start
  /// fresh with a new database.
  ///
  /// Note: This operation is asynchronous and should be awaited.
  Future<void> resetDatabase() async {
    final dbDirPath = await getDatabasesPath();
    final dbPath = join(dbDirPath, _dbName);

    // Xóa database nếu tồn tại
    if (await databaseExists(dbPath)) {
      await deleteDatabase(dbPath);
      print('Database đã được xóa');
    }

    // Tạo lại database và các bảng
    _database = await getDatabase();
    print('Database và các bảng đã được tạo lại');
  }

  /// Inserts default data into the provided database.
  ///
  /// This function performs the following operations:
  /// - Inserts sample customers into the `customer` table.
  /// - Inserts sample files into the `file` table.
  /// - Associates the inserted files with the first customer.
  /// - Inserts default labels into the `lable` table.
  ///
  /// The inserted data includes:
  /// - Two customers with names, phone numbers, notes, addresses, and favorite status.
  /// - Two files with links, names, extensions, and sizes.
  /// - Associations between the first customer and the two files.
  /// - Two labels with names, icons, and colors.
  ///
  /// Prints a message indicating that the default data has been inserted.
  ///
  /// Parameters:
  /// - `db`: The database instance where the data will be inserted.
  ///
  /// Returns:
  /// - A `Future<void>` indicating the completion of the operation.
  Future<void> insertDefaultData(Database db) async {
    // Chèn khách hàng mẫu
    int customer1Id = await db.insert(DBTable.customer, {
      DBCustomerColumn.name: 'lê Phước Thịnh',
      DBCustomerColumn.phone: '0334831013',
      DBCustomerColumn.note: 'Khách VIP',
      DBCustomerColumn.map: '',
      DBCustomerColumn.address: 'số 215 đường 3/2, hẻm thứ 2 quẹo trái',
      DBCustomerColumn.position: 1,
      DBCustomerColumn.isFavorite: 1,
      DBCustomerColumn.deleted: 0,
    });

    await db.insert(DBTable.customer, {
      DBCustomerColumn.name: 'Trần Thị B',
      DBCustomerColumn.phone: '0222244444',
      DBCustomerColumn.note: 'Khách mới',
      DBCustomerColumn.map: '',
      DBCustomerColumn.address: 'Hồ Chí Minh',
      DBCustomerColumn.position: 2,
      DBCustomerColumn.isFavorite: 0,
      DBCustomerColumn.deleted: 0,
    });

    // Chèn file mẫu
    int file1Id = await db.insert(DBTable.file, {
      DBFileColumn.link:
          'https://thanhvietcorp.vn/uploads/images/Bao%20chi/cac-mau-nha-vuon-dep.jpg',
      DBFileColumn.name: 'Hình 1',
      DBFileColumn.extention: 'jpg',
      DBFileColumn.size: 200,
    });

    int file2Id = await db.insert(DBTable.file, {
      DBFileColumn.link:
          'https://thanhvietcorp.vn/uploads/images/Bao%20chi/download-hinh-ngoi-nha-1024x684.jpg',
      DBFileColumn.name: 'Hình 2',
      DBFileColumn.extention: 'jpg',
      DBFileColumn.size: 200,
    });

    // Gán 2 hình ảnh cho khách hàng 1
    await db.insert(DBTable.customerFile, {
      DBCustomerFileColumn.customerId: customer1Id,
      DBCustomerFileColumn.fileId: file1Id,
    });

    await db.insert(DBTable.customerFile, {
      DBCustomerFileColumn.customerId: customer1Id,
      DBCustomerFileColumn.fileId: file2Id,
    });

    print('Dữ liệu mặc định đã được chèn vào database');
  }

  Future<void> insertTestData(Database db) async {
    // Chèn khách hàng mẫu
    for (int i = 0; i < 100; i++) {
      await db.insert(DBTable.customer, {
        DBCustomerColumn.name: 'Nguyễn Văn A $i',
        DBCustomerColumn.phone: '0334831013',
        DBCustomerColumn.note: 'Khách VIP $i',
        DBCustomerColumn.map: '',
        DBCustomerColumn.address: 'Hà Nội $i',
        DBCustomerColumn.position: i + 1,
        DBCustomerColumn.isFavorite: 0,
        DBCustomerColumn.deleted: 0,
      });
    }

    print('Insert 100 dữ liệu test');
  }
}
