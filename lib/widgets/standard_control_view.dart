import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StandardControlView extends StatefulWidget {
  const StandardControlView({super.key});

  @override
  _StandardControlViewState createState() => _StandardControlViewState();
}

class _StandardControlViewState extends State<StandardControlView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isCelsius = true;
  bool _isKPa = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Standard Control'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Implement settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildControlPanel(),
                _buildPresetConfigurations(),
                _buildDataFlow(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement toggle between Diagram and Standard views
        },
        tooltip: 'Toggle View',
        child: const Icon(Icons.swap_horiz),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(icon: Icon(Icons.tune), text: 'Controls'),
          Tab(icon: Icon(Icons.playlist_add_check), text: 'Presets'),
          Tab(icon: Icon(Icons.show_chart), text: 'Data Flow'),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTemperatureControls(),
        const SizedBox(height: 16),
        _buildPressureControls(),
        const SizedBox(height: 16),
        _buildFlowControls(),
      ],
    );
  }

  Widget _buildTemperatureControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Temperature Controls', style: Theme.of(context).textTheme.titleLarge),
                Switch(
                  value: _isCelsius,
                  onChanged: (value) {
                    setState(() {
                      _isCelsius = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputField('Heater 1', _isCelsius ? '°C' : '°F', '0-500'),
            const SizedBox(height: 8),
            _buildInputField('Heater 2', _isCelsius ? '°C' : '°F', '0-500'),
          ],
        ),
      ),
    );
  }

  Widget _buildPressureControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pressure Controls', style: Theme.of(context).textTheme.titleLarge),
                Switch(
                  value: _isKPa,
                  onChanged: (value) {
                    setState(() {
                      _isKPa = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputField('Chamber Pressure', _isKPa ? 'kPa' : 'psi', '0-1000'),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Flow Controls', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildInputField('MFC Flow Rate', 'sccm', '0-1000'),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String unit, String range) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixText: unit,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              int? intValue = int.tryParse(value);
              if (intValue == null || intValue < 0 || intValue > 1000) {
                return 'Value must be between $range';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPresetConfigurations() {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildPresetButton('Low Temp Coat', Colors.blue),
        _buildPresetButton('High Temp Coat', Colors.red),
        _buildPresetButton('Purge Cycle', Colors.green),
        _buildPresetButton('Custom Preset 1', Colors.orange),
      ],
    );
  }

  Widget _buildPresetButton(String label, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () {
        // TODO: Implement preset configuration
      },
      child: Text(
        label,
        style: const TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataFlow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.arrow_downward, size: 48),
        const SizedBox(height: 16),
        Text('Data Flow', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        const Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Interactions with Other Components:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('• Sends real-time data to Monitoring Page for live updates'),
                Text('• Communicates with Error Detection for immediate alerts'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}