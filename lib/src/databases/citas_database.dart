import 'package:form_validation/src/databases/databaseProvider.dart';
import 'package:form_validation/src/models/citas_model.dart';

class CitasDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarCitas(CitasModel citas) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Citas (idCita,idPaciente,fecha,hora,comentarios,estado,panombre,papellido,padni) "
          "VALUES ('${citas.idCita}','${citas.idPaciente}','${citas.fecha}','${citas.hora}','${citas.comentarios}','${citas.estado}','${citas.paNombre}','${citas.papellido}','${citas.padni}')");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<CitasModel>> obtenerCitasPorFecha(String fecha) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Citas where fecha='$fecha'");

    List<CitasModel> list =
        res.isNotEmpty ? res.map((c) => CitasModel.fromJson(c)).toList() : [];

    return list;
  }
}
