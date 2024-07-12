import 'package:flutter/material.dart';
import 'package:vallidator/models/Template.dart';
import 'package:vallidator/screens/TemplatesScreen/widgets/template_card_body.dart';
import 'package:vallidator/themes/main_colors.dart';

class TemplatesCard extends StatelessWidget {
  final bool isAdmin;
  final List<Template> templates;
  final String permission;
  TemplatesCard({
    super.key,
    this.isAdmin = false,
    required this.templates,
    required this.permission,
  });

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      interactive: true,
      trackVisibility: true,
      thickness: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0, top: 12.0),
                child: Text(
                  isAdmin ? 'All Templates' : 'Active Templates',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  color: MainColors.babyGreen,
                  border: Border.all(
                    color: MainColors.inactiveGreen,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text('Templates')],
                ),
              ),
            ),
            SliverList.builder(
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(left: 1, right: 1),
                  child: TemplateCardBody(
                    template: templates[index],
                    isAdmin: isAdmin,
                    permission: permission,
                  ),
                );
              },
              itemCount: templates.length,
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(bottom: 1, right: 1, left: 1),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  color: MainColors.babyGreen,
                  border: Border.all(
                    color: MainColors.inactiveGreen,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Viewing all templates',
                      style: TextStyle(color: Colors.black38),
                    )
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            )
          ],
        ),
      ),
    );
  }
}
