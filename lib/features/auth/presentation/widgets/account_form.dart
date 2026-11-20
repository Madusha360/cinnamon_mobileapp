import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/widgets/status_card.dart';

/// Presentation-only inputs. No repository, token persistence or network action.
class AccountForm extends StatefulWidget {
  const AccountForm({super.key, required this.register});
  final bool register;
  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    return AppPage(
      title: widget.register ? text.register : text.login,
      subtitle: widget.register ? text.registerSubtitle : text.loginSubtitle,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: BrandLogo(size: 80),
        ),
        const SizedBox(height: 20),
        Text(
          widget.register ? text.registerWelcome : text.loginWelcome,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        Text(
          text.authFormNote,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 24),
        TextField(
          key: const ValueKey('account-email'),
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: text.email,
            prefixIcon: const Icon(Icons.alternate_email_rounded),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          key: const ValueKey('account-password'),
          controller: _password,
          obscureText: _obscure,
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: text.password,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              tooltip: _obscure ? text.showPassword : text.hidePassword,
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                _obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        AppButton(
          label: widget.register ? text.register : text.login,
          icon: Icons.lock_outline_rounded,
        ),
        const SizedBox(height: 16),
        StatusCard(
          title: text.authUnavailable,
          message: text.authUnavailableBody,
          icon: Icons.cloud_off_outlined,
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => context.go(RouteNames.home),
          icon: const Icon(Icons.offline_bolt_outlined),
          label: Text(text.continueOffline),
        ),
        TextButton(
          onPressed: () => context.push(
            widget.register ? RouteNames.login : RouteNames.register,
          ),
          child: Text(widget.register ? text.login : text.register),
        ),
      ],
    );
  }
}
