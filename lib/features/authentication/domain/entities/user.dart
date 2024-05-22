import 'dart:io';

import 'package:equatable/equatable.dart';

class UserInfoEntity extends Equatable {
  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? image;

  final String? token;

  const UserInfoEntity ({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.image,
    this.token,
  });

  @override
  List<Object?> get props => [id, username, email, firstName, lastName, gender, image, token];
}