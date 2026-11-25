import 'package:flutter/material.dart';

/// Central source of truth for company/contact details and outbound links,
/// mirroring the values used on the Nexora Technologies website.
class Site {
  Site._();

  static const logoUrl =
      'https://res.cloudinary.com/danzeqybu/image/upload/v1795168241/Nexora_Technologies_Green_Orbit_Logo_zt3sfp.png';

  static const email = 'info@nexoratechnologies.com';
  static const phones = ['+250 787 059 322', '+250 790 989 830'];

  /// In-app AI assistant backend (OpenRouter). The app calls the model
  /// directly; the key is injected at build time from the OPENROUTER_API_KEY
  /// secret (--dart-define), never committed to the repository.
  static const openRouterUrl =
      'https://openrouter.ai/api/v1/chat/completions';
  static const openRouterModel = 'nvidia/nemotron-3-ultra-550b-a55b:free';
  static const openRouterApiKey =
      String.fromEnvironment('OPENROUTER_API_KEY');

  static const whatsappNumber = '250787059322';
  static const whatsappMessage =
      "Hello Nexora Technologies! I'd like to learn more about your software development services.";

  static Uri get whatsappUri => Uri.parse(
        'https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(whatsappMessage)}',
      );

  static Uri get emailUri => Uri(
        scheme: 'mailto',
        path: email,
        query: 'subject=${Uri.encodeComponent('Software project enquiry')}',
      );

  static Uri get mapUri =>
      Uri.parse('https://www.google.com/maps/search/?api=1&query=Kigali%2C+Rwanda');

  static final Uri gecoRwanda = Uri.parse('https://www.gecorwanda.com/');
  static final Uri elVerbuena = Uri.parse(
      'https://el-verbuena-portifolio-git-main-robertmugabos-projects.vercel.app/en');

  /// Footer social channels (matches the website footer). Only WhatsApp is
  /// wired to a destination; the rest are placeholders pending profiles.
  static const List<SocialLink> socials = [
    SocialLink('WhatsApp', Icons.chat_bubble_outline),
    SocialLink('Facebook', Icons.facebook),
    SocialLink('Instagram', Icons.camera_alt_outlined),
    SocialLink('TikTok', Icons.music_note_outlined),
    SocialLink('X', Icons.alternate_email),
    SocialLink('LinkedIn', Icons.business_center_outlined),
    SocialLink('GitHub', Icons.code),
  ];
}

class SocialLink {
  const SocialLink(this.label, this.icon);

  final String label;
  final IconData icon;
}
