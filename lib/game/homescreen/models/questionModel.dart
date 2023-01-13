// To parse this JSON data, do
//
//     final questionModel = questionModelFromJson(jsonString);

import 'dart:convert';

QuestionModel questionModelFromJson(String str) =>
    QuestionModel.fromJson(json.decode(str));

String questionModelToJson(QuestionModel data) => json.encode(data.toJson());

class QuestionModel {
  QuestionModel({
    required this.question,
    required this.difiiculty,
  });

  String question;
  int difiiculty;

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        question: json["question"],
        difiiculty: json["difiiculty"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "difiiculty": difiiculty,
      };
}
