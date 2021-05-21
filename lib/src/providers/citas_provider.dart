import 'dart:convert';

import 'package:form_validation/src/databases/citas_database.dart';
import 'package:form_validation/src/models/citas_model.dart';
import 'package:http/http.dart' as http;

class CitasProvider {
  final citasDatabase = CitasDatabase();

  Future<bool> listarCitasPorDia(String fecha) async {
    try {
      final url = 'https://guabba.com/dental/api/cita/listar_citas_dia_todo';

      final resp = await http.post(url, body: {
        'fecha': '$fecha',
      });

      final decodedData = json.decode(resp.body);

      if (decodedData['data'].length > 0) {
        for (int i = 0; i < decodedData['data'].length; i++) {
          CitasModel citasModel = CitasModel();

          citasModel.idCita = decodedData['data'][i]['id_cita'];
          citasModel.idPaciente = decodedData['data'][i]['id_paciente'];
          citasModel.fecha = decodedData['data'][i]['cita_fecha'];
          citasModel.hora = decodedData['data'][i]['cita_hora'];
          citasModel.comentarios = decodedData['data'][i]['cita_comentarios'];
          citasModel.estado = decodedData['data'][i]['cita_estado'];
          citasModel.paNombre = decodedData['data'][i]['paciente_nombre'];
          citasModel.papellido = decodedData['data'][i]['paciente_apellido'];
          citasModel.padni = decodedData['data'][i]['paciente_dni'];

          await citasDatabase.insertarCitas(citasModel);
        }
        //Huevo estuvo aqui
        return true;
      } else {
        return false;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return false;
    }
  }

  Future<bool> registrarCita(
      String idaPaciente, String fecha, String hora) async {
    try {
      final url = 'https://guabba.com/dental/api/cita/registrar_cita_dni';

      final horaSinFormato = hora.split('-');
      final fechita = horaSinFormato[0].trim();

      final algo = fechita.split(':');
      var estoVale = algo[0].trim();

      estoVale = '${estoVale.padLeft(2, '0')}:00:00';

      final resp = await http.post(url, body: {
        'dni': '$idaPaciente',
        'cita_fecha': '$fecha',
        'cita_hora': '$estoVale',
      });

      final decodedData = json.decode(resp.body);

      if (decodedData['result']['code'].toString() == '1') {
        //Huevo estuvo aqui
        return true;
      } else {
        return false;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return false;
    }
  }


  Future<bool> atenderCita(
      String idCita) async {
    try {
      final url = 'https://guabba.com/dental/api/cita/atender_cita';

    

      final resp = await http.post(url, body: {
        'id_cita': '$idCita',
        'cita_comentarios': '', 
      });

      final decodedData = json.decode(resp.body);

      if (decodedData['result']['code'].toString() == '1') {
        //Huevo estuvo aqui
        return true;
      } else {
        return false;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return false;
    }
  }
}
