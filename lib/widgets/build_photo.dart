import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

Widget buildCircularProfilePhoto(String url, bool isDark,
    [double height = 200, double width = 200]) {
  print(
      SchedulerBinding.instance!.window.platformBrightness == Brightness.dark);
  return Center(
    child: CachedNetworkImage(
      placeholder: (context, url) => Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey, width: 3),
        ),
        child: Icon(
          Icons.person_outline_sharp,
          size: height * 0.8,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      errorWidget: (BuildContext context, String url, error) => Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 3),
            ),
            child: Icon(
              Icons.person_outline_sharp,
              size: height * 0.8,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
    ),
  );
}

Widget buildPlaceholderPhoto(isDark,
    [double height = 200, double width = 200]) {
  print(height);
  return
      // Image.asset("assets/images/profile_icon.png",height: height,width: width);
      Container(
    alignment: Alignment.topCenter,
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.transparent,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.grey, width: 3),
    ),
    child: Icon(
      Icons.person_outline_sharp,
      size: height * 0.8,
      color: isDark ? Colors.white : Colors.black,
    ),
  );
}

Widget buildPhoto(String url,
    [double height = 200, double width = 200, BoxFit fit = BoxFit.cover]) {
  return Center(
    child: CachedNetworkImage(
      placeholder: (context, url) => Container(
        height: height,
        width: width,
      ),
      errorWidget: (BuildContext context, String url, error) => Container(
        height: height,
        width: width,
      ),
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: fit),
        ),
      ),
    ),
  );
}


Widget buildCircularPhoto(String url,
    [double height = 60, double width = 60, BoxFit fit = BoxFit.cover]) {
  return Center(
    child: CachedNetworkImage(
      placeholder: (context, url) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(shape: BoxShape.circle),
      ),
      errorWidget: (BuildContext context, String url, error) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(shape: BoxShape.circle),
      ),
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: fit),
        ),
      ),
    ),
  );
}
