import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';



import '../../data/database.dart';
import '../../data/models.dart';
import '../../l10n/app_localizations.dart';
import 'logbook_repository.dart';
import 'services/location_weather_service.dart';

class _RepFormData {
  Discipline discipline = Discipline.cwt;
  String performanceValue = '';
  PerformanceUnit performanceUnit = PerformanceUnit.m;
}

class LogbookEditScreen extends StatefulWidget {
  final AppDatabase db;
  final int? sessionId; // null이면 새 작성, 값이 있으면 수정

  const LogbookEditScreen({super.key, required this.db, this.sessionId});

  @override
  State<LogbookEditScreen> createState() => _LogbookEditScreenState();
}

class _LogbookEditScreenState extends State<LogbookEditScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime _date = DateTime.now();
  SiteType _siteType = SiteType.sea;
  String _siteName = '';
  PurposeTag _purposeTag = PurposeTag.leisure;
  int _overallRating = 0; // 0 means unrated
  double? _lat;
  double? _lon;
  DiveCondition _condition = const DiveCondition(source: ConditionSource.manual);
  bool _isLoadingLocation = false;
  bool _isLoadingSession = false;
  
  String _leaderName = '';
  String _note = '';
  final List<String> _photoPaths = [];

  final List<_RepFormData> _reps = [];
  late final LogbookRepository _repository;
  final LocationWeatherService _locationService = LocationWeatherService();
  final ImagePicker _picker = ImagePicker();
  final MapController _mapController = MapController();

  final _siteNameController = TextEditingController();
  final _waveHeightController = TextEditingController();
  final _waterTempController = TextEditingController();
  final _leaderNameController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repository = LogbookRepository(widget.db);
    
    if (widget.sessionId != null) {
      _loadExistingSession(widget.sessionId!);
    } else {
      _reps.add(_RepFormData());
    }
  }

  Future<void> _loadExistingSession(int id) async {
    setState(() => _isLoadingSession = true);
    try {
      final session = await _repository.getSession(id);
      if (session == null) return;
      final reps = await _repository.getRepsForSession(id);
      
      setState(() {
        _date = session.date;
        _siteType = session.siteType;
        _siteName = session.siteName;
        _siteNameController.text = _siteName;
        _purposeTag = session.purposeTag;
        _overallRating = session.overallRating ?? 0;
        _lat = session.lat;
        _lon = session.lon;
        _condition = session.condition;
        
        if (_condition.waveHeightM != null) {
          _waveHeightController.text = _condition.waveHeightM.toString();
        }
        if (_condition.waterTempC != null) {
          _waterTempController.text = _condition.waterTempC.toString();
        }
        
        _leaderName = session.leaderName ?? '';
        _leaderNameController.text = _leaderName;
        _note = session.note ?? '';
        _noteController.text = _note;
        
        _photoPaths.addAll(session.photoPaths);
        
        if (reps.isNotEmpty) {
          _reps.clear();
          for (final r in reps) {
            final fd = _RepFormData();
            fd.discipline = r.discipline;
            
            // 정수인 경우 소수점 없이 문자열로, 아니면 그대로
            if (r.performanceValue == r.performanceValue.toInt()) {
              fd.performanceValue = r.performanceValue.toInt().toString();
            } else {
              fd.performanceValue = r.performanceValue.toString();
            }
            
            fd.performanceUnit = r.performanceUnit;
            _reps.add(fd);
          }
        } else {
          if (_reps.isEmpty) _reps.add(_RepFormData());
        }
      });
      
      // initState 에서는 아직 MapController 가 바인딩되지 않았을 수 있으므로 약간의 지연 후 맵 이동
      if (_lat != null && _lon != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _mapController.move(LatLng(_lat!, _lon!), 13.0);
        });
      }
    } finally {
      if (mounted) setState(() => _isLoadingSession = false);
    }
  }

  @override
  void dispose() {
    _siteNameController.dispose();
    _waveHeightController.dispose();
    _waterTempController.dispose();
    _leaderNameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentLocationAndCondition() async {
    setState(() => _isLoadingLocation = true);
    try {
      final pos = await _locationService.getCurrentLocation();
      if (pos == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('위치 권한이 없거나 위치를 가져올 수 없습니다.')),
          );
        }
        return;
      }
      
      _lat = pos.latitude;
      _lon = pos.longitude;

      final placeName = await _locationService.getPlaceName(pos.latitude, pos.longitude);
      if (placeName != null) {
        _siteName = placeName;
        _siteNameController.text = placeName;
      }

      if (_lat != null && _lon != null) {
        _mapController.move(LatLng(_lat!, _lon!), 13.0);
      }

      final marineData = await _locationService.getMarineData(pos.latitude, pos.longitude);
      _condition = marineData;
      
      if (marineData.waveHeightM != null) {
        _waveHeightController.text = marineData.waveHeightM.toString();
      }
      if (marineData.waterTempC != null) {
        _waterTempController.text = marineData.waterTempC.toString();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('현재 위치 정보가 입력되었습니다.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final repCompanions = _reps.map((r) => DiveRepsCompanion.insert(
            sessionId: 0, // 레포지토리에서 실제 ID로 오버라이드
            sequence: 0, // 레포지토리에서 자동 할당
            discipline: r.discipline,
            performanceValue: double.tryParse(r.performanceValue) ?? 0.0,
            performanceUnit: r.performanceUnit,
            incident: IncidentType.none,
          )).toList();

      if (widget.sessionId != null) {
        await _repository.updateSession(
          sessionId: widget.sessionId!,
          date: _date,
          siteType: _siteType,
          siteName: _siteName,
          purposeTag: _purposeTag,
          overallRating: _overallRating,
          reps: repCompanions,
          lat: _lat,
          lon: _lon,
          condition: _condition,
          photoPaths: _photoPaths,
          leaderName: _leaderName.isEmpty ? null : _leaderName,
          note: _note.isEmpty ? null : _note,
        );
      } else {
        await _repository.saveSession(
          date: _date,
          siteType: _siteType,
          siteName: _siteName,
          purposeTag: _purposeTag,
          overallRating: _overallRating,
          reps: repCompanions,
          lat: _lat,
          lon: _lon,
          condition: _condition,
          photoPaths: _photoPaths,
          leaderName: _leaderName.isEmpty ? null : _leaderName,
          note: _note.isEmpty ? null : _note,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장되었습니다: $_siteName')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('로그 삭제'),
        content: const Text('정말 이 다이빙 로그를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _repository.deleteSession(widget.sessionId!);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('삭제되었습니다.')),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isNew = widget.sessionId == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? l10n.logbookNew : l10n.logbookEdit),
        actions: [
          if (!isNew)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: _confirmDelete,
            ),
          TextButton(
            onPressed: _save,
            child: Text(l10n.logbookSave),
          ),
        ],
      ),
      body: _isLoadingSession 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(theme, '다이빙 날짜'),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(_date),
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle(theme, '장소 정보'),
                  TextButton.icon(
                    onPressed: _isLoadingLocation ? null : _fetchCurrentLocationAndCondition,
                    icon: _isLoadingLocation 
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.my_location, size: 18),
                    label: const Text('현재 위치로 채우기'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SegmentedButton<SiteType>(
                segments: const [
                  ButtonSegment(value: SiteType.sea, label: Text('바다')),
                  ButtonSegment(value: SiteType.pool, label: Text('풀장')),
                  ButtonSegment(value: SiteType.lake, label: Text('호수')),
                ],
                selected: {_siteType},
                onSelectionChanged: (set) {
                  setState(() => _siteType = set.first);
                },
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _siteNameController,
                      decoration: const InputDecoration(
                        labelText: '장소명',
                        border: OutlineInputBorder(),
                        hintText: '예: 서귀포 섶섬, 가평 K26',
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? '장소명을 입력해주세요.' : null,
                      onChanged: (val) => _siteName = val,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () async {
                      if (_siteName.isEmpty) return;
                      final coords = await _locationService.searchPlace(_siteName);
                      if (coords != null) {
                        setState(() {
                          _lat = coords['lat'];
                          _lon = coords['lon'];
                        });
                        _mapController.move(LatLng(_lat!, _lon!), 13.0);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('지도 위치가 갱신되었습니다.')),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('장소를 찾을 수 없습니다.')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // 미니맵 위젯
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _lat != null && _lon != null 
                          ? LatLng(_lat!, _lon!) 
                          : const LatLng(33.24, 126.56),
                      initialZoom: 8.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.divebrew.trainer',
                      ),
                      if (_lat != null && _lon != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(_lat!, _lon!),
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _waveHeightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: '파고 (m)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        _condition = _condition.copyWith(waveHeightM: double.tryParse(val));
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _waterTempController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: '수온 (°C)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        _condition = _condition.copyWith(waterTempC: double.tryParse(val));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              _buildSectionTitle(theme, '버디 및 캡틴'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _leaderNameController,
                decoration: const InputDecoration(
                  labelText: '버디/강사/리더 이름 (쉼표로 구분)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => _leaderName = val,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle(theme, '사진 추가'),
                  TextButton.icon(
                    onPressed: () async {
                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          _photoPaths.add(image.path);
                        });
                      }
                    },
                    icon: const Icon(Icons.add_a_photo, size: 18),
                    label: const Text('갤러리'),
                  ),
                ],
              ),
              if (_photoPaths.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _photoPaths.length,
                    itemBuilder: (context, index) {
                      final path = _photoPaths[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: kIsWeb
                              ? Image.network(path, fit: BoxFit.cover)
                              : Image.file(File(path), fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 24),

              _buildSectionTitle(theme, '다이빙 목적'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: PurposeTag.values.map((tag) {
                  return ChoiceChip(
                    label: Text(_getPurposeText(tag)),
                    selected: _purposeTag == tag,
                    onSelected: (selected) {
                      if (selected) setState(() => _purposeTag = tag);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle(theme, '종합 평가'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final ratingValue = index + 1;
                  return IconButton(
                    iconSize: 40,
                    icon: Icon(
                      ratingValue <= _overallRating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() => _overallRating = ratingValue);
                    },
                  );
                }),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle(theme, '세부 다이빙 기록 (Reps)'),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _reps.add(_RepFormData()));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('랩 추가'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._reps.asMap().entries.map((entry) {
                final index = entry.key;
                final rep = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('랩 ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            if (_reps.length > 1)
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () {
                                  setState(() => _reps.removeAt(index));
                                },
                              )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<Discipline>(
                                initialValue: rep.discipline,
                                decoration: const InputDecoration(
                                  labelText: '종목',
                                  border: OutlineInputBorder(),
                                ),
                                items: Discipline.values.map((d) {
                                  return DropdownMenuItem(value: d, child: Text(d.name.toUpperCase()));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => rep.discipline = val);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                initialValue: rep.performanceValue,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: '기록',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (val) =>
                                    val == null || val.isEmpty ? '필수' : null,
                                onSaved: (val) => rep.performanceValue = val ?? '0',
                                onChanged: (val) => rep.performanceValue = val,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: DropdownButtonFormField<PerformanceUnit>(
                                initialValue: rep.performanceUnit,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                items: PerformanceUnit.values.map((u) {
                                  return DropdownMenuItem(value: u, child: Text(u.name));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => rep.performanceUnit = val);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 32),

              _buildSectionTitle(theme, '자유 메모'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: '다이빙 센터, 해양생물, 느낀 점 등 자유롭게 기록하세요.',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => _note = val,
              ),

              const SizedBox(height: 48), // 하단 여백
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
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
