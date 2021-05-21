import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/databases/pacientes_database.dart';
import 'package:form_validation/src/models/paciente_model.dart';
import 'package:form_validation/src/providers/citas_provider.dart';
import 'package:form_validation/src/providers/pacientes_provider.dart';
import 'package:form_validation/src/utils/responsive.dart';

class RegistroCita extends StatefulWidget {
  const RegistroCita({Key key, @required this.fecha, @required this.hora})
      : super(key: key);

  final String fecha;
  final String hora;

  @override
  _RegistroCitaState createState() => _RegistroCitaState();
}

class _RegistroCitaState extends State<RegistroCita> {
  int cantItems = 0;

  String dropdownSedes = '';
  String codSede = "";
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de citas'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: responsive.hp(1)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(4),
            ),
            child: Text(
              'Paciente',
              style: TextStyle(
                fontSize: responsive.ip(2),
              ),
            ),
          ),
          SizedBox(
            height: responsive.hp(1),
          ),
          _sedes(context, responsive),
          SizedBox(
            height: responsive.hp(2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'Fecha',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: responsive.ip(1.8),
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${widget.fecha}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: responsive.ip(1.8),
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Hora',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: responsive.ip(1.8),
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${widget.hora}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: responsive.ip(1.8),
                        fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: responsive.hp(2),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: responsive.wp(8),
            ),
            width: double.infinity,
            child: MaterialButton(
                color: Colors.green,
                child: Text(
                  'Confirmar cita',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.ip(2.2),
                  ),
                ),
                onPressed: () async {
                  if (codSede.length > 0) {
                    final pacientesDatabase = PacientesDatabase();
                    final citasProvider = CitasProvider();
                    final pacientesProvider = PacientesProvider();

                    final paciente =
                        await pacientesDatabase.obtenerPacientePorDni(codSede);
                    final pacienteResul =
                        await pacientesProvider.registrarPaciente(
                            paciente[0].name,
                            paciente[0].lastname,
                            paciente[0].carnet,
                            paciente[0].number,
                            'prueba@prueba.com',
                            paciente[0].fotoUrl);

                    final res = await citasProvider.registrarCita(
                        pacienteResul, widget.fecha, widget.hora);

                    if (res) {
                      print('oks');
                    } else {
                      print('hubo un error cita');
                    }
                  } else {}
                  print(codSede);
                }),
          )
        ],
      ),
    );
  }

  var list;

  var listSedes;

  Widget _sedes(BuildContext context, Responsive responsive) {
    final pacienteBloc = Provider.paciente(context);
    return StreamBuilder(
      stream: pacienteBloc.pacienteStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<PacienteModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            if (cantItems == 0) {
              listSedes = List<String>();

              listSedes.add('Seleccionar');
              for (int i = 0; i < snapshot.data.length; i++) {
                String nombreSedes =
                    snapshot.data[i].name + snapshot.data[i].lastname;
                listSedes.add(nombreSedes);
              }
              dropdownSedes = "Seleccionar";
            }
            return _sedesItem(responsive, snapshot.data, listSedes);
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        } else {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
      },
    );
  }

  Widget _sedesItem(
      Responsive responsive, List<PacienteModel> sedes, List<String> canche) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: responsive.wp(4),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(4),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        value: dropdownSedes,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        isExpanded: true,
        style: TextStyle(
          color: Colors.black,
          fontSize: responsive.ip(1.5),
        ),
        underline: Container(),
        onChanged: (String data) {
          setState(() {
            dropdownSedes = data;
            cantItems++;
            print(data);
            obtenerIdSede(data, sedes);
          });
        },
        items: canche.map(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                maxLines: 2,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: responsive.ip(1.8),
                    fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  void obtenerIdSede(String dato, List<PacienteModel> list) {
    for (int i = 0; i < list.length; i++) {
      if (dato == list[i].name + list[i].lastname) {
        codSede = list[i].carnet;
      }
    }

    print(codSede);
  }
}
