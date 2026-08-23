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
VALUES ('Nobatguly Rejepow')
ON DUPLICATE KEY UPDATE name = VALUES(name);

SET @poet_id = (
    SELECT id
    FROM poets
    WHERE name = 'Nobatguly Rejepow'
    LIMIT 1
);


INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Watan',
    'Watan—gyzgyn gursagymda namysym,
Watan—ýüreginden öndüren enem.
Watan babalaryň bagyşlan bagty,—
Mukama, mähire, söýgä eýlenen.

Gitsem—enem deýin elin serenim,
Gelsem—enem deýin gujak gerenim—
Eziz Watan, sensiň şirin janlary,
Seniň üçin şirin janyn bereniň.

Olaň arzuwydyň, aýdymydyň sen,
Olar sen bolubam göwsüňde galdy.
Aby-zemzem suwy bar bolsa sensiň,
Senden haýsymyzyň mährimiz gandy?!

Seniň Garagum däl, altyn humuň bar,
Seniň dagy-daşy ýarýan demiň bar.
Seniň şan-şöhratyň ýer ýüzüne däl,
Onuň geljegne-de ýalkymyn salýar.

Urşuň, gowur-gabahatyň üstünden.
Goja gyňyr tebigatyň üstünden.
Ädim ur, Watan,
Deret, gur, Watan,
Ýeňişlerden ýeňişlere ýör, Watan!',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Topragyň tagamy',
    'Topragym, pajarla, topragym, gülle,
Bu baky ýaşaýşyň gönezligi sen.
Bir görsem-ä atyz doly «ak altyn»,
Bir görsemem, al ýaňakly alma sen.
Desse-desse galla,
Besse-besse gul,
Ýaşaýşyň özi sen, gözelligi sen.

Ylla tylla ysyrgasy gyzlaryň—
Sallanan salkymyn gelinbarmagyň,
Synlap gördüm onda owadan ýerim,
Seniň bulduraýan görküň-görmegiň.

Sen ýüzi gylawlan gülaby bolup,
Gül aby deý syryp gitdiň damagym,
Iýdim, toprak, seni heýjana gelip,
Alyp senden ýaşaýyşyň tagamyn.

Pyragynyň lebzi ýaly halal sen
Hem-de hümmetli sen ene süýdi deý.
Seň miwäňden seni tanadym, toprak,
Sen, asal sen, gyz lebiniň dady deý.

Ýaz saňa burk urup gelen pillesi
Ne-hä uçup bildim,
Ne-de uçmadym...
Nygmatyňy iýip, labzym süýjedi,
Gülüň ysgap, yşk derdine uçradym.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Gün',
    'Tylla Günüm, gark et meni nuruňa,
Edil dik depämden şuglaňy saçyp.
Geç, sen türkmen asmanynyň törüne,
Ol türkmen göwni deý mydama açyk.
Posalagy, lellimleri ýigrendim.
Ýandyr meni, ýandyr gyzgyn howruňa,
Şu topraga meňzeýänçä reňkim,
Meňzeýänçäm öz topragmyň ogluna.
Seniň şu topraga yhlasyň uly.
Günde on bäş sagat üstünde dursuň.
Bal deý damjak bolup duran üzüm sen
Hem-de öz gabygna sygmadyk narsyň.
Gor guýduň ak garpyzlaryň göwsüne,
Ýalyn ýaly ýalkym salýar dilimi,
Garpyz däl-de, köz ol, daglar dadyna,
Ynanmadyk degrip görsüp dilini.
Nazy˗nygmatymyň gözbaşy Günüm,
Bagtym saýyp ýüze syldym men seni.
Seniň mährem howruň bollugy üçin,
Meniň ülkäm bolçulygyň mesgeni
Iki ýola hasylly sen topragyň,
Seniň tylla jöwzaň mähirden doly.
Juda gazaply sen ýetişen gyzyň
Ejaba sygmadyk söýgüsi ýaly.
Sowuk owadanlyk derkar däl maňa
Hem yssys gözellik nämäme gerek.
Güle ys sen,
          bereket sen topraga
Dözümli daraýan jöwzaňa derek.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Türkmeniň toýy',
    'Eger türkmen toý etse,
Özi otyr bir çetde.
Gojalar ygtyýarly
Beýemçi bor, elbetde.
Halan malyn soýarlar,
Baýrak baryn goýarlar.
«Kemi bolsa, ildeşler,
Duýduraýyň» diýerler.
Üýşenmez ýat gelenler,
Ýaşynmaz ýaş gelinler.
Küşt deper hyjuwyndan
Ot alýan ýaş-ýeleňler.
Gözler gözlere düşer,
Gözler göze düşüner.
Ýüreklerde dörän yşk
Eýýäm goşga goşular.
Duýulmaz, syr aýdylar,
Goşgy-gazal öýdüler.
Kesir-kesir gyzlaram
Söýenin soň duýdular,
Toý tutular üç güni,
Kalba sygmaz göçgüni,
Bagtyňyz toýa geler,
Eý, türkmeniň goçlary.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Eneme',
    'Meniň eziz enem, mähriban enem,
Okaýma bujagaz ýazan şygrymy.
Saňa agyr deger ýeňil bendimiň,
Pelsepämiň ýeňilligniň agramy.

Ödedimmi telim gijäň ukusyn,
Ullakan bagt saýyp çeken derdini?
Gör, nije ýyl umyt bilen garaşan
Ogluň seniň, garaşanňa degdimi?

Sen akyl çägine ýetipsiň dünýäň,
Men bolsa bärsinden garaýan häli.
Belki, seni doly görýän deldirin.
Belki, seni eşdýän däldirin doly.

Bu gün sen mähriňden ulalan ogluň
Söwer ogluň, murty tabap är çykdy.
Bu gün seň öňüňde meniň ýaşaýşym,
Ýaşaýyş däl-de, bir jogapkärlikdi.

Bilýän, örtenýänsiň menden ogryn sen,
Goşgularmy okap görüp gazetde,
«Şahyr däldir» diýip, gorkýansyň menden,
«Şahyrdyr» diýp, galýansyň ýa ezýetde,

Tamaň boldummy
                  ýa hemam boldumy
Ukusyz gijeleň çekdiren keşgi?
Eziz enem, heý, men seniň bagtyňa,
Arzuwyňa, umydyňa meňzeşmi?',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ene dilim',
    'Alys asyrlaryň ahy-nalasy,
Begenji-gynanjy,
                   jebri-ejiri
Meniň dilim, seniň dünýäňde galan,
Pyragynyň dünýä beren setiri.

Akyl bolup galan sende babalar,
Nakyl bolup galan sende danalar,
Galypdyr ýüregi dilýän ýaň bolup,
Duşmanlara olja bolan çagalar.

Hüwdi bolup galan eziz eneler,
Uzyn gije hüwdi çemenin bogup.
Ýesir düşen gerçekleriň dymmasy,
Galypdyr mukaddes dymyşlyk bolup.

Ösüşim,
         tesişim, ýagşym, etmişim,
Sen meniň taryhym —meniň geçmişim.
Eger diri bolsa Türkmeniň dili,
Geljegimem diri,
Geçmişem diri.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Düýş',
    'Düýşürgedi,
Näler urnup bilmedi,
Doňan kölde galan balyk deý oglan.
Gygyrmaga ysmady doň dilleri,
Bar güýjüni edip janykdy oglan.

Şeýle ýowuz bolýar düýşleň kadasy,
Şeýle ýowuz bolýar kanuny düýşüň.
Ne delalat degrip biler kakasy,
Ne bir nepi deger ýaragly güýjüň.

Birdenem ol «eje» diýip gygyrdy,
Jany aram tapdy giňän gursakda.
Iň kyn pursatlarda «eje» diýilýär,
Diýilýär ol, ýekeje söz diýmäge,
Hatda rugsat berilmeýän pursatda.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Komandir',
    '«Öňe,
             öňe,
                     diňe
                              öňe!»
                                         Şo mahal,
Gursakdan ýer aldy köz ýaly gurşun.
Ol soňky deminde,
                  ölmüň elinde,
Synlaýar asmanyň tüsseläp durşun.

Ýer gana ýuwulýar,
                  gözi ýumulýar.
A ol ýene pyşyrdaýar: «Ot,
                           ot,
                                         ot!»

Ot açylýar,
          gan saçylýar,
                              ol weli,
Şol durşy,
             şol durşy ölüp bilenok.

Ýok.
Ol ýene ölüp bilenok.
Asman gara duman,
                   zemin bolsa ot.
Ynanyň,
          bu mahal ölmek bolanok.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Harby syr',
    'Gazaplydyr uruşlaryň kadasy,
Ölüm adaty bir tal aby ýowuň.
Ah, ýene nämeler bolmaýar jeňde,
Ölümden ýüz esse,
Müň esse ýowuz.
Ol ýesir düşmezdem, duşmandan däl-de,
Böwründen goýberse iň soňky oky.
Emma oňlamady ýurdun şu halda,
Elhenç urşa goýup, ölüp sypmagy.
Ol soňky okuny duşmana atyp,
Ele düşdi. Ol —ölumdi soldata.
Duşman bolsa «erkinligi» hem «bagty»,
Göwnüň isleýşiçe berip dur wada.
Emma harby syry duşmana satmak,
Özüň üçin watanyňy satmakdy.
... Ýesiriň ýalaňaç ýagyrnysynda
Dürre çyrpynmady,
Ýyldyrym çakdy.
Tultuk suw bolýança ýençdiler ony,
Ädik nal yzyny goýdy kellede.
Haýykdyrjak bolup haýykdy duşman;
—Äl erklilik bolar eken beýle-de!
Gözlerinden ýaş däl, gan çykdy onuň,
Göwresinden syr däl, çykyp barýar jan.
Ol şonda ruhy güýjüne däl-de,
Gelip-gidýän öz huşuna ynanman,
Bedeninde jemläp ähli mejaly,
Bir biçärä «ene» diýjek dilini,
Bir gyzyň balyndan doýjak dilini,
Parça-parça edip çeýnedi ýigit,
Birden beýhuşka-da samraýmaz ýaly...',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Garly aga',
    'Beýik Watançylyk urşunyň weterany
                           Garly Öwezmyradowa,
Aýdyň, asman,
                 aýdyň zemin,
                                ak gije,
Toý, meýlis, meý,
Edil hyýaldaky deý.
Gapyda çykarlan agaç aýaklar,
Bu gün men kalbymy dilýär päki deý.

Tez bedewi kowup münen, Garly aga,
Dabanyndan ot syçradan, Garly aga.
Toý sypdyrman göreş tutan günleriň,
Nirelerde, nirelerde, galdy aga?

Dabanlar duýmaýar topragyň mährin,
Baldyrlar duýmaýar garyň sowguny.
... Adamlar, ah şindem sypryp bilenok,
Uruşlaryň goýan ünji sowduny.

Gör, nirde asmana gorkuly garap,
Asmandan gizlenýär suw deý çagalar.
Bir ýerde gije çen ýatyp bilenok,
Ýaraly arslanlar — garly agalar.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Esgerler',
    'Tarp,
        tarp,
               tarp.
Kemeriňi dart!
Depe-depe demre dönsün dabanyň.
Näzikligiň, lälikligiň bedenden
Damja-damja dere dönüp dagasyn!

Bu gün bizden talap edýär zamana,
Bize has erjellik, mergenlik gerek.
Nyşananyň aňyrsynda nyşana,
Sandyrasyn akar ýabyň gamşy dek.
Biz durmuşy, ýeri söýýäris.
                           Bize
Ykbalyn ynandy durmuş, ene ýer.
Sak bolýandyr göz goraýan gabaklar,
Sakdyr uka ýaş çagaly eneler,
Bize hasam saklyk gerek, esgerler.

                      ***
Men yzyma gaýtdym,
                 aýtereklerde
Şeýdýändir bat aljak bolanda çaga.
Ýa agyr söweşde saýpallan goşun
Gaýdýandyr güýjüni tükellemäge.

Şeýdip dag goçlary
                 duşanda duşman
Zarba urar ýaly gaýdýar yzyna.
Men yzyma gaýtdym, ýöne daşlaşman,
Diňe gaýdyp barmak üçin özüme.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Geçmişden parçalar',
    'I
Asylam men atam geplemsek däldi,
Uzyn gün arkasyn tamkepbä berip
Otyrdy açlygy,
                urşy,
                       togsandan
Geçen ýaşyn ses-sedasyz göterip.

Ol uzak dymardy,
                diňe käte bir,
Müňňüldärdi çekgedäki ýygyrdy.
Men gorkardym.
Onun düýpsüz dymyşy, –
Meniň üçin açlykdanam agyrdy.

Ýadymda. Bir gezek alabaharda,
Bir elinde hasa, bir çetinde men,
Gitdik joýalygyň, şüdügäriň hem
Onuň agyr dymyşlygnyň içinden.

Ýolda bar aýdany iki jümledi:
Bir bölejik gary meňzetdi una.
Soňra maňa tylla güni ümledi
Hem-de tylla güni deňedi nana.

Ýylgyrdym.
        Biçärä awady janym,
Sebäbi men una, nana beletdim.
Ýöne mährem güne sereden çagym,
Ynanyň, bir demde ajygyp gitdim.
Öňümizde bolsa tolkun atýardy,
Uç-gyraksyz ala gury şüdügär.
Mymyk şemal imisala akýardy,
Keseklere çeşme ýaly büdüräp.

Şohal gözmüň öňi garalyp gitdi,
Ýok, günüň öňüni tutupdyr bulut.
Çeträp jöwenek däl, hut jöwen ýagdy,
Birsalym oýnuny görkezdi Burkut,

Şonda atam agras başyny ýaýkap,
Ah çekdi, käýnidi ilkinji gezek:
— Çagany aldap bor.
                 Ah, pelek, pelek,
Topragy aldamak nämäne gerek!

                   II
Urşuň yzýanydy,
                 biziň maşgala,
(Kän bizden başga-da) derde ýolukdy.
Kakam pahyr bererlidi ýanyny,
Ol keselden saralypdy, solupdy.

A men ýaňy aýňalypdym keselden,
Ýarapdym mellekden tümmül ýygara,
Ýöne tümmül barmy?
                Iýiber entek
Tapanyňdan pytrap duran zagara.

Ah, zagara...
        Kyn günleriň höregi,
Saçagmyzda döwüm-dişlem bardy ol.
Ýöne böwet däldi akýan ýürege
Hem ajygýan ýerňe barmaýardy ol.

Şol günler kakamyň bir garyndaşy,
Gassap kakam öwejini öldürip,
Goňşymyza jar çekdirdi kän ýola,
Jar çekdirdi ýagly etin öwdürip.
Ol ganly penjede pulun gysymlap,
Gelenlere etden çekip berýärdi.
(Hut suw bolup akyp barýan ýüregim
Duýdurman göwrämden çykyp barýardy).

—Maňa ýarym kilo, pylany kaka...
Yzyny ýatlasam demim tutulýar.
—Puluň barmy?
Men başymy yradym.
— Bar, bu çaklar hurşy iýýändir puldar!

Şonda birden kuwwat gelip göwräme,
Depesine ýumraga-da asmany
Ýolbars deý pers-ala edesim geldi,
Gözleri gan,
                 elleri gan gassaby.

Şonda ganly etiň ýiti ysyna,
Duýdansyz, oýanan duýgulam bilen
Mes çaga kalbymy lerzana salyp,
Mende başga bir men dogulan eken.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Goňşy',
    'Diýýändirler «Kyýamat gün goňşudan»,
Goňşudandyr ajap döwürem, goňşy.
Her günüm kiçiräk toýa ogşudan.
Toýumy dabara öwüren goňşy.

Ýykylsyn-da aramyzyň howlusy,
Görnüp dursun aramyzyň gowlugy.
Sen-ä öz ogluňy, menem oglumy
Goňşokara bilen ýüwürdem, goňşy.

Meň gapyma sygman tutumy toýuň,
Toýhana aýlanar seniňem öýüň.
Sen şonda şol toýa özüňki deýin,
Göwnüňde baryny sowuran goňşy.

Başyň derde duşsa geler hossaryň,
Geler köňle gurbat bolup dost-ýaryň
Dertler gowzamanka ugradyp baryn,
Deň çekişjek sensiň şöwürem, goňşy.

Hut bagtam irizer her günde gelse,
Gelen aş diýp gelmän, wagtyňy alsa,
Agşam gara beräýmeseň sen bolsa,
Men seniňkä bakan ýüwürem, goňşy.

Eger her kes aýyplasa goňşusyn,
Diňe şondan görüp erbet oňşugyn,
Şol ýigidnň özüniňem oňdugyn,
Makullap bilmerin ömürem, goňşy.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Çopan',
    'Ol ýönekeý çopan,
                türkana çopan,
Gülli Garagumda erkana çopan.
Ýok onuň diplomy,
                ýok ýazan tomy,
Ýok, çopan asmanyň astronomy.

Sagady, kompasy—asmany
                          oňa
Ýel salgy biýr ýyldyzlary agaryp.
Onuň depesinde asmany dursa
Ýitmezem ol,
        gitmezem ol azaşyp.

Şapakdan, ýyldyzlaň durulygyndan,
Gijeleriň eýmenç garalygyndan,
Ýeliň gara bulutlary kowşundan,
Ol ertirki howaň tutumyn aňar,
Günüň batyşyndan,
Aýyň dogşundan.

Tüssesinden, mör-möjegiň sesinden,
Agyr dymyşyndan ýalaňaç gyryň,
Goýunlaň manyly göreçlerinden,
Asar tebigatyň saklaýan syryn.

Ol ýönekeý çopan,
                 türkana çopan,
Kesbine bagş eden paýhas-aňyny.
Tebigatyň iň ajaýyp synçysy,
Tebigatyň iň ajaýyp alymy.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Gözellik',
    'Şeýle tämiz güller biter ýazyna,
Şerap içen ýaly göçer-de kelläň,
Özüňem aňşyrman, çöküp dyzyňa,
Ysgarsyň ýolmaga milt edip bilmän.

Şeýle bir gyzlar bar, misli bir hyýal,
Baglara seýl eder şuglasyn saçyp.
Ýok, oňa kilçerip lak atmag-a däl,
Hatda galarsyň sen agzyňy açyp.

Şeýle bir goşgy bar, şeýle bir goşgy
Okabam bilmersiň labzyny ýoýup.
Oňa öýkünmeg-ä beýle-de dursun,
Ýazmaňam goýarsyn «meňki däl» diýip.

Eger ýürek diýlen bar bolsa sende,
Gözellik özüne ýesir edýändir.
Gözellik däl, özün gorap bilmese,
Ýoýup bolýan bolsa gözellik däldir.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Alabahar',
    'Ýene alabahar,
                  ýene ala gar,
Ýene pagyş-para şeker ýaly gar.
Ýok, men garyň erärine dözemok,
Men ýazyňam hak aşygy, ýary, gar.

Ýene alabahar,
                ýene ala gar,
Ýene mylaýym ýel gary oýnaýar.
Nem alyp, dem alman togsan gün ýatan,
Toprak agras ukusyndan oýanýar.

Gojalar ýalňyşman ýazy getirdi,
Getirdi alysdan ýazy durnalar.
Gaýdyp üçeklerde tüsselemezler,
Gara kesindi deý gara turbalar.

Ýene alabahar,
                ýene ala gar,
Ýene suwy känelipdir akaryň.
Mylaýymsyraýan gyşyň astyndan,
Gök ot bolup dömýär meniň baharym.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ýagyş',
    'Ýagyş,
       ýa-gyş,
              ý˗a-g-y-ş şabrap, şabraşyp
Begenjine adyn aýdaýjak bolýar.
Bulut dag gerşine garnyn garnadyp,
Ýeriň depesinden yňdarlyp gelýär.

Asman nagra çekýär, çakýar ýyldyrym,
Naýzalap ýagyşdan doly tulumyn.
Bir demde dünýäni ýylatsam diýýär,
Bir demde boşatsam diýýär buludyn.

Çygylyp çym-gyzyl bolan pyntyga,
Urlup, ak damjalar çakýar çakmagy.
(Ikuçly däl, pyntyjakdan hä diýmän,
Gäl däl-de, al-gyzyl ýalnyň çykjagy).

Gyşdan doňup çykan derýaň suwuna
Şabrap-şabrap ýagyş özüni urýa.
Bahar bormy çykarmasa hanaňdan?!
Ýaz özüne hiç nim sygmaýar, derýa!

Baharyň deminden etegin ýygryp,
Gaçyp daga çykan ak garly gyşy,
Ýagyş ýaza öwrüp, bulaga öwrüp,
Şagladyp goýberýär zemine garşy.

Hol gyzy,
      hol ýigdi,
              jübdi, ýalňyzy.
Biparh ýöräp barýan şol gamgyn gelni,
Suw bilen däl, ylham bilen, ýaz bilen
Ýagyş ýuwjak bolýar dabanna çenli.

Ýöne her kim,
        her kim busýar jaýyna
Ýa bukulýar saýawannyň astynda.
Heý, şeýdip jebr etmek bormy janyňa?
Heý! Nämeden gaçýaňyz siz aslynda?

Bolmajagyn bilip, jansyz üçegi,
Şabrap-şabrap ýumruklaýar badyna.
Soň, aýna ýarmaşyp,
Ýarym-ýaş bolup
Adam! Ýagyş aglaýar seň halyna.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Bahar',
    'Bark uran bahardan aýlanýar kelläm
Hem meniň tersime aýlanýar dünýä.
Zeminiň üstünde pasyrdaýar ýaz,
Aýna deý gökde-de şol ýaz görünýä.

Hol alysdan gelýän bir setir durna,
Bozlup aýlaw edäýsedi bir meýdan.
Ýogsam olar seniň algyr nazaryň
Hem meniň ýüregme atylan peýkam.

Gyzyl ýele meňzeş çaýdyr çeşmeleň,
Çeşme deý gök ýelleň keýpi zereňdi.
Eljiräp depeňde saýraýan guşlaň,
Hut ýazdan ýasalan ýalydy reňki.

Gözellik çäginden çykan çagynda,
Lezzet däl-de ezýet berýäne çemli.
Neneň kalba sygsyn, öz hanasyna
Sygman ýaz çykanda daglara çenli?!..

Häzir ýaşyl ýazyň ýaşyl oduna
Lowlap ýanyp duran şol ýaşyl bagy,
Fakel kimin garbap otlasym gelýär
Adamy,
       çöllügi,
              ýalaňaç dagy.

Seniň gök könnegňe meňzeş asmanyň,
Nikabyn göwsünden ýaka deý ýyrtyp
Dünýäň ýüregini göresim gelýär.
... Ýazyň ýanyp duran ýaşyl-gyzylly
Oduna özümi urasym gelýär.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Derýa',
    'Diňe mesän çagy bulanýar derýa,
Joşdugam gadymy ornuna sygman,
Oýun edýär derýa,
Elenýär derýa
Özüniň kakabaş oýnuna sygman.

Ýalap,
      ýalmap,
             gemrip opuran kertin
Adamçy göhert deý astyna salýar.
Öz kenaryn ýumrup, bir pursat erkin
Gül-pürçük ýaşaýşa çykasy gelýär.

Agdarlyp,
        düňderlip,
            ýowuz çarp urup,
Mejnun derýa her ýan sowýar ugruny.
Bulançak suwuna gözün gapdyryp,
Bulançak suwuna ýuwýar ruhuny.

Joşguna çydaman, şohal balygam
Terk edip mesgenin — derýanyň teýin,
Suw ýüzüne çykýar, joşan halatym
Meň juda ýabany duýgulam deýin...

Her hal pesdeligne kaýyldyr derýa
Berse-de ol beýik ýaşaýyşa jan,
Ýöne derejesine çykasy gelýär,
Käte daşan çagy özüne sygman.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Dagda',
    'Şäheriň kepderi titiliginden,
Dartgynlykdan,
        argynlykdan,
                  darlykdan
Sogrulyp pederden galan duýgyna
Melhem gözlärsiň sen gara daglykdan.

Tebigaty ysgap bar durkuň bile,
Tebigy zemine syn edersiň, syn.
Haýransyň çeşmäniň gözelligine,
Çeşmäniň ganawdan akmany üçin.

Ýagşyň reňki siňen gögümtil daşlar—
Hem başyňy aýlar dumanly uçut:
Bir pursat köňlüňe ýetesiň geler,
Daglaň depesinden pel-pelläp uçup.

Gygyrsyň, sesini ýetirjek bolup,
Öz dyrmaşyp bilmedik hol beýgiňe.
Ýatan ýaly seň sedaňa garaşyp,
Daglar sesiň gaýtalarlar keýpine.

Ownuk pikirlerňi seriňden zyňyp,
Bir saldamly yza dörär göwnüňde.
Duýarsyň öz ömrüň ýasamalygny
Şu keremli goja daglaň göwsünde.

Zamanaň ne ysy,
                 ne-de yzy bar,
Bagyrtlap ganarsyň gadym akardan.
Bu daglara däl-de,
                 gelen ýalysyň
Gadym dünýä ýigriminji asyrdan.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Guwlar',
    'Ýüzüň, guwlar,
                  geziň guwlar, erkana,
Siz menden däl, özgelerden wehm ediň.
Goşa nil däl, goşa gözlerden gana
Synlaýyn men,
                  Men inisi Rehmediň.

Synlaýyn,
Sypaýyn ýüpek ýel deýin,
Gözlerimi gamaşdyrýan ak peri.
Bilýän, ýaşlygymdan ömür gitmerin,
Duýsam, söýsem ähli gözellikleri.

Ap-ak guwlar,
                 ak arzuwlar gitseňiz
Kölüm dynar,
                  köňlüm dynar görkünden.
Bilýänizmi, size tüpeň çenän kim,
Onuň aryn alýaňyz siz, gör, kimden?',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ýüpek gurçugyna',
    'Irdiňmi sen,
         ardyňmy sen
                   dünýeden
Ýa ýüpege öwrüldimi bedeniň?
Düşün,
       başyň yrap, daşa oranyň
Ol pile däl,
       ýok, ol seniň kepeniň.
Ykbalyň şeýlemi,
         şeýlemi meýliň
Ýa täleýden içiň doly armanmy?
Ýa ýüpek taryňdan,
Ýürek taryňdan
Dirnligiň,
       diriligiň arzanmy?

Elde dutar zar-zar aglaýar,
                          zary
Dirilikde çekmän giden zaryňmy?
Gözelleriň älemgoşar öýmesi,
Ak gaýmasy
         seniň ýürek taryňmy?

...Iň soňky demiňi,
          soňky derdiňi
Hem şirin janyňy pilä berdiň sen.
Öz ölmüňi ýeňdiň ömüriň bilen,
Ýene ömür bolup çözlenersiň sen.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Gije etýudy',
    'Arkasyna alyp aýsyz asmany,
Alysda Garabil garalyp ýatyr.
«Dünýägörünende» çopanyň ody
Ýalňyz gyzyl gül deý ülpüldäp otyr.

Ak ýyldyzlar — ak ýagyşyň damjasy
Balkyldaýar, damaýarly görünýä.
Goýy tümden ýaňa ýöremegem kyn,
Goýy tümden ýaňa owadan dünýä.

Tümmüllere bagryn berip, ýapyryp
Ýatypdyr ýaýlanyň ýadan şemaly.
Ýaşlygymyň ýatlamasyn ýaşyryp,
Otyr kölege deý, ýalsyz şetdaly.

Akar ýap, ýelk ýasap, barýar geljege,
Şu asuda gijede-de howlugyp.
Çalaja görünýär aýyň erňegi
Ýaňy çykan dişi ýaly oglumyň.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ýelken',
    'Ýelken
         deňizden öwüsen heserli ýelden
Çişip,
         dolup-daşyp uçasy gelýär.
Ap-ak guwlar ýaly,
Göwünler ýaly,
Hol mawy asmany guçasy gelýär.
Ýitse-de gidesi gelýär şol taýa,
Ýapylasy gelip ýalaňaç aýa.
Bat alýar,
Göterlip bilenok erkin,
Göterlip bilenok ganatyn ýaýyp,
«Uçman geçdim» diýip, gynansa ýelken,
«Uçdum, uçdum» diýip begenýär gaýyk.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Gorky',
    'Solgun sary tokaý ýatyp bilenok
Hem görenok erteki deý düýşüni.
Ýapraksyz pürleri ýapyp bilenok.
Güýz düşeli syrdam-syrdam düýbüni.

Ýogsa tokaý özün bagtly saýýardy,
Owadandam onuň ýaşyl ykbaly.
Ýene depesinde ýarym aý bardy,
Çarhlanyp goýulaýan aýpalta ýaly.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Duman',
    'Dördünji,
       dördünji,
              dördünji gezek,
Ýene bir gaýrata galsana, Duman.
Başga çykalga ýok seniň güýjüňe,
Sen ozmaly,
        ozmaly sen bigüman,
Gadym Pendiň şöhratyna eýe sen,
Ýaryşlarda aldyň baýrak baryny.
Hatda seniň garşydaşlaň seýisem,
Seniň ýeňişleriň tarapdarydy.

Ýene eň-le, owaz ýaly ýeňle-de,
Goý, zamana adyn ýazsyn toýnagyň.
Goý, mähelläň ýüreginde ýene-de,
Toýnak sesin täze mukam oýnasyn.

Dördünji,
      dördünji,
             dördünji gezek,
Eý aman, eý aman, nädäýdiň, Duman?
Ýa unudan bolaýma dem almagy,
Ýa ýürege sygmadymy dyňzan gan?

Çapyksuwar honda gözýaş eýledi,
Ýaş syçrady gözlerinden seýisleň.
Ýeňdiň.
       Öldüň.
              Ýa täleýiň şeýlemi,
Ýa täleýi şeýlemidir beýikleň?!',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Gyş',
    'Patrak ýaly gar,
Erik gülden tänen ýaprak ýaly gar,
Ejap eýläp,
         başyň aýlap,
Ýylan deý ýalaňaç baglara gonýar.
Gözýetim golaýda şowaňky ýaly,
El ýeterli çaňap duran asmana,
Gözellik gar bolup örtdi dünýäni,
Hatda dözer ýaly däldi basmaga.

Küregenläp,
         boraganlap ýagýar gar,
Hut eşdilýär onuň ýagýan owazy.
Gyş ak köpük edip,
         köpürjikledip
Bahar üçin ýuwýar agras howany.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Balerina',
    'Ýaňlanýar duýgudan lummurdan mukam,
Syrylýar zalyň, däl,
         Duýgyň perdesi.
Syrylýar perdesi şahyr düýşüniň,
Ine, saňa hüýr-perili erteki.

Sen hyýaldan çykan suw perisi deý
Daraklygna galyp,
Galkyp ýeňilden,
Depesinden garap gelýäň zeminiň,
Depesinden ýöräp gelýäň köňülleň.

Tolkundyryp ganat ýaly gollaryň,
Tolgundyrdyň halys hyýalbent göwnüm.
Men sahnada seni däl-de,
                         gülleriň
Arasynda ýaýnan aýdymy gördüm.

Ýene çalyp gitdi meni bir heser,
Ýene jeýhun hyýallara gowuşdym.
Balerina!
Ýa sen göze görnüşimi aýdymyň?
Göze görnüşimi ýa-da sen yşgyn?',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Toýnama',
    'Gel, pelsepe otaraly toýda biz,
Biraz artyk görünse-de pelsepe,
Otaralyň, berlip meýe, keýpe biz,
Ünsden düşüp galmaz ýaly kelle-de.

Komsomol toý ýeňişidir döwrümiň,
Onda durmuş bahar ýaly pajarlar.
Toý diýeniň hiç bolmanda ömüriň.
Bir gününi uzaltmagy başarýar.

Bu durmuşdyr.
                 Çökmän bolmaz kalbyňa,
Çaýyň zeňi ýaly kinedir-öýkäň.
Şonda ony ýuwup ýaz deý aýdyma,
Kalbyňyz tutumly tonlara çaýkaň.

Goý, püre-pür bolsun göwün deý bada,
Guý, sen al şeraby güldir-de saky.
Baky bolmanmyzda näme dünýäde,
Bize derek dünýä,
Şu dünýä baky.

Uýalýa oturan çatynjalary,
Ugradyň otaga.
                 Etmäliň heläk,
Bagtdan ýaňa galpyldaşyp otyrka
Olara uludan uly bagt diläp.

Olary toý dabarasnyň üstünden,
Ugradyň siz täze açylan gapa.
(Ýaş-ýeleňler arzuwyna ugratsyn,
Gojalar ugratsyn ýaşlygna baka).

Çek dutaryň taryn, Ödenýaz bagşy,
Goýber joşgunyňy iki büküş-de.
Basgançak deý perdelerden ylgaşlap
Göwnüň, ýetilmedik çuňlugna düş-de,
Entek el degmedik ýürekleň taryn,
Gysymlap-gysymlap eňter sen nama.
Bogazyndan mäkäm boglan dutaryň
Bir äpet ýürek deý gelsin zybana.

Şahyr dileg etsin, diýeni gelsin,
Goý, diýeni gelsin kiçidir-ulyň.
Gysga bolsun çatynjalaň gündizi,
Gijesi uzyn.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Aýa',
    'Gijeler düýşleriň süýjäp başlasa,
Gündizine ýüpsüz baglasa aýna,
Buýsançdan balkyldap sereden çagyň
Jemalyň görünse aýna deý Aýda,
Uz basyp gideňde sarsman endamyň,
Näz bile ýörese topukdan aşak,
Ýalyn ýaly labyrdasa köýnegiň,
Şamar galbaň döşden towussa aşak,
Goşgudan başga zat okap bilmeseň,
Agşamlyk giresiň gelmese öýe.
Bu başlanşy dyňzap gelen ýaşlygyň,
Aýa sen,
          ilkinji baharyň aýa!
Söýmäge gyssanma,
Arzuwyň saňa.
Seň arzuwa meňzeş mahalyň aýa!
Del gözleriň jadylaýjy nazary,
Ýyrtmasyn ýüzüňden näzik nikaby.
Ilkinji emelsiz posany aýa,
Ol — ynsanyň iň mukaddes nikasy.
Ol — söýginiň lebzi,
Yşkyň baş genji,
Soňky posalary tanap bolmaýa,
Ikinjimi,
        ellinjimi,
                    ýüzünji.
Aýa sen,
        ilkinji posaňy aýa!
Soňra nadyl bolmaz ýaly bagtyňdan.
Söýgi ir gelýär-de, akyl, otly deý
Gijä galýar öz gelmeli wagtyndan.
Aýa sen,
        ilkinji söýgiňi aýa!
Hemraň gözün goran bilbilgöýe dek.
Ilkinji söýgiňdir bütin ömrüňde
Ýüregiň ýaşlykda galdyryp biljek.

Gijeler düýşleriň, süýjäp başlasa,
Girip-çykyp karar tapmasaň gündiz,
Düşnüksiz duýgudan başyň aýlanyp,
Öz-özüň ýylgyryp ýörmeseň şindiz,
Gyssanma!
          Atygsap söýmäni küýsän,
Kalbyň garaşmadyk dadyndan gandyr.
Ilkinji bakyşyň,
          ilkinji posaň—
Iň ygtybar,
Iň bagtyýar nikaňdyr.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Meýdan düşelgesinde',
    'Meýdan düşelgesi.
                  Tuduň kölgesi,
Ýigitler bir ýanda, gyzlar bir ýanda.
Zähmet bilen joşup Murgap jülgesi,
Ýürekde çeşme deý ýaşlyk gaýnanda,

Orta çykyp oslanmadyk bir oglan,
Çalmaga başlady dilli tüýdügin.
(Haýran galaýmaly, ol mundan owal,
Hatda diýip bilmeýärdi diýjegin).

Saýradyp tüýdügin şirinden-şirin,
Şeýle bir süýjüdip,
Sojadyp çalýar.
Bir pynhan gudratdan galkynan jiger,
Gör, nije ýüregi heýjana salýar,

Ýigitlerem haýran,
                 gyzlaram haýran,
Özem haýran galyp çalýar o sazy.
Kim bilsin, sazmy ol, mukammy ýa-da
Ýüreginde gaýnan yşkyň owazy?!

Ol şeýle bir çalýar,
                  onuň çalşyny,
Dil bilen-ä beýan etmez hiç kimse.
Tüýdük bolsa, berbat edip kalbyňy
Geňläp durdy örän düşnükli dilde.

Ol saz çalýar.
                Hol bir çetde zyba gyz,
Otyr gabagyny galdyryp bilmän.
Gyzarýar, ýazgarýar, gelýär toba gyz:

«Wah, aklyň nirede,
Nirede kelläň?!»
Uýalýar gyz,
Laplap ýanýar ýaňaklar,
Ähli syry äşgär bolandyr öýdup:
«Heý, söýginem şeýdip paş etmek bormy,
Heý, syryňam ýaýmak bolarmy şeýdip?!».',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Türkmen gyzlarynyň atlary',
    'Humaý, Bossan,
                 Dilber,
                         Läle hem Şeker,
Şeýle bir çeper at,
Şeýle bir şirin.
Hersi ýeke söze siňdirlen mukam,
Hersi daşyp oýanmasy heseriň.

Ony aýdyp bilmez bilbil labyzsyz,
Aýdyp bilmez şahyr, ýanman ataşda.
Ony aýdyp bilmez şar tara gözleň
Yşgyna ýüregin ezenden başga.

                  ***

Atymyn aldyrmaz türkmen gyzlary,
Çölde ýören jeren ýaly sakdyrlar.
Gara gözleriňde jadyň bolmasa,
Her mergene,
        her görgene atdyrmaz.

...Daýan!
Ol gözeli derde goýan sen,
Sen nirä barýarsyň söýgiňden geçip?
Çarkandaksyz ýollar söýgä barmaýar,
Sen söýgä barmarsyň müşgülden gaçyp.

Ýada pagtabentmi ol atan okuň,
Ýa jerenden sowa geçdimi gülläň?
Ýaraly galdyrma gaçan maralyň,
Ganyny sarkdyryp ýörenin bilmän.

Gülle degse çyn mergenler bilýärler,
Gitme ýigit, wah, bolmady diýipler.
Ýaralanyp,
                 ýalňyz galyp ölýärler,
Başarnyksyz saýýatlardan keýikler.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Deňiz we gyz',
    'Tolgunyp,
      tolkunyp,
              düýrügip,
                    ýazlyp,
Owsun urup daşa urunýar deňiz.
Gözden syçrap gidýän ýaşyna ezlip,
Gezm edip,
        hezl edip ysgan güllerin,
Deňize oklaýar gül meňizli gyz.

Ol gyz gülýär,
Ýanyp duran yşk bile,
Aşyk bolan deňzi sypasy gelýär.
Bir-birin ýassanyp gelýän tolkunlaň
Ap-ak topuklardan sypasy gelýär.
Deňiz daşa urlup, gynaýar jany
Hem ýetenok demi-demne sojara.
Gülmeňiz gyz, nämä duş etdiň ony,
Saňa näme etdi deňiz biçäre?

                  ***

«Söýýän» diýme,
                 «köýýän» diýme söýýänňe,
Zyýany ýok başarmasaň yrmagy,
Söýgi mätäç däldir kasama, anda,
Söýgi halamaýar ynandyrmagy.

Ondan gözleriňde ýyldyrym bolsun,
Hakyt söýýäniňe geçmäge guwä.
Ol sende özüniň derdini görsün
Hem-de sende görsün derdine dowa.

Söýgä derkar däldir tarypyň, waspyň,
Söýgä derkar däldir kasamyň, andyň.
Yşkyň seniň ýerňe ynandyr yşky,
Diňe lowlap ýangyn,
Alowlap ýangyn.

                 ***

Gamlanma sen,
                 nemlenmesin dideleň
Hem soldurma ol hal atan terligi.
Kim betbagt ol saňa özün ideden,
Saňa goýup yşkyň elhenç derdini?

Gama batmak — ýitirmekdir ömürden
Sylsana ýaşyňy kirpikmen owaň.
Gadymy aşyklar köýen söýgüsin
Ýatlamalar bilen edipdir dowam.

Sen merdem bol,
       merdem bol sen,
                         diňe şol
Söýgüde maksada ýetirýän ýoldur.
Söýen bolsa gaýdyp geler ir-u-giç,
Ýogsa ol solanňa degýänem däldir.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Utanjaň gyz',
    'Ýene penjireden ýollara garap,
Sahu-jemalyna berýär ol timar.
Gol degmedik gül göwsüniň üstünde
Tolkunjyrap ýatyr bir jübüt şamar.
Owadan gyz ýanýar bir derde uçrap —
Wah, bir ýandan söýgi,
Bir ýandan ejap.

Ne içeri sygýar, ne bir daşary,
Garaşmakdan gyz takaty püre-pür.
«Heý, bolmazmy seniň ýoluň düşeri,
Heý, gelmezmiň, hiç bolmanda, güne bir?»
Gyzy basmarlaýar yzaly güzap,
Wah, bir ýandan söýgi,
Bir ýandan ejap.

Aýdyma hiňlense ejesi duýjak,
Hiňlenmese gyzyň aglasy gelýär.
Nädip gyz halyňa ilki söz diýjek?
Uýalýar gyz, öz-özünden uýalýar
Hem barýar tutaşýan heserden eräp,
Wah, bir ýandan söýgi,
Bir ýandan ejap.

Dabannyň astynda aýlanýar zemin,
Depesinde mawy asman aýlanýar.
Owadan gyz ne-hä däliräp bilýär,
Ne ýolugan bu derdinden aýňalýar.
Iýip gelýär gyzyň ýüregin myjap,
Wah, bir ýandan söýgi,
Bir ýandan ejap.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ugratmak',
    'Rugsat ediň, ugradaýyn men sizi,
Howlyňyza çenli,
Öýňüze çenli.
Bu ýol siziň öýňüze däl,
                         ol biziň
Pynhan syrlarmyza barýana çemli.

Ugradaýyn bir ajaýyp aýdyma,
Ugradaýyn erteki deý äleme.
Näme siz uýalyp ejap edýäňiz,
Öz bagtyňa gitmek aýypmy näme?

Didämiň diýenin dile diýdire,
Duýdyra tapmadym ebeteýin hiç.
Rugsat ediň, ugradaýyn men sizi
Aýdyp bilmän ýören sözlerme deňiç.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Garaşmak',
    'Kümüşsöw igdeler bürendi güle,
Şokolad ysyndan gandy ýürekler,
Seniň, geleriňe dabara bile
Fontan ýaly çüwdurlip dur derekler.

Gyzgalaňly,
        gozgalaňly garaşmak,
Bireýýäm suw etdi sabyr-takady.
Çybynlaram dünýäň ähli giňligin
Hem il-güni peşehana gabady.

Diňe aşyklara galdy bu gije,
Aşyklara galdy gije, gül ýüzüm,
Seret asmany däl,
         aşyk ýüregmi
Çyzyp, otlap gitdi süýnen ýyldyzym.
Seniň daban sesiňdir diýp aldanýar
Öz-özüniň gürsüldisin ýüregim.
...Wah, meniň ýanşyma dabara bile
Fontan ýaly çüwdürlip dur deregim.

                ***

Sen ozalam şeýle owadanmydyň,
Neçün duýmadymkam şu günlere çen.
Neçün diýmedimkäm derdimi saňa,
Ýa-da 76-yň pasly-bahary,
Gözellige aňk etmäge jahany,
-Ähli gözelligin berdimi saňa?
Diýsem, gülüp:
 —Gözüňedir — diýýän sen.

Şar gara gözleňde näme bar seniň?
Dikanlap didäme bakan çaglaryň,
Meniň tez ýüregmi nazaryň bilen,
Jadyly nazaryň bilen dagladyň.
Diýsem, ýere garap çowly kirpigiň
Owadan gözlerňe edýäň-de perde:
—Göwnüňedir—diýýäň...
                          Mümkin.
                                Göwnümden
Ýöne göwnüm bitýär soňky günlerde.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Gözleriň bile',
    'Haýyr, küşdem depme meniň bile sen,
Gar ýaly ereme hesere-meýle.
Diňe pynhan syrly küştdepdiňe sen,
Meniň ýüregimi nyşana eýle.

Hem gülüp geç joraň bilen deňimden,
Goşgymam ýak ýüregime ot berip.
Ýöne öňkiň ýaly hatymy elten,
Jigimi garşyla şokolad berip.

Serwim, saňa lak atmaýyn kilçerip,
Diňe syrym ýaýaýyn men üm bile.
Sen şol pursat bir enaýy ýylgyryp,
Jogabyny gaýtar gözleriň bile.

                 ***

Men goşgy ýazmaryn şu günden şeýläk,
Eňräbem ýörmesin ýüregim zar-zar,
Bilmese bir gyzyň başyny aýlap,
Ol goşgy,
Ol talant nämäme derkar?

Bu gün hatda göwnüm geçdi özümden,
Saçlaryny ütýän bu gara kelläň.
Ýogsam, aýtjak sözüm ýat tutup gidip,
Gaýdardymmy näme diýjegim bilmän?

Bu gün hatda söýgüdenem dilgir men,
Onuň bar gudratyn,
Güýjün ret edip.
Ýogsa meni ýakyp-ýandyran söýgi,
Heý, bilmezmi seni biraz eredip?

Ýandyrdyň sen meniň niçe şygrymy,
Ýandyrdyň sen näçe goşgy-gazalym?!
Gör, ýene-de dilýär meniň bagrymy,
Şonça oda ýylamadyk nazaryň.

...Men goşgy ýazaryn şu günden şeýläk,
Maýyl bolup elwan gül deý keşbiňe,
Iru-giç iň gowy şygrymy saýlap
Tutaşdyrlyk ederin seň yşgyňa.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Köşeşeýin men',
    'Ýürek gursagyma sygmady bu gün,
Ýylgyryp garaý, gyz, köşeşeýin men.
Götertmedi yşkyň kysmaty bu gün,
Halymy soraý gyz, köşeşeýin men.

Bulutlar bu dertden ýagyp ýeňleýär,
Perwana alaçsyz ýanyp ýeňleýär,
Adam ogly syryn ýaýyp ýeňleýär,
Bir pursat duraý gyz, köşeşeýin men.

Hem dermanym, hem-de derdim diňe sen,
Örteme jigerim dile-dile sen.
Söz bilen däl, ala gözler bile sen,
Wada bir beräý gyz, köşeşeýin men.

Şar gara gözleriň jady-la seniň,
Çirkizdi ýüregmi oduna meniň.
Gözlerimi süzüp adyňa seniň
«Jan» goşup Suraý gyz, köşeşeýin men.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Düýe çal',
    'Ýa süzup aldymy aby-köwserden?
Wah, bilmedim, bilmedim men doýa, çal!
Ýa jady gardymy ala gözlerden,
Ejap bilen garap gyýa, gyýa, çal?!

Wah, düýe çal, düýe çal!
Eýläp al-asmanda saýran guş meni,
Saýlap söýgi bijesine baş meni,
Ýa çal diýim içirdimi yşgyny,
Öwrüp seni şol hyýaly meýe, çal?!
Wah, düýe çal, düýe çal!

Heser deý tütedip gaňşyrowgumy,
Kalbyma ot saldy her bir ýuwdumy.
A gyz, dogrudanam bagtym çüwdümi?
Ýaraýadyr hernä biziň toýa, çal.
Wah, düýe çal, düýe çal!

                 ***
Barybir sen meni söýmän bilmersiň,
Ýaz ýaly ýazylar kinedir-öýkäň.
Köşeşer gyz göwnüň,
Düşüşer göwnüň
Hem maňa ýene-de düşüner göwnüň.
Bilmersiň,
         sen meni bilmersiň söýmän.
Sen nämäniň aryn alýarsyň menden,
Zerurlygy näme meni örtemäň?
Ýa ýalbaryp başym egeýinmi men,
Bagrym ezeýinmi?
                Taýýar, eger sen
Söýýän bolsaň peselende mertebäm.
Meň söýgimden başga etmişim näme?
Ýaramaýar saňa yşkyň nämesi?
Ýa delmuryp gama bataýynmy men,
Boýnum burup bakaýynmy?
                         Taýyn men,
Gussa bolsa söýgiň subutnamasy,
Diýseň ynjyk bolýar söýende gyzlar,
Gyzlar gyrpa bolýar uçranda yşga,
Haýyş edýän, dymma! Näme diýseň diý —
Eger diýip bilse şol şirin diliň
Maňa şirin-şeker sözlerden başga.
Sygmasa kalbyňa kinedir-öýkäň,
Gygyryp bilersiň «söýemok» diýip,
Ýöne sen bilmersiň,
                 söýmän bilmersiň,
Çünki bir bakyşda köýdürip, köýüp,
Bir bakyşda şahyr eden dilbersiň.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Bagtym',
    'Edepli gyz duşuşyga giç gelýär,
Garaşdyryp sabryň soňuna çenli.
Eý kaddy-kamatyn küýseden bagtym,
Sen juda edepli bolmaga çemli.

Giç açylýar hoşroý ysly bägüller,
Kemsiz ganyp tylla günüň nurundan.
Bir gün beýhuş eder öýdüp ysyna,
Ynamyma beýhuş bolup ýörün men.

Dolan aý giç dogýar,
                 giç dogýar çenden,
Gijäni ýagtyldyp gündiz ýaly ol.
Garaşaryn bagtym mümkin däle çen,
Ýöne ýarym-ýalta däl-de, doly gel.

Özgäniň bagtyýar aýdymyn aýdyp,
Garaşýan, men saňa garaşýan, bagtym.

Sen gelersiň, ýöne, ynan, gorkýaryn
Gersiň öýdüp bagta mätäç däl wagtym.

                 ***

Meni ýalňyz goýup gitdiň sen, serwim,
Kime goýup gitdiň?
                Gussamy?
                         Gama?
Kalbyma joş urup sygmadyk söýgim,
Gussa öwrülende çekdirmi maňa.

Sen gitdiň dabanyň tagmasyn basyp,
Ak gara däl,
         ak gar ýaly ykrarňa.
Sen gitdiň,
         gitdiň sen aýak yzlaryň
Basa-basa meniň sowan ykbalma.

Syraýar,
      boraýar,
             küreýär ak gar,
Gar zemine däl-de kalbyma ýagýar.
Asman bolsa çap-çal saçly derwüş dek,
Söýgimiň üstüne kepenin ýazýar.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Hoşlaşyk',
    'Hoş gal,
       hoş hyýal,
              boş hyýal,
                     ho-oş gal,
Bessir indi düýş deý göwnüm aldama.
Men seniň däl,
         men söýginiň alnynda,
Bütin durkum bile bataýyn gama.

Söýginiň sönenin satdy gözleriň,
Hoşlaş, ýalbarmaýyn ýansa-da jiger.
Durmuş Nobatguly däldir ezizim,
Durmuş irde-giçde göwnüňe deger.

Bagtly bolsaň,
       söýülseň sen,
              söýseň sen,
Maňa orun bolmaz seniň ýadyňda.
Bagtsyz bolsaň, (gorkýan) görünerin men,
Seniň damja-damja daman ýaşyňda.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Söýgi',
    'Söýgi gelip-geçip gidipdir eýýäm,
Dilim baglap,
Gamaşdyryp çeşmimi,
Müşk ysyna beýhuş edip bir meýdan
Hem aýňaltdy ysgadyp şol müşgüni.

Men söýginiň nämedigin bilmedim,
Bilmedim men hut şol söýgä baş goýup.
Ol gursagym doldursa-da duýgudan,
Gitdi meniň gujagymy boş goýup.

Söýgi maňa şygyr bolup galmady,
Galmady dilberme ýazan hatymda.
Şondan bäri goşgy ýazýan söýgi diýp,
Ýöne olaň bary söýgi hakynda.

Görübem,
       duýubam bolýar söýgini.
Ýöne nämedigni aýdyp bolmaýar.
Çünki, söýgi agyz-dilden aýyrman,
Jadylaman, beýhuş etmän gelmeýär.

                  ***
Gör, näçe ýyl sensiz geçipdir, dilber,
Gör, näçe daşlaşdym seniň yşgyňdan.
Seni juwan gyzlaň keşbinden idäp,
Idäp ahu-gözli gyzlaň çeşminden.

Ýene hiç zat çalşyrgyçsyz däl eken.
Görseň, ine, gözlerine söweýin,
Bir zyba gyz otly söýgi bilen däl,
Mähri bilen tutdy seniň, öweziň.

Bar eken bagtyňam ýerin tutýan zat,
Bozlap aýra düşen bagtymyň ornun,
Tutdy akja gundagynda jägildäp,
Däbşenekläp ýatan ilkinji oglum.

Belkem, yrgadyryn,
                 durnuksyzdyryn
Ýa-da uýgunlaşyp ýürek zaryma,
Özümi ýitirip gam-gussa bilen,
Dönüp gidendirin başga birine,

Belkem, mejnun bolup söýen däldirin,
Ýaşlygyň alydyr kalbymdaky ot.
Sensiz ýaşap bilmän ýören hallarym,
Göz öňüne getiribem bilemok.

Gör, näçe ýyl sensiz geçipdir, dilber.
Galan ömrüme-de şu günüm bolýar.
Ýöne
       käte seni bagryma basyp,
Şeýle bir,
       şeýle bir aglasym gelýär.

                           ***

Ýok, ýatlama,
      ýakmasa-na bagry bir,
Geçenleri ýatlap didäň ýaşlama.
Ökünç bilen,
Ötünç bilen barybir
Gaýdyp barabilmeris biz ýaşlyga.

Geçmişiň kölgesi gül deý keşbiňe
Ýakal kimin düşüp artmasyn müýnüň.
Rast, düýnüň bagtyndan düşdüňmi jyda,
Gamynam unutmak derkardyr düýnüň.

Ähli zatda dolansa bor yzyňa,
Hatda dolansa bor köýdürlen yşga.
Emma hiç zat galan däldir ýylnara
Ahmyrly, lezzetli gussadan başga.

Gaýdyp maňa ysnyşjagam bolma sen,
Ýadyňa-da salma meni düýbünden.
Çykaryn men uwnup-çydap bilmeseň,
Entek gyz päkligin saklan düýşüňden.

Diňe, kä tötänden ýolugan pilläň,
Endam-janyň jümşüldese, elense,
Özüňi ýitirip, nätjegiň bilmän
Erk tapmasaň lagşap galan bedende,

Şol pursat özüňi serwim saýda sen,
Kynam bolsa, gitgin arany aç-da.
Bir dem bagtyýar bol, köýen söýgüden
Şondan uly bagta bolsa garaşma.

                         ***

Meniň ähli derdim söýgi däl ahyr,
Bar meňem dünýäde ýüzlerçe derdim.
Ýöne yşkyň bir möwsümi üçin men,
Bütin ömrüm goşgy ýazyp giderdim.

Yşkyň dünýäsinde ýitip gitsem-de,
Pidagärim — söýgim eziz maňa has.
Çünki ähli betbagtlykdan özümi,
Diňe söýgim bilen eýläpdim halas.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Wagt',
    'Wagt, seni gördüm-de tisginip gitdim,
Derläp çykan ýaly çigrek şemala,
Sen ýerläp barýardyň ap-ak buludyň
Sessiz-üýnsüz kölgesi deý hamana.

Soň gitmediň gözlerimiň öňünden,
Ýagyş bolup ýagdyň,
Gar bolup ýagdyň,
Üzülip-üzülip gitdiň ömrümden,
Ylla tylla ýapragy deý daragtyň.

Goňras kesmek baglan gaýas gerşinde
Kesmek däl-de, seniň jesedis ýatyr.
Sen ýel kibi öwsüp-öwsüp gelşiňe
Bihuda ölümden edýäň howatyr.

Wagt, maňa duşduň sen, çaýkandy dünýäm,
Kalbym asman ýaly lerzana gelip,
Sen düşdüň, düýn meni ahmyrda goýan
Gyzyň, gujagynda bäbejik bolup...

                           ***

                                      Kakabaýa
Ýok, gardaş, agtarma özünden günä,
Goşgy ýaz.
         kyssa ýaz gussa çekme-de.
Ýeri, ak «Wolgaly» gatnamanda nä,
Ertir-agşam çagalarmyz mekdebe.

Aslynda biz baýlygyn däl, Baýronyň,
Pyragynyň yzyn yzlap selpedik.
Biz bu dünýä diňe keýp etmäge hem
Gelnimizi bezemäge gelmedik.

Studentlik öwretmändi diňe bir,
Özümiz kitaba bendi etmegi.
Makaronly ýyllar öwrenipdik biz,
Sada geýinmegi,
Bergi etmegi.

Ýok, biz iller ýaly miweler bişse,
Agtaryp kurortlaň gowudan gowsun,
Sergin ülkelerde, diýardan daşda,
Goşga geçirmedik Türkmeniň tomsun.

Ýalňyşsak-da, ýara alsak-da herhal,
Ýan bermän gideli diňe öňe biz.
Çünki janymyzy goramaga däl,
Söweşmäge giripdig-ä jeňe biz.

Ýok, gardaş, agtarma özüňden günä,
Hem çekme sen ýalňyşlygyň keşgini.
Bize hiç mahalam miýesser etmez.
Ýeňles şahyrlaryň ýeňil geçgini.

Goý, gözläli,
         urunaly her ýana,
Çözläli üzülse üzülsin kelep.
Guwwaslar gark bolar däli derýada,
Azaşsa, çöllerde azaşar belet.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Dostuma',
    'Biler bolsaň, biziň ýükümiz ýeňil,
Az bizde alada,
Az bizde gaýgy.
Şindem batbörek deý asmanda köňül,
Agyr zadymyz ýok ukudan gaýry.

Duýýas indi ýeňil günleň agramyn,
Ýeňilligmiz üçin mätäç kömege.
Ownuk ýeňşe çişen gabaramyzdan,
Diňe ömrümize düşýär kölege.

Biler bolsaň, biziň ýükümiz ýeňil,
Ýeňil barmak isleýäris matlaba.
Onsoň batyp galýas ýüksüz maşynyň
Batyşy dek gabat gelen batgada.

Şol batan maşynyň yzky tigri deý,
Günler boş aýlanýar,
Hepde boş geçýär.
Onsoň günbe-günden ownaýar pikir,
Onsoň bize garşydaşam çüpreşýär.

Biler bolsaň, bize şeýle ýük gerek,
Hatda depämizde lowurdan saç-da,
Goý, dökülsin, dözmän artyk agramyn,
Salyp oturmaga bu argyn başda.

Egnindäki ýüki ýetende kişiň,
Hem gaty gidýändir,
Hem örän dogry.
Ýeňil zady zyňyp bolmaýşy kimin,
Gaýdyryp ýörmäliň pamyk deý şygry.

Ömrümizi sowrup ýörmän dil bile
Hem pidasy etmän eşretiň-aýşyň.
Gerek agyr ýükün götermek bize,
Şonça ýüki ýeňlär ýaly ýaşaýşyň.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Endik',
    'Halys,
      halys irýän, adatylykdan,
Ümür ýaly basmarlaýar endişe.
Çykmak dälmi näme adamçylykdan,
Goşgy ýazmak dönse eger endige?
Endikdenem geçdi ýanmaga asyl,
Ýanýaň,
      oturanok hiç zada synyň,
Zeýrenýän,
      (bu duýgy garramakdan däl,
Bu başdaş duýgusy mydam yzkynyň).
Salam berýän,
       alýan endige görä,
Hal-ahwal soraşýaň endige görä,
Işe barýaň,
       gelýäň.
              Ertir ýene şol,
Guýudan suw çekýän düýe deý göýä.
Mahal-mahal söýgi küýseýär ýürek,
Oňa bolsa wagt ýok. (Gülkünç, gör, niçik?)
Soň joşdurjak bolup köşeşdirýäris,
Barja duýgymyzam al şerap içip.
Ýüregiň gobsunşy göwnüňe jaý däl,
Ýüregiň gussasy saňa keseki.
Biz düşekde ýatman geçirjek bolýas,
Ylgap ýörşümize ýolgan keseli.
Birsydyrgyn günler bolsa bat alyp,
Inýär depämizden juwaz oky deý.
Künjiniň deregne zenzele bolup,
Ýenjilip dur ömrümiz boş soky deý.

                  ***

Özüňi käte bir undup bilsediň,
Kimdigiň düýbünden çykaryp ýatdan.
Güleňde kalbyňy çöwrüp gülsediň,
Gark bolsa gözleriň owasy ýaşdan-

Heserli nazara uçran juwan deý,
Ähli zady undup togtasa kelläň.
Bu dünýäde bagtly bolsaň bir pursat,
Şohal bagtlydygyň özüňem bilmän.

Biz nähili beýik bolýas,
                  mukama
Meýmiräp özümiz undan pillämiz,
Ýöne ýürege erk berýärmi näme,
Halys depämize çykan kellämiz?

Biz neneň adyl hem arassa bolýas,
Beýniň däl, ýüregiň erkine berlip,
Gözümizi süzüp çägäň üstünde,
Güzerlerde ýatan çagymyz serlip.

Ýok,
Paýhasdan nadyl däl men aslynda,
Akylyna sarpa goýýan ynsanyň,
Ýöne ol özüniň derejesinden,
Belende göterip bilmez ynsabyň.

Ýürek bolsa seniň başky päkligiň,
Günäsiz,
        etmişsiz neresse çaga.
Ýürek — seniň ýalňyz mümkinçiligiň,
Iň asyl çagyňa gaýdyp barmaga.

                 ***

Howa şeýle bir petiş,
Sähra şeýle bir solgun.
Ýetiş, ak jala,
Ýetiş!
Men halys boldum.
Güburde, çal asman,
                  şabyrda, jala,
Takyr ýerde şarpa-şarpa ýaryl sen,
Suwy süýjän gelinbarmak üzüm deý,
Penjiräme ýaz ýagmyryn perdele
Hem syryk sen gözýaş ýaly ýüzümden.
Gumak ýolda tozan turzup çapala,
Murtlaryny göge diken üzümler
Seni monjuk deýin düzsün sapaga.
Ýetiş, ak jala,
Ýetiş!
Howa nähili petiş.
Çaňjaryp dur asman,
                  gurak bulutlar,
Ýüregiň gysdyryp basýar üstünden.
Solgun biýaralar, saralan otlar,
Howa ýetmän gidipdirler essinden.
Garalýar günbatar öýleden bäri.
Hem öýleden bäri howa-da dymyk.
Teşne daglar bulduň ýelnin sokjaýar,
Emma kör emjegi bilenok emip.
Daglar dymyşyp dur, baglar doňuşyp,
Petiş howa basmarlaýar dünýäni.
...Ýagyşyn öňýany şeýle bolýandyr
Hem-de goşgy ýazylmaznyň öňýany.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Daglar',
    'Daglar,
        daş ykbally daglar,
               ýalaňaç daglar,
Bagry bilen gatan ykbalyňyz keç.
Siz iliň derdine ýüregin daglan,
Şahyryň ýalaňaç ýüregne meňzeş.

Bulutlaryň mesgenidir gerşiňiz,
Ýelem depäňizde haýal-ýagallar.
Ýere ýagyş ýagsa — gardyr durşuňyz,
Ýere gyraw düşse, size ýagar gar.

Diňe tomus çözüp siziň doňuňyz,
Göm-gök buzdan donuňyza zer çaýar.
...Daglar, gara daglar daş bolup ýatyr,
Dolup-daşyp aksyn diýip derýalar.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Otuz ýaş',
    'Ýyllar emaý bilen sypady başym,
Eliniň yzyndan agardy saçym.
Eliniň gyzgynna depäm lasyrdap,
Azaldy saçym.
Meni şahyr eden kemmagal ykbal
Ýumşak daryşmady,
                 etmedi näzi.
Derledip derimi çalanda ýyllar,
Maňlaýymda galdy barmaklaň yzy.
Şümi ýyllaň zähmetime aklygy,
Şümi bar sowgady bahar-gyşlaryň?
Aýdyň ýyllar, aslynda, siz näm berip,
Alýarsynyz meniň ýaşlyk yşnagym?
Akyl-parasatmy?
                 Şahyrlaň baky,
Duýgusyndan ejiz gelýändir akly.
Duýgy diýmek — ýaşlyk.
                 Onda şahyrlar
Hemişe ýaşlykda galmaga hakly.

Men indi köýnegmiň jübusi hatly.
Nazarkerde gyza atmarynmy lak?
Maňa kyn günlerde ýürekdeş gyzyň,
Gözlegne çykmanmy gözlerim çarhlap?
Ysgap al ýaňagy,
                 duýmanmy şygryň,
Meýmiredip kalpdan syzylyp gelşin.
Ähli zadyň serhedimi otuz ýaş
Hem indi ýaşlyga nokatmy gelnim?
...Otuz ýaşa uýgunlaşyp bolanok.
Otuza özümi görmedim rowa.
Tomsum bilen baharymyň sepgidi—

(Men çydap bilemok),
Çalyşýar howa.
Otuz däl,
                  şu mahal berseler elin,
Razy men kyrk ýaşa,
                  kyrk bäşe,
                          ellä.
Otuzda ýaşlykdan aýra düşme kyn,
Emmeden aýrylan çaga deý ylla.
Ýok, ýyllar ýaşlygym almady,
                          ony,
Çalyşdym men her aýdyma, her bende.
Syrdam boýlaryny, dury roýuny,
Gelinleriň çalşyşy deý perzende.

Ýürek!
                 Ýaşlygyňy şygra öwür sen,
Galanynyň tapylar bir alajy.
Terje hyýar ýaly ýaşyl ömürleň,
Barybir ahyry gutarýar ajy.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Asman meniň saýawanym',
    'Gar ýagýar,
         agarýar dünýäniň reňki,
Asman saýawanym ygally günler.
Ýagyş-garda maňa busma gerek däl,
Goý, ýagsyn üstüme ap-ak gar güller.
Çünki gar meňki.
Trolleýbus meňki,
         awtobus meňki,
Gar geýinen şäher meňki durşuna.
Men gözümiň röwşenini siňdirýän,
Oňa buýsanç bilen garap barşyma.
Hol ýykylan çagajygy diňdirýän,
Soň boýna mündürýän,
         keýp edýär ýaňky.
Onuň menden sähelçejik beýgelen
Beýikligi meňki
Hem keýpi meňki.
Duralgada duran şol gyz meňki däl,
Meňki bolmanda nä ýaňagy meňli.
Lak atýaryn,
         ol mylaýym ýylgyrýar:
Diýmek, gül ýüzdäki ýylgyryş meňki.
Gar ýagýar,
         gyzarýar gözelleň meňzi,
Özgerýär ak zemin,
Hiç zat öňki däl.
Bu gün bu dünýäde ähli zat meňki,
Diňe,
       diňe,
              diňe özüm meňki däl.

SERKERDE
Liriki poema

Ýene saba bilen atyldy tüpeň;
Atyldy böwründen asudalygyň,
Ümsümligiň,
          süýt deý säheriň, türkmen.
Indi sygyn, türkmen, gyljyňa sygyn!
Ilçi deý atyldy parahatlygyň,
Gözden gaýyp düşdi ok degen gije,
Horguryp çarpaýa galdy atlaryň,
Şol okuň sarsgynna atdy hallançak,
Bäbejigi oýanmadyk sallançak.

                  ***
— Hany, türkmen, seniň tuguň nirede?
— Tugum — serimdir!
— Läşdir başsyz göwre, hanyň nirede?
— Hanym — şu üstünde duran ýerimdir!
— Janyň nirede?
— Erkimdir!
— Hany, türkmen...
                 Gylyç iýndi şol demde,
Sorag edip durar ýaly sen kimdir!

                   ***
Gerçekler towusdy ýalaňaç ata,
Atlar süýnüp gitdi duşmana tarap,
Eger söweş güni janyn aýasa
Hatyny däl,
Özi Watandan talak.

Düýrme gylyç güneş oýnap howada
Iýndi gelmişegin, çapgy boýnundan.
Galkan gümmürlendi,
Meýdan elendi
Goçaklaryň «Wellemşaha» oýnundan...

—Dillen, gana suwsap geldiňmi, duşman?
Saç onda sen ilki haram ganyňy!
Ýa islegliň gyzmy, gelinmi, duşman?
Al jennetiň tutuş hüýrüstanyny!
Ýer küýsäp,
       ýurt küýsäp geldiňmi, duşman?
Bolýar, seňki bolsun ýedi gary ýer!
Biz topragyň üstünde-de oňuşýas.
Size-de gysganmaz astyn gara ýer...

Sykylyklap uçýar gyrgy naýzalar,
Sary peýkam esger döşün boýlady.
Ala meýdanlarda maslykdan ýaňa
Topraga degmedi atlaň toýnagy.

«Uruň goçaklarym,
Gyryň nerlerim,
Galkyň gerçeklerim, hüjüme galkyň!
Handyr özün gala salyn goraýan,
Siz diri galasy Watanyň, halkyň.

Aman bermän,
       zaman bermän, adamlar,
Bize çozup gelen bet duşman erur,
Külli Lebap gana gark bolmaz ýaly,
Bize bu gün gyzyl gan dökmek zerur»

Şahyr sarsdyrardy goşgusy bilen
Şalaryň algyndan tagty-täjini,
Sen şahyra gylyç berdiňmi, indem
Gözüň bileň görem onuň güýjüni.

Indi durup bilseň, dur sen öňünde,
Ýygyn dartyp, munda gelen, Mirhaýdar.
Gutularyn diýseň türkmen atyndan,
Yza at goý,
         ýogsa kelemäň gaýtar...

                  ***
Uruş atdan agdy,
         surnaý kesildi,
Garaguşlar meýlis gurdy läşinde.
Uruş odun otlan kesindi deýin —
Naýza söndi ýigitleriň döşünde.
Uruş atdan agdy,
         kernaý kesildi,
Läş-läşe,
         döş-döşe degişip ýatyr.
Giň ýurduny dar görenler, gör, indi
At gaýtarym ýere sygyşyp ýatyr.

Olja küýsäp gelen öwrüldi olja,
Doýmaz-dolmaz doldy ahyr kemini:
Ýa şeýdip aklyňa aýlanmalymy?!
Uruşa läş bolup düşünmelimi?!...

Watan seniň bahaň ýokdur.
                          Her bir jeň—
Seň dilenen nyrhyň diňe zerresi.
Seni basyp aljak bolup, gör, kimler,
Kimler söýüp pürreletdi serleri.

                   ***
Üçden biri geldi jeňe gideniň,
Ýeňiş geldi özgeleriň deregne.
Ogul bir ýan oklap çybyk «bedewni»,
Eýe çykdy atanyň at-ýaragna.

Ir bilen çykmady, gör, näçe öýden,
Ardynjyran ýigdiň gödeňsi sesi.
Onuň deregine ähli tüýnükleň,
Burugsap asuda çykdy tüssesi.

             ÝEKME-ÝEK

Ýekme-ýek,
Gadymy uruşlaň däbi,
Ýekme-ýek gadymy ýowlaň erkegi.
Uruşdan goranmak mümkin däl çagy,
Şeýdip gandan gorapdyrlar serlerin.

Ýekme-ek.
Ýene jeň.
Goja serkerde
Asyndan geçirýär ýigitleň baryn:
«Ýeri, indi kime ynanyp biljek
Watanyň ykbalyn,
Halkyň ykbalyn?!»

Şahyryny jandan eý gören goja,
Ynam bilen şahyryna ümledi.
Ýurdun hiç gerçege ynanyp bilmän,
Duran Seýdiň ýüki şol dem ýeňledi.

Garpyşdy baýlyk hem Batana söýgi,
Gylyç syrdy jahalat hem adalat.
Seýdi ýalňyz däldi, ikidi Seýdi,
(Kimçe ýokmuş iýenleri halal at).

Durşuna Watana öwrülen şahyr,
Durşuna Ynama öwrülen şahyr.
Ýeňilmek bolanok, bolanok saňa,
Sen halkyň bagtynyň çözgüdi ahyr.
Saňa ejiz gelmek bolanok, Seýdi,
Saňa ýara salsa duşman gylyjy,
Ýyldyrym deý ýandyrdygy biläýgin,
Gana boýap Garabeki, Halajy...

Saňa bu söweşde synmak bolanok,
Atanlykda atdan agaýsaň eger,
Seriň belent tutan külli ärsary
Ýene matam tutup, bagryny ezer.

Aljyrama, şahyr,
Howlukma, şahyr,
Türkmen aty bardyr seniň astynda.
Sen ýeňersiň,
         çünki söweşýäs ahyr
Keramatly öz topragyň üstünde.
...Birden gowşap gitdi goja serkerde,
Heý, bu pursat aýdar ýaly söz bamy?
Çogup çykdy gabaklarnyň astyndan,
Gojaň begenjinden ýaňa gözýaşy:

«Atym al,
        adym al,
                gylyç-galkanym,
Seýitnazar — sen mertlere serkerde.
Gyljyň bilen ulus-ili gallagyn,
Şygryň bilen em bol iliň dertlerne».

              MONOLOG

Men diş gyssam ýüregimi iňleden,
Dünýäde tutuldy gün-u-aý imdi.
Gerçekleriň jeňe berip soňladan
Naçar ene, bozlap saçyň ýaý imdi.

Asman-zemin, meň halyma ses ediň.
Hany Haýdar oglum, hany Esenim?
Lebap kibi boşap galdy jesedim,
Akdy gözlerimden ganly çaý imdi.

Janym al, aýyrma jigerlerimden,
Namart dünýä tutma ejiz ýerimden,
Erkek bolsaň, dawa sal sen serimden,
Sen, gerçege däl ekeniň taý imdi.

Ýöne bir daýhan men, asuda günüň,
Jeňli gün – serkerdäň, eýäň men seniň.
Gör, duşman neýledi seni, mesgenim?
Seň günüňe, meň günüme waý imdi.

Betbagtlyk iberdiň meniň dadyma,
Zar eýlediň Lebabymyň adyna,
Ýandym, pelek, ýandym seniň oduňa,
Indi gel-de, doň ýüregiň çoý imdi.

                  ***

Esger ýetişmeýär ýigrimi ýylsyz,
Gör, näçe ýowy bar ýigrimi ýylyň?!
Seniň bir gün rahatlygyň deregine
Başyn goýdy san-sajaksyz ogulyň.

              A taryh diýeniň» ýigrimi ýyl däl,
              Türkmen, sada arzan düşmedi erkiň!
              Ýok, hasaplap bilmez telim bir Babel1
              Seň jeňiň sanyny,
              Sanyny merdiň.

              Düýäniň üstünde gurlan ýaşaýşyň,
              At üstünde dowam eden durmuşyň
              Hem synmadyk erkiň.
              Asudalygyn
              Azatlygyn rowaç eden durmuşyň,
              Keramat deý ýatlaýaryn her demde
              Mukaddes buýsanjym — Geçmişiň seniň.
              Saňa sejde edýän,
                      din-imanyn däl
              Topragyn hem erkin goran Türkmenim.

                             WESÝET

              Ýigit, baýlyk seniň nämäňe gerek?
              Ne bir itiň, ne bir ýalagyň bolsun.
              Dünýäde bol zadyň ýamagyň bolsun.
              Ýöne seniň ähli ýetmezňe derek,
              Bedew atyň bilen ýaragyň bolsun.
              Şu Watanyň bir parçasy kesilip,
              Gursagyňa salnan ýüregiň bolsun.

              Ýylba-ýyldan pese gaçsa-da ornuň,
              Ýylba-ýyldan seniň känelsin ogluň.
              Goý, seňki bolmasyn bediýan çölüň
              Süri-süri sygry, goýun, düýesi.

         Fransuz alymy. Ol dünýädäki uruşlaryň we pidalaryň hasabyny
çykarypdyr.',
    ''
);

SET FOREIGN_KEY_CHECKS = 1;
