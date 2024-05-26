import 'package:flutter/material.dart';
import 'package:volgatech_client/core/model/extension/iterable_extension.dart';
import 'package:volgatech_client/core/view/widgets/card_widget.dart';
import 'package:volgatech_client/projects/model/entities/project.dart';

class ProjectListItem extends StatelessWidget {
  final Project project;
  final Function(Project) onEdit;
  final Function(Project) onDelete;

  const ProjectListItem({
    super.key,
    required this.project,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTitle(context),
          if (project.responsible?.name.isNotEmpty ?? false)
            _buildInfoRow(
              context,
              title: "Ответственный: ",
              text: project.responsible!.name,
            ),
        ].separate((index, length) => const SizedBox(height: 5)).toList(),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      project.name ?? "Проект #${project.projectId}",
      style: Theme.of(context).textTheme.displaySmall,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String title,
    required String text,
  }) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: text),
        ],
      ),
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
