import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vallidator/models/Template.dart';
import 'package:vallidator/screens/DashboardScreen/widgets/status_pill.dart';

TableRow templatesTableRow(Template template, bool even) {
  return TableRow(
      decoration: BoxDecoration(
          color: even == true ? Colors.black.withOpacity(0.05) : Colors.white,
          border: const Border(
              bottom: BorderSide(
                  color: Color.fromRGBO(222, 226, 230, 1), width: 1))),
      children: [
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(template.id.toString(),
              style: TextStyle(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(template.nome,
              style: TextStyle(fontFamily: GoogleFonts.inter().fontFamily),
              textAlign: TextAlign.center),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(template.extensao.toUpperCase(),
              style: TextStyle(fontFamily: GoogleFonts.inter().fontFamily),
              textAlign: TextAlign.center),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(template.id_criador.toString(),
              style: TextStyle(fontFamily: GoogleFonts.inter().fontFamily),
              textAlign: TextAlign.center),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
              DateTime.parse(template.data_criacao).toString().substring(0, 10),
              style: TextStyle(fontFamily: GoogleFonts.inter().fontFamily),
              textAlign: TextAlign.center),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: StatusPill(status: template.status),
        )),
      ]);
}
