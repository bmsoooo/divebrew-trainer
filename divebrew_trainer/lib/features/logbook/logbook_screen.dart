import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/database.dart';
import '../../data/models.dart';
import '../../l10n/app_localizations.dart';
import 'logbook_map_view.dart';
import 'logbook_repository.dart';
import 'widgets/logbook_card.dart';
import 'widgets/logbook_stats_card.dart';

enum ViewMode { list, gallery, map }

class LogbookScreen extends StatefulWidget {
  final AppDatabase db;

  const LogbookScreen({super.key, required this.db});

  @override
  State<LogbookScreen> createState() => _LogbookScreenState();
}

class _LogbookScreenState extends State<LogbookScreen> {
  late final LogbookRepository _repository;
  ViewMode _viewMode = ViewMode.list;

  SiteType? _filterSiteType;
  PurposeTag? _filterPurposeTag;
  int? _filterMinRating;

  String _getPurposeText(PurposeTag tag) {
    switch (tag) {
      case PurposeTag.training: return '트레이닝';
      case PurposeTag.leisure: return '펀다이빙';
      case PurposeTag.spearfishing: return '스피어피싱';
      case PurposeTag.photo: return '수중촬영';
      case PurposeTag.competitionPractice: return '대회준비';
      case PurposeTag.other: return '기타';
    }
  }

  String _getSiteTypeText(SiteType type) {
    switch (type) {
      case SiteType.sea: return '바다';
      case SiteType.pool: return '풀장';
      case SiteType.lake: return '호수';
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('로그 필터', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  
                  Text('장소 타입', style: Theme.of(context).textTheme.titleMedium),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('전체'),
                        selected: _filterSiteType == null,
                        onSelected: (val) {
                          if (val) setModalState(() => _filterSiteType = null);
                        },
                      ),
                      ...SiteType.values.map((e) => ChoiceChip(
                        label: Text(_getSiteTypeText(e)),
                        selected: _filterSiteType == e,
                        onSelected: (val) {
                          if (val) setModalState(() => _filterSiteType = e);
                        },
                      )),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text('다이빙 목적', style: Theme.of(context).textTheme.titleMedium),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('전체'),
                        selected: _filterPurposeTag == null,
                        onSelected: (val) {
                          if (val) setModalState(() => _filterPurposeTag = null);
                        },
                      ),
                      ...PurposeTag.values.map((e) => ChoiceChip(
                        label: Text(_getPurposeText(e)),
                        selected: _filterPurposeTag == e,
                        onSelected: (val) {
                          if (val) setModalState(() => _filterPurposeTag = e);
                        },
                      )),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text('최소 별점', style: Theme.of(context).textTheme.titleMedium),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('전체'),
                        selected: _filterMinRating == null,
                        onSelected: (val) {
                          if (val) setModalState(() => _filterMinRating = null);
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('3점 이상'),
                        selected: _filterMinRating == 3,
                        onSelected: (val) {
                          if (val) setModalState(() => _filterMinRating = 3);
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('5점 만점'),
                        selected: _filterMinRating == 5,
                        onSelected: (val) {
                          if (val) setModalState(() => _filterMinRating = 5);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {}); // 닫히면서 부모 setState 호출
                        Navigator.pop(context);
                      },
                      child: const Text('적용하기'),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _repository = LogbookRepository(widget.db);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabLogbook),
        actions: [
          IconButton(
            icon: Icon(
              _viewMode == ViewMode.list
                  ? Icons.photo_library
                  : _viewMode == ViewMode.gallery
                      ? Icons.map
                      : Icons.list,
            ),
            onPressed: () {
              setState(() {
                if (_viewMode == ViewMode.list) {
                  _viewMode = ViewMode.gallery;
                } else if (_viewMode == ViewMode.gallery) {
                  _viewMode = ViewMode.map;
                } else {
                  _viewMode = ViewMode.list;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/logbook/new');
        },
        icon: const Icon(Icons.add),
        label: const Text('로그 작성'),
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<List<DiveSession>>(
      stream: _repository.watchSessions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final sessions = snapshot.data;
        
        if (sessions == null) return const Center(child: CircularProgressIndicator());
        
        final filteredSessions = sessions.where((s) {
          if (_filterSiteType != null && s.siteType != _filterSiteType) return false;
          if (_filterPurposeTag != null && s.purposeTag != _filterPurposeTag) return false;
          if (_filterMinRating != null && (s.overallRating ?? 0) < _filterMinRating!) return false;
          return true;
        }).toList();

        if (filteredSessions.isEmpty) {
          return Center(
            child: Text(
              sessions.isEmpty
                  ? '작성된 로그가 없습니다.\n새로운 로그를 추가해보세요!'
                  : '조건에 맞는 로그가 없습니다.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          );
        }

        if (_viewMode == ViewMode.map) {
          return LogbookMapView(
            sessions: filteredSessions,
            onMarkerTap: (session) {
              context.push('/logbook/edit/${session.id}');
            },
          );
        }

        if (_viewMode == ViewMode.gallery) {
          final photoSessions = filteredSessions.where((s) => s.photoPaths.isNotEmpty).toList();
          if (photoSessions.isEmpty) {
            return const Center(child: Text('사진이 첨부된 로그가 없습니다.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: photoSessions.length,
            itemBuilder: (context, index) {
              final s = photoSessions[index];
              final path = s.photoPaths.first;
              return GestureDetector(
                onTap: () => context.push('/logbook/edit/${s.id}'),
                child: kIsWeb
                    ? Image.network(path, fit: BoxFit.cover)
                    : Image.file(File(path), fit: BoxFit.cover),
              );
            },
          );
        }

        // List Mode (Grouped by Month)
        final Map<String, List<DiveSession>> grouped = {};
        for (var s in filteredSessions) {
          final monthYear = DateFormat('yyyy년 M월', 'ko_KR').format(s.date);
          if (!grouped.containsKey(monthYear)) {
            grouped[monthYear] = [];
          }
          grouped[monthYear]!.add(s);
        }

        return ListView.builder(
          itemCount: grouped.keys.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return LogbookStatsCard(sessions: filteredSessions);
            }
            final monthYear = grouped.keys.elementAt(index - 1);
            final monthSessions = grouped[monthYear]!;
            final itemTheme = Theme.of(context);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Text(
                    monthYear,
                    style: itemTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: itemTheme.colorScheme.primary,
                    ),
                  ),
                ),
                ...monthSessions.map((session) => Dismissible(
                  key: ValueKey('log_${session.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('로그 삭제'),
                        content: const Text('정말 삭제하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('삭제', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) async {
                    await _repository.deleteSession(session.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('삭제되었습니다.')),
                      );
                    }
                  },
                  child: LogbookCard(
                    session: session,
                    onTap: () {
                      context.push('/logbook/edit/${session.id}');
                    },
                  ),
                )),
              ],
            );
          },
        );
      },
    );
  }
}
