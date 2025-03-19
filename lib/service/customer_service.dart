import 'dart:io';

import 'package:base/models/customer.dart';

import 'database_service.dart';

class CustomerService {
  final DatabaseService _databaseService = DatabaseService.instance;

  /// Saves a [Customer] object to the database.
  ///
  /// This function inserts the given [customer] into the customer table
  /// in the database. It uses the [_databaseService] to get the database
  /// instance and then performs the insert operation.
  ///
  /// The [customer] parameter is the [Customer] object to be saved.
  ///
  /// Throws an exception if the database operation fails.
  ///
  /// Example:
  /// ```dart
  /// Customer customer = Customer(name: 'John Doe', email: 'john.doe@example.com');
  /// await saveCustomer(customer);
  /// ```
  Future<int> saveCustomer(Customer customer) async {
    final db = await _databaseService.database;
    return await db.insert(DBTable.customer, customer.toMap());
  }

  /// Retrieves a list of customers from the database, including their associated files.
  ///
  /// This function performs a raw SQL query to fetch customer data along with any associated
  /// files and sort by isFavorite . It joins the `customer`, `customer_file`, and `file` tables to gather the necessary
  /// information. The results are then processed to create a list of `Customer` objects, each
  /// containing a list of file URLs if any files are associated with the customer.
  ///
  /// Returns a `Future` that resolves to a list of `Customer` objects.
  ///
  /// Throws an exception if there is an error during the database query or processing.
  Future<List<Customer>> getCustomers() async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT c.*, f.id as file_id, f.link, f.extention, f.size 
      FROM customer c
      LEFT JOIN customer_file cf ON c.id = cf.customer_id
      LEFT JOIN file f ON cf.file_id = f.id
    ''');

    Map<int, Customer> customerMap = {};

    for (var row in results) {
      int customerId = row['id'];

      // If customer is not in the map, add it
      if (!customerMap.containsKey(customerId)) {
        customerMap[customerId] = Customer.fromMap(row);
      }

      // If the file_id is not null, add the file to the customer
      if (row['file_id'] != null) {
        customerMap[customerId]!.imageUrl.add(row['link']);
      }
    }

    List<Customer> customers = customerMap.values.toList();

    // Sort customers by position
    customers.sort((a, b) => a.position.compareTo(b.position));

    // Move isFavorite customers to the beginning of the list
    customers.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return a.position.compareTo(b.position);
    });

    return customers;
  }

  /// Updates the `isFavorite` status of a customer.
  ///
  /// This function updates the `isFavorite` status of the customer with the given [id].
  /// It sets the `isFavorite` column to the value of [isFavorite] for the specified customer.
  ///
  /// The [id] parameter is the ID of the customer to be updated.
  /// The [isFavorite] parameter is the new value for the `isFavorite` status.
  ///
  /// Throws an exception if the database operation fails.
  Future<void> updateIsFavorite(int id, bool isFavorite) async {
    final db = await _databaseService.database;
    await db.update(
      DBTable.customer,
      {DBCustomerColumn.isFavorite: isFavorite ? 1 : 0},
      where: '${DBCustomerColumn.id} = ?',
      whereArgs: [id],
    );
  }

  /// Updates the positions of a list of customers in the database.
  ///
  /// This function iterates over the provided list of customers and updates
  /// each customer's position in the database by calling the `updatePosition`
  /// method.
  ///
  /// Parameters:
  /// - `customers`: A list of `Customer` objects whose positions need to be updated.
  ///
  /// Returns:
  /// A `Future` that completes when all customer positions have been updated.
  Future<void> updateCustomerPositions(List<Customer> customers) async {
    final db = await _databaseService.database;

    for (var customer in customers) {
      // Update each customer's position in the database
      await db.update(
        DBTable.customer,
        {'position': customer.position},
        where: 'id = ?',
        whereArgs: [customer.id],
      );
    }
  }

  /// Saves a customer image to the database.
  ///
  /// This function takes a [customerId] and an [imagePath], and performs the following steps:
  /// 1. Inserts the image into the file table with its metadata (link, name, extension, and size).
  /// 2. Links the inserted image to the customer in the customerFile table.
  ///
  /// The function prints 'Customer image saved' upon successful completion.
  ///
  /// Throws an exception if there is an error during the database operations.
  ///
  /// - Parameters:
  ///   - customerId: The ID of the customer to whom the image belongs.
  ///   - imagePath: The file path of the image to be saved.
  Future<void> saveCustomerImage(int customerId, String imagePath) async {
    final db = await _databaseService.database;

    // Insert the image into the file table
    int fileId = await db.insert(DBTable.file, {
      DBFileColumn.link: imagePath,
      DBFileColumn.name: imagePath.split('/').last,
      DBFileColumn.extention: 'jpg',
      DBFileColumn.size: await File(imagePath).length(),
    });

    // Link the image to the customer
    await db.insert(DBTable.customerFile, {
      DBCustomerFileColumn.customerId: customerId,
      DBCustomerFileColumn.fileId: fileId,
    });

  }

  Future<void> deleteCustomerImage(int customerId, String imagePath) async {
    final db = await _databaseService.database;

    // Get the file ID of the image
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT f.id
      FROM file f
      JOIN customer_file cf ON f.id = cf.file_id
      WHERE cf.customer_id = ? AND f.link = ?
    ''', [customerId, imagePath]);

    if (results.isNotEmpty) {
      int fileId = results.first['id'];

      // Delete the image from the file table
      await db.delete(DBTable.file,
          where: '${DBFileColumn.id} = ?', whereArgs: [fileId]);

      // Unlink the image from the customer
      await db.delete(DBTable.customerFile,
          where:
              '${DBCustomerFileColumn.customerId} = ? AND ${DBCustomerFileColumn.fileId} = ?',
          whereArgs: [customerId, fileId]);

    }
  }

  Future<void> updateCustomer(int id, Customer customer) async {
    final db = await _databaseService.database;
    await db.update(DBTable.customer, customer.toMap(),
        where: '${DBCustomerColumn.id} = ?', whereArgs: [id]);
  }

  /// Deletes a customer from the database.
  /// This function deletes the customer with the given [id] from the database.
  ///
  /// Parameters:
  /// - `id`: The ID of the customer to be deleted.
  Future<void> deleteCustomer(int id) async {
    final db = await _databaseService.database;
    await db.delete(DBTable.customer,
        where: '${DBCustomerColumn.id} = ?', whereArgs: [id]);
  }

  /// Get the last customer added
  ///
  /// This function returns the last customer added to the database.
  ///
  /// @return Future<Customer?>
  Future<Customer?> getLastInsertedCustomer() async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT c.*, f.id as file_id, f.link, f.extention, f.size 
      FROM customer c
      LEFT JOIN customer_file cf ON c.id = cf.customer_id
      LEFT JOIN file f ON cf.file_id = f.id
      ORDER BY c.id DESC
      LIMIT 1
    ''');

    if (results.isNotEmpty) {
      Map<int, Customer> customerMap = {};
      for (var row in results) {
        int customerId = row['id'];

        if (!customerMap.containsKey(customerId)) {
          customerMap[customerId] = Customer.fromMap(row);
        }

        if (row['file_id'] != null) {
          customerMap[customerId]!.imageUrl.add(row['link']);
        }
      }
      return customerMap.values.first;
    }

    return null;
  }
}
