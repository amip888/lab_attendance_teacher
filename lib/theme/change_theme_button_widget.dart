import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ChangeThemeButtonWidget extends StatefulWidget {
  const ChangeThemeButtonWidget({super.key});

  @override
  State<ChangeThemeButtonWidget> createState() =>
      _ChangeThemeButtonWidgetState();
}

class _ChangeThemeButtonWidgetState extends State<ChangeThemeButtonWidget> {
  bool isDarkMode = false;
  @override
  void initState() {
    statusThemeMode();
    super.initState();
  }

  statusThemeMode() async {
    final theme = await LocalStorageServices.getThemeMode();
    setState(() {
      if (theme == true) {
        isDarkMode = true;
      } else {
        isDarkMode = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isDarkMode = !isDarkMode;
        });
        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'assets/images/svgs/ic_history.svg',
            ),
            divideW10,
            Expanded(child: Text(isDarkMode ? 'Light Mode' : 'Dark Mode')),
            IconButton(
                onPressed: () {
                  setState(() {
                    isDarkMode = !isDarkMode;
                  });
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
                icon: Icon(
                  isDarkMode ? Icons.wb_sunny : Icons.nightlight,
                  color: isDarkMode ? Colors.amber : Pallete.primary,
                  size: 20,
                ))
          ],
        ),
      ),
    );
  }
}
