import 'package:form_validation/src/databases/databaseProvider.dart'; 
import 'package:form_validation/src/models/paciente_model.dart';

class PacientesDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarPaciente(PacienteModel paciente) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Paciente (dniPaciente,nombrePaciente,direccion,telefono,foto,apellidoPaciente) "
          "VALUES ('${paciente.carnet}','${paciente.name}','${paciente.direccion}','${paciente.number}','${paciente.fotoUrl}','${paciente.lastname}')");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<PacienteModel>> obtenerPacientes() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Paciente");

    List<PacienteModel> list =
        res.isNotEmpty ? res.map((c) => PacienteModel.fromJson2(c)).toList() : [];

    return list;
  }
  Future<List<PacienteModel>> obtenerPacientePorDni(String dni) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Paciente where dniPaciente='$dni'");

    List<PacienteModel> list =
        res.isNotEmpty ? res.map((c) => PacienteModel.fromJson2(c)).toList() : [];

    return list;
  }
}
