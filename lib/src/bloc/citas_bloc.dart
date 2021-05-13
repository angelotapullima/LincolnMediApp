import 'package:form_validation/src/models/citas_model.dart';
import 'package:rxdart/rxdart.dart';

class CitasBloc {
  final _citasController = BehaviorSubject<List<CitasModel>>();

  Stream<List<CitasModel>> get emailStream => _citasController.stream;

  dispose() {
    _citasController?.close();
  }

  void obtenerCitas() async {
    _citasController.sink.add(await obtenerecitasPtm('2021-05-12'));
  }

  Future<List<CitasModel>> obtenerecitasPtm(String fecha) async {
    final List<CitasModel> algo = [];

    var horaAperturaOficial = 8;
    var hCierreNegocio = 21;
    

    String horaFinal;
    String horaCancha;

    for (int i = horaAperturaOficial; i < hCierreNegocio; i++) {

      int horaFin = i + 1;
      int hini = i;
      horaCancha = '$hini:00 - $horaFin:00';
      if (horaFin > 12) {
        horaFin = horaFin - 12;
        if (hini > 12) {
          hini = hini - 12;
        }
        horaFinal = '$hini:00 - $horaFin:00 pm';
      } else {
        horaFinal = '$i:00 - $horaFin:00 am';
      }



      CitasModel citasModel = CitasModel();

      citasModel.hora = horaFinal;
      citasModel.fecha = i.toString();
      citasModel.estado = (i % 3 == 0) ? '1' : '0';
      citasModel.medico = (i % 3 == 0) ? 'chapátin' : '';
      citasModel.paciente = (i % 3 == 0) ? 'el muertito' : '';
      algo.add(citasModel);
    }

    return algo;
  }
}
