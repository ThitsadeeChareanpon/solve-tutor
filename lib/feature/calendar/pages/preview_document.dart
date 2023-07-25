import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:solve_tutor/feature/calendar/constants/custom_colors.dart';
import 'package:solve_tutor/feature/calendar/constants/custom_styles.dart';
import 'package:solve_tutor/feature/calendar/widgets/sizebox.dart';

class PreviewDocument extends StatefulWidget {
  PreviewDocument(
      {super.key,
      required this.name,
      required this.images,
      required this.index});
  String name;
  List<dynamic> images;
  final int index;
  @override
  State<PreviewDocument> createState() => _PreviewDocumentState();
}

class _PreviewDocumentState extends State<PreviewDocument> {
  int activePage = 0;
  late PageController _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activePage = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    _pageController =
        PageController(viewportFraction: 1, initialPage: widget.index);
    return Scaffold(
      backgroundColor: CustomColors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: CustomColors.white,
        centerTitle: true,
        elevation: 6,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.close,
              color: CustomColors.gray878787,
            )),
        title: Text(
          widget.name,
          style: CustomStyles.bold22Black363636,
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            itemCount: widget.images.length,
            pageSnapping: true,
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                activePage = page;
              });
            },
            itemBuilder: (context, pagePosition) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  Expanded(
                    child: CachedNetworkImage(
                      width: double.infinity,
                      fit: BoxFit.contain,
                      imageUrl: widget.images[pagePosition] ?? '',
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 80),
                ],
              );
            },
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 16,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CustomColors.gray878787,
                      width: 1,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            _pageController.animateToPage(--activePage,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.bounceInOut);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          )),
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: CustomColors.gray878787,
                              width: 1,
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text('หน้า ${activePage + 1}',
                              style: CustomStyles.med14greenPrimary)),
                      S.w(10),
                      Text(
                        '/ ${widget.images.length}',
                        style: CustomStyles.med14Black363636,
                      ),
                      TextButton(
                          onPressed: () {
                            _pageController.animateToPage(++activePage,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.bounceInOut);
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      // body: SingleChildScrollView(
      //   child: SizedBox(
      //     height: MediaQuery.of(context).size.height,
      //     width: MediaQuery.of(context).size.width,
      //     child: ListView.builder(
      //       itemCount: widget.images.length,
      //       itemBuilder: (context, index) => Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: CachedNetworkImage(
      //           width: double.infinity,
      //           fit: BoxFit.fitHeight,
      //           imageUrl: widget.images[index] ?? '',
      //           placeholder: (context, url) =>
      //               const Center(child: CircularProgressIndicator()),
      //           errorWidget: (context, url, error) => const Icon(Icons.error),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
