import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../l10n/app_strings.dart';
import '../core/site.dart';
import '../theme/app_theme.dart';
import '../core/utils.dart';
import '../widgets/common.dart';
import '../widgets/tab_page.dart';

/// Contact tab — contact channels plus a form that opens the mail client,
/// mirroring the website `Contact` section.
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final name = _name.text.trim();
    final email = _email.text.trim();
    final message = _message.text.trim();
    final uri = Uri(
      scheme: 'mailto',
      path: Site.email,
      queryParameters: {
        'subject': 'New enquiry from $name',
        'body': 'Name: $name\nEmail: $email\n\n$message',
      },
    );
    openExternal(uri);

    _name.clear();
    _email.clear();
    _message.clear();
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(AppStrings.of(context).t('contact.success'))),
      );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return NxTabPage(
      eyebrow: strings.t('contact.eyebrow'),
      title: strings.t('contact.title'),
      subtitle: strings.t('contact.subtitle'),
      children: [
        NxContainer(child: _ContactInfo(strings: strings)),
        const SizedBox(height: 28),
        NxContainer(child: _buildForm(strings)),
      ],
    );
  }

  Widget _buildForm(AppStrings strings) {
    return NxCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Field(
              label: strings.t('contact.nameLabel'),
              controller: _name,
              hint: strings.t('contact.namePlaceholder'),
              keyboardType: TextInputType.name,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? strings.t('contact.nameLabel')
                  : null,
            ),
            const SizedBox(height: 18),
            _Field(
              label: strings.t('contact.emailFieldLabel'),
              controller: _email,
              hint: strings.t('contact.emailPlaceholder'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                final v = value?.trim() ?? '';
                if (v.isEmpty || !v.contains('@') || !v.contains('.')) {
                  return strings.t('contact.emailFieldLabel');
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            _Field(
              label: strings.t('contact.messageLabel'),
              controller: _message,
              hint: strings.t('contact.messagePlaceholder'),
              maxLines: 4,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? strings.t('contact.messageLabel')
                  : null,
            ),
            const SizedBox(height: 22),
            NxButton.primary(
              label: strings.t('contact.submit'),
              icon: Icons.send_outlined,
              expand: true,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  const _ContactInfo({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final p = context.nx;

    final items = [
      _InfoData(
        icon: Icons.location_on_outlined,
        label: strings.t('contact.locationLabel'),
        value: strings.t('contact.locationValue'),
        onTap: () => openExternal(Site.mapUri),
      ),
      _InfoData(
        icon: Icons.mail_outline,
        label: strings.t('contact.emailLabel'),
        value: Site.email,
        onTap: () => openExternal(Site.emailUri),
      ),
      _InfoData(
        icon: Icons.phone_outlined,
        label: strings.t('contact.phoneLabel'),
        value: Site.phones.join(' / '),
        onTap: () => openExternal(Uri(scheme: 'tel', path: Site.phones.first.replaceAll(' ', ''))),
      ),
      _InfoData(
        icon: Icons.schedule,
        label: strings.t('contact.hoursLabel'),
        value: strings.t('contact.hoursValue'),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.t('contact.infoTitle'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          strings.t('contact.infoDesc'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        for (var i = 0; i < items.length; i++) ...[
          _InfoRow(data: items[i]),
          if (i != items.length - 1) const SizedBox(height: 18),
        ],
        const SizedBox(height: 8),
        Text(
          strings.t('footer.builtIn'),
          style: GoogleFonts.inter(fontSize: 13, color: p.muted),
        ),
      ],
    );
  }
}

class _InfoData {
  const _InfoData({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.data});

  final _InfoData data;

  @override
  Widget build(BuildContext context) {
    final p = context.nx;
    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NxIconTile(icon: data.icon, size: 44, iconSize: 21),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: p.heading,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: context.nx.body,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
