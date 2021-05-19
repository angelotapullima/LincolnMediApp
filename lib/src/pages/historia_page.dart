import 'dart:html';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/models/paciente_model.dart';
import 'package:form_validation/src/providers/pacientes_provider.dart';

import 'package:flutter/material.dart';

import '../models/paciente_model.dart';

final paciente = new PacienteModel();
final pacientesProvider = new PacientesProvider();
class HistoriaPage extends StatefulWidget {
  @override
  _HistoriaPageState createState() => _HistoriaPageState();
}

class _HistoriaPageState extends State<HistoriaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historia'),
      ),
      body: SingleChildScrollView(
        child:  Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 40),
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${paciente.carnet}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                '${paciente.name}'+" "+'${paciente.lastname}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                '${paciente.number}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                               Text(
                                '${paciente.direccion}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        )
      ),
    );
  }
}
