import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/database.dart';
import '../../data/models.dart';
import 'logbook_repository.dart';

enum ShareField { record, date, site, condition, rating, purpose }

class ShareCardPreference {
  Set<ShareField> selectedFields;
  bool overlayGradient;
  bool watermark;
  bool isTextWhite;
  Map<ShareField, Offset> customPositions;
  Map<ShareField, double> customScales;

  ShareCardPreference({
    this.selectedFields = const {
      ShareField.record,
      ShareField.date,
      ShareField.site,
      ShareField.condition,
    },
    this.overlayGradient = true,
    this.watermark = true,
    this.isTextWhite = true,
    this.customPositions = const {},
    this.customScales = const {},
  });

  static Future<ShareCardPreference> load() async {
    final prefs = await SharedPreferences.getInstance();
    final fieldsList = prefs.getStringList('share_fields');
    Set<ShareField> fields;
    if (fieldsList != null) {
      fields = fieldsList.map((e) => ShareField.values.firstWhere((f) => f.name == e)).toSet();
    } else {
      fields = {
        ShareField.record,
        ShareField.date,
        ShareField.site,
        ShareField.condition,
      };
    }
    final overlay = prefs.getBool('share_overlay') ?? true;
    final watermark = prefs.getBool('share_watermark') ?? true;
    final isTextWhite = prefs.getBool('share_text_white') ?? true;

    final positionsMap = <ShareField, Offset>{};
    final scalesMap = <ShareField, double>{};
    for (final field in ShareField.values) {
      final x = prefs.getDouble('share_pos_${field.name}_x');
      final y = prefs.getDouble('share_pos_${field.name}_y');
      if (x != null && y != null) {
        positionsMap[field] = Offset(x, y);
      }
      final s = prefs.getDouble('share_scale_${field.name}');
      if (s != null) {
        scalesMap[field] = s;
      }
    }

    return ShareCardPreference(
      selectedFields: fields,
      overlayGradient: overlay,
      watermark: watermark,
      isTextWhite: isTextWhite,
      customPositions: positionsMap,
      customScales: scalesMap,
    );
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('share_fields', selectedFields.map((e) => e.name).toList());
    await prefs.setBool('share_overlay', overlayGradient);
    await prefs.setBool('share_watermark', watermark);
    await prefs.setBool('share_text_white', isTextWhite);

    for (final entry in customPositions.entries) {
      await prefs.setDouble('share_pos_${entry.key.name}_x', entry.value.dx);
      await prefs.setDouble('share_pos_${entry.key.name}_y', entry.value.dy);
    }
    for (final entry in customScales.entries) {
      await prefs.setDouble('share_scale_${entry.key.name}', entry.value);
    }
  }
}

class LogbookShareScreen extends StatefulWidget {
  final AppDatabase db;
  final DiveSession session;

  const LogbookShareScreen({super.key, required this.db, required this.session});

  @override
  State<LogbookShareScreen> createState() => _LogbookShareScreenState();
}

class _LogbookShareScreenState extends State<LogbookShareScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  ShareCardPreference _prefs = ShareCardPreference();
  bool _isLoading = true;
  bool _isSharing = false;
  List<DiveRep> _reps = [];
  ShareField? _selectedField;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = LogbookRepository(widget.db);
    final reps = await repo.getRepsForSession(widget.session.id);
    final prefs = await ShareCardPreference.load();
    setState(() {
      _reps = reps;
      _prefs = prefs;
      _isLoading = false;
    });
  }

  Future<void> _share() async {
    setState(() => _isSharing = true);
    try {
      final imageBytes = await _screenshotController.capture(delay: const Duration(milliseconds: 100));
      if (imageBytes == null) return;

      final xFile = XFile.fromData(
        imageBytes,
        mimeType: 'image/png',
        name: 'divebrew_log_${widget.session.id}.png',
      );

      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [xFile],
        text: '다이브브루에서 기록한 프리다이빙 로그입니다! 🌊\n장소: ${widget.session.siteName}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('공유 중 오류가 발생했습니다: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  void _savePrefs() {
    _prefs.save();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공유 카드 만들기'),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: _isSharing
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.ios_share),
              onPressed: _isSharing ? null : _share,
              tooltip: '공유하기',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      // 카드 여백 클릭 시 선택 해제
                      setState(() => _selectedField = null);
                    },
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
                          ],
                          color: Colors.black,
                        ),
                        child: Screenshot(
                          controller: _screenshotController,
                          child: _buildCardContent(),
                        ),
                      ),
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  flex: 2,
                  child: _buildEditor(),
                ),
              ],
            ),
    );
  }

  Widget _buildCardContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final photoPath = widget.session.photoPaths.first;

        return Material(
          color: Colors.black,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              kIsWeb
                  ? Image.network(photoPath, fit: BoxFit.cover)
                  : Image.file(File(photoPath), fit: BoxFit.cover),
                  
              // Overlay
              if (_prefs.overlayGradient)
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent, Colors.black87],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.4, 1.0],
                    ),
                  ),
                ),

              // Draggable Content
              ..._buildDraggableFields(width, height),

              // Watermark
              if (_prefs.watermark)
                Positioned(
                  right: 24,
                  bottom: 24,
                  child: Text(
                    'DiveBrew Trainer',
                    style: TextStyle(
                      color: _prefs.isTextWhite ? Colors.white54 : Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildDraggableFields(double width, double height) {
    final items = <Widget>[];

    for (final field in ShareField.values) {
      if (!_prefs.selectedFields.contains(field)) continue;

      Widget? fieldWidget = _buildFieldWidget(field);
      if (fieldWidget == null) continue;

      // Ensure the field has an initial position if not set
      if (!_prefs.customPositions.containsKey(field)) {
        _prefs.customPositions[field] = _getDefaultPosition(field);
      }

      final posPct = _prefs.customPositions[field]!;
      // Clamp to prevent moving completely off-screen
      final dx = (posPct.dx * width).clamp(0.0, width - 20.0);
      final dy = (posPct.dy * height).clamp(0.0, height - 20.0);

      final isSelected = _selectedField == field;

      items.add(
        Positioned(
          left: dx,
          top: dy,
          child: GestureDetector(
            onTap: () {
              setState(() => _selectedField = field);
            },
            onPanStart: (_) {
              setState(() => _selectedField = field);
            },
            onPanUpdate: (details) {
              setState(() {
                final newX = (dx + details.delta.dx) / width;
                final newY = (dy + details.delta.dy) / height;
                _prefs.customPositions[field] = Offset(
                  newX.clamp(0.0, 1.0),
                  newY.clamp(0.0, 1.0),
                );
              });
            },
            onPanEnd: (_) => _savePrefs(),
            child: Container(
              // 패딩을 주어 터치 영역을 넓게 확보
              padding: const EdgeInsets.all(4),
              decoration: isSelected
                  ? BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    )
                  : const BoxDecoration(color: Colors.transparent),
              child: fieldWidget,
            ),
          ),
        ),
      );
    }
    return items;
  }

  Offset _getDefaultPosition(ShareField field) {
    switch (field) {
      case ShareField.record:
        return const Offset(0.05, 0.85); // 좌하단
      case ShareField.date:
        return const Offset(0.05, 0.05); // 좌상단
      case ShareField.site:
        return const Offset(0.05, 0.10);
      case ShareField.condition:
        return const Offset(0.05, 0.15);
      case ShareField.purpose:
        return const Offset(0.05, 0.20);
      case ShareField.rating:
        return const Offset(0.05, 0.25);
    }
  }

  Widget? _buildFieldWidget(ShareField field) {
    final scale = _prefs.customScales[field] ?? 1.0;
    final primaryColor = _prefs.isTextWhite ? Colors.white : Colors.black;
    final secondaryColor = _prefs.isTextWhite ? Colors.white70 : Colors.black87;
    final bgColor = _prefs.isTextWhite ? Colors.white24 : Colors.black12;
    
    switch (field) {
      case ShareField.record:
        if (_reps.isNotEmpty) {
          final rep = _reps.first;
          String recordText = '';
          if (rep.discipline == Discipline.sta) {
            final min = rep.performanceValue ~/ 60;
            final sec = (rep.performanceValue % 60).toInt();
            recordText = 'STA ${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
          } else {
            recordText = '${rep.discipline.name.toUpperCase()} ${rep.performanceValue} ${rep.performanceUnit.name}';
          }
          return Text(
            recordText,
            style: TextStyle(color: primaryColor, fontSize: 36 * scale, fontWeight: FontWeight.bold),
          );
        } else {
          return Text(
            widget.session.siteName,
            style: TextStyle(color: primaryColor, fontSize: 32 * scale, fontWeight: FontWeight.bold),
          );
        }
        
      case ShareField.date:
        return Text(
          DateFormat('yyyy.MM.dd').format(widget.session.date),
          style: TextStyle(color: secondaryColor, fontSize: 16 * scale),
        );
        
      case ShareField.site:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, color: secondaryColor, size: 16 * scale),
            SizedBox(width: 4 * scale),
            Text(
              widget.session.siteName,
              style: TextStyle(color: primaryColor, fontSize: 20 * scale, fontWeight: FontWeight.bold),
            ),
          ],
        );
        
      case ShareField.condition:
        if (widget.session.condition.waterTempC != null || widget.session.condition.waveHeightM != null) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.session.condition.waterTempC != null)
                Text('수온 ${widget.session.condition.waterTempC}°C', style: TextStyle(color: secondaryColor, fontSize: 14 * scale)),
              if (widget.session.condition.waterTempC != null && widget.session.condition.waveHeightM != null)
                Text(' · ', style: TextStyle(color: secondaryColor, fontSize: 14 * scale)),
              if (widget.session.condition.waveHeightM != null)
                Text('파고 ${widget.session.condition.waveHeightM}m', style: TextStyle(color: secondaryColor, fontSize: 14 * scale)),
            ],
          );
        }
        return null;
        
      case ShareField.purpose:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 4 * scale),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4 * scale)),
          child: Text(_getPurposeText(widget.session.purposeTag), style: TextStyle(color: primaryColor, fontSize: 12 * scale)),
        );
        
      case ShareField.rating:
        if (widget.session.overallRating != null) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              5,
              (i) => Icon(
                i < widget.session.overallRating! ? Icons.star : Icons.star_border,
                size: 16 * scale,
                color: Colors.amber,
              ),
            ),
          );
        }
        return null;
    }
  }

  Widget _buildEditor() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_selectedField != null) ...[
          Text('${_getFieldName(_selectedField!)} 글자 크기 조절', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          Slider(
            value: _prefs.customScales[_selectedField!] ?? 1.0,
            min: 0.5,
            max: 3.0,
            divisions: 25,
            label: '${((_prefs.customScales[_selectedField!] ?? 1.0) * 100).toInt()}%',
            onChanged: (val) {
              setState(() => _prefs.customScales[_selectedField!] = val);
            },
            onChangeEnd: (_) => _savePrefs(),
          ),
        ] else ...[
          const Text('크기를 조절할 항목을 위 사진에서 터치하세요.', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 48), // Space placeholder to prevent jumping
        ],
        const SizedBox(height: 16),
        const Text('표시 정보 (드래그하여 이동 가능)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ShareField.values.map((field) {
            final isSelected = _prefs.selectedFields.contains(field);
            return FilterChip(
              label: Text(_getFieldName(field)),
              selected: isSelected,
              onSelected: (val) {
                if (val) {
                  _prefs.selectedFields.add(field);
                } else {
                  _prefs.selectedFields.remove(field);
                }
                _savePrefs();
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Text('효과', style: TextStyle(fontWeight: FontWeight.bold)),
        SwitchListTile(
          title: const Text('배경 어둡게 (가독성 향상)'),
          value: _prefs.overlayGradient,
          onChanged: (val) {
            _prefs.overlayGradient = val;
            _savePrefs();
          },
        ),
        SwitchListTile(
          title: const Text('글씨 검정색으로 변경'),
          value: !_prefs.isTextWhite,
          onChanged: (val) {
            _prefs.isTextWhite = !val;
            _savePrefs();
          },
        ),
        SwitchListTile(
          title: const Text('앱 워터마크 표시'),
          value: _prefs.watermark,
          onChanged: (val) {
            _prefs.watermark = val;
            _savePrefs();
          },
        ),
      ],
    );
  }

  String _getFieldName(ShareField field) {
    switch (field) {
      case ShareField.record:
        return '기록/횟수';
      case ShareField.date:
        return '날짜';
      case ShareField.site:
        return '장소명';
      case ShareField.condition:
        return '컨디션';
      case ShareField.rating:
        return '별점';
      case ShareField.purpose:
        return '목적 태그';
    }
  }

  String _getPurposeText(PurposeTag tag) {
    switch (tag) {
      case PurposeTag.training:
        return '트레이닝';
      case PurposeTag.leisure:
        return '펀다이빙';
      case PurposeTag.spearfishing:
        return '스피어피싱';
      case PurposeTag.photo:
        return '수중촬영';
      case PurposeTag.competitionPractice:
        return '대회준비';
      case PurposeTag.other:
        return '기타';
    }
  }
}
