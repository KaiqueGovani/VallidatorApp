import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TableRow filesTableHeader() {
  return TableRow(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Color.fromRGBO(222, 226, 230, 1), width: 1))),
      children: <Widget>[
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text('#',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.inter().fontFamily),
              textAlign: TextAlign.center),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text('Name',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.inter().fontFamily),
              textAlign: TextAlign.center),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text('Template',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.inter().fontFamily),
              textAlign: TextAlign.center),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text('Creator',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.inter().fontFamily),
              textAlign: TextAlign.center),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text('Sent At',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.inter().fontFamily),
              textAlign: TextAlign.center),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text('Size',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.inter().fontFamily),
              textAlign: TextAlign.center),
        )),
      ]);
}
