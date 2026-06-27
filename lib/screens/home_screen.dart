import 'package:flutter/material.dart';
import '../services/astronomy_service.dart';
import '../models/celestial_object.dart';
import '../widgets/sky_canvas.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _astronomyService = AstronomyService();
  List<CelestialObject> _objects = [];
  bool _isLoading = false;
  String? _error;

  // Default location (Delhi, India)
  double _latitude = 28.6139;
  double _longitude = 77.2090;
  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    setState(() {
      _objects = _astronomyService.getSampleSky();
    });
  }

  Future<void> _calculateSky() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final objects = await _astronomyService.calculateSky(
        latitude: _latitude,
        longitude: _longitude,
        dateTime: _selectedDateTime,
      );

      setState(() {
        _objects = objects;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // Left panel - Controls
          Container(
            width: 300,
            color: Colors.grey.shade900,
            child: _buildControlPanel(),
          ),

          // Right panel - Sky view
          Expanded(
            child: _buildSkyView(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'SkyCanvas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'v0.1 Alpha',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 32),

          // Location
          const Text(
            'Location',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildTextField(
            label: 'Latitude',
            value: _latitude.toString(),
            onChanged: (value) {
              final lat = double.tryParse(value);
              if (lat != null) _latitude = lat;
            },
          ),
          const SizedBox(height: 8),
          _buildTextField(
            label: 'Longitude',
            value: _longitude.toString(),
            onChanged: (value) {
              final lon = double.tryParse(value);
              if (lon != null) _longitude = lon;
            },
          ),
          const SizedBox(height: 24),

          // Date & Time
          const Text(
            'Date & Time (UTC)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDateTime,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() {
                  _selectedDateTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    _selectedDateTime.hour,
                    _selectedDateTime.minute,
                  );
                });
              }
            },
            child: Text(
              '${_selectedDateTime.year}-${_selectedDateTime.month.toString().padLeft(2, '0')}-${_selectedDateTime.day.toString().padLeft(2, '0')}',
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
              );
              if (time != null) {
                setState(() {
                  _selectedDateTime = DateTime(
                    _selectedDateTime.year,
                    _selectedDateTime.month,
                    _selectedDateTime.day,
                    time.hour,
                    time.minute,
                  );
                });
              }
            },
            child: Text(
              '${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}',
            ),
          ),
          const SizedBox(height: 24),

          // Calculate button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _calculateSky,
              icon: const Icon(Icons.calculate),
              label: Text(_isLoading ? 'Calculating...' : 'Calculate Sky'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(
              'Error: $_error',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],

          const SizedBox(height: 24),

          // Object list
          const Text(
            'Visible Objects',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _objects.where((o) => o.isVisible).length,
              itemBuilder: (context, index) {
                final obj = _objects.where((o) => o.isVisible).toList()[index];
                return ListTile(
                  dense: true,
                  title: Text(
                    obj.name,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  subtitle: Text(
                    '${obj.type} • ${obj.altitude.toStringAsFixed(1)}° alt',
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: TextEditingController(text: value),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildSkyView() {
    if (_objects.isEmpty) {
      return const Center(
        child: Text(
          'Click "Calculate Sky" to see the stars',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return CustomPaint(
      painter: SkyCanvas(objects: _objects),
      child: Container(),
    );
  }
}
