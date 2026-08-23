-- tm-data
-- Turkmen Poetry Dataset
-- MySQL 8+

SET NAMES utf8mb4;

SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS poets (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,

    PRIMARY KEY (id),
    UNIQUE KEY uq_poets_name (name)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS poems (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    poet_id BIGINT UNSIGNED NOT NULL,
    title VARCHAR(500) NOT NULL,
    text LONGTEXT NOT NULL,
    source VARCHAR(1000) NULL,

    PRIMARY KEY (id),

    KEY idx_poems_poet_id (poet_id),
    KEY idx_poems_title (title),

    CONSTRAINT fk_poems_poet
        FOREIGN KEY (poet_id)
        REFERENCES poets(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;

INSERT INTO poets (name)
VALUES ('Seydi')
ON DUPLICATE KEY UPDATE name = VALUES(name);

SET @poet_id = (
    SELECT id
    FROM poets
    WHERE name = 'Seydi'
    LIMIT 1
);


INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Seýdi',
    '«ÝEDIGEN» kitaphanajygy

  Seýdi

       «TURAN»
     Aşgabat, 1991
              Seýdi – Goşgular
Kitapça türkmen klassygy Seýitnazar Seýdiniň
              goşgulary girizildi.
 «Ýedigen» kitaphanajygy – Aşgabat, «Turan»
               neşirýaty, 1991.

                     —
TSSR-iň halk ýazyjysy Gurbandurdy Gurbansä-
hedowyň redaksiýasy bilen.
Redaktor-düzüji: Tejen Nepesow.
Neşir üçin jogapkärler: Kömek Kulyýew, Anna
Sous.
Suratçylar: Sülgün, Myrat, Annaguly Hojaguly-
ýewler.
                     —
Bu kitapdaky maglumat "bolşy ýaly" esaslarda,
kepilliksiz getirilýär. Bu iş taýýarlananda ähli
seresaplyk çäreleri görlen hem bolsa, ne aw-
tor(lar), ne «» sahypasy bu işdäki
informasiýa sebäpli çekilen göni ýa gytaklaýyn
ýitgi ýa zelel üçin hiç bir adamyň ýa guramanyň
öňünde jogapkärçilik çekmeýär.

                     —
PDF-a geçirildi: 22. Aprel 2013
«» sahypasynyň kitaphanasy.
              MAZMUNY

Seýdi . . . . . . . . . . . . . . . . . . . .     iii
Timar, Hatyja . . . . . . . . . . . . . . .        1
Gel, Arzygül, görüşeli! . . . . . . . . . .        2
Jigi-jigi . . . . . . . . . . . . . . . . . . .    4
Owadan . . . . . . . . . . . . . . . . . . .       6
Bir gelin . . . . . . . . . . . . . . . . . .      7
Saňa näm boldy . . . . . . . . . . . . . .         8
Ärsarynyň ýigitleri . . . . . . . . . . . .        9
Bedewsuwar indi . . . . . . . . . . . . .         11
Aýryldyk . . . . . . . . . . . . . . . . . .      13
Pisada döndi . . . . . . . . . . . . . . . .      15
Seni ynjytmaýa . . . . . . . . . . . . . .        17
Harap eder . . . . . . . . . . . . . . . .        19
Soltan, Hatyja . . . . . . . . . . . . . . .      20
Beter, Hatyja . . . . . . . . . . . . . . .       22
Ahy-zar olar . . . . . . . . . . . . . . . .      24
Ýaňaklaryň alyna . . . . . . . . . . . . .        26
Çagdyr bu çaglar . . . . . . . . . . . . .        28
Dönmenem, begler . . . . . . . . . . . .          30
Boldugy bardyr . . . . . . . . . . . . . .        32
Görülsin indi . . . . . . . . . . . . . . . .     34
Baraýlyň . . . . . . . . . . . . . . . . . .      36
Döwrany bardyr . . . . . . . . . . . . . .        38

                       ii           
Mübärek olsun . . . . . . . . . . . . . .        41
Sagat gütse gerekdir . . . . . . . . . . .       43
Çykyp gideliň . . . . . . . . . . . . . . .      46
Lebap, hoş indi . . . . . . . . . . . . . .      47
Galdyň, hoş indi . . . . . . . . . . . . .       49
Gal indi . . . . . . . . . . . . . . . . . . .   51

                      iii          
                   SEÝDI

                 (1775 – 1836)

    Seýdi Lebap boýunda, Garabekewüliň Lam-
ma obasynda dogulýar. Ol Lebap we Buhara
medreselerini geçýär. Gündogar taryhyny we
edebiýatyny çuň bilýär. Onda folklor we milli
poeziýa birikýär. Şol wagtda Buhara merkezi
bolan "Diwan" poeziýasyny çuň özleşdirýär. No-
waýy (Hyrat) we Fuzuly (Kerkuk) mekdebi oňa
ýat däl. Hatyja – yşky poeziýany, Buhara aga-
lygyna garşy göreşler söweşjeňlik poeziýasyny
oýarýar. Syýasatda milli-azatlyk aýdymçysy. Te-
bigaty serkerde bu şahyr käte Soltannyýaz begiň
täsirinde bolýar. Poeziýa onuň söweş gimnleridir,
ýöriş surnaýydyr. Buharanyň hüjümleri Seýdi-
ni gözel Lebapdan aýryp, Mara tarap kowýar.
Ol Mary-Hywa gepleşiklerinde uly figura. Mary
we Maşat gatnaşyklarynda-da Seýdi görünýär.
Onun poeziýasy, bir taýdan, çakylyk, beýleki taý-
dan, taryhy günleriň ýylýazgysyna çalym edýär.
Real söweşjeňlik ruh we anyk taryhy material
bu poeziýada has aktiw. Seýdiniň "Diwanynyň"
bir göçürme nusgasy mälim.

                       iv          
   Seýdi – bu söweşjeňligiň simwoly.
   Seýdiniň golunda galam we gylyç deň oýna-
ýar.

                              Tejen Nepesow

                     v         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Timar, Hatyja',
    'Gözi gara, gaşy gara,
Zülpleri timar, Hatyja!
Ýüregime saldyň ýara,
Eýlediň bimar, Hatyja!

Gözüňe sürme ýaraşar,
Biliňe tirme ýaraşar,
Saçyňa örme ýaraşar,
Saçlary şamar Hatyja.

Bagyňda toty-gumrular,
Yzyňda jahyl-jümrüler,
Göwsüňde goşa ýumrular
Almamydyr nar, Hatyja?

Seýdi diýer, bu şertlere,
Başladyň köne ýurtlara,
Meni tükenmez dertlere
Eýlediň duçar, Hatyja!

            1             ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Gel, Arzygül, görüşeli!',
    'Gurbanyň bolaýyn, gaçma,
   Gel, Arzygül, görüşeli!
   Uýalsaň, ýüzüňni açma,
   Gel, Arzygül, görüşeli!

   Meniň bozuk köňlüm dyndyr
   Rakyplar boýnuny syndyr,
   «Bu» diýp durmak ýaman kyndyr,
   Gel, Arzygül, görüşeli!

   Men aşygam, gözüm ýaşly,
   Synam dagly, bagrym daşly
   Gara gözli, galam gaşly,
   Gel, Arzygül, görüşeli!

   Hijr oduna ýana-ýana,
   Tapmadym derdime çäre,
   Rähmiň gelsin hassa jana,
   Gel, Arzygül, görüşeli!

   Bigana tutma özüňni,
   Bizden aýyrma gözüňni,
   Kän aňry sowma ýüzüňni,
   Gel, Arzygül, görüşeli!

               2          
Arzym eşit, gözel şahym,
Ot saçar älemge ahym,
Geçirgil, bolsa günähim,
Gel, Arzygül, görüşeli!

Arzygül çykar üçege,
Ýalkymy düşer köçäge,
Ada bilen düş aşaga,
Gel, Arzygül, görüşeli!

Aşyk Seýdi diýer, öldüm,
Gam bile saraldym, soldum,
Senden mähr isteýip geldim,
Gel, Arzygül, görüşeli!

             3            ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Jigi-jigi',
    'Ýar, meniň golumy tutup,
Ýanyňa al, jigi-jigi!
Ýa sen güle-güle ötüp,
Bu ýana gel, jigi-jigi!

Seniň raýyňa garaýyn,
«Gel» diýseň, ötüp baraýyn,
Herne işiňe ýaraýyn,
Goýsa ajal, jigi-jigi!

Rehm edip, bakgyl gözüme,
Bir gülüp bakgyl ýüzüme,
Şu sapar herne sözüme
Etme bedel, jigi-jigi!

Waspyňy ýagşy ýazaýyn,
Her ýerde aýdyp gezeýin,
Yşkyňda daglar gazaýyn,
Bolmasam şel, jigi-jisi!

Ýaryňdyr adamyň pujy,
Ýetişmez bizlere güýji,
Talh agzymy eýle süýji,
Lebleri bal, jigi-jigi!

            4             
Hasyl etseň myradymy,
Bereýin hemme zadymy,
Indi syndyrma badymy,
Ýanyma gel, jigi-jigi.

Gözüň süzüp, gaşyň kakyp,
Meni sen öldürdiň ýakyp,
Durma beýle aşak bakyp,
Ýokary gal, jigi-jigi.

Meni bir şat etgin indi,
Myradyma ýetgin indi,
Ýa bu ýerden gitgin indi,
Etme haýal, jigi-jigi.

Eýlegil derdime derman,
Galmasyn köňlümde arman,
Men bolaýyn saňa gurban,
Ýüzleri hal, jigi-jigi.

Bir ýigidiň bagty çapar,
Bar kişiden myrat tapar,
Seýidini sen bir sapar
Goýnuňa sal, jigi-jigi.

            5          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Owadan',
    'Eý agalar, ol obada
Bir gelin gördüm owadan.
Dilber meniň aklym aldy,
Näzenin gördüm owadan.

Sallanyp öýden çykyşy,
Gözün gypyp, gaş kakyşy,
Ak ýüze zülpün döküşi,
Näzenin gördüm owadan.

Barar idim men ýol bilen,
Sowuldym bir hyýal bilen,
Duşup Dursunjemal bilen,
Näzenin gördüm owadan.

Seýdi diýer, arman-arman,
Arman, galdym bir ýalbarman,
Tapylmaz derdime derman,
Älhepus, gördüm owadan.

            6          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Bir gelin',
    'Eý agalar, ol obada
Bize kän güldi bir gelin.
Ala ýaglyk, akja pada,
Bize kän güldi bir gelin.

Işigine bardym sorup,
Nije habar berdim durup,
Belki, bizden ýaman görüp,
Bize kän güldi bir gelin.

Gül açylar çygy bilen,
Dildi bagrym tygy bilen,
Çep gözüniň gyýgy bilen
Bize kän güldi bir gelin.

Ýar ýolunda çekdim arman,
Ötdi ömrüm bir ýalbarman,
Sorasam, bir jogap bermän,
Bize kän güldi bir gelin.

Seýdi diýer, saldyň nazar,
Yşk ýolunda çekdim azar,
Gözi Meňlihana meňzär,
Bize kän güldi bir gelin.

             7              ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Saňa näm boldy',
    'Ala gözli ablaksaýat,
Saňa näm boldy, näm boldy?
Şähdi-şeker dilleriňden
Sözle, näm boldy, näm boldy?

Talandy, göwnüm talandy,
Bakyşyň janym alandy,
Ak göwsüň bäri dolandy,
Saňa näm boldy, näm boldy?

Sen otyrsyň serhoş eýläp,
Göreniň bagryn daş eýläp,
Gel, ikimiz meý noş eýläp, —
Saňa näm boldy, näm boldy?

Seýdi diýer, gülüp bakyp,
Al ýaňakdan zülpüň döküp,
Assa ýöräp, aýak çekip,
Saňa näm boldy, näm boldy?

             8          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ärsarynyň ýigitleri',
    'Her ýerde çoh abraý tapar
 Ärsarynyň ýigitleri.
 Ganym görse, dogry deper
 Ärsarynyň ýigitleri.

 Hiç zada salmaz nazarlar,
 Daýyma mestan gezerler,
 Hem okyrlar hem ýazarlar
 Ärsarynyň ýigitleri.

 Orta ýerde top dikerler,
 Iki ýanda sap çekerler,
 Watan üçin gan dökerler
 Ärsarynyň ýigitleri.

 Özi Hatam çöreklidir,
 Hemme arslan ýüreklidir,
 Seýilhanda gereklidir
 Ärsarynyň ýigitleri.

 Iki ýana elleşerler,
 Alar awyn belleşerler,
 Oljany hup telleşerler
 Ärsarynyň ýigitleri.

             9            
Seýdi diýer, bu jahanda
Ölse, arman ýokdur onda,
Mugtaberdir seýilhanda
Ärsarynyň ýigitleri.

          10         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Bedewsuwar indi',
    'Ýörsün gyzylbaş üstüne
Niçe bedewsuwar indi.
Läş dökülsin läş üstüne,
Alynsyn hemme ar indi.

Baryp ülkesin çapaly,
Üýnüne suwlar sepeli,
Ar alyp, abraý tapaly,
Ýar olsa biribar indi.

Sapar esbaby şaýlansyn
Hem ýagşy-ýaman saýlansyn,
Bir mert daşyndan aýlansyn,
Namartdan set bizar indi.

Uýat gelse ýüzümize,
Duraly şul sözümize,
Köp mahaldyr gözümize
Bolmuş giň jahan dar indi.

Gorkup ekiz, üçem guzlap,
Galmaň öýde ýalan sözläp,
Ýesirleriň bärsin gözläp,
Bolandyr intizar indi.

           11            
Barsak bu gün käni bilen,
Ýesir çykar sany bilen,
Duşmanlaryň gany bilen
Ýer bolsun lälezar indi.

Sapar ýazda ýagşy işdir,
Gyş gününde köp teşwişdir,
Öňümiz gazaply gyşdyr,
Buz doňup, ýagar gar indi.

Bedewlere nagyl kakyň,
Naýzaga al ýalaw dakyň,
Her at arryk bolsa bakyň,
Tapylynça serdar indi.

Il üçin çekseňiz jepa,
Möwlam size eder wepa,
Hoş görüp, gözel Mustapa,
Söýünir çaryýar indi.

Seýidi aýdar, beg aga,
Wagda ediň atlanmaga,
Habar gönderiň Morjaga,
Dursun bolup taýýar indi.

           12         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Aýryldyk',
    'Eý agalar, arman bilen
Dürli döwrandan aýryldyk.
Il bolup Rahym han bilen,
Haýdar soltandan aýryldyk.

Bedew münüp, begres geýen,
Ne näzi-nygmatlar iýen,
Köp eşretli Lebap diýen
Bir gadyrdandan aýryldyk.

Girdik bir çöli-mugana,
Suw içmedik gana-gana,
Uçradyk azaby-käne,
Rahaty-jandan aýryldyk.

Ärsarynyň ady ýitdi,
Her haýsy bir ýana gitdi,
Han «hezretiň» köňli bitdi,
Biz weli sandan aýryldyk.

Subhy-şam bilen ýörüşen,
Haýry-şeri deň görüşen,
Zowky-sapalar sürüşen
Ýary-ýarandan aýryldyk.

            13          
Daglarda dikilmiş eren,
Gyrylmyşdyr sansyz jeren,
Ürgenç, Lebaba suw beren
Bahry-ummandan aýryldyk.

Kürsüsi niçe paýaly,
Begler galdy köp daýaly,
Ser howuzly, hoş saýaly
Köşki-eýwandan aýryldyk.

Niçe yşwaly, şiweli
Gaçdyk, tapmady hywaly,
Dürli şejerli, miweli
Bagy-bossandan aýryldyk.

Tapmaýan öňki eşreti,
Ýuwtarmyz gamy, hesreti,
«Isteý-isteý» han «hezreti»,
Ahyr mekandan aýryldyk.

Seýdi diýer, haýp Lebap!
Galdy ilsiz-günsüz garap,
Berhem bolup mülki-esbap,
Bar hanymandan aýryldyk.

             14          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Pisada döndi',
    'Bu ýyl bir ýaman ýyl bolup,
Haýr işler pisada döndi.
Ähli-diller bidil bolup,
Şatlygy naşada döndi.

Zebun geçdi niçe aýlar,
Örtendi pakyrlar, baýlar,
Ne ajaýyp abat jaýlar
Ýykyldy, bibada döndi.

Garny doýman aşdan-nandan,
Halaýyklar geçip jandan,
Begzadalar çykyp sandan,
Maslahat betzada döndi.

Süýthor baýlar wagtyn tapyp,
Gezer pakyrlary çapyp,
Jomartlar suprasyn ýapyp,
Satygçy hannada döndi.

Göterlip mähri-şepagat,
Gidipdir sabry-kanagat,
Köňli ýumşak, ähli-tagat
Binurbat jellada döndi.

            15          
Mally gurradyr malyna,
It aglar garyp halyna,
Şum hannadyň ykbalyna
Gamly güni şada döndi.

Ogul ata hyzmat kylmaz,
Ata hem ogluny bilmez,
Dogan dogana göz ilmez,
Her haýsy bir ýada döndi.

Bu gymmatlyk boldy uzak,
Tozdy garagalpak, gazak,
Bir nan üçin gurup duzak,
Il bary saýýada döndi.

Bereket gidip bar zatdan,
Ynsap gidipdir hannatdan,
Şalar düşüp adalatdan,
Işleri bibada döndi.

Köp mahallar gussa ýutup,
Bu günler hem gider ötüp,
Gudrat bilen derýa tutup,
Misli bir polada döndi.

Il gelsin diýp ystygfara,
Seýdi sözleýir bir para,
Her kim sygynsa gaffara,
Müşgüli güşada döndi.

            16          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Seni ynjytmaýa',
    'Barsaň bir merdiň ýanyna,
Hergiz seni ynjytmaýa.
Jan goşsaň namart janyna,
Walla, ol hiç ýer tutmaýa.

Her wagtda bir duş geler,
Ýaz ötüp, ýene gyş geler,
Mert elinden çoh iş geler,
Namartdan bir iş bitmeýe.

Panydyr bu dünýä, pany,
Ýokdur hiç kime paýany,
Bedasylyň bir nyşany —
Ýüz görüp, köňül güýtmeýe.

Adam ogly bolsa ysyň,
Barma ýanyna näkesiň.
Bir akylsyz muhannesiň
Hergiz minneti gitmeýe.

Bilgil ömür bibakaňy,
Çirk eýleme hoşlakaňy,
Ajal ger tutsa ýakaňy,
Dadyňa hiç kim ýetmeýe.

            17            
Ähli merde derdiň söýle,
Derman andan, umyt eýle,
Beýhuda ýörmegil beýle,
Zyýandyr, peýda etmeýe.

Gül açylar bahar pasly,
Aşyga hoşdur ýar wasly,
Çyn juwanmertligiň asly —
Etdijek lebzin ýutmaýa.

Zerre kim bolsa bagtyndan,
Çoh şalar düşer tagtyndan,
Kaza ýetişen wagtyndan
Bir nepes aňry ötmeýe.

Seýdi, söýle rastyňy,
Hoş gör möwlamyň hastyny,
Bakgyl aýagyň astyny,
Gidejek ýoluň ýitmeýe.

           18         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Harap eder',
    'Çaparman algyr ýigidi
Ahyr galla harap eder.
Çyra ýanmaz gök ýüzünde,
Degse, gülle harap eder.

Baryşsaň mert bile baryş,
Namartlardan bitmez her iş,
Neri ýörüş, aty ýaryş, —
Uzak pelle harap eder.

Almak üçin il gezer pir,
Ýyl-ýyldan nebsi güýç getir,
Her ýetenler: «Sopy men» diýr,
Gury selle harap eder.

Tebibiň bolmasa duçar,
Niçik şypa tapar bimar,
Hassa galyp biygtyýar —
Awy berip, harap eder.

Ýagşynyň bolmaz hormaty,
Ýamanyň argar kuwwaty,
Seýdi diýer, şerigaty
Niçe molla harap eder.

            19         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Soltan, Hatyja',
    'Goýmaz rakyp görnüşiňe gelmäge,
Gözeller içinde soltan, Hatyja!
Bir gün gülli desmal içinde gözgi
Eýlär men sen tarap rowan, Hatyja!

Gizli derdim saňa eýlesem haly,
Bilenler aşyk diýr, bilmedik—däli,
Gözgüýe bak, göter gülli desmaly,
Bolsun biz garypdan nyşan, Hatyja!

Derdim köpdür, maňa tebip duş gelmez,
Köňlüm gamgyn, dünýe sözi hoş gelmez,
Hijran oky dogry geler, duş gelmez,
Sanjylar bagryma peýkam, Hatyja!

Pelek meni derde ulaşdyrypdyr.
Alypdyr aklymy, üleşdiripdir,
Basyp gam laýyna bulaşdyrypdyr,
Men bilmeýän sudu-zyýan, Hatyja!

Ah ursam, agzymdan çykan ot boldy,
Dost ýüzün dönderip, bizden ýat boldy,
Ähli duşman el çarpyşyp, şat boldy,
Maňa ýagy boldy jahan, Hatyja!

                 20          
Seniň dek näzenin jahana gelmez,
Görsem, gözüm doýmaz, köňlüm aýrylmaz,
Ýanaşanda, seniň bilen deň bolmaz
Segsen gyz, segsen müň juwan, Hatyja!

Bu niçik syr boldy, bilebilmedim,
Ölüm pikrin tutdum, ölebilmedim,
Haýp, jepa çekdim, alabilmedim,
Köp galdy janymda arman, Hatyja!

Seýdi diýer, tirsem gunça gülüň men,
Emip sorsam lebleriňden balyň men.
Hyzmatyňda goly bagly guluň men,
Bolaýyn başyňa gurban, Hatyja!

                 21         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Beter, Hatyja',
    'Arzymy eşitgil, eý, söwer ýarym:
Günbe-günden derdim beter, Hatyja!
Yşkyňda galmady namysym, arym,
Munça jebr eýlediň, ýeter, Hatyja!

Men seniň yşkyňdan gelip men dada,
Gel, jebr etme indi mundan zyýada,
Gözleriň ogşaýdyr mysal jellada,
Müjgän tygyň jandan öter, Hatyja!

Takat ýok, görmesem gara gözüňi,
Dünýä hyrajyna bermen özüňi,
Perde tartyp dolamagyn ýüzüňi,
Gel, indi nykabyň göter, Hatyja!

Arzy-halym aýtdym, dessan baglaýyp,
Şat bolmadym, senden köňül çaglaýyp,
Gije-gündiz pyrakyňda aglaýyp,
Bir gün ahym seni tutar, Hatyja!

Günbe-günden artdy ahy-efganym,
Eşitgil arzymy, näzli soltanym,
Simap dek bikarar tende bu janym,
Gaýgyly hesretden gutar, Hatyja!

                22         
Bu dünýä gelenler gonup-geçendir.
Niçe aşyk arzuw bile geçendir,
Ölüm şerbetinden barça içendir,
Haçan waslyň bize ýeter, Hatyja!

Seýdi diýer, bal-şekerdir dilleriň,
Guçmana ýaraşar näzik billeriň,
Wagty ýetse, solar täze gülleriň,
Biraz soňra wagty öter, Hatyja!

                  23          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ahy-zar olar',
    'Garasaç jan, seni gören kişiniň
Gije-gündiz işi ahy-zar olar.
Höziri bolmaýyn ýazu-gyşynyň,
Hesretiňde ýörüp, ömri har olar.

Meni sen öldürdiň gara göz bile,
Bagrymy eretdiň şirin söz bile,
Husn içinde elli bile, ýüz bile
Bäs eýleseň, hemme şermysar olar.

Sen bezenip, haçan çyksaň daşary,
Turuzar sen halka ruzy-magşary,
Möwlamyň ýaradan peri-beşeri,
Hemme gelip, saňa hyzmatkär olar.

Heýkel-tumaryňy boýnuňa asyp,
Ýol ýörseň, näz bile aýagyň basyp,
Zülpüň çil-çil bolup, her ýandan ösüp,
Iki al ýaňakda müşkibar olar.

Ýüz juwan-kenizdir, elli gyz—nöker,
Her gören-görmedik arzuwyň çeker,
Zenahdanyň—alma, lebleriň—şeker,
Her kim ondan datsa, ygtybar olar...

                 24          
Her ýüzüň görende, köňül açylar,
Gep ursaň, agzyňdan dürler saçylar,
Inçe bilden, ýa reb, haçan guçular?
Anyň üçin köňül bikarar olar.

Hüýru-gulman gelse ýanyňa seniň,
Sençe bolmaz husny-jemaly anyň,
Ak gujagyň bile ol näzik teniň,
Kişi bilmez, kime sezewar olar.

Aý ýüzi–ýasemen, dahany–gunça,
Äleme ot salyp, köýdürme munça!
Ilde bir näzenin tapylmaz sençe,
Barça älem saňa intizar olar.

Gaşlaryň kemandyr, kirpigiň okdur,
Ýalançyda sen dek näzli gyz ýokdur,
Aşyk Seýdi diýer, bu sözüm hakdyr,
Aşyklara ýalan diýmek ar olar.

                25          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ýaňaklaryň alyna',
    'Söwdügim, gül özün para eýlemiş,
Reşk ediban ýaňaklaryň alyna.
Akmaga gül özün para eýlemiş,
Ynanyp, dünýäniň mekru-alyna.

Şirin lebiň meňzär asala, ganda,
Men senden aýrylyp, gideýin kanda?
Yşkyňda gark olmuş jigerim ganda,
Ynanmasaň, bakgyl eşkim alyna.

Ýar ýaryny, ýarym, söýen ýaraşyr,
Gel birzaman bize söýen ýaraşyr,
Diýseň: «Nesimi dek soýan ýaraşyr»,
Herne kylsaň, ygtyýaryň alyna.

Gözleýeňde iki çeşmi-göz bilen,
Rakyp ölsün hesret bilen, köz bilen.
Dilber, meni ýene böhtan söz bilen,
Salmaýa sen bir zalymyň alyna.

Çeşmimden akyzyp, ganly ýaşymy,
Ýoluňda sarp etdim herne ýaşymy,
Uly aňlar, hergiz bilmez işimi,
Dilber, senden niçik köňül alyna?

                 26          
Aşykdyr sen inçge bile, Seýidi,
Her jepany rahat bile Seýidi,
Ýörmüş diýip ýaman bile Seýidi,
Meni aýp edeniň gelsin alyna.

                27         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Çagdyr bu çaglar',
    'Ölçerme odumy, gozgama derdim,
Dert başymdan aşan çagdyr bu çaglar.
Nadanmyşam, bir biwepa dil berdim,
Ýardan köňlüm sowşan çagdyr bu çaglar.

Şunça jepa çekdim, bolmady paýym,
Bu nalyşym eşitmedi hudaýym,
Gökdäki röwşenim — ýyldyzym, aýym
Halka urup ýaşan çagdyr bu çaglar.

Gahba pelek otyr çarhyn ters towlap,
Dost köňlün galdyryp, duşmanyň awlap,
Etim çişe düzüp, süýegim çowlap,
Süýeklerim bişen çagdyr bu çaglar.

Men dönsem-de köňlüm ýardan dönen ýok,
Ýar zalymdyr, maňa rehmi inen ýok,
Meniň bu halyma bile ýanan ýok,
Synama ot düşen çagdyr bu çaglar.

Siz mert biliň yşk azabyn çekeni,
Azap çekip, elin ýuwup çykany,
Yşkyň söwdasynda gamyň tikeni
Sanjyp, bagrym deşen çagdyr bu çaglar.

                 28         
Dosta derdim aýan etdim söz bilen,
Arz etmişem elli merte ýüz bilen,
Jowap berer göze, ýakyp köz bilen,
Hal hetdinden aşan çagdyr bu çaglar.

Seýdi diýr, baş alyp gidewer bir ýan,
Uçarga — ganat ýok, ýörerge — perman,
Aýdawer, janynda galmasyn arman,
Däli köňlüm joşan çagdyr bu çaglar.

                 29          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Dönmenem, begler',
    'Watan üçin çykdym gyr at üstüne,
Tä janym çykynça, dönmenem, begler!
Dikdir serim, düşmen duşman astyna,
Sil deý aksa, gandan ganmanam, begler!

Ilim üçin şirin jandan geçer men,
Düldül münüp, ganat baglap uçar men,
Namart dälem, hakdan kasam içer men,
Ýanyp duran nar men, sönmenem, begler!

Ýesir galmaz, oglan-uşak aglaýyp,
Oda düşmez, aşyk ýürek daglaýyp,
Men hem şu gün Murtezadan çaglaýyp,
Kasam kyldym, ondan dönmenem, begler!

Tomaşa eýläňler kylan urşuma,
Ýüz müň leşger çyka bilmez garşyma,
Är ýigit men, mertlik bilen durşuma,
Oda urarlar, men hem ýanmanam, begler!

«Är men» diýen çyksyn bile ýörmäge,
Leşger tartyp, Mirhaýdary urmaga,
Il-gün üçin şirin janym bermäge
Urdum başym, şertden synmanam, begler!

                 30         
Hak ezelden saldy meni bu ýola,
Jan bermeýen, diri düşmenem gola,
Tomaşa kylyňlar bulanan sile,
Niçe gan ýuwutdym, ganmanam, begler!

Ärden öndüm, ärlik bilen öler men,
Kim dostum, duşmanym—parhyn biler men,
Söweşde aglaman, şat men, güler men,
Namart bolup, dünýä inmenem, begler!

Ýat kylar men Göroglyny, Zamany,
Aly Murtezany — Şahymerdany,
Rustem, Zal, Isgender, Gajar pälwany,
Orta atdym, köpün sanmanam, begler!

Seýdi çykdy atyn, ýaragyn besläp,
Gan gördi gözlerim, ýürek höwesläp,
Gaçmanam, öler men, köp leşger isläp,
Söweş üçin çykdym, dönmenem, begler!

                  31         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Boldugy bardyr',
    'Biziň ärsarynyň goç ýigitlerniň
Her zaman başy jem boldugy bardyr;
Mejlis içre gülgün şeraplar içip,
Şady-horram oýnap güldügi bardyr.

Türpe edeplidir otursa-tursa,
Bary gulak goýar, biri gep ursa,
Her ýerde özünden ulyny görse,
Onuň gadryn ýagşy bildigi bardyr.

Ýagşysy, ýamany aýly-saýlydyr,
Ata çyksa, ýaraglydyr, şaýlydyr,
Guýma sagdyk, ispyhany ýaýlydyr,
Görenler haýrana galdygy bardyr.

Goçaklar döwtalap dursa meýdanda,
Gaýry muhannesler hiç bolmaz sanda,
At ýykylyp, ýoldaş galsa meýdanda,
Dönüp-dönüp naýza saldygy bardyr.

Algyr guş dek sagy-soluna bakyp,
Günde at oýnadyp, meýdana çykyp.
Kanda ganym görse, atyndan ýykyp,
Golun baglap, alyp geldigi bardyr.

                32         
Seýilhan ulusy Ärsary baba,
Her kim deger bolsa, galar gazaba,
Hyzmatynda galandyr çoh sogaba,
Ajyzyna nazar saldygy bardyr.

Kirewke egninde, tuwulga serde,
Isteseň tapylar, her şury-şerde,
Külli türkmen, özbek ýygylan ýerde
Owal başda abraý aldygy bardyr.

Gündizine awlar sonany, gazy,
Gijesine gurar söhbeti-sazy,
Seýidi dek şahyrlaryň owazy
Bu ýalan jahana doldugy bardyr.

                33          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Görülsin indi',
    'Gorky ede-ede ryswamyz çykdy,
Her ne nesip bolsa, görülsin indi!
Zalym duşman ahyr ýurdumyz ýykdy,
Köp ýatdyk, ýaranlar, turulsyn indi!

Möwlam bermiş bize niçe galany,—
Kytnamy, Perwerdi, Halaç, Çylany,
Başdan-aýak ýygyp hurdu-kelany,
Zalym beg üstüne ýörülsin indi!

Gaýrat edip, şirin jandan geçeli,
Gylyçdan gyrmyzy ganlar seçeli,
Duşman bilen aramyzy açaly,
Hemme şol ykrara gurulsyn indi!

Bir ýerde top bile baýdak dikilsin,
Goşun iki ýandan sap-sap çekilsin,
Kelleler kesilsin, ganlar dökülsin,
Arada gurt oýny gurulsyn indi!

Eger her kim gorky etse janyndan,
Aýrylmasyn aýalynyň ýanyndan,
Il gaçsa, aýrylar hanymanyndan,
Dogry durup, gylyç urulsyn indi!

                 34          
Agzymyz bir etsek tükel ärsary,
Duşman geçebilmez serhetden bäri.
Her ýigidiň söweş bolsa hünäri,
Öňümize salyp, sürüsin indi!

Ýagy bolsa salyr, sarygu-teke,
Biz munda il bolmak ogşamaz ýeke,
Beýle oturynça pul çeke-çeke,
Bir gylyja dähmiz berilsin indi!

Seýdi diýr, gaýnap, daşyp, joş edip,
Bir bäş gün gezeli köňül hoş edip,
Çärjew begin ýeňsek, urup, uşadyp,
Zalym ähli tükel gyrylsyn indi!

                 35          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Baraýlyň',
    'Duşman geldi Lebap boýun ot eýläp,
Turuň, begler, ol döwüşe baraýlyň!
Şahymerdan Murtezany ýat eýläp,
Boluň, begler, şol soweşe baraýlyň!

Är ýigitler gazat güni çykanda,
Düldül böküp, asman saýy bakanda,
Çaýlar dolup, gyrmyzy gan akanda.
Är deý durup, şol söweşe baraýlyň!

Görogludan şu gün alyp tilsimi,
Kurhan açyp, gel, içeýliň kasamy,
Şu gün bolsun Isgenderiň kysymy,
Är deý durup, şol söweşe baraýlyň!

At, ýaragyň şaý edilsin ýol üçin,
Bagda bilbil, degresinde gül üçin,
Watan üçiň, abraý üçin, il üçin
Är deý durup, şol söweşe baraýlyň!

Şahymerdan gelip, goldar bizleri,
Kyrk erenler ýola saldy sizleri,
Gana boýap üsti-başy, gözleri,
Är deý durup, şol söweşe baraýlyň!

                  36         
Nesip budur: tiz jan almak borjuňdyr,
Biler bolsaň, magşar güni harjyňdyr,
Türkmen ýigit, Mirhaýdarda hyrçyňdyr,
Är deý durup, şol söweşe baraýlyň!

Seýdi aýdar geçsem şu gün janymdan,
Lebap daşyn boýap gyzyl ganymdan,
Namart ýigit gitsin meniň ýanymdan,
Är deý durup, şol söweşe baraýlyň!

                 37        ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Döwrany bardyr',
    'Işabaşy ogly Soltannyýaz begiň
Bu dünýäde dürli döwrany bardyr.
Bedew münüp ýagşy ýigitler bilen,
Günde çoh sapaly seýrany bardyr.

Hemişe ýörüşi hüňker tutumly,
Sözlese, her kime sözi ötümli,
Subhy-şam jöwlany bolan ýetimli,
Hak bereket beren aş-nany bardyr.

Çyn begdir, hiç zatdan ýokdur perwaýy,
Her gelene berer dürli serpaýy,
Palaw iýip, içmäge gaýmakly çaýy,
Käseýi-çynydan çendany bardyr.

Owazasy düşüp ýakyn, yraga,
Belki, ýetişendir Ruma, Yraga,
Aman bolsa hemme beglere aga,
Bolmagyna niçe nyşany bardyr.

Il içinde hökmi bolsa hem jary,
Hiç bir musulmana ýokdur azary,
Her remezan aýy geltirip kary,
Sowap üçin hatmy-kurhany bardyr.

                38         
«Sahawatda Hatam Taýdan zyýada»
Diýen adam hergiz galmaz uýada,
Hyzmatyna her kim gelse pyýada,
At münüp, don geýip gitdigi bardyr.

Akyldan esräkdir onuň bar işi,
Mert ogludyr, merdanadyr ýörüşi,
Hoş görer mollany, hoja-derwüşi,
Olara köp haýyr-yhsany bardyr.

Tebgy belent, özi akylly, huşly,
Ýany mirşikärli, gollary guşly,
Ajap parasatly, merdana işli,
Haýsy mülküň beýle soltany bardyr.

Söweş güni keserlidir gylyjy,
Bardyr özi söweş ylmyn biliji,
Daýym yzy üzülmeýen geliji,
Her gün çar tarapdan myhmany bardyr.

Şaýdyr at-ýaragy, tükel esbaby,
Geýer daýym atlaz bile zerbaby,
Munça begi istäp Buhar, Lebaby,
Gezip tapmaklygyň emkany bardyr.

Atlansa, din yslam gylyjyn çalsa,
Ýaraşur küffardan baş puly alsa,
Otursa, öňüne arzaçy gelse,
Adalaty, dogry diwany bardyr.

                39          
Hiç kime ogşamaz syny-summaty,
Özge begzadadan köpdür hümmeti,
Ýalan diýse, bir Muhammet ymmaty,
Elbetde, dinine nuksany bardyr.

Il ýygylyp, günde berer salamy,
Hyzmatyn ederler manend gulamy,
Seýidi gul aýdar, halys kelamy
Sözlesem, tükenmez destany bardyr.

               40         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Mübärek olsun',
    'Eý, garawul begi, Lebapdan gaçyp,
Bu gelen ýurduňyz mübärek olsun!
Mirhaýdaryň külli baryndan geçip,
Bu gelen ýurduňyz mübärek olsun!

Harazminde sürüp dürli «eşreti»,
Görüp geldiňizmi, ol han «hezreti?»
Imdi hiç görmeýen gamy-hesreti,
Bu gelen ýurduňyz mübärek olsun!

... eýleban uzak endişe,
El urupsiz bu gün köp ýagşy işe,
Ylahym abraýly bolup hemişe,
Bu gelen ýurduňyz mübärek olsun!

Bendi baglasaňyz, jepalar çekip,
Köp hasyl alar siz ekinler ekip,
Oturmaga hatar boz öýler dikip,
Bu gelen ýurduňyz mübärek olsun!

Eşitmişem köp agyzdan, köp dilden,
Özün ötgeripdir diýrler bar ilden,
Hak berse, kän ekip akdan-gyzyldan,
Bu gelen ýurduňyz mübärek olsun!

                 41         
Biz hem geldik şu gün sizi görmäge,
Nesip etse, dürli döwran sürmäge,
Seýdi diýer, saglyk bilen ýörmäge,
Bu gelen ýurduňyz mübärek olsun!

                42          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Sagat gütse gerekdir',
    'Soltannyýaz begniň toýuna indi
Müneçjimler sagat gütse gerekdir.
Gelen dosty gitmän öýüne indi,
Hyzmat edip munda ýatsa gerekdir.

Çar tarapa çapar gitdi hat bile,
Hoş lybaslar geýip, ýüwrük at bile,
Gelse gaýy ili hem baýat bile,
Owal altyn gabak atsa gerekdir.

Başdan-aýak külli ärsary gelip,
Teke, salyr, saryk bisýary gelip,
Bil ki türkmen atly il bary gelip,
At münüp, don geýip gitse gerekdir.

Ýene her il sagdan-goldan ýetişip,
Garşy, Buhar, Garakölden ýetişip,
Omaçaly boz palaw boldan ýetişip,
Hemme hursand bolup gitse gerekdir.

Ýedi gün peýgadan bedew çapylyp,
Meýdanlar süpürlip, suwlar sepilip,
Şol gün her ne isteýeni tapylyp,
Bar işi alladan bitse gerekdir.

                 43          
Ürgençden, Balkandan, Gazmin,
                            Tährandan,
Maşatdan, Hyratdan, Balh, Badahşandan,
Gazakdan, Goňratdan, gyrgyz, Kokantdan,
Eşideni sürüp, ýetse gerekdir.

Niçe dokuz bagşy hoş owaz bile,
Söhbetler guralar dürli saz bile,
Ýene köp oýunçy, köp darbaz bile
Ajaýyp oýunlar etse gerekdir.

Müň sukum, iki müň goýun soýulyp,
Uly ata bir gul baýrak goýulyp,
Oguz hanyň toýy kibi toý olup,
Köp tomaşa bile ötse gerekdir.

Muhapbetli hemme ýakyny-daşy.
Getirler halyna laýyk peşgeşi,
Oturyp iýende köp dürli aşy,
Eli-agzy ýaga batsa gerekdir.

Halk edende möwlam ezelde muny,
Köňlüne salmamyş zerre gaýgyny,
Bu toý üçin halky jemg eden güni,
Engamynyň sany ýitse gerekdir.

                 44         
Gelen iliň hemme pakyry-baýy,
Geýerler özüne laýyk serpaýy,
Köp eşidip, nagarany, surnaýy,
Halkyň göz-gulagy gatsa gerekdir.

Iýgen aýdar «Aperinu-merheba!»
Dürli zyýapatlar her şamu-saba,
Belki, gelen hemme garyp-guraba,
Datmadyk tagamyn datsa gerekdir.

Seýdiniň ýalan bolmaz sözleri,
Enşealla, baryn görer gözleri.
Ýedi gün çapylan atyň tozlary
Aý-günüň şuglasyn tutsa gerekdir.

                45         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Çykyp gideliň',
    'Il birlik etmedi bize, ýigitler,
Geliň, bu watandan çykyp gideliň!
(Duşmanyň) ýalyna öwrenen itler
Gitmese, boýnuna kakyp gideliň!

Syndyrmaňlar goçaklaryň badyny,
Ýitirdiňiz ärsarynyň adyny,
Indi möwlam berse iliň dadyny,
«Lahowla-billany» okyp gideliň!

Begleriň ýüzüne gara çekildi,
Anyň üçin abraý ýere döküldi,
Üstümize emir tugy dikildi,
Goldan gelse, ony ýykyp gideliň!

Gün-günden halymyz bolandyr harap,
Bir niçe humsanyň agzyna garap,
Seýdi diýer, haram boldy bu Lebap,
Bir ýana sil kimin akyp gideliň!

                46          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Lebap, hoş indi',
    'Sakar halky bilen ärsary bolup,
Biz gitdik, sen galdyň, Lebap, hoş indi,
Kimse aglap gitdi, kimseler gülüp,
Kimse çekip dürli azap, hoş indi.

Kinämiz ýok sen gadyrdan watandan,
Ynjadyk Mirhaýdar ýerler ýuwtandan,
Tä ölinçäk üstümizden ötenden,
Gezsek gerek seni sorap, hoş indi.

Seniň üçin jepa çekdik, jan berip,
Ekin ekdik, doga aldyk, nan berip,
Hyrajyny-salgydyňy kän berip,
Gezdik köp işiňe ýarap, hoş indi.

Zowky-sapa sürüp, bir niçe ýyllar!,
Seni diýp oturdy munda köp iller,
Pil urup düzülen atyzlar-çiller,
Eýesiz galdyňyz garap, hoş indi.

Haknyň bergenine edip kanagat,
Oturmyşdyk tapyp aýşy-parahat,
Söhbet üçin bina bolgan ymarat,
Galar bolduň itler ýalap, hoş indi.

                  47          
Ýüz elwan miweli bagy-bostanlar,
Hoş öten baharlar hem zemistanlar,
Sizden araňyza niçe destanlar
Salyp galgan kurhan-kitap, hoş indi.

Sizler bizden tapmaýasyz webaly,
Ýok idi hiç kimiň gitmek hyýaly,
Bakjalaryň näzik biten nahaly,
Oturyň başyňyz yrap, hoş indi.

Gülşende sebz olup açylan güller,
Dost ile ýanaşyp ýörüşen ýollar,
Bize pata üçin göterip gollar,
Bolmady sizlerden jowap, hoş indi.

Özge begler Mirhaýdara höwesdir,
Bilseňiz, ol halkyň ykbaly pesdir,
Bize Soltanýazyň begligi besdir,
Gaharguly, hana harap, hoş indi.

Ýüz elli ýyl watan diýip gezildi,
Ekinler ekildi, ýaplar gazyldy,
Müň iki ýüz bir kem kyrkda ýazyldy,
Taryhyn etseňiz hasap, hoş indi.

Seýdi diýer, indi tükendi sözüm,
Gideýin, sizleri görmesin gözüm,
Gol aýagyň her ýan uzadyp, üzüm,
Ýat parahat, başyň büräp, hoş indi.

                 48          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Galdyň, hoş indi',
    'Gider boldum indi üşbu watandan,
Jebir gören iller, galdyň, hoş indi.
Hiç unutman, janym çyksa bu tenden,
Süýji sözlän tiller, galdyň, hoş indi.

Kätmen urup, elem tartyp, nan berdim,
Ara ýolda jepa çekip, jan berdim,
Hyrajyň, salgydyň örän kän berdim,
Jepalyja çiller, galdyň, hoş indi.

Küňňüreli howla gelen myhmanlar,
Ara ýolda köýdi jepaly janlar,
Ili berbat etdi niçe bisanlar...
Agzyň açyp howlular, galdyň, hoş indi.

Gahr eýlesem, indi gelmez gaharlar,
Niçe ýazlar geçdi, baharlar,
Amydan suw içen terçek nahallar,
Sen elwanlap galar bolduň, hoş indi.

Gije-gündiz dynman çapdy bendeler,
Para alyp, ili bozdy gendeler,
Bibat ýerde biten maýmyk igdeler,
Sen ümürläp galar bolduň, hoş indi.

                  49          
Ýigit bary göçüp gitdi watandan,
Baryp habar algyn ýoldan ötenden,
Jebir gördük Mirhaýdar ýer ýuwtandan,
Aglap, garyp iller, galdyň, hoş indi.

                50         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Gal indi',
    'Ozalda şum boldy meniň kysmatym,
Ygtybarsyz ýalan jahan, gal indi!
Menzilim, mesgenim, ýurdum, watanym,
Ygtybarsyz ýalan jahan, gal indi!

Gowga güni Rüstem kibi gyzdygym,
Tora düşüp, jandan umyt üzdügim,
Başym silkip, serhoş bolup gezdigim,
Eşretli sürdügim döwran, gal indi!

Bendilikde ygtybar ýok bizlerde,
Çoh armanym galdy gara gözlerde,
Agdarlyp, mest bolup, ýazzy-düzlerde
At çapdygym däli meýdan, gal indi!

Dünýäýe geldigim bolmady belli,
Haýp, ýaşamadym ýüzde bir elli...
Zer warakly, ýüzi gyzyl jezwelli,
Okydygym kitap, kurhan, gal indi!

Gahba pelek bize saldy bu resim,
Näçe abatlary bozar sen basym,
Kesildi mejlisim, sazym, söhbetim,
Işigimde agyr diwan, gal indi!

                 51          
Muhammetgylyç meniň bir gara dagym,
Bolsaýdy ýanynda gyssanan çagym...
Kyblagähim atam, çeşmim-çyragym —
Habyp Hoja ner-päliwan, gal indi!

Hazan urup, soldy ömrümiň güli,
Saýraman kapasda şeýda bilbili,
Kyýamat gardaşym, molla Zelili,
Sen yzymda düzüp dessan, gal indi!

Bile «gazat» diýip çykan goçlarym,
Siz gaçdyňyz, duşman aldy daşlarym,
Hemdem bolup gezen hemsyrdaşlarym,
Deňim-duşum, ýary-ýaran, gal indi!

Haýp boldy arman bile galanym,
Kim eşider garyp ýerde ölenim...
Seçip, saýlap, höwes bile alanym,
Göz guwanjym, Hatyja jan, gal indi!

Bir atadan Mäti — ýalňyz gardaşym,
Bihabar sen, duşman alypdyr daşym,
Läşim goýup, duşman aparsa başym,
Sen onda eder sen pygan, gal indi!

«Geljek» diýip giden ýolumy gözlän,
Kesip-kesip gara bagryny duzlan.
Köşekden aýrylan, maýa dek bozlan
Käbäm enem, bagry birýan, gal indi!

                 52         
Ýakasyn çäk edip, synasyn daglan,
Matam tutup, gara geýip, ýas baglan,
Hijran ody bilen jigerin daglan
Orazbibi, naçar dogan, gal indi!

Seýdi diýer, munda çekdi topragym,
Ýa reb, tapylarmy meniň soragym?
Hem bu dünýä, hem o dünýä geregim —
Kirpigi ok, gaşy keman, gal indi!

                 53         
                 —
«» sahypasynyň kitaphanasy.
                 —',
    ''
);

SET FOREIGN_KEY_CHECKS = 1;
