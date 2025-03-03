import 'package:flutter/material.dart';

import '../../utils/api.dart';
import '../../utils/utils.dart';

class BusRepository {
  Future<Map<String, dynamic>> busDetails(
      {required String? school_code, required BuildContext context}) async {
    try {
      print(school_code);
      final result = await Api.getWithHeader(
        url: Api.studentProfile,
        useAuthToken: true,
        customHeaders: {'school_code': school_code ?? ''},
      );

      return result;

      // print(result.runtimeType);
      // Utils.showCustomSnackBar(
      //   context: context,
      //   errorMessage: result['message'],
      //   backgroundColor: Theme.of(context).colorScheme.secondary,
      // );
      // print(result['message']);
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
