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
VALUES ('Bahargül Mejidowa')
ON DUPLICATE KEY UPDATE name = VALUES(name);

SET @poet_id = (
    SELECT id
    FROM poets
    WHERE name = 'Bahargül Mejidowa'
    LIMIT 1
);


INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'GÜÝZ HOŞLAŞYP BARÝAR',
    'Gyzyl, sary, ýaşyl öwsüp,
Güýz hoşlaşyp gidip barýar.
Şahyrlaryň kalbyn böwsüp,
Güýz daşlaşyp gidip barýar.

Dözüp bolman gyş zarbyna,
Kaýyl boluplar aňzaga,
Meňzäp sary gül ýaglyga,
Güýz hoşlaşyp gidip barýar.

Sada, agras, akylly güýz,
Bir görseňem asylly güýz,
Gyş oýnundan basyldy güýz,
Güýz daşlaşyp gidip barýar.

Göýä aşygyndan ýanan,
Saralyp derdini ýeňen,
Kalba söýgi bolup siňen,
Güýz hoşlaşyp gidip barýar.

BAHAR BILEN BAGT

Müşk-anbaryň ysy kükeýip gelýär,
Bu bahar howasy – bagtyň howasy.
Bilbilleň joşguny bagryňy dilýär,
Bu bahar owazy – bagtyň owazy.

Daglardan buldurap çeşme-çaý akýar,
Günem öz nuruny äleme dökýär,
Gözeller näz edip, lälesin kakýar.
Bu bahar nagmasy – bagtyň nagmasy.

Sähramyza seýran edip geziler,
Gülälekler haly bolup ýazylar,
Bökjekleşip oýnar owlak-guzular,
Bu bahar howasy – bagtyň howasy.

Kalbyň al-asmanda – arşyň deňinde,
Bahar bilen bagt joşýar göwünde,
Adam özün baky saýýar bu günde,
Bu bahar dünýäsi – bagtyň dünýäsi.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'GABANMA',
    'Nirä baksam, gysganýarsyň gözlerim,
Çynyň bilen meni beýle gabanma!
Diňe saňa bagş eýledim näzlermi,
Çynyň bilen meni beýle gabanma!

Sözümde ýalan ýok, söýýänme ynan,
Söýgi berkemeýär bolmasa ynam.
Joşgunly kalbymy talaňa salan,
Çynyň bilen meni beýle gabanma!

Dünýe ýaly giň kalbymyň şasy sen,
Bu gudratly ylhamymyň joşy sen,
Şatlygym sen, gözlerimiň ýaşy sen,
Çynyň bilen meni beýle gabanma!

Sen diýip gursakda gürsüldär çepim,
Beýiklerden synla dünýäniň çetin,
Eger men gabansam, bolmaýar çakyň,
Çynyň bilen meni beýle gabanma!',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'SAŇA',
    'Dogrusy, men saňa näme diýeýin,
Neçüýn geldiň beýdip ynjytjak bolsaň?!
Kalbymdaky näzik duýgymy talap,
Neçüýn geldiň beýdip ynjytjak bolsaň?!

Az gördüňmi öňem ejizlän göwni,
Ençe ýyl gursakda düwülen düwni,
Ýadygärlik goýup, maňa bu güni,
Neçüýn geldiň beýdip ynjytjak bolsaň?!

Söýgiňi ýüregme ömrüme ýazdym,
Seni ömürboýy arzuwlap gezdim,
Meniň päk duýgyma neneňsi dözdüň,
Neçüýn geldiň beýdip ynjytjak bolsaň?!

Baharyň şemaly tersine öwsüp,
Gözýaşlar gussalaň böwedin böwsüp,
Aglaryn men kime derdimi egsip,
Neçüýn geldiň beýdip ynjytjak bolsaň?!',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'SÖÝGI – BAGT',
    'Seniň söýgiň meni bagta äkidýär,
Hem gursagma mähir guýýar müdimi.
Şeýlebir, şeýlebir joşasym gelýär,
Saňa duşdum, menem bagtly indi.

Başymdaky elwan öýmäň galgaýşy,
Bilseň, saňa çakylykdyr, ezizim!
Meni bagtyň gujagyna doldurýar,
Joşgunly baharym, söýgüli güýzüm.

Ak daňlar atanda Kuýaşyň dogşy,
Nurlandyrýar bagta barýan ak ýoly.
Iki bolup bir menzili külterläp,
Söýgi bilen bezäp barýas ykbaly.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'HALYPAM',
    'Ikimizem gözel dünýäň aşygy,
Bu ömrümiň bezegi Siz, halypam!
Allam bersin Göroglynyň ýaşyny,
Poeziýanyň ýüregi Siz, halypam!

Galamňyza mätäç her bir setirim,
Aklym haýran edýär güýçli pikiriň,
Bilmen, haçan deňiňize ýeterin,
Hemmeleriň geregi Siz, halypam!

Hemişe şadyýan güler ýüzüňiz,
Durşuna manydyr her bir sözüňiz,
Köplere halypa ýeke özüňiz,
Köňülleriň diregi Siz, halypam!',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'GARRAMAGA WAGT BARMY',
    'Garramaga wagt barmy dünýede,
Aýlar-ýyllar gözüň-başyň aýlap dur.
Söýülip, owadan ýaşamak üçin,
Aşyklary bir-birine taýlap dur.

Garramaga wagt barmy dünýede,
Gözellikden ganyp ýörkä göwünler.
Şaýat bolup ömrüňdäki şatlyga,
Ýene baky dowam eder bu günler.

Garramaga wagt barmy dünýede,
Gije-gündiz erkiň alýandyr duýgy.
Garramazlyk üçin, ölmezlik üçin,
Ýaşasyn arzuwlar, ýaşasyn söýgi!',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'GALAMDAŞLARYMA',
    'Men sizi şeýlebir göresim gelýär,
Siz bilen ýeňleýär gussaly göwnüm.
Biriň atam, biriň enem, biriň dost,
Siz bilen çözlenýär ýaraly düwnüm.

Ol sadaja ýüzlerňize bakamda,
Ýalňyzlygmy unudýaryn her gezek.
Durmuşda ojaklar aýra bolsa-da,
Göýä barymyzda urýar bir ýürek.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'SENDE SÖÝGI DÖRESE',
    'Dünýäň ala-ýaz bolar,
Sende söýgi dörese.
Ýüregiňde näz bolar,
Sende söýgi dörese.

Ýatdan çykar gam gussa,
Şatlyk artar müň esse,
Güller bogular desse,
Sende söýgi dörese.

Mähirlidir ýüzleriň,
Nurdan dolar gözleriň,
Dile geler sözleriň,
Sende söýgi dörese.

Garry bolsaň ýaş eder,
Derýa deýin joş eder,
Täsinlige duş eder,
Sende söýgi dörese.

Dok bolarsyň aç wagtyň,
Söýgä garaşýan wagtyň,
Bir gün açylar bagtyň,
Sende söýgi dörese.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'YŞK, SÖÝGI...',
    'Meň saňa bir zatlar aýdasym gelýär,
Pyşyrdadyp posa küýsän leblerim.
Göz öňümde gara gözleriň gülýär,
Men seniň söýgiňe mätäç, serwerim!

Meň saňa bir zatlar aýdasym gelýär,
Ýaz ýagşynyň damjalaryna öwrülip.
Bahar gaýtalanýar, ýaz gaýtalanýar,
Owal-ahyr seň söýgiňe ýugrulyp.

Meň saňa bir zatlar aýdasym gelýär,
Ýüregimi açyp, kalbymy açyp.
Ýollar geçen güni ýadyma salýar,
Eý, Hudaý, bu dünýäň gurluşy niçik?
Yşk, söýgi sen bolup köňlüme dolýar,
Meň saňa bir zatlar aýdasym gelýär.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'DÜNÝÄM',
    'Bu dünýe ajaýyp, bu dünýe gözel,
Sebäbi dünýäde sen bar-a, dünýäm!
Seň bilen durmuşym durşuna gazal,
Sebäbi dünýäde sen bar-a, dünýäm!

Säher turup, ýüze sylýan her güni,
Sowgat edýäň bagdan ýolup ter güli,
Bagt bile baky döwran sürmeli,
Sebäbi dünýäde sen bar-a, dünýäm!

Mähire ýugrulan, söýgä ýugrulan,
Maňa garap syrly bakýan nazarlaň,
Soňky güne çenli waspyň ýazar men,
Sebäbi dünýäde sen bar-a, dünýäm!',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'GARAŞÝAN',
    'Men saňa garaşýan umytly gije,
Aý yşgyndan syratyňy gözledim.
Ýyllaň gujagynda towlanyp her ýan,
Gözýaşymy özgelerden gizledim.

Men saňa garaşýan her gün, her säher,
Saýraýan bilbilleň owazyn diňläp.
Bilmedim, nireden ýetdi bu heser,
Kalbymyň hyjuwy joş urýar dyňzap.

Men saňa garaşýan goşgular ýazyp,
Setirlemde sandyraýar sözlerim.
Bir wagt sen hökman gelersiň diýip,
Penjireden garaşyp dur gözlerim.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'SAŇA GOÝUP GIDERIN',
    'Men sen diýip geçip giderin, bilýän,
Owalda maňlaýa ýazylandyr bu.
Men sen diýip öçüp giderin, dünýäm,
Nätjek-dä, köňülde galsa-da arzuw.

Ýyllar boýy arzuw eýledim seni,
Ýyllar boýy hyýal kölün boýladym.
Arzuwda ýaşamak oňat ekeni,
Seň adyňy ýerde-gökde goýmadym.

Ýene şeýle bolar, soňky deme çen
Seniň adyň bilen ýaşap öterin.
Meň ýyldyzym ýanar, ýanar-da, öçer,
Men söýgimi saňa goýup giderin.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'GEL SÖHBET EDELI',
    'Gel, ikimiz bile söhbet edeli,
Bagt hakda, söýgi hakda söz açyp.
Gel, ikimiz bile söhbet edeli,
Yşk diýlen zat kalpdan gitmesin öçüp.

Gel, ikimiz bile söhbet edeli,
Gyşyň buzun gursagmyzda eredip.
Çöşläli söýginiň syrly ýumagyn,
Bu älemiň gözelligne seredip.

Gel, ikimiz bile söhbet edeli,
Howasyndan ganyp tämiz säheriň.
Çemen bogup bagrymyza oýkaly,
Elwan göllerini ajap baharyň.

Gel, ikimiz bile söhbet edeli,
Aýrylmaly tä topraga siňýänçäk.
Bizi yşka salan söhbetimizi
Gutarmaly tä özümiz diňýänçäk.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'SEN HAKDA',
    'Nämüçin sen hakda oýlanyp ýörün,
Duýgulam goýanok erkime meni.
Aslynda sen maňa ýöne bir tanyş,
Dymmalygyň bilen örteme meni.

Nämüçin sen hakda oýlanyp ýörün,
Göz öňüme getirýärin keşbiňi.
Hyýalymda seň mähriňi küýsedim,
Çünki sen bezeýäň köňül köşgümi.

Nämüçin sen hakda oýlanyp ýörün,
Göwnüme ýüregim saňa has ýakyn.
Käte seniň bilen görüşen wagtym
Senden aýra düşmek maňa has-da kyn.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'SEN NIREDE?',
    'Sen nirede?
Umyt baglap ýörenim,
Alysdamy, ýakyndamy, ýanymda?
Göze görünmeýän täsin bir gudrat,
Oý-pikirmi, alňasaýan aňymda.

Sen nirede?
Hazyratly sandygym,
Saňa bagyşlaýyn dünýe barymy.
Seni gözläp pasyllarda aýlandym,
Basgylaplar ençe gyşyň garyny.

Sen nirede?
Ylhamymyň syrdaşy,
Goşgy ýazmagyma bolýarsyň sebäp.
Kä agladym, käte şatlandym sensiz,
Aşyk boldum, ataş kalbymda köräp.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'ÝARYŇ BOLUP GALAÝYN',
    'Şeýle bir bagtly geçýär günlerim,
Sen meniň ýanymda bolan pursatyň.
Söýgüden dolduryp köňül köşgümi,
Adyň tutup gürsüldeýär gursagym.

Ynjan göwnüm ganat baglap gaýyp ýör,
Tämizlenen gök asmanyň ýüzünde.
Söýen kalbym hiç erkime goýanok,
Ylham joşýar gök baýyrlaň düzünde.

Aýdym aýdýaň söýgimizi wasp edip,
Saýrasana, owazyňdan ganaýyn.
Öz dünýämi seň dünýäňe äkidip,
Ömürbaky ýaryň bolup galaýyn.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'SEN ÝOK',
    'Ýaşlyk geçip barýar gününi sanap,
Bir ýetmezim sen ýok meniň dünýämde.
Saňa kän garaşdym janymy gynap,
Bir ýetmezim sen ýok meniň dünýämde.

Gyşdan soň ýaz gelýär ajaýyp bolup,
Tomsuň jöwzasyna güllerim solup,
Güýz gelýär kalbymy heýjana salyp,
Bir ýetmezim sen ýok meniň dünýämde.

Şükür, ýeke balam durmuşda höwrüm,
Şoň bilen şatlykdan dolýandyr ömrüm,
Mähirden, söýgüden ganatly göwnüm,
Bir ýetmezim sen ýok meniň dünýämde.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'SEN MENI KÜÝSÄRSIŇ',
    'Sen meni küýsärsiň ýalňyz çagyňda,
Küýsärsiň bir zada begenen wagtyň.
Ýaşarsyň gaplanyp arzuw-hyýala,
Dünýäme dolanyp gelmejek bagtym.

Sen meni küýsärsiň, men ony bilýän,
Hem ýatlarsyň bala dönen günleri.
Şol pursat ejizlär mert bolan göwnüň,
Adymy tutarsyň ysgap gülleri.

Sen meni küýsärsiň soňky deme çen,
Gözlerimi göz öňüne getirip.
Bu pany dünýäde armanyň galar,
Gitseň-de sen mundan ömrüň ötürip.

Sen meni küýsärsiň baharda-ýazda,
Geçennem duýmarsyň ömüriň, wagtyň.
Bagtly pursatlar galypdyr yzda,
Wah, indi gujagma dolmajak bagtym.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'NÄDIP SÖÝMÄÝIN?!',
    'Sen diýip, gözlerim şatlykdan gülse,
Ezizim, men seni nädip söýmäýin?!
Sen diýip, ýüregim otlara salsa,
Ezizim, men seni nädip söýmäýin?!

Gursagymda ylham joşup gaýnasa,
Setirlemde söýgi sözlem aýnasa,
Göwnüm al-asmanda oýnap-ýaýnasa,
Ezizim, men seni nädip söýmäýin?!

Gyş gelýär küýsedip ýyly mähriňi,
Ýaz gelýär ýatladyp eden ähdiňi.
Bilseň, saňa aýap ýörün mährimi,
Ezizim, men seni nädip söýmäýin?!',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'SÜÝJI HEM AJY',
    'Dünýäde süýji zat näme diýseler,
Gülüp duran gara gözleň bakyşy.
Dünýäde ajy zat näme diýseler,
Şol gözleriň kalbym oda ýakyşy.

Dünýäde süýji zat näme diýseler,
Göwün beren ýaryň posa alyşy.
Dünýäde ajy zat näme diýseler,
Aşyklaryň ahy bilen nalyşy.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'GYŞ GELENDE',
    'Gyş gelende sowuk şemal öwsüp,
Küýseder söýgüli ýaryň mährini.
Seni posalarmyň howruna çoýup,
Gelseň, saňa siňdirerdim mährimi.

Gyş gelende suwlar doňar buz bolup,
Küýseder söýgüli ýaryň gujagny.
Söýgi bolup doldursana, ezizim,
Seniň üçin aýap ýören gujagmy.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'ÝAGYŞ ÝAGÝAR',
    'Ýagyş ýagýar, her damjasy bir hasrat,
Göýä meň derdimden habarly ýaly.
Daş-töwerek owaz edýär şybyrdap,
Kalbym soňlanmajak arzuwdan doly.

Ýagyş ýagýar, geçmişimi ýatladyp,
Ýalňyzlykda neneň geçer günlerim.
Tebigata gözelligni güjeňläp,
Ezilipdir al öwüsýän güllerem.

Ýagyş ýagýar, sepelenip asmandan,
Gözüm gidýär boşaýşyna bulutlaň.
A men bolsa ýaşap ýörün gaýgyda,
Çünki ykbal hasratymy gulplan.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'ADAMLAR',
    'Ýalňyzlykdan halys iripdir başym,
Maňa artyk sorag bermäň, adamlar.
Gybat gurşap aldy töwerek-daşym,
Maňa artyk sorag bermäň, adamlar.

Men zyba däl, ak ýürekli hem sada,
Gül ömrüm kül bolup ýanandyr oda,
Söýmesem-de, ýar etdiler bir ýada,
Maňa artyk sorag bermäň, adamlar.

Durmuş akymyndan dogry akmanym,
Köplere geň boldy meniň ykbalym,
Duşman gepi beterletdi ahwalym,
Maňa artyk sorag bermäň, adamlar.

Borçlumy men gizlemäge duýgymy,
Dost diýenim ogurlady söýgimi,
Goşgym bilen paýlaşýaryn gaýgymy,
Maňa artyk sorag bermäň, adamlar.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'BENTLER',
    '***

Söýsene sen meni öz söýşüm ýaly,
Bagryňa bas, gursagňa gys, goýberme!
Söýsene sen meni şu diýşim ýaly,
Hatda maňa söýmäge-de maý berme.

***

Umytly garaşdym seniň gelerňe,
Saňa duşdum, gözelleşdi bu dünýäm.
Ýüregimde syr sakladym üç sözi,
Aýdaýyn, ezizim: “Men seni söýýän!”

***

Seniň bilen geçen bagtly günlermi,
Ýatlanymda dolup gidýär damagym.
Bilýän baky gidemden soň dünýeden,
Ýaňaklarňa gözýaş bolup damaryn.

MAZMUNY

Maňa ýürekdeş bolsaň         3
Güýz hoşlaşyp barýar         4
Bahar bilen bagt             5
Gabanma                       6
Saňa                         7
Söýgi – bagt                  8
Halypam                      9
Garramaga wagt barmy        10
Galamdaşlaryma              11
Sende söýgi dörese          12
Yşk, söýgi                  13
Dünýäm                      14
Garaşýan                    15
Saňa goýup giderin          16
Gel söhbet edeli            17
Sen hakda                   18
Sen nirede                  19
Ýaryň bolup galaýyn         20
Sen ýok                     21
Sen meni küýsärsiň          22
Nädip söýmäýin              23
Süýji hem ajy               24
Gyş gelende                 25
Ýagyş ýagýar                26
Adamlar                     27
Bentler                     28

MEJIDOWA BAHARGÜL

     Goşgular

   Edebi-çeper neşir

  Türkmen dilinde',
    ''
);

SET FOREIGN_KEY_CHECKS = 1;
