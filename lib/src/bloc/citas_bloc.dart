import 'package:form_validation/src/databases/citas_database.dart';
import 'package:form_validation/src/models/citas_model.dart';
import 'package:form_validation/src/providers/citas_provider.dart';
import 'package:rxdart/rxdart.dart';

class CitasBloc {
  final citasProvider = CitasProvider();
  final citasDatabase = CitasDatabase();
  final _citasController = BehaviorSubject<List<CitasModel>>();

  Stream<List<CitasModel>> get emailStream => _citasController.stream;

  dispose() {
    _citasController?.close();
  }

  void obtenerCitas(String fecha) async {
    _citasController.sink.add(await obtenerecitasPtm(fecha));
    await citasProvider.listarCitasPorDia(fecha);
    _citasController.sink.add(await obtenerecitasPtm(fecha));
  }

  Future<List<CitasModel>> obtenerecitasPtm(String fecha) async {
    final citasfecha = await citasDatabase.obtenerCitasPorFecha(fecha);

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
      var estoVale = '${i.toString().padLeft(2, '0')}:00:00';
      print('$estoVale');

      if (citasfecha.length > 0) {
        for (var x = 0; x < citasfecha.length; x++) {
          var fechilla = citasfecha[x].hora;
          if (estoVale == fechilla) {
            CitasModel citasModel = CitasModel();

            citasModel.idCita =citasfecha[x].idCita;
            citasModel.hora = horaFinal;
            citasModel.fecha = fecha;
            citasModel.estado = citasfecha[x].estado;
            citasModel.medico = (citasfecha[x].estado=='0')?'ocupado':'Atendido';
            citasModel.paNombre = citasfecha[x].paNombre;
            algo.add(citasModel);
          } else {
            CitasModel citasModel = CitasModel();

            citasModel.hora = horaFinal;
            citasModel.fecha = fecha;
            citasModel.estado = '9';
            citasModel.medico = 'Libre';
            citasModel.paNombre = '';
            algo.add(citasModel);
          }
        }
      } else {
        CitasModel citasModel = CitasModel();

        citasModel.hora = horaFinal;
        citasModel.fecha = fecha;
        citasModel.estado = '9';
        citasModel.medico = 'Libre';
        citasModel.paNombre = '';
        algo.add(citasModel);
      }
    }

    return algo;
  }
}
