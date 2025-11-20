import 'package:flutter/material.dart';
import 'package:lablink/LabAdmin/Pages/Add_New_Location.dart';
import 'package:lablink/LabAdmin/Pages/Add_New_Test.dart';
import 'package:lablink/LabAdmin/Pages/Manage_Tests_screen.dart';
import 'package:lablink/LabAdmin/Widgets/top_widget.dart';
import 'package:lablink/LabAdmin/services/location_services.dart';

class LabLocations_screen extends StatefulWidget {
  const LabLocations_screen({super.key});

  @override
  State<LabLocations_screen> createState() => _LabLocations_screenState();
}

class _LabLocations_screenState extends State<LabLocations_screen> {
  final labid = 'StetfS8KpRZCntXqc46wAzIhnVI2';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          top_screen(
            context: context,
            title: 'Lab Locations',
            subtitle: 'Manage your laboratory locations',
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 290,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddNewLocation()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009689),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: Colors.white),
                  Text(
                    ' Add New Location',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: LocationServices().getLocations(labid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No locations found'));
                }

                var locations = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    final location = locations[index];
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              location.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  location.address,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.phone, color: Colors.grey),
                                const SizedBox(width: 5),
                                Text(
                                  location.phone,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer_outlined,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${location.startday.substring(0, 3)} - ${location.endday?.substring(0, 3) ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${location.openinghours} - ${location.closinghours}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: const [
                                    Text(
                                      '20 Tests',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      'available',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                   print(location.id); 
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ManageTests(
                                              locationid: location.id ?? '',
                                               labid: labid,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 113,
                                        height: 31,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xFF009689),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Manage Tests',
                                            style: TextStyle(
                                              color: Color(0xFF009689),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () async {
                                        if (location.id != null) {
                                          await LocationServices()
                                              .deletLocation(
                                                location.id!,
                                                labid,
                                              );
                                        }
                                      },
                                      child: Container(
                                        width: 38,
                                        height: 31,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.red),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.delete_outlined,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
