// Fotografiile prezentării, toate de pe Wikimedia Commons, cu licențe libere
// (domeniu public, CC0, CC BY, CC BY-SA). Autorii și licențele sunt în CREDITE_FOTO.md.

/// O fotografie din `assets/images/plastic/`, cu autorul și licența ei.
class Photo {
  const Photo(this.file, this.author, this.license, this.commons);

  final String file;
  final String author;
  final String license;

  /// Numele paginii de pe Wikimedia Commons (pentru lista de surse).
  final String commons;

  String get path => 'assets/images/plastic/$file';
}

class Photos {
  Photos._();

  static const Photo microplasticHand = Photo(
    'cover_microplastic.jpg', 'OceanBlueProject', 'CC BY-SA 4.0',
    'Microplastic-found-key-largo-beach-state-park.jpg');
  static const Photo blood = Photo(
    's01_sange.jpg', 'National Eye Institute', 'CC BY 2.0',
    'Checking Blood Sample (9955279835).jpg');
  static const Photo parkes = Photo(
    's02_parkes.jpg', 'Oosoom', 'CC BY-SA 3.0',
    'Alexander Parkes Blue Plaque.jpg');
  static const Photo hyatt = Photo(
    's02_hyatt.jpg', 'autor necunoscut', 'domeniu public',
    'John Wesley Hyatt.jpg');
  static const Photo billiard = Photo(
    's02_bile_biliard.jpg', 'DPLA', 'domeniu public',
    'Set of Celluloid Billiard Balls in Wooden Box - DPLA - b6942c2a95bf8b42c47fd914215ebbbb.jpg');
  static const Photo baekeland = Photo(
    's02_baekeland.jpg', 'autor necunoscut', 'domeniu public',
    'Leo Baekeland ca 1906 (cropped).jpg');
  static const Photo bakelitePhone = Photo(
    's02_telefon_bachelita.jpg', 'Holger Ellgaard', 'CC BY-SA 3.0',
    'Bakelittelefon 1947a.jpg');
  static const Photo pellets = Photo(
    's03_granule.jpg', 'Teemeah', 'CC BY-SA 3.0',
    'Plastic pellets for injection molding.jpg');
  static const Photo pe3d = Photo(
    's03_pe_3d.png', 'Ben Mills', 'domeniu public',
    'Polyethylene-xtal-packing-3D-balls-perspective.png');
  static const Photo pet3d = Photo(
    's03_pet_3d.png', 'Jynto', 'CC0',
    'Polyethylene-terephthalate-3D-balls.png');
  static const Photo beach = Photo(
    's04_plaja.jpg', 'CaptainDarwin', 'CC BY-SA 4.0',
    'Plastic Pollution in Santa Luzia, Cape Verde.jpg');
  static const Photo petBales = Photo(
    's05_pet.jpg', 'Grendelkhan', 'CC BY-SA 4.0',
    'Bales of PET bottles closeup.jpg');
  static const Photo hdpeMilk = Photo(
    's05_hdpe.jpg', 'ArnoldReinhold', 'CC BY 4.0',
    'Two milk gallons in refrigerator door.agr.jpg');
  static const Photo pvcBlister = Photo(
    's06_pvc_blister.jpg', 'autor necunoscut', 'CC0',
    'Pills in blister pack.jpg');
  static const Photo ldpeFilm = Photo(
    's06_ldpe_folie.jpg', 'Ilmari Karonen', 'domeniu public',
    'Clingfilm.jpg');
  static const Photo ppLid = Photo(
    's07_pp.jpg', 'Mk2010', 'CC BY-SA 3.0',
    'Polypropylene lid.JPG');
  static const Photo psSem = Photo(
    's07_ps_sem.jpg', 'HaefnerP', 'CC BY-SA 4.0',
    'Polystyrene expanded in SEM.jpg');
  static const Photo pcJug = Photo(
    's07_pc_bidon.jpg', 'Myke2020', 'domeniu public',
    'Refilling 18L water jug bottled water 5219.JPG');
  static const Photo fragments = Photo(
    's08_fragmente.jpg', 'Provincie Limburg / Alf Mertens', 'CC0',
    'River litter plastic fragments 1.jpg');
  static const Photo everest = Photo(
    's08_everest.jpg', 'Luca Galuzzi', 'CC BY-SA 2.5',
    'Everest North Face toward Base Camp Tibet Luca Galuzzi 2006.jpg');
  static const Photo mariana = Photo(
    's08_marianelor.jpg', 'Daiju Azuma', 'CC BY-SA 2.5',
    'Hirondellea gigas.jpg');
  static const Photo petase = Photo(
    's09_petaza.png', 'Keministi', 'CC0',
    'PETase 5XH3 with HEMT-cartoon.png');
  static const Photo waxWorm = Photo(
    's09_larva_molie.jpg', 'Sam Droege (USGS)', 'domeniu public',
    'Wax worm, U, Maryland, side 2015-07-13-13.01.17 ZS PMax.jpg');
  static const Photo mealworms = Photo(
    's09_viermi_faina.jpg', 'Fvukajlovic', 'CC BY 4.0',
    'Tenebrio molitor larvae FV2.jpg');
  static const Photo ooho = Photo(
    's10_ooho.jpg', '林阿君', 'CC BY-SA 4.0',
    '半透膜 環保水球-Ooho 4.jpg');
  static const Photo mycelium = Photo(
    's10_miceliu.jpg', 'Mycobond', 'CC BY-SA 2.0',
    'Wine Shipper in fungal products by Mycobond.jpg');
  static const Photo plaCups = Photo(
    's10_pla.jpg', 'Cmglee', 'CC BY-SA 4.0',
    'Cmglee PLA cups.jpg');

  /// Toate, în ordinea din prezentare (pentru teste).
  static const List<Photo> all = <Photo>[
    microplasticHand, blood, parkes, hyatt, billiard, baekeland, bakelitePhone,
    pellets, pe3d, pet3d, beach, petBales, hdpeMilk, pvcBlister, ldpeFilm,
    ppLid, psSem, pcJug, fragments, everest, mariana, petase, waxWorm,
    mealworms, ooho, mycelium, plaCups,
  ];
}
