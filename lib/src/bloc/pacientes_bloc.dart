import 'package:form_validation/src/databases/pacientes_database.dart';
import 'package:form_validation/src/models/paciente_model.dart';
import 'package:form_validation/src/providers/pacientes_provider.dart';
import 'package:rxdart/rxdart.dart';

class PacientesBloc {
  final pacientesDatabse = PacientesDatabase();
  final pacientesProvider = PacientesProvider();

  final _pacientesController = BehaviorSubject<List<PacienteModel>>();
  Stream<List<PacienteModel>> get pacienteStream => _pacientesController.stream;

  dispose() {
    _pacientesController?.close();
  }

  void obtenerPacientes() async {
    _pacientesController.sink.add(await pacientesDatabse.obtenerPacientes());
    pacientesProvider.cargarPacientes();
    _pacientesController.sink.add(await pacientesDatabse.obtenerPacientes());
  }
}
