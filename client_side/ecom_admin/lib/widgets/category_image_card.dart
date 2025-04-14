import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryImageCard extends StatelessWidget {
  final String labelText;
  final String? imageUrlForUpdateImage;
  final File? imageFile;
  final VoidCallback onTap;

  const CategoryImageCard({
    super.key,
    required this.labelText,
    this.imageFile,
    required this.onTap,
    this.imageUrlForUpdateImage,
  });

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final cardWidth = isMobile ? double.infinity : 200;
        // double cardWidth = size.width * 0.4;
        if (isMobile) {
          log("isMobile => $isMobile");
        }
        final imageHeight = isMobile ? 120.0 : 150.0;

        return GestureDetector(
          onTap: onTap,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: cardWidth.toDouble(),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (imageFile != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: kIsWeb
                            ? Image.network(
                                imageFile?.path ?? '',
                                width: double.infinity,
                                height: imageHeight,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                imageFile!,
                                width: double.infinity,
                                height: imageHeight,
                                fit: BoxFit.cover,
                              ),
                      )
                    else if (imageUrlForUpdateImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrlForUpdateImage ?? '',
                          width: double.infinity,
                          height: imageHeight,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        height: imageHeight,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: isMobile ? 40 : 50,
                          color: Colors.grey[600],
                        ),
                      ),
                    const SizedBox(height: 10),
                    Text(
                      labelText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
