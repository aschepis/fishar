import '../models/fish_species.dart';

class FishDataService {
  static final Map<String, FishSpecies> _fishData = {
    '0': const FishSpecies(
      id: '0',
      commonName: 'Angelfish',
      scientificName: 'Pterophyllum scalare',
      description: 'Angelfish are graceful freshwater fish with distinctive triangular fins and elegant swimming patterns. They are popular in home aquariums due to their striking appearance and relatively peaceful nature.',
      habitat: 'Freshwater rivers and floodplains',
      region: 'Amazon Basin, South America',
      imageAsset: 'assets/images/angelfish.jpg',
      sizeRange: '6-8 inches (15-20 cm)',
      facts: [
        'Can live up to 10 years in captivity',
        'Form monogamous pairs when breeding',
        'Originally silver with black stripes, but many color variations exist',
        'Prefer tall aquariums due to their body shape',
      ],
    ),
    '1': const FishSpecies(
      id: '1',
      commonName: 'Clownfish',
      scientificName: 'Amphiprion ocellatus',
      description: 'Made famous by the movie "Finding Nemo," clownfish are small, brightly colored marine fish known for their symbiotic relationship with sea anemones.',
      habitat: 'Coral reefs and sea anemones',
      region: 'Indo-Pacific Ocean',
      imageAsset: 'assets/images/clownfish.jpg',
      sizeRange: '2-5 inches (5-13 cm)',
      facts: [
        'Immune to sea anemone stings',
        'All clownfish are born male and can change to female',
        'Live in small family groups called schools',
        'Feed on algae, zooplankton, and anemone tentacles',
      ],
    ),
    '2': const FishSpecies(
      id: '2',
      commonName: 'Goldfish',
      scientificName: 'Carassius auratus',
      description: 'One of the most popular pet fish, goldfish are hardy freshwater fish that come in various colors and fin types. They are descendants of wild carp from East Asia.',
      habitat: 'Freshwater ponds, lakes, and slow-moving rivers',
      region: 'Originally East Asia, now worldwide',
      imageAsset: 'assets/images/goldfish.jpg',
      sizeRange: '4-16 inches (10-41 cm)',
      facts: [
        'Can live over 20 years with proper care',
        'Have a memory span longer than 3 seconds',
        'Can see both infrared and ultraviolet light',
        'Produce ammonia, requiring good filtration',
      ],
    ),
    '3': const FishSpecies(
      id: '3',
      commonName: 'Betta Fish',
      scientificName: 'Betta splendens',
      description: 'Also known as Siamese fighting fish, bettas are known for their vibrant colors and flowing fins. Males are territorial and should be kept alone.',
      habitat: 'Shallow waters, rice paddies, and floodplains',
      region: 'Southeast Asia (Thailand, Cambodia, Vietnam)',
      imageAsset: 'assets/images/betta.jpg',
      sizeRange: '2.5-3 inches (6-8 cm)',
      facts: [
        'Can breathe air from the surface using a labyrinth organ',
        'Males build bubble nests for their eggs',
        'Show complex behavioral patterns and can recognize their owners',
        'Live 2-3 years on average',
      ],
    ),
    '4': const FishSpecies(
      id: '4',
      commonName: 'Guppy',
      scientificName: 'Poecilia reticulata',
      description: 'Small, colorful freshwater fish popular with beginners. Guppies are livebearers, meaning they give birth to live young rather than laying eggs.',
      habitat: 'Freshwater streams and rivers',
      region: 'South America (Trinidad, Venezuela, Guyana, Brazil)',
      imageAsset: 'assets/images/guppy.jpg',
      sizeRange: '1-2.5 inches (2.5-6 cm)',
      facts: [
        'Females are larger than males',
        'Can produce offspring every 28 days',
        'Eat mosquito larvae in the wild',
        'Highly adaptable to different water conditions',
      ],
    ),
    '5': const FishSpecies(
      id: '5',
      commonName: 'Neon Tetra',
      scientificName: 'Paracheirodon innesi',
      description: 'Small, peaceful schooling fish with distinctive blue and red coloration. They are one of the most popular aquarium fish due to their striking appearance in groups.',
      habitat: 'Soft, acidic waters of the Amazon Basin',
      region: 'South America (Brazil, Colombia, Peru)',
      imageAsset: 'assets/images/tetra.jpg',
      sizeRange: '1-1.5 inches (2.5-4 cm)',
      facts: [
        'Should be kept in groups of at least 6',
        'The blue stripe helps them recognize their own species',
        'Prefer dimly lit environments',
        'Live 5-8 years in captivity',
      ],
    ),
    '6': const FishSpecies(
      id: '6',
      commonName: 'African Cichlid',
      scientificName: 'Pseudotropheus zebra',
      description: 'Colorful freshwater fish known for their complex social behaviors and parental care. African cichlids are popular for their vibrant colors and active personalities.',
      habitat: 'Rocky shores of freshwater lakes',
      region: 'African Great Lakes (Malawi, Tanganyika, Victoria)',
      imageAsset: 'assets/images/cichlid.jpg',
      sizeRange: '3-6 inches (8-15 cm)',
      facts: [
        'Practice mouth brooding to protect their young',
        'Can be territorial and aggressive',
        'Over 1,000 species of cichlids exist in Africa',
        'Some species are endemic to specific lakes',
      ],
    ),
    '7': const FishSpecies(
      id: '7',
      commonName: 'Corydoras Catfish',
      scientificName: 'Corydoras paleatus',
      description: 'Small, armored catfish that are excellent bottom cleaners in aquariums. They are peaceful, social fish that prefer to live in groups.',
      habitat: 'River bottoms and shallow waters',
      region: 'South America (Argentina, Brazil, Paraguay, Uruguay)',
      imageAsset: 'assets/images/catfish.jpg',
      sizeRange: '2-4 inches (5-10 cm)',
      facts: [
        'Have barbels around their mouth to find food',
        'Can gulp air from the surface',
        'Produce a clicking sound when excited',
        'Should be kept in groups of 3 or more',
      ],
    ),
    '8': const FishSpecies(
      id: '8',
      commonName: 'Tiger Barb',
      scientificName: 'Puntigrus tetrazona',
      description: 'Active, semi-aggressive freshwater fish with distinctive black stripes. They are schooling fish that do best in groups of 6 or more.',
      habitat: 'Streams and rivers with moderate flow',
      region: 'Southeast Asia (Malaysia, Thailand, Cambodia)',
      imageAsset: 'assets/images/barb.jpg',
      sizeRange: '2-3 inches (5-8 cm)',
      facts: [
        'Known for nipping at fins of slower fish',
        'Very active swimmers',
        'Can live up to 7 years',
        'Prefer slightly acidic water',
      ],
    ),
    '9': const FishSpecies(
      id: '9',
      commonName: 'Zebra Danio',
      scientificName: 'Danio rerio',
      description: 'Small, hardy fish with distinctive horizontal stripes. They are excellent beginner fish and are commonly used in scientific research.',
      habitat: 'Slow-moving streams and rice paddies',
      region: 'South Asia (India, Pakistan, Bangladesh, Nepal)',
      imageAsset: 'assets/images/danio.jpg',
      sizeRange: '1.5-2 inches (4-5 cm)',
      facts: [
        'One of the first fish to be cloned',
        'Commonly used as a model organism in research',
        'Very hardy and adaptable',
        'Fast swimmers that prefer the upper levels of the tank',
      ],
    ),
  };

  static FishSpecies? getFishBySpeciesId(String speciesId) {
    return _fishData[speciesId];
  }

  static List<FishSpecies> getAllFish() {
    return _fishData.values.toList();
  }

  static List<FishSpecies> searchFish(String query) {
    final lowerQuery = query.toLowerCase();
    return _fishData.values.where((fish) {
      return fish.commonName.toLowerCase().contains(lowerQuery) ||
             fish.scientificName.toLowerCase().contains(lowerQuery) ||
             fish.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}