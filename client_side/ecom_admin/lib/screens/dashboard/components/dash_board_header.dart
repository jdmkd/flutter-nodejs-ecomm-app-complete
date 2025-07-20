import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ecotte_admin/utility/extensions.dart';
import '../../../core/data/data_provider.dart';
import '../../../utility/constants.dart';

class DashBoardHeader extends StatelessWidget {
  const DashBoardHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: isMobile
          ? Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ProfileCard(),
                ),
                const SizedBox(height: defaultPadding),
                SizedBox(
                  child: SearchField(
                    onChange: (val) =>
                        context.read<DataProvider>().filterProducts(val),
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Smaller width for SearchField
                SizedBox(
                  width: 400,
                  child: SearchField(
                    onChange: (val) =>
                        context.read<DataProvider>().filterProducts(val),
                  ),
                ),
                ProfileCard(),
              ],
            ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding / 2),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Only takes needed space
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/images/profile_pic.png",
              height: 40,
              width: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.account_circle,
                    size: 40, color: Colors.white);
              },
            ),
          ),
          SizedBox(width: defaultPadding / 2),
          Text(
            "Admin",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 8),
          Icon(Icons.keyboard_arrow_down, color: Colors.white),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final Function(String) onChange;

  const SearchField({Key? key, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45, // Slightly taller for better usability
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.white, fontSize: 16),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(defaultPadding * 0.75),
              margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              // margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                "assets/icons/Search.svg",
                // height: 22,
                // width: 22,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        style: TextStyle(color: Colors.white, fontSize: 16),
        onChanged: (value) {
          onChange(value);
        },
      ),
    );
  }
}
