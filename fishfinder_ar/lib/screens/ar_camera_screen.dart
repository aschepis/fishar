import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../services/fish_detection_service.dart';
import '../services/permission_service.dart';
import '../models/fish_detection.dart';
import '../widgets/bounding_box_overlay.dart';
import '../widgets/fish_info_modal.dart';
import '../services/fish_data_service.dart';

class ARCameraScreen extends StatefulWidget {
  const ARCameraScreen({super.key});

  @override
  State<ARCameraScreen> createState() => _ARCameraScreenState();
}

class _ARCameraScreenState extends State<ARCameraScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isDetecting = false;
  List<FishDetection> _detections = [];
  String? _error;
  bool _isDemoMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      // Check if camera is supported on this platform
      if (kIsWeb || defaultTargetPlatform == TargetPlatform.macOS) {
        setState(() {
          _error = null; // Clear error for demo mode
          _isInitialized = true;
          _isDemoMode = true;
        });
        _startDemoMode();
        return;
      }

      final permissionService = context.read<PermissionService>();
      final hasPermission = await permissionService.requestCameraPermission();
      
      if (!hasPermission) {
        setState(() {
          _error = 'Camera permission is required to use this feature';
        });
        return;
      }

      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _error = null;
          _isInitialized = true;
          _isDemoMode = true;
        });
        _startDemoMode();
        return;
      }

      _cameraController = CameraController(
        _cameras!.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _error = null;
        });
        
        // Initialize fish detection service
        final fishDetectionService = context.read<FishDetectionService>();
        await fishDetectionService.initialize();
        
        // Start detection
        _startDetection();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to initialize camera: $e';
        });
      }
    }
  }

  void _startDetection() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    _cameraController!.startImageStream((CameraImage image) {
      if (!_isDetecting) {
        _detectFish(image);
      }
    });
  }

  Future<void> _detectFish(CameraImage image) async {
    if (_isDetecting) return;
    
    setState(() {
      _isDetecting = true;
    });

    try {
      final fishDetectionService = context.read<FishDetectionService>();
      final detections = await fishDetectionService.detectFish(image);
      
      if (mounted) {
        setState(() {
          _detections = detections;
        });
      }
    } catch (e) {
      print('Detection error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isDetecting = false;
        });
      }
      
      // Add delay to control detection frequency (target 1-5 fps)
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  void _startDemoMode() {
    // Simulate fish detection in demo mode
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || !_isDemoMode) {
        timer.cancel();
        return;
      }
      
      _simulateDetection();
    });
    
    // Start with initial detections
    Future.delayed(const Duration(milliseconds: 500), _simulateDetection);
  }

  void _simulateDetection() async {
    if (!_isDemoMode) return;
    
    setState(() {
      _isDetecting = true;
    });

    // Create simulated detections
    final random = DateTime.now().millisecondsSinceEpoch;
    final detections = <FishDetection>[
      FishDetection(
        speciesId: (random % 5).toString(),
        label: ['angelfish', 'clownfish', 'goldfish', 'betta', 'guppy'][random % 5],
        confidence: 0.7 + (random % 30) / 100,
        boundingBox: Rect.fromLTWH(
          50 + (random % 200).toDouble(),
          100 + (random % 300).toDouble(),
          80 + (random % 60).toDouble(),
          60 + (random % 40).toDouble(),
        ),
        timestamp: DateTime.now(),
      ),
      if (random % 3 == 0) FishDetection(
        speciesId: ((random + 1) % 5).toString(),
        label: ['angelfish', 'clownfish', 'goldfish', 'betta', 'guppy'][(random + 1) % 5],
        confidence: 0.6 + (random % 25) / 100,
        boundingBox: Rect.fromLTWH(
          200 + (random % 150).toDouble(),
          200 + (random % 200).toDouble(),
          70 + (random % 50).toDouble(),
          50 + (random % 30).toDouble(),
        ),
        timestamp: DateTime.now(),
      ),
    ];

    await Future.delayed(const Duration(milliseconds: 300));
    
    if (mounted) {
      setState(() {
        _detections = detections;
        _isDetecting = false;
      });
    }
  }

  void _onFishTapped(FishDetection detection) {
    final fishData = FishDataService.getFishBySpeciesId(detection.speciesId);
    if (fishData != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => FishInfoModal(
          fishSpecies: fishData,
          detection: detection,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('FishFinder AR'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _initializeCamera,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('FishFinder AR'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing camera...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Camera preview or demo background
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: _isDemoMode 
                ? Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF1E3A8A), // Deep blue
                          Color(0xFF3B82F6), // Medium blue
                          Color(0xFF60A5FA), // Light blue
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Demo background elements
                        Positioned(
                          top: 100,
                          left: 50,
                          child: _buildBubble(30),
                        ),
                        Positioned(
                          top: 250,
                          right: 80,
                          child: _buildBubble(20),
                        ),
                        Positioned(
                          bottom: 200,
                          left: 100,
                          child: _buildBubble(25),
                        ),
                        Positioned(
                          bottom: 150,
                          right: 50,
                          child: _buildBubble(15),
                        ),
                        // Demo mode indicator
                        const Positioned(
                          top: 120,
                          left: 20,
                          right: 20,
                          child: Card(
                            color: Colors.black54,
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                '🐠 DEMO MODE\nSimulating AR fish detection\nUse iOS/Android for real camera',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : CameraPreview(_cameraController!),
          ),
          
          // Bounding box overlays
          InteractiveBoundingBoxOverlay(
            detections: _detections,
            onFishTapped: _onFishTapped,
            screenSize: MediaQuery.of(context).size,
          ),
          
          // App bar overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: const Text('FishFinder AR'),
              backgroundColor: Colors.black26,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    _showInfoDialog(context);
                  },
                ),
              ],
            ),
          ),
          
          // Detection status indicator
          Positioned(
            bottom: 100,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _isDetecting ? Colors.green : (_isDemoMode ? Colors.blue : Colors.grey),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isDetecting ? 'Detecting...' : (_isDemoMode ? 'Demo Mode' : 'Ready'),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          
          // Fish count indicator
          if (_detections.isNotEmpty)
            Positioned(
              bottom: 100,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_detections.length} fish detected',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to use FishFinder AR'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Point your camera at fish in an aquarium'),
            SizedBox(height: 8),
            Text('2. Wait for fish to be detected and labeled'),
            SizedBox(height: 8),
            Text('3. Tap on a detected fish to learn more about it'),
            SizedBox(height: 8),
            Text('4. Green boxes indicate high confidence detections'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
    );
  }
}