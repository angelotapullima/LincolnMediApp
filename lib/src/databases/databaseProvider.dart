import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Database _database;
  static final DatabaseProvider db = DatabaseProvider._();

  DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'dental.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Paciente ('
          'dniPaciente VARCHAR  PRIMARY KEY,'
          'nombrePaciente VARCHAR,'
          'direccion VARCHAR,'
          'telefono VARCHAR,'
          'foto VARCHAR,'
          'apellidoPaciente VARCHAR'
          ')');

      await db.execute('CREATE TABLE Citas ('
          'idCita VARCHAR  PRIMARY KEY,'
          'idPaciente VARCHAR,'
          'fecha VARCHAR,'
          'hora VARCHAR,'
          'comentarios VARCHAR,'
          'estado VARCHAR,'
          'panombre VARCHAR,'
          'papellido VARCHAR,'
          'padni VARCHAR'
          ')');
    });
  }
}
