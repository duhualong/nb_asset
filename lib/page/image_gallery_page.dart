import 'package:flutter/material.dart';
import 'package:flustars/flustars.dart';
import 'package:nbassetentry/common/style/style_set.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'base_page.dart';
import '../common/model/image_gallery_item.dart';
import '../common/style/string_set.dart';

class ImageGalleryPage extends StatefulWidget {
  static final String routeName = '/image_gallery';

  final Widget loadingChild;
  final int initialIndex;
  final Decoration backgroundDecoration;
  final PageController pageController;
  final List<ImageGalleryItem> galleryItems;

  ImageGalleryPage({
    this.loadingChild,
    this.initialIndex = 0,
    this.backgroundDecoration,
    @required this.galleryItems,
  }) : pageController = PageController(initialPage: initialIndex);

  @override
  _ImageGalleryPageState createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    setState(() {});
  }

  void _onPageChanged(int index) {
    _currentIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      hasAppBar: true,
      color: ThemeDataSet.tabColor,
      title: StringSet.IMAGE_GALLERY,
      leadingIconData: Icons.arrow_back_ios,
      leadingOnTap: () => Navigator.pop(context),
      body: Container(
        color: Colors.black,
        constraints: BoxConstraints.expand(
          height: ScreenUtil.getScreenH(context),
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: BouncingScrollPhysics(),
              itemCount: widget.galleryItems.length,
              builder: (context, index) {
                ImageGalleryItem item = widget.galleryItems[index];
                return PhotoViewGalleryPageOptions(
                  imageProvider: item.imageProvider,
                  initialScale: PhotoViewComputedScale.contained,
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 1.2,
                );
              },
              onPageChanged: _onPageChanged,
              pageController: widget.pageController,
              loadingChild: widget.loadingChild,
              backgroundDecoration: widget.backgroundDecoration,
            ),
            Container(
              margin: EdgeInsets.only(right: 20, bottom: 20),
              child: Text(
                '${_currentIndex + 1} / ${widget.galleryItems.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  decoration: null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
