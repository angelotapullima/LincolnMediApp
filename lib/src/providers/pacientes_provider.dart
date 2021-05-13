import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'package:form_validation/src/models/paciente_model.dart';

class PacientesProvider {
  final String _url = 'https://prueba-c3e76-default-rtdb.firebaseio.com';

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

    // print(pacientes);

    return pacientes;
  }

  Future<int> borrarPaciente(String id) async {
    final url = '$_url/pacientes/$id.json';
    final resp = await http.delete(url);

    print(resp.body);

    return 1;
  }

  Future<String> subirImagen( File imagen ) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dv0emsqcp/image/upload?upload_preset=zfnajtpq');
    final mimeType = mime(imagen.path).split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path,
      contentType: MediaType( mimeType[0], mimeType[1] )
    );

    imageUploadRequest.files.add(file);


    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('Algo salio mal');
      print( resp.body );
      return null;
    }

    final respData = json.decode(resp.body);
    print( respData);

    return respData['secure_url'];


  }
}
