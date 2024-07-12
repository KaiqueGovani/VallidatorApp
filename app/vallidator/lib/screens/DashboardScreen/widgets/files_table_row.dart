import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vallidator/helpers/human_file_size.dart';

TableRow filesTableRow(Map<String, dynamic> fileData, bool even) {
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
          child: Text(fileData['id'].toString(),
              style: TextStyle(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(fileData['nome'],
              style: TextStyle(fontFamily: GoogleFonts.inter().fontFamily),
              textAlign: TextAlign.center),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(fileData['id_template'].toString(),
              style: TextStyle(fontFamily: GoogleFonts.inter().fontFamily),
              textAlign: TextAlign.center),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(fileData["id_usuario"].toString(),
              style: TextStyle(fontFamily: GoogleFonts.inter().fontFamily),
              textAlign: TextAlign.center),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
              DateTime.parse(fileData['data']).toString().substring(0, 10),
              style: TextStyle(fontFamily: GoogleFonts.inter().fontFamily),
              textAlign: TextAlign.center),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(humanFileSize(fileData['tamanho_bytes'], si: true),
              style: TextStyle(fontFamily: GoogleFonts.inter().fontFamily),
              textAlign: TextAlign.center),
        )),
      ]);
}
