// To parse this JSON data, do
//
//     final pacienteModel = pacienteModelFromJson(jsonString);

import 'dart:convert';

PacienteModel pacienteModelFromJson(String str) => PacienteModel.fromJson(json.decode(str));

String pacienteModelToJson(PacienteModel data) => json.encode(data.toJson());

class PacienteModel {
    PacienteModel({
        this.id,
        this.carnet,
        this.name ='',
        this.lastname ='',
        this.number,
        this.direccion ='',
        this.fotoUrl,
    });

    String id;
    int carnet;
    String name;
    String lastname;
    int number;
    String direccion;
    String fotoUrl;

    factory PacienteModel.fromJson(Map<String, dynamic> json) => PacienteModel(
        id: json["id"],
        carnet: json["carnet"],
        name: json["name"],
        lastname: json["lastname"],
        number: json["number"],
        direccion: json["direccion"],
        fotoUrl: json["fotoUrl"],
    );

    Map<String, dynamic> toJson() => {
        //"id": id,
        "carnet": carnet,
        "name": name,
        "lastname": lastname,
        "number": number,
        "direccion": direccion,
        "fotoUrl": fotoUrl,
    };
}
