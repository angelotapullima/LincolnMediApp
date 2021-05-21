import 'dart:convert';
import 'dart:io';
import 'package:form_validation/src/databases/pacientes_database.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'package:form_validation/src/models/paciente_model.dart';

class PacientesProvider {
  final pacientesDatabase = PacientesDatabase();
  final String _url = 'https://prueba-c3e76-default-rtdb.firebaseio.com';

  Future<String> registrarPaciente(
      String nombre, String apellido, String dni,String telefono,String correo,String image) async {
    try {
      final url = 'https://guabba.com/dental/api/paciente/registrar_paciente';
      var dniciti;
      if (dni.length >= 8) {
        dniciti = dni.substring(0, 8);
      } else {
        int numero = 8-dni.length;
        String a='0';

        if(numero >0){

          for (var i = 0; i < numero-1; i++) {
            a+='0';
            
          }

        }

        dniciti = '$a$dni';
      }

      final resp = await http.post(url, body: {
        'paciente_nombre': '$nombre',
        'paciente_apellido': '$apellido',
        'paciente_dni': '$dniciti',
        'paciente_telefono': '$telefono',
        'paciente_correo': '$correo',
        'paciente_imagen_url': '$image',
      });

      final decodedData = json.decode(resp.body);

      if (decodedData['result']['code'].toString() == '1') {
        //Huevo estuvo aqui
        return dniciti;
      } else {
        return dniciti;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 'false';
    }
  }

  Future<bool> crearPaciente(PacienteModel paciente) async {
    final url = '$_url/pacientes.json';

    final resp = await http.post(url, body: pacienteModelToJson(paciente));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<bool> editarPaciente(PacienteModel paciente) async {
    final url = '$_url/pacientes/${paciente.id}.json';

    final resp = await http.put(url, body: pacienteModelToJson(paciente));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<List<PacienteModel>> cargarPacientes() async {
    final url = '$_url/pacientes.json';

    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<PacienteModel> pacientes = new List();
    if (decodedData == null) return [];

    decodedData.forEach((id, paci) {
      final paciTemp = PacienteModel.fromJson(paci);
      paciTemp.id = id;

      pacientes.add(paciTemp);
    });

    print('fruta');

    for (var i = 0; i < pacientes.length; i++) {
      PacienteModel paciente = PacienteModel();
      paciente.carnet = pacientes[i].carnet.toString();
      paciente.name = pacientes[i].name.toString();
      paciente.lastname = pacientes[i].lastname.toString();
      paciente.number = pacientes[i].number.toString();
      paciente.direccion = pacientes[i].direccion.toString();
      paciente.fotoUrl = pacientes[i].fotoUrl.toString();
      await pacientesDatabase.insertarPaciente(paciente);
    }

    // print(pacientes);

    return pacientes;
  }

  Future<int> borrarPaciente(String id) async {
    final url = '$_url/pacientes/$id.json';
    final resp = await http.delete(url);

    print(resp.body);

    return 1;
  }

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dv0emsqcp/image/upload?upload_preset=zfnajtpq');
    final mimeType = mime(imagen.path).split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];
  }
}
