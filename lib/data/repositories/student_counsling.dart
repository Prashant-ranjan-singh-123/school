import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test/utils/utils.dart';

import '../../utils/api.dart';

class StudentCounslingRepository {
  Future<String> submitAssignment({
    required int userId,
    required BuildContext context,
    required String studentName,
    required String gradeClassSection,
    required String studentContactInfo,
    required String parentGuardianName,
    required String parentContactInfo,
    required String counselingQueryDetails,
  }) async {
    try {
      final result = await Api.post(
        body: {
          "user_id": userId,
          "student_name": studentName,
          "grade_class_section": gradeClassSection,
          "student_contact_info": studentContactInfo,
          "parent_guardian_name": parentGuardianName,
          "parent_contact_info": parentContactInfo,
          "counseling_query_details": counselingQueryDetails,
        },
        url: Api.counslingForm,
        useAuthToken: false,
      );

      // print(result.runtimeType);
      // Utils.showCustomSnackBar(
      //   context: context,
      //   errorMessage: result['message'],
      //   backgroundColor: Theme.of(context).colorScheme.secondary,
      // );
      // print(result['message']);

      return result['message'];

    } catch (e) {
      Utils.showCustomSnackBar(
        context: context,
        errorMessage: e.toString(),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      throw ApiException(e.toString());
    }
  }
}
