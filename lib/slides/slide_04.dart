import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Slide 04 – Sistemul de Codificare Europeana: Codurile E
// ─────────────────────────────────────────────────────────────────────────────

class Slide04Milestones extends StatefulWidget {
  const Slide04Milestones({super.key});
  @override
  State<Slide04Milestones> createState() => _S04State();
}

class _S04State extends State<Slide04Milestones>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  Timer? _autoTimer;
  int _pageIndex = 0;
  bool _isAutoPlaying = true;

  static const _autoAdvanceDuration = Duration(seconds: 5);

  static const _particles = [
    _Particle(x:0.5,y:0.95,speedX:0.1,speedY:0.02,amplitude:0.02,phase:0.0,radius:1.5,opacity:0.06,pulseSpeed:0.3,useColor2:true),
    _Particle(x:0.804,y:0.168,speedX:0.18,speedY:0.03,amplitude:0.035,phase:0.4,radius:2.3,opacity:0.10,pulseSpeed:0.45,useColor2:false),
    _Particle(x:0.052,y:0.538,speedX:0.26,speedY:0.04,amplitude:0.05,phase:0.8,radius:3.1,opacity:0.14,pulseSpeed:0.6,useColor2:false),
    _Particle(x:0.856,y:0.775,speedX:0.34,speedY:0.05,amplitude:0.065,phase:1.2,radius:3.9,opacity:0.18,pulseSpeed:0.75,useColor2:true),
    _Particle(x:0.423,y:0.057,speedX:0.42,speedY:0.06,amplitude:0.02,phase:1.6,radius:4.7,opacity:0.06,pulseSpeed:0.9,useColor2:false),
    _Particle(x:0.257,y:0.879,speedX:0.5,speedY:0.02,amplitude:0.035,phase:2.0,radius:1.5,opacity:0.10,pulseSpeed:1.05,useColor2:false),
    _Particle(x:0.935,y:0.386,speedX:0.58,speedY:0.03,amplitude:0.05,phase:2.4,radius:2.3,opacity:0.14,pulseSpeed:0.3,useColor2:true),
    _Particle(x:0.102,y:0.29,speedX:0.1,speedY:0.04,amplitude:0.065,phase:2.8,radius:3.1,opacity:0.18,pulseSpeed:0.45,useColor2:false),
    _Particle(x:0.651,y:0.924,speedX:0.18,speedY:0.05,amplitude:0.02,phase:3.2,radius:3.9,opacity:0.06,pulseSpeed:0.6,useColor2:false),
    _Particle(x:0.675,y:0.086,speedX:0.26,speedY:0.06,amplitude:0.035,phase:3.6,radius:4.7,opacity:0.10,pulseSpeed:0.75,useColor2:true),
    _Particle(x:0.091,y:0.687,speedX:0.34,speedY:0.02,amplitude:0.05,phase:4.0,radius:1.5,opacity:0.14,pulseSpeed:0.9,useColor2:false),
    _Particle(x:0.928,y:0.639,speedX:0.42,speedY:0.03,amplitude:0.065,phase:4.4,radius:2.3,opacity:0.18,pulseSpeed:1.05,useColor2:false),
    _Particle(x:0.279,y:0.108,speedX:0.5,speedY:0.04,amplitude:0.02,phase:4.8,radius:3.1,opacity:0.06,pulseSpeed:0.3,useColor2:true),
    _Particle(x:0.398,y:0.938,speedX:0.58,speedY:0.05,amplitude:0.035,phase:5.2,radius:3.9,opacity:0.10,pulseSpeed:0.45,useColor2:false),
    _Particle(x:0.872,y:0.246,speedX:0.1,speedY:0.06,amplitude:0.05,phase:5.6,radius:4.7,opacity:0.14,pulseSpeed:0.6,useColor2:false),
    _Particle(x:0.055,y:0.436,speedX:0.18,speedY:0.02,amplitude:0.065,phase:6.0,radius:1.5,opacity:0.18,pulseSpeed:0.75,useColor2:true),
    _Particle(x:0.785,y:0.849,speedX:0.26,speedY:0.03,amplitude:0.02,phase:6.4,radius:2.3,opacity:0.06,pulseSpeed:0.9,useColor2:false),
    _Particle(x:0.526,y:0.051,speedX:0.34,speedY:0.04,amplitude:0.035,phase:6.8,radius:3.1,opacity:0.10,pulseSpeed:1.05,useColor2:false),
    _Particle(x:0.177,y:0.813,speedX:0.42,speedY:0.05,amplitude:0.05,phase:7.2,radius:3.9,opacity:0.14,pulseSpeed:0.3,useColor2:true),
    _Particle(x:0.95,y:0.487,speedX:0.5,speedY:0.06,amplitude:0.065,phase:7.6,radius:4.7,opacity:0.18,pulseSpeed:0.45,useColor2:false),
    _Particle(x:0.16,y:0.205,speedX:0.58,speedY:0.02,amplitude:0.02,phase:8.0,radius:1.5,opacity:0.06,pulseSpeed:0.6,useColor2:false),
    _Particle(x:0.551,y:0.947,speedX:0.1,speedY:0.03,amplitude:0.035,phase:8.4,radius:2.3,opacity:0.10,pulseSpeed:0.75,useColor2:true),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // DATE COMPLETE – toate codurile E din document, grupate pe categorii
  // ─────────────────────────────────────────────────────────────────────────
  static final _pages = [
    _EPage(
      range: 'E100–E199',
      title: 'Coloranți Alimentari',
      accentColor: const Color(0xFF00F0FF),
      icon: Icons.palette_rounded,
      description: 'Coloranții conferă sau restabilesc culoarea alimentelor. '
          'Fiecare este evaluat de EFSA înainte de aprobare pe piața europeană.',
      rows: const [
        _ERow('E102', 'Tartrazină', 'Băuturi, dulciuri, deserturi', 'C₁₆H₉N₄Na₃O₉S₂'),
        _ERow('E120', 'Carmin (din insecte)', 'Iaurturi, sucuri, jeleuri', 'C₂₂H₂₀O₁₃'),
        _ERow('E150a', 'Caramel simplu', 'Cola, sosuri, bere', 'C₁₂H₁₈O₉'),
        _ERow('E150b', 'Caramel caustic sulfitic', 'Whisky, otet', 'C₁₂H₁₈O₉'),
        _ERow('E150c', 'Caramel amoniacal', 'Bere, sosuri de soia', 'C₁₂H₁₈O₉'),
        _ERow('E150d', 'Caramel sulfito-amoniacal', 'Cola, băuturi, patiserie', 'C₁₂H₁₈O₉'),
        _ERow('E171', 'Dioxid de titan (TiO2)', 'Dulciuri, gumă, înghețată', 'TiO₂'),
        _ERow('E172', 'Oxizi de fier', 'Suplimente, capsule, decoratiuni', 'Fe₂O₃'),
      ],
      imagePath: 'assets/images/slide04_coloranti.png',
    ),
    _EPage(
      range: 'E200–E214',
      title: 'Conservanți: Acid Sorbic și Benzoați',
      accentColor: const Color(0xFFFFCC00),
      icon: Icons.shield_rounded,
      description: 'Acizii sorbic și benzoic și sărurile lor inhibă mucegaiurile și drojdiile. '
          'DZA cumulativă E200-E203 este 25 mg/kg; E210-E213 este 5 mg/kg corp.',
      rows: const [
        _ERow('E200', 'Acid sorbic', 'Brânzeturi, sucuri, pizza, panificație', 'C₆H₈O₂'),
        _ERow('E201', 'Sorbat de sodiu', 'Margarina, brânzeturi, tartinabile', 'C₆H₇NaO₂'),
        _ERow('E202', 'Sorbat de potasiu', 'Gemuri, iaurturi, panificație, vin', 'C₆H₇KO₂'),
        _ERow('E203', 'Sorbat de calciu', 'Brânzeturi, tartinabile', 'C₁₂H₁₄CaO₄'),
        _ERow('E210', 'Acid benzoic', 'Băuturi nealcoolice, sucuri, conserve', 'C₇H₆O₂'),
        _ERow('E211', 'Benzoat de sodiu', 'Băuturi carbogazoase, murături', 'C₇H₅NaO₂'),
        _ERow('E212', 'Benzoat de potasiu', 'Margarina, uleiuri pentru salata', 'C₇H₅KO₂'),
        _ERow('E213', 'Benzoat de calciu', 'Produse de patiserie, sosuri', 'C₁₄H₁₀CaO₄'),
        _ERow('E214', 'Para-hidroxibenzoat de etil', 'Conserve, cosmetice', 'C₉H₁₀O₃'),
      ],
      imagePath: 'assets/images/slide04_sorbic.png',
    ),
    _EPage(
      range: 'E220–E252',
      title: 'Conservanți: Sulfiți și Nitrați',
      accentColor: const Color(0xFFFF9500),
      icon: Icons.warning_amber_rounded,
      description: 'Sulfiții (DZA 0,7 mg/kg) sunt alergeni declarați obligatoriu pe etichetă. '
          'Nitriții (DZA 0,06 mg/kg) previn botulismul în mezeluri dar necesită monitorizare atentă.',
      rows: const [
        _ERow('E220', 'Dioxid de sulf (SO2)', 'Vinuri, fructe uscate, cartofi', 'SO₂'),
        _ERow('E221', 'Sulfit de sodiu', 'Vinuri, produse deshidratate', 'Na₂SO₃'),
        _ERow('E222', 'Bisulfit de sodiu', 'Bere, vinuri, fructe conservate', 'NaHSO₃'),
        _ERow('E223', 'Metabisulfit de sodiu', 'Vinuri, cidru, fructe', 'Na₂S₂O₅'),
        _ERow('E224', 'Metabisulfit de potasiu', 'Vinuri, bere, fructe uscate', 'K₂S₂O₅'),
        _ERow('E226', 'Sulfit de calciu', 'Conserve de legume, vin', 'CaSO₃'),
        _ERow('E249', 'Nitrit de potasiu', 'Preparate din carne sărată', 'KNO₂'),
        _ERow('E250', 'Nitrit de sodiu', 'Mezeluri, salam, sunca, bacon', 'NaNO₂'),
        _ERow('E251', 'Nitrat de sodiu', 'Carne maturata, brânzeturi', 'NaNO₃'),
        _ERow('E252', 'Nitrat de potasiu (salpetru)', 'Jambon, brânzeturi', 'KNO₃'),
      ],
      imagePath: 'assets/images/slide04_sulfiti.png',
    ),
    _EPage(
      range: 'E260–E290',
      title: 'Conservanți: Acizi Organici și CO₂',
      accentColor: const Color(0xFF00FF88),
      icon: Icons.biotech_rounded,
      description: 'Acizii acetic, lactic și propionic sunt produși natural prin fermentație. '
          'Majoritatea nu au DZA stabilită, fiind considerați siguri în cantitățile utilizate.',
      rows: const [
        _ERow('E260', 'Acid acetic', 'Muraturi, maioneza, dressing-uri', 'CH₃COOH'),
        _ERow('E261', 'Acetat de potasiu', 'Conserve pesti, condimente', 'CH₃COOK'),
        _ERow('E262', 'Acetat de sodiu', 'Chipsuri, snack-uri, pâine', 'CH₃COONa'),
        _ERow('E270', 'Acid lactic', 'Lactate fermentate, margarina', 'C₃H₆O₃'),
        _ERow('E280', 'Acid propionic', 'Produse de panificație ambalate', 'C₃H₆O₂'),
        _ERow('E281', 'Propionat de sodiu', 'Pâine, produse brutărie', 'C₃H₅NaO₂'),
        _ERow('E282', 'Propionat de calciu', 'Pâine feliată, patiserie', 'C₆H₁₀CaO₄'),
        _ERow('E283', 'Propionat de potasiu', 'Produse de panificație', 'C₃H₅KO₂'),
        _ERow('E284', 'Acid boric', 'Icre negre/rosu', 'H₃BO₃'),
        _ERow('E290', 'Dioxid de carbon (CO2)', 'Băuturi carbogazoase, bere', 'CO₂'),
      ],
      imagePath: 'assets/images/slide04_acizi_organici.png',
    ),
    _EPage(
      range: 'E300–E399',
      title: 'Antioxidanți și Regulatori de Aciditate',
      accentColor: const Color(0xFF7B61FF),
      icon: Icons.science_rounded,
      description: 'Antioxidanții previn râncezirea și oxidarea. '
          'Vitamina C (E300) și acidul citric (E330) sunt cei mai utilizați, complet siguri și naturali.',
      rows: const [
        _ERow('E300', 'Acid ascorbic (Vitamina C)', 'Sucuri, conserve, carne', 'C₆H₈O₆'),
        _ERow('E301', 'Ascorbat de sodiu', 'Mezeluri, produse procesate', 'C₆H₇NaO₆'),
        _ERow('E302', 'Ascorbat de calciu', 'Suplimente, produse lactate', 'C₁₂H₁₄CaO₁₂'),
        _ERow('E306', 'Extract bogat în tocoferoli', 'Uleiuri vegetale, margarină', 'C₂₇–C₂₉H₄₆–₅₀O₂'),
        _ERow('E307', 'Alfa-tocoferol (Vit. E sintetica)', 'Uleiuri, produse copii', 'C₂₉H₅₀O₂'),
        _ERow('E308', 'Gamma-tocoferol', 'Uleiuri vegetale', 'C₂₈H₄₈O₂'),
        _ERow('E309', 'Delta-tocoferol', 'Uleiuri rafinate', 'C₂₇H₄₆O₂'),
        _ERow('E330', 'Acid citric', 'Băuturi, gemuri, bomboane', 'C₆H₈O₇'),
        _ERow('E331', 'Citrati de sodiu', 'Brânzeturi topite, băuturi', 'C₆H₅Na₃O₇'),
        _ERow('E332', 'Citrati de potasiu', 'Gemuri, conserve, lactate', 'C₆H₅K₃O₇'),
        _ERow('E333', 'Citrati de calciu', 'Brânzeturi, suplimente', 'C₁₂H₁₀Ca₃O₁₄'),
        _ERow('E334', 'Acid tartric', 'Vinuri, produse de patiserie', 'C₄H₆O₆'),
        _ERow('E338', 'Acid fosforic', 'Cola, băuturi carbogazoase', 'H₃PO₄'),
      ],
      imagePath: 'assets/images/slide04_antioxidanti.png',
    ),
    _EPage(
      range: 'E400–E499',
      title: 'Agenți de Îngroșare, Stabilizatori și Emulgatori',
      accentColor: const Color(0xFFFF6BFF),
      icon: Icons.water_drop_rounded,
      description: 'Această categorie include substanțe care modifică textura alimentelor. '
          'Pectina, alginații și lecitina sunt de origine naturală și larg utilizate.',
      rows: const [
        _ERow('E400', 'Acid alginic', 'Inghetata, produse lactate', '(C₆H₈O₆)ₙ'),
        _ERow('E401', 'Alginat de sodiu', 'Patiserie, jeluri, sosuri', 'C₆H₇NaO₆'),
        _ERow('E402', 'Alginat de potasiu', 'Produse cofetarie, jeluri', 'C₆H₇KO₆'),
        _ERow('E404', 'Alginat de calciu', 'Produse din carne restructurată', 'C₁₂H₁₄CaO₁₂'),
        _ERow('E406', 'Agar-agar', 'Deserturi, jeluri, produse vegetariene', '(C₁₂H₁₈O₉)ₙ'),
        _ERow('E407', 'Caragenan', 'Produse lactate, mezeluri, înghețată', '(C₁₂H₁₈O₉)ₙ'),
        _ERow('E410', 'Faina de roscove (LBG)', 'Inghetata, lactate, sosuri', '(C₆H₁₂O₆)ₙ'),
        _ERow('E412', 'Guma guar', 'Produse fără gluten, înghețată', '(C₆H₁₂O₆)ₙ'),
        _ERow('E414', 'Guma arabica', 'Bomboane, gumă, băuturi', '(C₆H₁₂O₆)ₙ'),
        _ERow('E415', 'Guma xantan', 'Dressing-uri, produse fără gluten', '(C₃₅H₄₉O₂₉)ₙ'),
        _ERow('E440', 'Pectine', 'Gemuri, jeluri, sucuri, patiserie', '(C₆H₁₀O₇)ₙ'),
        _ERow('E471', 'Mono- și digliceride acizi grași', 'Margarină, pâine', 'C₂₁H₄₂O₄'),
        _ERow('E476', 'Poliglicerol poliricinoleat (PGPR)', 'Ciocolata, sosuri', 'C₅₇H₁₀₄O₉'),
      ],
      imagePath: 'assets/images/slide04_emulgatori.png',
    ),
    _EPage(
      range: 'E500–E599',
      title: 'Regulatori de Aciditate și Antiaglomeranți',
      accentColor: const Color(0xFF00D4FF),
      icon: Icons.compress_rounded,
      description: 'Bicarbonatul de sodiu (E500) este agentul de dospit clasic. '
          'Antiaglomeranții (E551-E570) previn bulgării în sare, lapte praf și condimente.',
      rows: const [
        _ERow('E500', 'Bicarbonat de sodiu', 'Produse panificație, efervescente', 'NaHCO₃'),
        _ERow('E501', 'Carbonat de potasiu', 'Patiserie, cacao procesata', 'K₂CO₃'),
        _ERow('E503', 'Carbonat de amoniu', 'Biscuiti, produse patiserie', '(NH₄)₂CO₃'),
        _ERow('E504', 'Carbonat de magneziu', 'Sare de masa, suplimente', 'MgCO₃'),
        _ERow('E509', 'Clorura de calciu', 'Brânzeturi, conserve, tofu', 'CaCl₂'),
        _ERow('E511', 'Clorura de magneziu', 'Tofu, suplimente, patiserie', 'MgCl₂'),
        _ERow('E516', 'Sulfat de calciu', 'Tofu, pâine, cereale', 'CaSO₄'),
        _ERow('E551', 'Dioxid de siliciu (SiO2)', 'Condimente, lapte praf', 'SiO₂'),
        _ERow('E553b', 'Talc', 'Tablete, guma mestecat, orez', 'Mg₃Si₄O₁₀(OH)₂'),
        _ERow('E570', 'Acizi grași', 'Produse de panificație, glazuri', 'CₙH₂ₙO₂'),
      ],
      imagePath: 'assets/images/slide04_bicarbonati.png',
    ),
    _EPage(
      range: 'E600–E699',
      title: 'Intensificatori de Aroma (Potentiatori)',
      accentColor: const Color(0xFFFF4488),
      icon: Icons.restaurant_rounded,
      description: 'Potențiatorii amplifică gustul existent fără a adăuga propria aromă. '
          'MSG (E621) este natural prezent în roșii, parmezan și ciuperci.',
      rows: const [
        _ERow('E620', 'Acid glutamic', 'Condimente, supe instant, snack-uri', 'C₅H₉NO₄'),
        _ERow('E621', 'Glutamat monosodic (MSG)', 'Snack-uri, supe, asiatice', 'C₅H₈NNaO₄'),
        _ERow('E622', 'Glutamat monopotasic', 'Condimente, conserve, supe', 'C₅H₈KNO₄'),
        _ERow('E623', 'Diglutamat de calciu', 'Conserve, supe, procesate', 'C₁₀H₁₆CaN₂O₈'),
        _ERow('E624', 'Glutamat monoamoniacal', 'Condimente, preparate culinare', 'C₅H₁₂N₂O₄'),
        _ERow('E625', 'Diglutamat de magneziu', 'Supe, sosuri, produse procesate', 'C₁₀H₁₆MgN₂O₈'),
        _ERow('E626', 'Acid guanilic', 'Supe instant, snack-uri', 'C₁₀H₁₄N₅O₈P'),
        _ERow('E627', 'Guanilat disodic (GMP)', 'Snack-uri, supe, condimente', 'C₁₀H₁₂N₅Na₂O₈P'),
        _ERow('E630', 'Acid inozinic', 'Produse procesate, supe instant', 'C₁₀H₁₃N₄O₈P'),
        _ERow('E631', 'Inozinat disodic (IMP)', 'Chipsuri, supe, carne', 'C₁₀H₁₁N₄Na₂O₈P'),
        _ERow('E635', 'Ribonucleotide disodice', 'Chipsuri, snack-uri intense', 'C₁₀H₁₁N₄Na₂O₈P + C₁₀H₁₂N₅Na₂O₈P'),
      ],
      imagePath: 'assets/images/slide04_potentiatori.png',
    ),
    _EPage(
      range: 'E900–E999',
      title: 'Ceară, Glazuranți și Îndulcitori',
      accentColor: const Color(0xFFFFAA00),
      icon: Icons.star_rounded,
      description: 'Îndulcitorii intensivi (E950-E960) au putere de 200-13.000x față de zahăr '
          'și sunt esențiali pentru produsele dietetice și diabetice.',
      rows: const [
        _ERow('E901', 'Ceara de albine', 'Bomboane, fructe glazurate', 'C₁₆H₃₂O₂'),
        _ERow('E902', 'Ceara de candelilla', 'Guma de mestecat, bomboane', 'C₃₀H₆₂'),
        _ERow('E903', 'Ceara de carnauba', 'Bomboane, fructe glazurate', 'C₂₄H₄₈O₂'),
        _ERow('E904', 'Selac', 'Glazura fructe citrice, bomboane', '(C₁₅H₂₂O₅)ₙ'),
        _ERow('E941', 'Azot (N2)', 'Ambalare MAP, lactate, cafea', 'N₂'),
        _ERow('E942', 'Protoxid de azot (N2O)', 'Frisca presata, deserturi aerate', 'N₂O'),
        _ERow('E948', 'Oxigen (O2)', 'Ambalare MAP, produse proaspete', 'O₂'),
        _ERow('E950', 'Acesulfam K', 'Băuturi dietetice, produse fără zahăr', 'C₄H₄KNO₄S'),
        _ERow('E951', 'Aspartam', 'Băuturi light, iaurturi, gumă', 'C₁₄H₁₈N₂O₅'),
        _ERow('E952', 'Acid ciclamic / Ciclamat', 'Băuturi dietetice, deserturi', 'C₆H₁₃NO₃S'),
        _ERow('E954', 'Zaharina și sărurile ei', 'Produse dietetice, bauturi', 'C₇H₅NO₃S'),
        _ERow('E955', 'Sucraloza', 'Fără zahăr, băuturi, produse lactate', 'C₁₂H₁₉Cl₃O₈'),
        _ERow('E960', 'Glicozide steviol (Stevia)', 'Produse bio fără zahăr, băuturi', 'C₃₈H₆₀O₁₈'),
        _ERow('E965', 'Maltitol', 'Ciocolată fără zahăr, gumă', 'C₁₂H₂₄O₁₁'),
        _ERow('E967', 'Xilitol', 'Gumă fără zahăr, produse dentare', 'C₅H₁₂O₅'),
        _ERow('E968', 'Eritritol', 'Produse keto, dulciuri fără zahăr', 'C₄H₁₀O₄'),
      ],
      imagePath: 'assets/images/slide04_indulcitori.png',
    ),
    _EPage(
      range: 'E1000–E1999',
      title: 'Aditivi Suplimentari (Amidonuri Modificate)',
      accentColor: const Color(0xFF88FFAA),
      icon: Icons.grain_rounded,
      description: 'Amidonurile modificate (E1400+) sunt derivate din porumb, cartofi sau grâu '
          'și îmbunătățesc textura și stabilitatea produselor procesate.',
      rows: const [
        _ERow('E1103', 'Invertaze', 'Bomboane cu umplutura lichida', 'C₆H₁₂O₆'),
        _ERow('E1200', 'Polidextroza', 'Produse cu calorii reduse', '(C₆H₁₀O₅)ₙ'),
        _ERow('E1400', 'Dextrine, amidon prajit', 'Sosuri, supe, procesate', '(C₆H₁₀O₅)ₙ'),
        _ERow('E1401', 'Amidon tratat cu acid', 'Patiserie, supe instant', '(C₆H₁₀O₅)ₙ'),
        _ERow('E1402', 'Amidon tratat alcalin', 'Produse de panificație, sosuri', '(C₆H₁₀O₅)ₙ'),
        _ERow('E1403', 'Amidon albit', 'Produse de panificație, deserturi', '(C₆H₁₀O₅)ₙ'),
        _ERow('E1404', 'Amidon oxidat', 'Sosuri, supe, produse din carne', '(C₆H₁₀O₅)ₙ'),
        _ERow('E1410', 'Fosfat de monoamidon', 'Produse congelate, supe instant', '(C₆H₁₀O₅)ₙ'),
        _ERow('E1412', 'Fosfat de diamidon', 'Produse procesate, sosuri, supe', '(C₆H₁₀O₅)ₙ'),
        _ERow('E1413', 'Fosfat de diamidon fosfatat', 'Alimente procesate, supe, sosuri', '(C₆H₁₀O₅)ₙ'),
        _ERow('E1414', 'Fosfat de diamidon acetilat', 'Alimente congelate, carne', '(C₆H₁₀O₅)ₙ'),
        _ERow('E1420', 'Amidon acetilat', 'Supe, sosuri, produse de patiserie', '(C₆H₁₀O₅)ₙ'),
        _ERow('E1422', 'Adipat de diamidon acetilat', 'Produse procesate, supe', '(C₆H₁₀O₅)ₙ'),
        _ERow('E1440', 'Hidroxipropil amidon', 'Congelate, sosuri, supe instant', '(C₆H₁₀O₅)ₙ'),
        _ERow('E1442', 'Fosfat hidroxipropil diamidon', 'Procesate, supe, sosuri', '(C₆H₁₀O₅)ₙ'),
        _ERow('E1450', 'Octenil succinat de amidon', 'Băuturi cu aromă, emulsii, supe', '(C₆H₁₀O₅)ₙ'),
      ],
      imagePath: 'assets/images/slide04_amidonuri.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 6))
      ..repeat();
    _startAutoTimer();
  }

  void _startAutoTimer() {
    _autoTimer?.cancel();

    // Corectare de logică critică: Nu reporni timer-ul dacă utilizatorul a pus expres pe pauză
    if (!_isAutoPlaying) return;

    _autoTimer = Timer.periodic(_autoAdvanceDuration, (_) {
      if (mounted) {
        setState(() {
          _pageIndex = (_pageIndex + 1) % _pages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_pageIndex < _pages.length - 1) {
      setState(() => _pageIndex++);
      _startAutoTimer(); // Resetează timerul doar dacă suntem în modul auto-play
    }
  }

  void _goPrev() {
    if (_pageIndex > 0) {
      setState(() => _pageIndex--);
      _startAutoTimer(); // Resetează timerul doar dacă suntem în modul auto-play
    }
  }

  void _toggleAutoPlay() {
    setState(() {
      _isAutoPlaying = !_isAutoPlaying;
    });

    if (_isAutoPlaying) {
      _startAutoTimer();
    } else {
      _autoTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_pageIndex];

    return Container(
      key: const ValueKey('slide_04'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF020609), Color(0xFF060A14), Color(0xFF030D13)],
        ),
      ),
      child: Stack(children: [
        // Am izolat custom paint-urile pentru a preveni blocarea invizibilă a apasărilor
        IgnorePointer(
          child: CustomPaint(painter: _DotGridPainter04(), size: Size.infinite),
        ),
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => IgnorePointer(
            child: CustomPaint(
              painter: _ParticlePainter04(_ctrl.value),
              size: Size.infinite,
            ),
          ),
        ),

        // Glow orbs
        Positioned(
          top: -100, right: -60,
          child: IgnorePointer(
            child: Container(
              width: 500, height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  page.accentColor.withOpacity(0.08),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -80, left: 40,
          child: IgnorePointer(
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFFFF6BFF).withOpacity(0.05),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
        ),

        // ── MAIN CONTENT ───────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 20, 40, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── BODY: stânga foto | dreapta titlu + tabel + navigare ────
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    // ── STÂNGA – imagine ──────────────────────────────────
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: ClipRRect(
                            key: ValueKey('img_$_pageIndex'),
                            borderRadius: BorderRadius.circular(16),
                            child: page.imagePath != null
                                ? Image.asset(
                              page.imagePath!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                decoration: BoxDecoration(
                                  color: page.accentColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: page.accentColor.withOpacity(0.25)),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(page.icon,
                                          color: page.accentColor.withOpacity(0.4),
                                          size: 64),
                                      const SizedBox(height: 12),
                                      Text(
                                        page.range,
                                        style: TextStyle(
                                          color: page.accentColor.withOpacity(0.5),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                                : Container(
                              decoration: BoxDecoration(
                                color: page.accentColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: page.accentColor.withOpacity(0.25)),
                              ),
                              child: Center(
                                child: Icon(page.icon,
                                    color: page.accentColor.withOpacity(0.4),
                                    size: 64),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ── DREAPTA – titlu + tabel + navigare ───────────────
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // ── TITLE AREA ──────────────────────────────────
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: Row(
                              key: ValueKey('title_$_pageIndex'),
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: page.accentColor.withOpacity(0.13),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(page.icon, color: page.accentColor, size: 22),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: page.accentColor.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                              color: page.accentColor.withOpacity(0.45)),
                                        ),
                                        child: Text(page.range, style: TextStyle(
                                          color: page.accentColor,
                                          fontSize: 11, fontWeight: FontWeight.w900,
                                          letterSpacing: 2,
                                        )),
                                      ),
                                      const SizedBox(height: 3),
                                      ShaderMask(
                                        shaderCallback: (b) => LinearGradient(
                                          colors: [Colors.white, page.accentColor.withOpacity(0.8)],
                                        ).createShader(b),
                                        child: Text(
                                          page.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            height: 1.1,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        page.description,
                                        style: TextStyle(
                                          color: page.accentColor.withOpacity(0.65),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // ── TABLE ────────────────────────────────────────
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              child: _ETable(
                                key: ValueKey(_pageIndex),
                                page: page,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // ── NAVIGATION ───────────────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _NavButton(
                                onTap: _pageIndex > 0 ? _goPrev : null,
                                label: _pageIndex > 0
                                    ? '<- ${_pages[_pageIndex - 1].range}'
                                    : '<- Înapoi',
                                color: page.accentColor,
                              ),

                              // Corectare HitTestBehavior și UI pentru butonul de redare/pauză
                              GestureDetector(
                                onTap: _toggleAutoPlay,
                                behavior: HitTestBehavior.opaque, // Asigură preluarea click-urilor perfect
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _isAutoPlaying
                                        ? page.accentColor.withOpacity(0.12)
                                        : Colors.white.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: _isAutoPlaying
                                          ? page.accentColor.withOpacity(0.50)
                                          : Colors.white.withOpacity(0.20),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _isAutoPlaying
                                            ? Icons.pause_rounded // Schimbat iconița pentru a semnifica mai clar funcția de pauză
                                            : Icons.play_arrow_rounded,
                                        color: _isAutoPlaying
                                            ? page.accentColor
                                            : Colors.white.withOpacity(0.55),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _isAutoPlaying ? "Pauză" : "Redare", // Adăugat text pentru zonă de contact mai mare
                                        style: TextStyle(
                                          color: _isAutoPlaying
                                              ? page.accentColor
                                              : Colors.white.withOpacity(0.55),
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              _NavButton(
                                onTap: _pageIndex < _pages.length - 1 ? _goNext : null,
                                label: _pageIndex < _pages.length - 1
                                    ? '${_pages[_pageIndex + 1].range} ->'
                                    : 'Sfarsit ->',
                                color: page.accentColor,
                                alignRight: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Neon strip stanga (izolat de atingeri)
        Positioned(
          left: 0, top: 0, bottom: 0,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => IgnorePointer(
              child: Container(
                width: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      page.accentColor.withOpacity(0),
                      page.accentColor.withOpacity(
                          0.75 + 0.25 * math.sin(_ctrl.value * 2 * math.pi)),
                      const Color(0xFFFF6BFF).withOpacity(0.45),
                      page.accentColor.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// Restul componentelor au rămas intacte
class _ImageFrame extends StatelessWidget {
  final String? imagePath;
  final Color accentColor;
  final String label;
  const _ImageFrame({
    super.key,
    this.imagePath,
    required this.accentColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accentColor.withOpacity(0.30), width: 1.5),
          color: accentColor.withOpacity(0.03),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.08),
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              imagePath != null
                  ? Image.asset(
                imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _ImagePlaceholder(
                  accentColor: accentColor,
                  label: label,
                ),
              )
                  : _ImagePlaceholder(
                accentColor: accentColor,
                label: label,
              ),
              Positioned(
                left: 0, right: 0, bottom: 0,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color(0xFF020609).withOpacity(0.80),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16, bottom: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: accentColor.withOpacity(0.40)),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final Color accentColor;
  final String label;
  const _ImagePlaceholder({required this.accentColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: accentColor.withOpacity(0.04),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_outlined, color: accentColor.withOpacity(0.25), size: 52),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: accentColor.withOpacity(0.40),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'assets/images/',
              style: TextStyle(
                color: accentColor.withOpacity(0.22),
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── E TABLE WIDGET ────────────────────────────────────────────────────────────
class _ETable extends StatelessWidget {
  final _EPage page;
  const _ETable({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: page.accentColor.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: page.accentColor.withOpacity(0.22), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: page.accentColor.withOpacity(0.05),
            blurRadius: 24, spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              decoration: BoxDecoration(
                color: page.accentColor.withOpacity(0.10),
                border: Border(
                  bottom: BorderSide(color: page.accentColor.withOpacity(0.30)),
                ),
              ),
              child: Row(children: [
                _HeaderCell('Cod E', flex: 2, color: page.accentColor),
                _HeaderCell('Denumire chimica', flex: 3, color: page.accentColor),
                _HeaderCell('Alimente tipice', flex: 4, color: page.accentColor),
                _HeaderCell('Structura', flex: 2, color: page.accentColor, alignRight: true),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                itemCount: page.rows.length,
                itemBuilder: (context, i) {
                  final row = page.rows[i];
                  final isEven = i % 2 == 0;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isEven
                          ? Colors.transparent
                          : Colors.white.withOpacity(0.015),
                      border: Border(
                        bottom: BorderSide(
                          color: page.accentColor.withOpacity(0.08),
                        ),
                      ),
                    ),
                    constraints: const BoxConstraints(minHeight: 48),
                    child: Row(children: [
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: page.accentColor.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: page.accentColor.withOpacity(0.35)),
                            ),
                            child: Text(row.code, style: TextStyle(
                              color: page.accentColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: Text(row.name, style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        )),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 4,
                        child: Text(row.foods, style: TextStyle(
                          color: Colors.white.withOpacity(0.60),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        )),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            row.formula,
                            style: TextStyle(
                              color: page.accentColor.withOpacity(0.90),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── HEADER CELL ───────────────────────────────────────────────────────────────
class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  final Color color;
  final bool alignRight;
  const _HeaderCell(this.label,
      {required this.flex, required this.color, this.alignRight = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label.toUpperCase(),
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: TextStyle(
          color: color.withOpacity(0.70),
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

// ── NAV BUTTON ────────────────────────────────────────────────────────────────
class _NavButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String label;
  final Color color;
  final bool alignRight;
  const _NavButton({
    required this.onTap,
    required this.label,
    required this.color,
    this.alignRight = false,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.onTap != null;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: active ? (_) => setState(() => _pressed = true) : null,
      onTapUp: active ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: active ? () => setState(() => _pressed = false) : null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: _pressed
              ? widget.color.withOpacity(0.28)
              : active
              ? widget.color.withOpacity(0.10)
              : widget.color.withOpacity(0.03),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _pressed
                ? widget.color.withOpacity(0.90)
                : active
                ? widget.color.withOpacity(0.45)
                : widget.color.withOpacity(0.15),
            width: _pressed ? 1.5 : 1.0,
          ),
          boxShadow: _pressed
              ? [
            BoxShadow(
              color: widget.color.withOpacity(0.30),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ]
              : [],
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 100),
          style: TextStyle(
            color: _pressed
                ? widget.color
                : active
                ? widget.color.withOpacity(0.80)
                : widget.color.withOpacity(0.25),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

// ── DATA MODELS ───────────────────────────────────────────────────────────────
class _EPage {
  final String range;
  final String title;
  final Color accentColor;
  final IconData icon;
  final String description;
  final List<_ERow> rows;
  final String? imagePath;
  const _EPage({
    required this.range,
    required this.title,
    required this.accentColor,
    required this.icon,
    required this.description,
    required this.rows,
    this.imagePath,
  });
}

class _ERow {
  final String code;
  final String name;
  final String foods;
  final String formula;
  const _ERow(this.code, this.name, this.foods, this.formula);
}

// ── PARTICLE SYSTEM ───────────────────────────────────────────────────────────
class _Particle {
  final double x, y, speedX, speedY, amplitude, phase, radius, opacity, pulseSpeed;
  final bool useColor2;
  const _Particle({
    required this.x, required this.y,
    required this.speedX, required this.speedY,
    required this.amplitude, required this.phase,
    required this.radius, required this.opacity,
    required this.pulseSpeed, required this.useColor2,
  });
}

class _ParticlePainter04 extends CustomPainter {
  final double t;
  _ParticlePainter04(this.t);
  static const _c1 = Color(0xFF00F0FF);
  static const _c2 = Color(0xFFFF6BFF);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _S04State._particles) {
      final dx = p.x * size.width +
          math.sin(t * 2 * math.pi * p.speedX + p.phase) * p.amplitude * size.width;
      final dy = (p.y + t * p.speedY) % 1.0 * size.height;
      final col = p.useColor2 ? _c2 : _c1;
      final paint = Paint()
        ..color = col.withOpacity(p.opacity *
            (0.5 + 0.5 * math.sin(t * 2 * math.pi * p.pulseSpeed + p.phase)))
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dx, dy), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter04 old) => old.t != t;
}

class _DotGridPainter04 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00F0FF).withOpacity(0.038)
      ..style = PaintingStyle.fill;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter04 _) => false;
}