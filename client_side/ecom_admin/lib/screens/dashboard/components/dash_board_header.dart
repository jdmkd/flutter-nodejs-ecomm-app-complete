import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ecom_admin/utility/extensions.dart';
import '../../../core/data/data_provider.dart';
import '../../../utility/constants.dart';

class DashBoardHeader extends StatelessWidget {
  const DashBoardHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.end, // Align everything to the right
      children: [
        // Profile Card Positioned on Right
        Align(
          alignment: Alignment.topRight,
          child: ProfileCard(),
        ),
        SizedBox(height: defaultPadding), // Space before search bar

        // Search Field Below
        SearchField(
          onChange: (val) {
            final dataProvider = context.read<DataProvider>();
            dataProvider.filterProducts(val);
          },
        ),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.black54, fontSize: 16),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                "assets/icons/Search.svg",
                height: 22,
                width: 22,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        style: TextStyle(color: Colors.black, fontSize: 16),
        onChanged: (value) {
          onChange(value);
        },
      ),
    );
  }
}
