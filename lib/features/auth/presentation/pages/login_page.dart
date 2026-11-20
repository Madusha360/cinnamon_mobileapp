import 'package:flutter/material.dart';

import '../widgets/account_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) => const AccountForm(register: false);
}
