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
VALUES ('Mollanepes')
ON DUPLICATE KEY UPDATE name = VALUES(name);

SET @poet_id = (
    SELECT id
    FROM poets
    WHERE name = 'Mollanepes'
    LIMIT 1
);


INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Dişleriňe',
    'Dür Derýadan çyka bilmez,
Nazar kylsa dişleriňe.
Dowzah meni ýaka bilmez,
Ýanyp men ataşlaryňa.

«Leýli-Şirin saňa taýdyr» –
Diýseler, ol söz bijaýdyr.
Elip deý kamatym ýaýdyr,
Sežde eýläp gaşlaryňa.

Bu dünýä hem ruzu-magşar,
Haýyr etseň haýyr, şer etseň şer,
Rahmet gökden ýerge düşer,
Degip gara saçlaryňa.

Çoh sygynmyşam özüňe,
Ýetmişem kelam sözüňe,
Mynasyp eýle ýazyňa,
Duçar etme gyşlaryňa.

Tapmaklykda müşgül kändir,
Tapmaslyk besi asandyr,
Bende men, aklym haýrandyr,
Sungatyňa, işleriňe.

Nepes diýer, çeker zaryň,
Mydam arzuw seň didaryň,
Jan pidasy, men seň ýaryň,–
Ýüzüm sürtsem daşlaryňa!

            2         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Zary bilen',
    'Toty tekellim bir peri,
Sözlär şeker zary bilen.
Şuňkar guşum bent eýlemiş,
Her zülpüniň tary bilen.

Görünse ýaryň gül ýüzi,
Oltursa gije-gündizi,
Ýar gelse tenha bir özi,
Gelmese agýary bilen.

Müşkün saçyn eýläp dügün,
Halymny eýläpdir zebun,
Razy men, öldürse bu gün
Goýnundaky nary bilen.

Bäh-bäh, ajaýyp simi-ten!
Oldur meni mejnun eden,
Aklykda bäs eýlär beden
Kyrk çilläniň gary bilen.

Her kim özün ram eýleýir,
Subhun anyň şam eýleýir,
Käpirni yslam eýleýir
Yzhary-güftary bilen.

            3          
Gähi nahal dek çyrmaşyp,
Kä öpüşip, kä guçuşyp,
Mollanepes diýr, ýantaşyp,
Oltursa öz ýary bilen.

            4          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Gülüstanyma',
    'Geldi galam gaşly gyz,
Jilwe kylyp ýanyma;
Kirpikleri tygma-tyg,
Geçer meniň janyma.

Men diýdim ki: «Roýy gül,
Hyzmatyňda bendi gul,
Gahryň goý-da, sabyr kyl,
Suwsan bolsaň ganyma».

Men diýdim ki: «Jan talaş,
Didäm döker ganly ýaş,
Bakmadyň-la bagry daş,
Haly perişanyma».

Bir şeýda bilbil bolsam,
Ýana-ýana kül bolsam,
Bir gije dahyl bolsam,
Täze gülüstanyma.

           5             ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ýar bir ýana, biz bir ýana',
    'Tiri-peýkamyn gizleýir,
    Gaş bir ýana, göz bir ýana.
    Dahanyn açyp sözleýir,
    Dil bir ýana, söz bir ýana.

    Hazan aýrylmaz gülümden,
    Bir gazal ýazdym tilimden,
    Ýaşylbaş uçdy kölümden,
    Suw bir ýana, gaz bir ýana.

    Söwdügim gözümden uçdy,
    Baryp rakyplara düşdi,
    Bir söý bile aýrylyşdy—
    Ýar bir ýana, biz bir ýana.

    Bezenşip janym alarlar,
    Görenler haýran galarlar,
    Ýasaw edip sallanarlar,
    Gelin bir ýana, gyz bir ýana.

    Gulak goýuň üşbu zara,
    Sözlesin Nepes biçäre,
    Dildi bagrymy set para,
    Tyg bir ýana, duz bir ýana.

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
    'Gitdim',
    'Gara gözüň, galam gaşyň
Tirdir diýip, gaçdym gitdim.
Ýalpyldysyn gara saçyň
Mardyr diýip, uçdum gitdim.

Aşyk bolup, hiç gezmeýen,
Lebni bilmez, gant ezmeýen,
Daň-säherler hiç dözmeýen,
Gül dek ýüzüň açdym gitdim.

Bilbil söýer bagyň gülün,
Magşuk darar ol sünbülin,
Dura bilmän, ýaryň bilin
Emaý bilen guçdum gitdim...

Ýatypdyr, ak gol ýassanyp,
Ýüpek mahmallar üssenip,
Gapyny açdym gyssanyp,
Rahmet nuryn saçdym gitdim.

Reýhan göwni hoşdur ýazdan,
Köl kaýyldyr guba gazdan,
Müň gelinden, ança gyzdan
Şol perimni seçdim gitdim.

             7          
Dürler saçar ýar dahandan,
Müň geler hünär zybandan,
Nepes diýer, bu jahandan
Ýary taşlap, geçdim gitdim.

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
    'Mollanepes',
    'diýr, ýantaşyp,
Oltursa öz ýary bilen.

            4          
 Gülüstanyma
Geldi galam gaşly gyz,
Jilwe kylyp ýanyma;
Kirpikleri tygma-tyg,
Geçer meniň janyma.

Men diýdim ki: «Roýy gül,
Hyzmatyňda bendi gul,
Gahryň goý-da, sabyr kyl,
Suwsan bolsaň ganyma».

Men diýdim ki: «Jan talaş,
Didäm döker ganly ýaş,
Bakmadyň-la bagry daş,
Haly perişanyma».

Bir şeýda bilbil bolsam,
Ýana-ýana kül bolsam,
Bir gije dahyl bolsam,
Täze gülüstanyma.

           5             
Ýar bir ýana, biz bir ýana
    Tiri-peýkamyn gizleýir,
    Gaş bir ýana, göz bir ýana.
    Dahanyn açyp sözleýir,
    Dil bir ýana, söz bir ýana.

    Hazan aýrylmaz gülümden,
    Bir gazal ýazdym tilimden,
    Ýaşylbaş uçdy kölümden,
    Suw bir ýana, gaz bir ýana.

    Söwdügim gözümden uçdy,
    Baryp rakyplara düşdi,
    Bir söý bile aýrylyşdy—
    Ýar bir ýana, biz bir ýana.

    Bezenşip janym alarlar,
    Görenler haýran galarlar,
    Ýasaw edip sallanarlar,
    Gelin bir ýana, gyz bir ýana.

    Gulak goýuň üşbu zara,
    Sözlesin Nepes biçäre,
    Dildi bagrymy set para,
    Tyg bir ýana, duz bir ýana.

                 6          
        Gitdim
Gara gözüň, galam gaşyň
Tirdir diýip, gaçdym gitdim.
Ýalpyldysyn gara saçyň
Mardyr diýip, uçdum gitdim.

Aşyk bolup, hiç gezmeýen,
Lebni bilmez, gant ezmeýen,
Daň-säherler hiç dözmeýen,
Gül dek ýüzüň açdym gitdim.

Bilbil söýer bagyň gülün,
Magşuk darar ol sünbülin,
Dura bilmän, ýaryň bilin
Emaý bilen guçdum gitdim...

Ýatypdyr, ak gol ýassanyp,
Ýüpek mahmallar üssenip,
Gapyny açdym gyssanyp,
Rahmet nuryn saçdym gitdim.

Reýhan göwni hoşdur ýazdan,
Köl kaýyldyr guba gazdan,
Müň gelinden, ança gyzdan
Şol perimni seçdim gitdim.

             7          
Dürler saçar ýar dahandan,
Müň geler hünär zybandan,
Nepes diýer, bu jahandan
Ýary taşlap, geçdim gitdim.

             8          
   Mollanepes
Gaflat ukusynda galdyň,
Oýan imdi, Mollanepes!
Kä sargaryp, kähi solduň,
Oýan imdi, Mollanepes!

Hijran bile bagr daglaşar,
Seni görsem diýp çaglaşar,
Söwer ýaryň çoh aglaşyr,
Oýan imdi, Mollanepes!

Bu dünýäge dürler doldy,
Aýlar ýaşdy, günler galdy,
Turgul imdi, wagt boldy,
Oýan imdi, Mollanepes!

Bir ýar geldi alma-narly,
Bilbil zenahdan, güftarly,
Gaflat ukusynda zarly
Galdyň, oýan, Mollanepes!

Sen çekip sen köp pyraky,
Bu dünýä imesdir baky,
Ýaradypdyr hijran oky, —
Degdi, oýan Mollanepes!

            9          
Ýad eýlegil sewer ýary,
Ak göwsünde alma, nary,
Çolanmyşdyr zülpi-tary...
Oýan imdi, Mollanepes!

Gara gözler seň kastyňa,
Mahmal ýazdy ýar astyňa,
Ala öýme, al üstüňe
Atdy, oýan, Mollanepes!

Ýeter erte magşar güni,
Gagşadar janlary, teni,
Ýar ukuda diýip, seni
Öpdi, oýan, Mollanepes!

Sen galyp sen ýürek daglap,
Biliňni hijrana baglap,
Ýufar alyp, köp sylaglap,
Sepdi, oýan, Mollanepes!

Nepes, gelgin sen huşuňa,
Köp oýun geler başyňa,
Emaý bilen ýar daşyňa
Duzak gurdy, Mollanepes!

           10          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Rähm etmezmiň halyma',
    'Ýandyrdyň, köýdürdiň, näzli dildarym,
Eý binurbat, rähm etmezmiň halyma?
Rast kamaty serwi, çeşmi-hunhorym,
Helal gaşyň ogşamazmy kemana?

Intizaram görjek, eý peri-peýker,
Husnuň mähtajydyr mahy-minewwer,
Örüm-örüm saçyň – owsunjy aždar,
Hurşyt ýüzüň ogşar genji-nahana.

Serhowza gonmuşdyr bir ajap sona,
Gördüm, talaň düşdi ömrüm köşküne,
Gyýa bakyp, timar berip zülpüne,
Bir elinde aýna, bir elde şana.

Seýran edip gezdim niçe kent bilen,
Habaryň almyşam Hezarant bilen,
Gezdim Buhar şährin Samarkant bilen,
Düşmüş owazasy jümle jahana.

Halaýyk hyzmagda sap-sap dursalar,
Hyrydar gymmatyň gelip sorsalar,
Her zülpüňe müň gul baha goýsalar,
Kim alsa, bähbitdir, galmaz zyýana.

                 11         
Saňa aşyk bolan ýanar, kül bolar.
Zulmuňa dözmeýän namyrat galar.
Gözümiň degresi möwç urup dolar
Gündizler – ýaş bilen, gijeler gana...

Nepes diýer, yşkyň ýandyrdy bizi,
Janymny alypdyr laglynyň sözi,
Teke, ýomut, ärsary – türkmeniň gyzy –
Barysy gurbandyr bir Durdy hana.

                  12           ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Hiç görmedim illerde',
    'Keşt edip gezmişem pany jahany,
Sen deý gözel hiç görmedim illerde;
Köňlümiň aramy, menzil-mekany,
Şeýda köňül joşmaz özge güllerde.

Il husnuňa dahyl, görmäge zar men,
Yşgyňda bahar men, köýüňde nar men.
Tä ölinçäm seniň ýoluň garar men,
Ryzwan kimin gözüm galdy ýollarda.

Säher seýle çyksa, ger tökse siller,
Owsunar her ýana, tutukdyr tiller,
Zerefşan gulpagy, syýa käkiller,
Çöşse ýere düşer, örseň billerde.

Nergiz gaşyň, helal gözüňe gurban,
Adyň zikr etmäge dilde ýok perman,
Bir janym bar, müň derdim bar, sen derman,
Jismim ot içinde, ýaşym sillerde.

Mis özün deň etmiş simu-zer bilen,
Muş barabar bolmuş murgy-per bilen
Zäher hemra bolmuş bir şeker bilen,
Enwer ebr içinde, göwher köllerde.

                   13          
Elwan geýip, gyýa-gyýa bakar sen,
Zerewşan zülpuňi ýere döker sen,
Seýle çyksaň, ak jeren dek böker sen,
Jeren hem sen kimin bökmez çöllerde.

Nepes diýr, adatdyr, möwç urup joşma,
Aşyga humardyr ogryn garaşma,
Hem jilwe, hem gamza, näzu-kereşme
Mekan tutmuş göz-gaşyňda, gollarda.

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
    'Heserli',
    'Näzenin kamatyň, güler ýüzleriň
Bir nowça nahaldyr gülli, semerli.
Piste dodaklaryň, bal agyzlaryň
Altyn piýaladyr gandu-şekerli.

Ak gollar synada tapmyş kemaly,
On barmakda ýüzük lagl mysaly,
Serinde ebrişim, egninde aly,
Sylaý gerdenleriň tylla tumarly.

Zülpüň meňzär leňkebudyň taryna,
Göwsüň meňzär kyrk çilläniň garyna,
Gözeller haýrandyr kesbi-kärine,
Bir jady tilsimli, goly hünärli.

Nepes diýer kä aglar men, güler men,
Gähi açylar men, gähi solar men,
Gähi diriler men, gähi öler men,
Yşkyň ýoly ajap ýoldur heserli.

                 15          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Badam gabaklaryňdan',
    'Sapaly söwdügim, gül ýüzli ýarym,
Aýlanaýyn badam gabaklaryňdan.
Boýlaryň tubydyr, kamatyň ar-ar,
Gol uzadyp tutsam pudaklaryňdan.

Seniň husnuň hergiz gözümden gitmez,
Her niçe dalbynsam, saňa gol ýetmez,
Sen bolmasaň Aý, Gün, älem ýarytmaz,
Röwşen tapar gözüm ýaňaklaryňdan.

Gaşyňny kakyban, gözüň güldir sen,
Iba bilen aşyk küňlün doldyr sen,
Näz eýleýip, asta-asta ýylgyr sen,
Zenehdan bildir sen eňekleriňden.

Köňlüňni sowutma, söwdügim, bizden,
Umydymyz köpdür, dildarym, sizden,
Däne-däne hal çykypdyr gül ýüzden,
Örtener men emsem bulaklaryňdan.

Nepes diýer, bakyp oltur ýüzüme,
Özüm bilmen, aýp eýleme sözüme,
Şemsi kamar görünmezmiş gözüme,
Bir şöhle düşmüşdir sahaklaryňdan.

                16         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ol ýylan',
    'Gara gözdür aşyklaryň guwanjy,
Guran sözüň hasta janyň söýenji,
Iki şamar saklap ýatyr bir genji,
Genç üstünde halka guran ol ýylan.

Men saňa aşyklyk lybasyn saldym,
Niçe ýyl ugruňda saralyp, soldum,
Mejnun deýin jismim otlarga saldym,
Synalarmy göz-göz eden ol ýylan.

Gara gözüň jan almagyň kastynda,
Bilbil mesgen tutmuş gülüň üstünde,
Bir jüp ýylan ýatyr göwsüň üstünde,
Synalarmy göz-göz eden ol ýylan.

Käte öýmesini başyna orap,
Käte şana bilen zülplerin darap,
Aşygyna jilwe berip, bir garap,
Synalarmy göz-göz eden ol ýylan.

Nepes diýer, işim ahy-sert bilen,
Iş salyşsaň bir töwekgel mert bilen,
Jan agalar, bir muşakgat dert bilen,
Synalarmy göz-göz eden ol ýylan.

                 17         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Näzli ýar',
    'Gara saçyň gije diýip, uklap men,
Gündiz eken, çoh armanym, näzli ýar!
Saba-säher wagty diýip, çaklap men,
Çeşmim açsam, arman eken, näzli ýar!

Gel, görüşseň keramatly goluňdan,
Aýlanaýyn dahanyňdan, tiliňden,
Gahar etme, golum salsam biliňden,
Ataşgähi sen, suzanym, näzli ýar!

Tarypyn eşitdim gara gözüňniň,
Gedasy men, dostum, güler ýüzüňniň,
Zybandan aýrylan her bir sözüňniň,
Kesgil başym, men gurbany, näzli ýar!

Nepes diýer, yşkym hetden aşypdyr,
Tomaşaňa ulug iller üýşüpdir,
Gözüm açsam, aýym-günüm ýaşypdyr.
Zyndan boldy giň jahanym, näzli ýar!

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
    'Ýaý imdi',
    'Wysalyndan gamgyn köňlüm açyldy,
Pyrkatyndan elip kaddym ýaý imdi.
Ýüzüň nury älem ara saçyldy,
Hergiz dogmaz özüň kimin aý imdi.

Muştakdyr roýuňa bu dünýä pany,
Ýoluňda gedadyr hanlaryň hany,
Keşt eýledim on sekiz müň jahany,
Hiç tapmadym bir zülpüňe taý imdi.

Säher ýeli zülpuň perişan eder,
Gamzaň okdur, jiger bagrym gan eder,
Görse bizi şum rakyplar taň eder,
Gyz, eýlegin öz goýnuňda jaý imdi.

Senden özge ýary gözüm görmesin,
Sensiz zowky alla maňa bermesin.
Sen bolmasaň, dünýä bir dem durmasyn,
Ýykym-ýumrum bolsa, diýmen «waý» imdi...

Nepes diýr, bir ýara bilim baglar men,
Aryf özüm, dost-duşmany saglar men,
Tä ölinçäm, Durdyhal diýp aglar men.
Gözlerimden dolup aksyn çaý imdi.

                 19          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ýadyma düşdi',
    'Nägehan gezerdim güli-gülşende,
Gülgün ýaňaklaryň ýadyma düşdi;
Alma enaryna gözüm düşende,
Alma ýaňaklaryň ýadyma düşdi.

Hijr elinden çekdim pygany-nala,
Elip dek kamatym ogşady dala,
Arzuw eýläp ýete bilmen wysala,
Aýralyk çaglaryň ýadyma düşdi.

Ýüzleriň şemygdyr, syýa käkiller,
Saçlaryň manendi mary-sünbüller,
Çemenler baglandy, jemyg oldy güller,
Başdan aýaklaryň ýadyma düşdi.

Seniň hesretiňden sargaryp soldum,
Jebri-tygyň bilen bagrymy dildim,
Ýüz müň arman bilen senden aýryldym,
Ol gezen jaýlaryň ýadyma düşdi.

Misli dogan aý dek göksüňniň agy,
Ganymdan reň tapmyş destiň boýagy,
Çar tarap dartylmyş serwi pudagy,
Hasa gujaklaryň ýadyma düşdi.

                20         
Nepes diýer, bagrym daglar içinde,
Bezm eýlesem ak otaglar içinde,
Badam kemal tapmyş baglar içinde,
Badam gabaklaryň ýadyma düşdi.

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
    'Gyz-gelniň aýdyşygy',
    'Bir gyz bilen bäs eýleýir bir gelin,
Gelin aýdar: «Husnum erem bagydyr;
Aşyk ähli tirsem diýer ter gülüm,
Aşyk bolan bir-birine ýagydyr».

Gyz hem aýdar: «Ýüzüm hurşydy-hawer,
Husnum mähtäjidir mahy-münewwer,
Uzyndyr boýlarym serwi-senuber,
Ýaşym on dört, hup mestana çagydyr».

Gelin aýdar: «Meniň söhbedim süýji,
Ança ýigitlerniň başynyň täji,
Gyýa-gyýa baksam, gözümiň ujy
Gören aşyklaryň aklyn dagydyr.»

Gyz hem aýdar: «Älem ýakar näzlerim,
Beklegli gunça dek bolsam özlerim.
Indi ger açylsa bahar ýazlarym,
Baglaryň sünbüli zülpüm dagydyr».

Gelin diýr: «Bezensem müň dürli elwan,
Görmäge ajyzdyr hurşydy-taban,
Aşyk synasynda ýaradyr çendan,
Nerkes gözlerimiň goýan dagydyr».

                 22         
Gyz hem aýdar: «Gelin maňa taý degil,
Goýnum bir jennetdir, özge jaý degil,
Deň görüngen täze dogan aý degil,
Ýakamdan görünen göwsüm agydyr».

«Gel, gyz, bäs eýleme sen meniň bilen,
Jahyllar janyna men otlar salan,
Kamatym barabar tubylar bilen,
Leblerim açylan gül ýapragydyr».

Gyz hem aýdar: «Husnum elem peýwendi,
Alynmyş geliniň galasy, kendi.
Abatdyr şährimiň müftahy-bendi,
Synam köp arzyly şa otagydyr».

Gelin aýdar: «Indi haýran olup men,
Seniň bu sözüňe teslim kylyp men.
Özüm satyp, ýüzläp tümen alyp men,
Goç ýigitnin seýran eden çagydyr».

Nepes diýer bizge barabar bary,
Serden çykmaz gyz-geliniň humary,
Ikiňiz hem täze bagyň gülzary,
Baglaryň açylgan gül pudagydyr.

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
    'Aňsa',
    'Hindiniň awçysy çyksa şikäre,
Özge aw islemez, pil sesin aňsa;
Otag ören bolsa bilbili-zara,
Otaga ot salar, gül sesin aňsa.

Jereniň balasyn baksaň, bejerseň,
Suw ýerine şeker-şerbetler berseň,
Höregne gül berip, bir güni görseň,
Watandan el gögär, çöl sesin aňsa,

Gündize gün zynat, gijäge – mahtap,
Kümüş zäge mätäç, altyna – simap,
Derýa görki mähek hem dürri-naýap,
Bilur röwşen tapar, kül sesin aňsa.

Harsydünýä söýer teňňäni, maly,
Bir gün bitap bolup, gitse mejaly,
Dönüp-deprenmäge bolmasa haly,
Galar garysyna, pul sesin aňsa.

Jelep karar etmez ýeke är bilen,
Dostun görse, bolmaz kesbi-kär bilen,
Ýola gelmez taýak bilen, zor bilen,
Ýagşy zen daş gaçar, gel sesin aňsa.

                  24         
Gula döwlet gelse bilmez agasyn,
Nakyldyr: har semrär – deper eýesin,
Kyrk çillede görseň doňuz çagasyn,
Bükürdi urar gaçar jul sesin aňsa.

Ýagşy zen suhanwer, bolsa sypaýy,
Ýüzi misli mahtap, on tördi aýy,
Gaçar bethüýlerden söz guran saýy,
Çyrag iba kylar, ýel sesin aňsa.

Bedasylyň köňli açylar, şer diýseň,
Hergiz gitmez, il derdine ýör diýseň.
Bahyllaryň jany çykar, ber diýseň,
Täzeden jan geler, al sesin aňsa.

Karun mülkün alsa bir är ýa tişi,
Pulum az diýr, her gün çeker käýişi,
Nuhuň ömrün hasyl etse bir kişi,
Ýakmaz gulagyna, öl sesin aňsa.

Nepes, sen sözleseň ulus illerde,
Bilbil şeýda bolar täze güllede,
Asal ezgil dahan içre tillerde,
Ary hüjüm eýlär, bal sesin aňsa.

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
    'Oýanmadyň',
    'Ýolum düşdi, geldim seniň gapyňa,
«Ýar, oýangyl» diýdim, sen oýanmadyň.
It-guş ah eýledi kylan zaryma,
Ýatanlar oýandy, sen oýanmadyň...

Daň-säherde öwser sabanyň ýeli,
Men bilbilem, ýat eýlerem ol güli,
Deňim-duşum aýdar: nedir hyýaly?
Syrym paş eýledim, ýar, oýanmadyň.

Gije garaňkydyr, gözlerim görmez,
Hyýalym keç boldy, pikirim ýörmez,
Ýagşydan, ýamandan ýarym ses bermez,
Gulagyň ker boldy, ýar, oýanmadyň.

Bir guş geldi, gondy tüýnük ustüne,
Nazar saldy akja öýüň astyna,
Ganat ýaýdy, gitdi älem pestine,
Ýatan guş oýandy, ýar, oýanmadyň.

Gapysyna geldim, görsem diýp ýüzün,
Hassa men, eşitsem ol şirin sözün,
Dünýäge taý görmen, ýar gara gözüň,
Gözlerim kör boldy, ýar, oýanmadyň.

                 26         
Şykyrt edip, ýel oýnaýar işigin,
Söndüripdir men pakyryň yşygyn,
Magşuk imdi ýada salmaz aşygyn,
Biwepa garaşdym, ýar, oýanmadyň.

Daň ýyldyzy dogdy, jahan ýagtyldyp,
Men pakyr durar men gapysyn alyp,
Oýatmaz ukudan daň ýeli çalyp,
Daň şemaly turdy, ýar, oýanmadyň.

Ne bolupdyr saňa, beýle ýatyp sen?
Pikir bilen gam laýyna batyp sen,
Öz söwdügiň ýowuz derde satyp sen,
Ýusup deý gider men, ýar, oýanmadyň.

Aşyk diýsem, kime gulagyn goýar,
Ýaşyrsam syrymny, ulus-il duýar,
Hudaýym, ýar haçan ukudan doýar,
Yns-jyns doýandyr, ýar, oýanmadyň.

Nepes diýer, indi giderem mundan,
Daň şemaly öter bu ýektaý dondan,
Imdi gol göterdim, ýar, menem senden,
Uzyn gije ötdi, ýar, oýanmadyň...

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
    'Berkarar bolsun',
    'Bizden salam bolsun Garaoglan hana,
Döwletiň eliňde berkarar bolsun.
Arap at, goç ogul, zynatdyr saňa,
Söýmek, münmek saňa ygtyýar bolsun.

Dünýä pany saraý, başga jaý degil,
Müň ýyldyz jem bolsun, dogan aý degil,
Dünýä ýalan, her haryslar han degil,
Her ýerde seýranyň lälezar bolsun.

Gelinler gaşyňda gaşlary ýaýdyr,
Her haýsy bir surat, Gün bilen Aýdyr,
Ak öýüň otagydyr, tagtdyr, saraýdyr,
Seniň bu destgähiň kimde bar bolsun.

Riýaýy mollalar sözlär ýetişmän,
Ol sözünden taňla köp eder puşman,
Pil bolsa hasymyň ger bolsa duşman,
Gaşyňda peşe dek bimydar bolsun.

Zynat üçin gelmiş pany jahana,
Hasanat depderiň çykmyş asmana,
Çar tarapdan gelen azyz myhmana,
Geýip, iýip-içmek ygtyýar bolsun.

                 28         
Iki dünýä alla bersin myradyň,
Arşyň her künjünde ýazylmyş adyň,
Tilinde zikri sen ýakynyň-ýadyň,
Hakyň söwer guly medetkär bolsun.

Her kim zyýan kylsa sud-y-suz bilen,
Gara köňül bilen, sadyk söz bilen,
Bir duşman gözlese ýaman göz bilen,
Tilleri lal bolsun, gözi kör bolsun.

Özüň deýin bolmaz deňi-duşuňda,
Döwlet guşy mekan tutmyş başyňda,
Her iş tutsaň nazaryňda gaşyňda,
On iki ymam gaýyp gerek er bolsun.

Ruzy magşar sünnileriň ýarydyr,
Garyplar gamhory, howandarydyr,
Senden dogan ogul äriň äridir,
Ondan dogan ogul meger är bolsun.

Ryzkyň bostanynda açylmyş rizwan,
Bäş gün miýesserdir bu döwri, döwran,
Ýigitlik çagynda eýleseň seýran,
Dowamat düýrdügiň alma-nar bolsun.

Nepes diýr, halka, ýara sözüm ýok,
Bir näkesem, gaýratym ýok, püzüm ýok,
Mydam gaflatda men, gyşym-ýazym ýok,
Gamhorum kerem bagş, biribar bolsun.

                 29         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Biten gyz',
    'Bag Eremde, gül-gülüstan içinde
Gudrat bilen bir şahada biten gyz.
Waspyňny ýaza men destan içinde,
Örme saçyň ak mämäňe ýeten gyz.

Seniň kimin gözel bolmaz jahanda,
Tamam hur-periler husnuňa bende,
Leýliniň sypaty bar eken sende,
Bu gün yşkyň söwdasyna batan gyz.

Boýuň şejerge ogşar, ýüzüň zülala,
Dişiň düre meňzär, lebleriň bala,
Bagty gelse, ýagşy-ýaman bir gula
Kadyr özi ryzky-rozun çatan gyz.

Nepes diýer, on üç, on dört ýaşynda,
Gara gotaz, altyn gupba başynda,
Ýüze gülap sürtup, wesme gaşynda,
Gyrmyz geýip, dildarlyga ýeten gyz.

                 30          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Köňlüm',
    'iň aramy, menzil-mekany,
Şeýda köňül joşmaz özge güllerde.

Il husnuňa dahyl, görmäge zar men,
Yşgyňda bahar men, köýüňde nar men.
Tä ölinçäm seniň ýoluň garar men,
Ryzwan kimin gözüm galdy ýollarda.

Säher seýle çyksa, ger tökse siller,
Owsunar her ýana, tutukdyr tiller,
Zerefşan gulpagy, syýa käkiller,
Çöşse ýere düşer, örseň billerde.

Nergiz gaşyň, helal gözüňe gurban,
Adyň zikr etmäge dilde ýok perman,
Bir janym bar, müň derdim bar, sen derman,
Jismim ot içinde, ýaşym sillerde.

Mis özün deň etmiş simu-zer bilen,
Muş barabar bolmuş murgy-per bilen
Zäher hemra bolmuş bir şeker bilen,
Enwer ebr içinde, göwher köllerde.

                   13          
Elwan geýip, gyýa-gyýa bakar sen,
Zerewşan zülpuňi ýere döker sen,
Seýle çyksaň, ak jeren dek böker sen,
Jeren hem sen kimin bökmez çöllerde.

Nepes diýr, adatdyr, möwç urup joşma,
Aşyga humardyr ogryn garaşma,
Hem jilwe, hem gamza, näzu-kereşme
Mekan tutmuş göz-gaşyňda, gollarda.

                 14          
            Heserli
Näzenin kamatyň, güler ýüzleriň
Bir nowça nahaldyr gülli, semerli.
Piste dodaklaryň, bal agyzlaryň
Altyn piýaladyr gandu-şekerli.

Ak gollar synada tapmyş kemaly,
On barmakda ýüzük lagl mysaly,
Serinde ebrişim, egninde aly,
Sylaý gerdenleriň tylla tumarly.

Zülpüň meňzär leňkebudyň taryna,
Göwsüň meňzär kyrk çilläniň garyna,
Gözeller haýrandyr kesbi-kärine,
Bir jady tilsimli, goly hünärli.

Nepes diýer kä aglar men, güler men,
Gähi açylar men, gähi solar men,
Gähi diriler men, gähi öler men,
Yşkyň ýoly ajap ýoldur heserli.

                 15          
 Badam gabaklaryňdan
Sapaly söwdügim, gül ýüzli ýarym,
Aýlanaýyn badam gabaklaryňdan.
Boýlaryň tubydyr, kamatyň ar-ar,
Gol uzadyp tutsam pudaklaryňdan.

Seniň husnuň hergiz gözümden gitmez,
Her niçe dalbynsam, saňa gol ýetmez,
Sen bolmasaň Aý, Gün, älem ýarytmaz,
Röwşen tapar gözüm ýaňaklaryňdan.

Gaşyňny kakyban, gözüň güldir sen,
Iba bilen aşyk küňlün doldyr sen,
Näz eýleýip, asta-asta ýylgyr sen,
Zenehdan bildir sen eňekleriňden.

Köňlüňni sowutma, söwdügim, bizden,
Umydymyz köpdür, dildarym, sizden,
Däne-däne hal çykypdyr gül ýüzden,
Örtener men emsem bulaklaryňdan.

Nepes diýer, bakyp oltur ýüzüme,
Özüm bilmen, aýp eýleme sözüme,
Şemsi kamar görünmezmiş gözüme,
Bir şöhle düşmüşdir sahaklaryňdan.

                16         
           Ol ýylan
Gara gözdür aşyklaryň guwanjy,
Guran sözüň hasta janyň söýenji,
Iki şamar saklap ýatyr bir genji,
Genç üstünde halka guran ol ýylan.

Men saňa aşyklyk lybasyn saldym,
Niçe ýyl ugruňda saralyp, soldum,
Mejnun deýin jismim otlarga saldym,
Synalarmy göz-göz eden ol ýylan.

Gara gözüň jan almagyň kastynda,
Bilbil mesgen tutmuş gülüň üstünde,
Bir jüp ýylan ýatyr göwsüň üstünde,
Synalarmy göz-göz eden ol ýylan.

Käte öýmesini başyna orap,
Käte şana bilen zülplerin darap,
Aşygyna jilwe berip, bir garap,
Synalarmy göz-göz eden ol ýylan.

Nepes diýer, işim ahy-sert bilen,
Iş salyşsaň bir töwekgel mert bilen,
Jan agalar, bir muşakgat dert bilen,
Synalarmy göz-göz eden ol ýylan.

                 17         
           Näzli ýar
Gara saçyň gije diýip, uklap men,
Gündiz eken, çoh armanym, näzli ýar!
Saba-säher wagty diýip, çaklap men,
Çeşmim açsam, arman eken, näzli ýar!

Gel, görüşseň keramatly goluňdan,
Aýlanaýyn dahanyňdan, tiliňden,
Gahar etme, golum salsam biliňden,
Ataşgähi sen, suzanym, näzli ýar!

Tarypyn eşitdim gara gözüňniň,
Gedasy men, dostum, güler ýüzüňniň,
Zybandan aýrylan her bir sözüňniň,
Kesgil başym, men gurbany, näzli ýar!

Nepes diýer, yşkym hetden aşypdyr,
Tomaşaňa ulug iller üýşüpdir,
Gözüm açsam, aýym-günüm ýaşypdyr.
Zyndan boldy giň jahanym, näzli ýar!

                 18         
            Ýaý imdi
Wysalyndan gamgyn köňlüm açyldy,
Pyrkatyndan elip kaddym ýaý imdi.
Ýüzüň nury älem ara saçyldy,
Hergiz dogmaz özüň kimin aý imdi.

Muştakdyr roýuňa bu dünýä pany,
Ýoluňda gedadyr hanlaryň hany,
Keşt eýledim on sekiz müň jahany,
Hiç tapmadym bir zülpüňe taý imdi.

Säher ýeli zülpuň perişan eder,
Gamzaň okdur, jiger bagrym gan eder,
Görse bizi şum rakyplar taň eder,
Gyz, eýlegin öz goýnuňda jaý imdi.

Senden özge ýary gözüm görmesin,
Sensiz zowky alla maňa bermesin.
Sen bolmasaň, dünýä bir dem durmasyn,
Ýykym-ýumrum bolsa, diýmen «waý» imdi...

Nepes diýr, bir ýara bilim baglar men,
Aryf özüm, dost-duşmany saglar men,
Tä ölinçäm, Durdyhal diýp aglar men.
Gözlerimden dolup aksyn çaý imdi.

                 19          
      Ýadyma düşdi
Nägehan gezerdim güli-gülşende,
Gülgün ýaňaklaryň ýadyma düşdi;
Alma enaryna gözüm düşende,
Alma ýaňaklaryň ýadyma düşdi.

Hijr elinden çekdim pygany-nala,
Elip dek kamatym ogşady dala,
Arzuw eýläp ýete bilmen wysala,
Aýralyk çaglaryň ýadyma düşdi.

Ýüzleriň şemygdyr, syýa käkiller,
Saçlaryň manendi mary-sünbüller,
Çemenler baglandy, jemyg oldy güller,
Başdan aýaklaryň ýadyma düşdi.

Seniň hesretiňden sargaryp soldum,
Jebri-tygyň bilen bagrymy dildim,
Ýüz müň arman bilen senden aýryldym,
Ol gezen jaýlaryň ýadyma düşdi.

Misli dogan aý dek göksüňniň agy,
Ganymdan reň tapmyş destiň boýagy,
Çar tarap dartylmyş serwi pudagy,
Hasa gujaklaryň ýadyma düşdi.

                20         
Nepes diýer, bagrym daglar içinde,
Bezm eýlesem ak otaglar içinde,
Badam kemal tapmyş baglar içinde,
Badam gabaklaryň ýadyma düşdi.

               21         
  Gyz-gelniň aýdyşygy
Bir gyz bilen bäs eýleýir bir gelin,
Gelin aýdar: «Husnum erem bagydyr;
Aşyk ähli tirsem diýer ter gülüm,
Aşyk bolan bir-birine ýagydyr».

Gyz hem aýdar: «Ýüzüm hurşydy-hawer,
Husnum mähtäjidir mahy-münewwer,
Uzyndyr boýlarym serwi-senuber,
Ýaşym on dört, hup mestana çagydyr».

Gelin aýdar: «Meniň söhbedim süýji,
Ança ýigitlerniň başynyň täji,
Gyýa-gyýa baksam, gözümiň ujy
Gören aşyklaryň aklyn dagydyr.»

Gyz hem aýdar: «Älem ýakar näzlerim,
Beklegli gunça dek bolsam özlerim.
Indi ger açylsa bahar ýazlarym,
Baglaryň sünbüli zülpüm dagydyr».

Gelin diýr: «Bezensem müň dürli elwan,
Görmäge ajyzdyr hurşydy-taban,
Aşyk synasynda ýaradyr çendan,
Nerkes gözlerimiň goýan dagydyr».

                 22         
Gyz hem aýdar: «Gelin maňa taý degil,
Goýnum bir jennetdir, özge jaý degil,
Deň görüngen täze dogan aý degil,
Ýakamdan görünen göwsüm agydyr».

«Gel, gyz, bäs eýleme sen meniň bilen,
Jahyllar janyna men otlar salan,
Kamatym barabar tubylar bilen,
Leblerim açylan gül ýapragydyr».

Gyz hem aýdar: «Husnum elem peýwendi,
Alynmyş geliniň galasy, kendi.
Abatdyr şährimiň müftahy-bendi,
Synam köp arzyly şa otagydyr».

Gelin aýdar: «Indi haýran olup men,
Seniň bu sözüňe teslim kylyp men.
Özüm satyp, ýüzläp tümen alyp men,
Goç ýigitnin seýran eden çagydyr».

Nepes diýer bizge barabar bary,
Serden çykmaz gyz-geliniň humary,
Ikiňiz hem täze bagyň gülzary,
Baglaryň açylgan gül pudagydyr.

                 23          
               Aňsa
Hindiniň awçysy çyksa şikäre,
Özge aw islemez, pil sesin aňsa;
Otag ören bolsa bilbili-zara,
Otaga ot salar, gül sesin aňsa.

Jereniň balasyn baksaň, bejerseň,
Suw ýerine şeker-şerbetler berseň,
Höregne gül berip, bir güni görseň,
Watandan el gögär, çöl sesin aňsa,

Gündize gün zynat, gijäge – mahtap,
Kümüş zäge mätäç, altyna – simap,
Derýa görki mähek hem dürri-naýap,
Bilur röwşen tapar, kül sesin aňsa.

Harsydünýä söýer teňňäni, maly,
Bir gün bitap bolup, gitse mejaly,
Dönüp-deprenmäge bolmasa haly,
Galar garysyna, pul sesin aňsa.

Jelep karar etmez ýeke är bilen,
Dostun görse, bolmaz kesbi-kär bilen,
Ýola gelmez taýak bilen, zor bilen,
Ýagşy zen daş gaçar, gel sesin aňsa.

                  24         
Gula döwlet gelse bilmez agasyn,
Nakyldyr: har semrär – deper eýesin,
Kyrk çillede görseň doňuz çagasyn,
Bükürdi urar gaçar jul sesin aňsa.

Ýagşy zen suhanwer, bolsa sypaýy,
Ýüzi misli mahtap, on tördi aýy,
Gaçar bethüýlerden söz guran saýy,
Çyrag iba kylar, ýel sesin aňsa.

Bedasylyň köňli açylar, şer diýseň,
Hergiz gitmez, il derdine ýör diýseň.
Bahyllaryň jany çykar, ber diýseň,
Täzeden jan geler, al sesin aňsa.

Karun mülkün alsa bir är ýa tişi,
Pulum az diýr, her gün çeker käýişi,
Nuhuň ömrün hasyl etse bir kişi,
Ýakmaz gulagyna, öl sesin aňsa.

Nepes, sen sözleseň ulus illerde,
Bilbil şeýda bolar täze güllede,
Asal ezgil dahan içre tillerde,
Ary hüjüm eýlär, bal sesin aňsa.

                  25          
         Oýanmadyň
Ýolum düşdi, geldim seniň gapyňa,
«Ýar, oýangyl» diýdim, sen oýanmadyň.
It-guş ah eýledi kylan zaryma,
Ýatanlar oýandy, sen oýanmadyň...

Daň-säherde öwser sabanyň ýeli,
Men bilbilem, ýat eýlerem ol güli,
Deňim-duşum aýdar: nedir hyýaly?
Syrym paş eýledim, ýar, oýanmadyň.

Gije garaňkydyr, gözlerim görmez,
Hyýalym keç boldy, pikirim ýörmez,
Ýagşydan, ýamandan ýarym ses bermez,
Gulagyň ker boldy, ýar, oýanmadyň.

Bir guş geldi, gondy tüýnük ustüne,
Nazar saldy akja öýüň astyna,
Ganat ýaýdy, gitdi älem pestine,
Ýatan guş oýandy, ýar, oýanmadyň.

Gapysyna geldim, görsem diýp ýüzün,
Hassa men, eşitsem ol şirin sözün,
Dünýäge taý görmen, ýar gara gözüň,
Gözlerim kör boldy, ýar, oýanmadyň.

                 26         
Şykyrt edip, ýel oýnaýar işigin,
Söndüripdir men pakyryň yşygyn,
Magşuk imdi ýada salmaz aşygyn,
Biwepa garaşdym, ýar, oýanmadyň.

Daň ýyldyzy dogdy, jahan ýagtyldyp,
Men pakyr durar men gapysyn alyp,
Oýatmaz ukudan daň ýeli çalyp,
Daň şemaly turdy, ýar, oýanmadyň.

Ne bolupdyr saňa, beýle ýatyp sen?
Pikir bilen gam laýyna batyp sen,
Öz söwdügiň ýowuz derde satyp sen,
Ýusup deý gider men, ýar, oýanmadyň.

Aşyk diýsem, kime gulagyn goýar,
Ýaşyrsam syrymny, ulus-il duýar,
Hudaýym, ýar haçan ukudan doýar,
Yns-jyns doýandyr, ýar, oýanmadyň.

Nepes diýer, indi giderem mundan,
Daň şemaly öter bu ýektaý dondan,
Imdi gol göterdim, ýar, menem senden,
Uzyn gije ötdi, ýar, oýanmadyň...

                 27         
     Berkarar bolsun
Bizden salam bolsun Garaoglan hana,
Döwletiň eliňde berkarar bolsun.
Arap at, goç ogul, zynatdyr saňa,
Söýmek, münmek saňa ygtyýar bolsun.

Dünýä pany saraý, başga jaý degil,
Müň ýyldyz jem bolsun, dogan aý degil,
Dünýä ýalan, her haryslar han degil,
Her ýerde seýranyň lälezar bolsun.

Gelinler gaşyňda gaşlary ýaýdyr,
Her haýsy bir surat, Gün bilen Aýdyr,
Ak öýüň otagydyr, tagtdyr, saraýdyr,
Seniň bu destgähiň kimde bar bolsun.

Riýaýy mollalar sözlär ýetişmän,
Ol sözünden taňla köp eder puşman,
Pil bolsa hasymyň ger bolsa duşman,
Gaşyňda peşe dek bimydar bolsun.

Zynat üçin gelmiş pany jahana,
Hasanat depderiň çykmyş asmana,
Çar tarapdan gelen azyz myhmana,
Geýip, iýip-içmek ygtyýar bolsun.

                 28         
Iki dünýä alla bersin myradyň,
Arşyň her künjünde ýazylmyş adyň,
Tilinde zikri sen ýakynyň-ýadyň,
Hakyň söwer guly medetkär bolsun.

Her kim zyýan kylsa sud-y-suz bilen,
Gara köňül bilen, sadyk söz bilen,
Bir duşman gözlese ýaman göz bilen,
Tilleri lal bolsun, gözi kör bolsun.

Özüň deýin bolmaz deňi-duşuňda,
Döwlet guşy mekan tutmyş başyňda,
Her iş tutsaň nazaryňda gaşyňda,
On iki ymam gaýyp gerek er bolsun.

Ruzy magşar sünnileriň ýarydyr,
Garyplar gamhory, howandarydyr,
Senden dogan ogul äriň äridir,
Ondan dogan ogul meger är bolsun.

Ryzkyň bostanynda açylmyş rizwan,
Bäş gün miýesserdir bu döwri, döwran,
Ýigitlik çagynda eýleseň seýran,
Dowamat düýrdügiň alma-nar bolsun.

Nepes diýr, halka, ýara sözüm ýok,
Bir näkesem, gaýratym ýok, püzüm ýok,
Mydam gaflatda men, gyşym-ýazym ýok,
Gamhorum kerem bagş, biribar bolsun.

                 29         
           Biten gyz
Bag Eremde, gül-gülüstan içinde
Gudrat bilen bir şahada biten gyz.
Waspyňny ýaza men destan içinde,
Örme saçyň ak mämäňe ýeten gyz.

Seniň kimin gözel bolmaz jahanda,
Tamam hur-periler husnuňa bende,
Leýliniň sypaty bar eken sende,
Bu gün yşkyň söwdasyna batan gyz.

Boýuň şejerge ogşar, ýüzüň zülala,
Dişiň düre meňzär, lebleriň bala,
Bagty gelse, ýagşy-ýaman bir gula
Kadyr özi ryzky-rozun çatan gyz.

Nepes diýer, on üç, on dört ýaşynda,
Gara gotaz, altyn gupba başynda,
Ýüze gülap sürtup, wesme gaşynda,
Gyrmyz geýip, dildarlyga ýeten gyz.

                 30          
            Köňlüm
Söýdüm bir perini, isledim rahat,
Talwas eýlär her dem ol ýara köňlüm;
Hiç rahat görmedim, ýetişdi apat,
Pyrkat içre galdy azara köňlüm.

Göýä pasly-bahar açylan güldür,
Koýdüm hasratyndan, söwdügim güldür,
Ýarym täze güldür, köňlüm bilbildir,
Baryp kaçan gonar gülzara köňlüm.

Tygy-peýkamyndan bagrym dilindi,
Razy men öldürseň, janym al indi,
Gara zülpüň ýüzde ýüze bölündi,
Her zülpüň ýüzüňde ýüz para köňlüm.

Aşyk bolan gulak salar bu sözge,
Mejnunam, Leýli üçin çykmyşam düzge,
Meniň köňlüm ýarda, ýar köňli özge,
Hergiz el aýyrmaz biçäre köňlüm.

Gül ýüzüne düşen ol gara gaşdyr,
Gözlesem ol gaşa, gözlerim ýaşdyr,
Halyma rehm etmez, bir bagry daşdyr.
Mydam sergerdandyr awara köňlüm.

                 31         
Sendeý gözel gelmez ýalan jahana,
Gördüm ataş düşdi bu şirin jana,
Köňlüm guşy ürküp uçmaz her ýana,
Baglydyr zülpüňde bir tara köňlüm.

Nepes diýer, serim, ýar, saňa gurban,
Jemalyň görenler husnuňa haýran,
Men yşkyň derdini gizledim pinhan,
Görüň, zahyr kylar äşkäre köňlüm.

                 32          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Owadan gelin',
    'Eýran, Turan, arap, ajam ilinde
Görmedim seniň deý owadan gelin.
Jahan ragnasynda, bagyň gülünde
Bolmaz özüň kimin gül beden gelin.

Gözleseň, jan alar gara gözleriň,
Ölini direlder şirin sözleriň,
Alma ýaňaklaryň, güler ýüzleriň,
Şirindir lebleriň miweden, gelin!

Gara üzüm sen, şerbet bilen ýutmaga,
Takat bermez, köňül üzüp gitmäge,
Duzak gurup, aşyklary tutmaga,
Zülpün başdan-aýak tor eden gelin.

Bizi bilbil eýläp, özün gul eýläp,
Näz odundan istihanym kül eýläp,
Saçlaryn boýnuna selasyl eýläp,
Söz balyndan bagrym suw eden gelin...

Kamatyň gubudyr, goýnuňda nardyr,
Gerdeniň dutardyr, zülpleriň tardyr,
Jemalyň görmäge gözlerim zardyr,
Görsem gül ýuzüňi, sabadan, gelin!

                 33          
Men aşyk men, aşyk sözün beslär men,
..........................
Seniň didaryňy hakdan islär men,
Salma ýoluň ertir-sabadan, gelin.

Nepes diýer, aşnalygym ýat olmaz,
Bir görmesem, hergiz köňlüm şat olmaz.
Ýer ýüzünde sen deý perizat olmaz,
Meger ýere düşdüň howadan, gelin!

                34         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Geldi ana jananyň',
    'Buşluk, saňa janu ten,
                      geldi ana jananyň,
Arzuwy-wysal bilen
                  ol näzli gadyrdanyň
Isterki dowa senden,
                     al eliňe galamdanyň,
Barmakny katyp ýazgyl,
                         ýok bolsa syýadanyň,
Kagyza salyp nagş et,
                      ol serwi huramany.

Eý göz maňa gile etme,
                         janana gidenden soň,
Bak ýagşy nazar birle,
                      gülgün ýüzüni görseň,
Göz-gaşyna peşgeş diýp,
                      göz nuktasyny berseň,
Perwana sypat parlap,
                      jananadan öwrülseň,
Mestana basyp gelmiş,
                      bul kebik huramany.

Eý gol saňa rugsatdyr,
                      dal gerdene dolgaşsaň,
Eý leb saňa hem peşgeş,
                      gülgün meýiden içseň,

                    35           
Sabr eýle tenim-janym,
                       her näçe ýanyp bişseň,
Köňlüňge ýeter dilber,
                      pinhan ýerde uçraşsaň,
Ister ki gara gözüm,
                   her derdine dermany.

Sen-sen periler şahy,
                     elbetde, jahan içre,
Dürdäne dişin goýmuş
                       gül-gunça dahan içre,
Aýnajan gelip düşdi,
                   tenha bu mekan içre,
Maksatly gözel ýarym,
                       girseň bu gün don içre,
Sözläne gulak salgyn
                     bu dürri suhandany.

Ýar diýdi ki rugsat ber,
                        köp söz bile durmaly,
Dostdan niçe duşman köp,
                           bu ýerde oturmaly,
Her günde gelip görsem,
                        halyňny şunuň ýaly,
Tutdum goludan pugta,
                        gitmekde anyň päli,
Seýr eýledim, eý dostlar,
                        bu bag bile bostany.

                        36      
Ýar diýdi: «Eýa dilber,
                    ah çekme asyl, hergiz,
Bagş eýlem tamamyny,
                    sen kylma bu dem ferhiz,
Duşmanlara bildirmeý,
                        paýyňny berem, al tiz»
Gerdenge golum saldym,
                        maksatga kylyp engiz,
Goýdum lebim üstüne,
                      aý dek görüp Aýnany.

Ýar diýdi: «Jemalymdan
                       ýagtyldy seniň jaýyň»,
Diýdim: «Seniň hiç bolmaz,
                       dünýäde deňiň-taýyň»,
Diýdi: «Ne üçindir bu,
                       ah birle çeken waýyň»,
Diýdim: «Meniň halym teň,
                  ýokdur seniň perwaýyň,
Rehm et maňa, eý dilber,
                         aç bagy-gülüstany».

Eý Mollanepes,
             kylgyl taňryga şükür berjaý,
Aýnaň lebiden gandyň,
                      ýok indi saňa perwaý,

                    37          
Aýnaňa bu dem rugsat ber,
                       ýene alyp ki bir paý,
Şu hylwatyň az däldir,
                      içdiň bileje gök çaý,
Şükür edeýin ýetişdi,
                   bu köňlümiň istäni.

                     38         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Diýdi: «Aýt arzyň, myhman»',
    'Diýdim: «Aşyklar şasy!»
      Diýdi: «Aýt arzyň, myhman!»
  Diýdim: «Geçgil günähim!»
      Diýdi: «Ötdüm damja gan»,
  Diýdim: «Tagtyň berkarar!»
      Diýdi: «Şeýle bipaýan».
  Diýdim: «Seniň deý şalar...»
      Diýdi: «Ýokdur bigüman».
  Diýdim: «Geldim. Guluň men».
      «Tur git, – diýdi, – musulman!»
  Diýdim: «Ol ne pissedir?»
      Diýdi ki: «Dahan erer».
  Diýdim: «Ol ne gumrudyr?»
      Diýdi ki: «Zyban erer».
  Diýdim: «Ak ýüzde hallar...»
      Diýdi ki: «Reýhan erer».
  Diýdim: «Bu niçik dondur?»
      Diýdi: «Zerefşan erer».
  Diýdim: «Ölsem arman ýok...»
      Diýdi: «Dökme nahak gan».

  Diýdim: «Zülpler owsunjy...»
      Diýdi: «Dagdan geldi mar».
  Diýdim: «Ne goşa alma?»
      Diýdi: «Ak göwsümde nar...».

                 39         
Diýdim: «Ol ne injirdir?»
    Diýdi ki: «Bagda enar».
Diýdim: «Çille garydyr...»
    Diýdi: «Onda gülgüzar».
.....................
Diýdim: «Bir posa bergil!»
    Diýdi: «Bereý güldürseň».
Diýdim: «Hak aşyk menem».
    Diýdi: «Käriň bildirseň».
Diýdim: «Ajyz myhman men».
    Diýdi: «Gelgil, öldürseň».
Diýdim: «Bu ne sözdür, eý!..»
    Diýdi «Gelgil, soldursaň».
Aldym derhal golumga.
    Diýdi: «Göredir bagban...»

Golum saldym boýnuga,
    geldi tawusym uçup,
Diýdim: «Gel imdi tutaý».
    Diýdi: «Gül deý çyrmaşyp...»
Diýdim: «Wysalyň ýetir».
    Diýdi: «Onda uçraşyp».
Galdy ýürek ornundan,
    gitdi karar syçraşyp.
Aşyk Nepes bu gije
    sürdi beýle çoh döwran...

               40         
41   ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Bäri gel',
    'Saňa düşdi nazarym, söýgüli janan, bäri gel.
Saçy müşk isli ýufar, sünbüli-reýhan, bäri gel.
Gül beden, gülgün reň, dony zerafşan, bäri gel.
Al ýaňak, kirpigi ok, alma zenehdan, bäri gel.
Janyňa sadka olam, bäri gel, eý jan, bäri gel!

Gel otur gaşymda sen, zowky-jemalyň göreli,
Gel ýüzüň şöhlesine saz bilen söhbet guraly,
Dost gadyryn bileli, duşmany otga uraly,
Dünýe bäş gündür, öter, zowky sapalar süreli,
Bu ýalan dünýä öter, ötdi-le döwran, bäri gel!

Kä gülüp bäri bakyp, näz bilen sen sallana sen,
Käte gaşyňy çytyp, her tarapga tolguna sen,
Älemge şöhle salgan türpe ajaýyp sona sen,
Öz ýüzüň şöhlesine belki özüň hem ýana sen,
Ýüregim otga ýakana taşy-suzan, bäri gel!

Duýmasyn gende rakyp, bir ýerde pinhan bolaly,
Jany jan içre goşup, bir tenu-bir jan bolaly,
Maksady hasyl edip, meşguly döwran bolaly,
Sözleşip bir-birimiz, ança gadyrdan bolaly,
Bäş gündür siz – bize,
                     biz – size myhman bäri, gel!

                       42          
Leb gysyp, gaş kakyşyp,
                  mährem olup, gol tutuşyp,
Çolaşyp hem çyrmaşyp,
               ýag ile süýt deý gatyşyp,
Oýnaşyp, seýre çykyp, ak-gyzyl alma atyşyp,
Göýä bir nowça nahal dek bir-birimize ýetişip...
Kylaly gaýgy-gamy ýer bile ýegsan, bäri gel!

Çekerem her gijelerde ah bilen zaryň seniň,
Menden özge kim çeker derdi-azaryň seniň?
Bermenem ýüz müň tümenge
                        käkili taryň seniň,
Ak göwsüňde biten ol alma-enaryň seniň, –
Tirmesem, ança galar janda köp arman, bäri gel!

Perileriň patyşasy, belli mestana gözel,
Sen ki bir şam çyragy, men ki perwana, gözel,
Hulky hoş, labzy şirin, ýüzleri nurana gözel,
Bagry buz, sözleri uz, dişleri dürdäne gözel,
Lebi lagyl, geýdigi al, jenneti-ryzwan bäri gel!

Söwdügim, her sözüňge, sözle, şirin jany bereý,
Her nuktaýy-halyňa Eýrany-Turany bereý,
Her saçyň bir taryna käpir-musulmany bereý,
Seýr kylyp bakyşyňa Balhy-Badahşany bereý.
Kylaýyn men bu jahany sana gurban, bäri gel!

                       43          
Uýalyp, ýerge bakyp bizden ki iba kyla sen,
Gözleýip göz uç ile, synamga otlar sala sen,
Bir güni ölture sen, ahyry bu janym ala sen,
Näge rehm etmes sen, halymny özüň bile sen,
Diýr Nepes, köňlüm alan täze gülüstan, bäri gel!

                      44          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Istäp ki gözel ýary',
    'Istäp ki gözel ýary,
                   gördüm ki salamatdyr,
Baş goýdum aýakynda.
            «Tur! – diýdi – ne halatdyr?»
Turdum, diýdim: «Arzym bar».
                   – «Arz eýle adalatdyr!»
Diýdim: «Saňa aşyk men...»
                 «Goý – diýdi – ne hajatdyr?»
Diýdim: «Periler hany,
                   Sensiz neterem jany?»
Diýdi: «Bu sözüň bizge
                   ýalgançy hekaýatdyr».

Diýdim: «Gözüň öldürdi,
                    gamzaň ki kylyp hasta».
«Şeksiz öle sen – diýdi –
                    bir gaýry watan iste».
Diýdim ki: «Özüm gitsem,
                    köňlüm saňa wabeste!».
Diýdi: «Ne alaç eýleý,
                    sen aşygy – näkeste!»
Diýdim ki: «Alaç eýle,
                    Husnuň maňa paç eýle!»
Bir güldi elin dişläp,
                    diýdi: «Ne kesapatdyr».

                     45          
Diýdim: «Ne tütündir bu?»
                   Ol: «Zülpi käkilim» – diýdi.
Diýdim: «Ne elipdir bu?»
                   Ýar: «Inçge bilim» – diýdi.
Diýdim: «Ne şekerdir bu?»
                   – «Şerbetli dilim» – diýdi.
Bir posa talap kyldym
                   – «Lazymdyr ölüm» – diýdi.

Diýdim: «Meni öltürgil
                 Ýa posa mürewwet kyl!»
Agzymga çenäp ýumruk,
                 «Goý – diýdi, – gabahatdyr».

Umydy – wasyl birlen
                  işikni kiçik açdym,
Gözläp ki ýeň astyndan,
                  göz ümledi, men düşdüm,
Duşmanlara duýdurmaý,
                  bir lahza habarlaşdym,
«Pinhan ýere bar» diýdi,
                  geldi ki gujaklaşdym...
Diýdim: «Meni yşkyňda
                  köýdürme meni, eý jan!»
Diýdi ki: «Ýanyp köýmek
                  aşyklara adatdyr».

                     46          
Diýdim ki: «Güli-jennet,
                   bir dem süreli aşrat...»
Diýdi ki: «Säher boldy...»
                   – turdy, diledi rugsat.
«Rugsat ki bereý – diýdim
                   – araga düşer pyrkat».
Ýyglap ki golum tutdy.
            «Sen çekme, – diýdi, – hasrat.
Diýdim ki: «Meni öldir bu –
                   aýralyk, eý dildar!»
Diýdi: «Saňa bu aşrat
                   her gije zyýapatdyr...»

Gapyda kişi goýdy.
                   «Gaşyga baraý» diýdim,
Diýdi ki: «Nedir kesbiň?»
                   – «Gullukda duraý» diýdim,
Perde bile sözleşdi.
                   «Aç ýüzüň göreý» diýdim,
Diýdi ki: «Getir muzduň»
                   – «Janymny bereý» diýdim.
Diýdi: «Bu ne diwana?»
                   Diýdim: «Saňa perwana».
Diýdi: «Saňa görmek ýok,
                   jan tende amanatdyr».

                     47          
Diýdim ki: «Meniň köňlüm
                  almazmy sen, eý zalym!»
Diýdi ki: «Ne akmak sen,
                  halk diýr ki saňa alym».
Diýdim: «Ne günähim bar,
                  diýgil, nedir agmalym?»
Diýdi: «Nahan syrrym
                  halk içre kylyp mälim».
Diýdim ki: «Günäkärom,
                  Mähnetge giriftaram».
Diýdi maňa ol ýarym:
                  «Mähnet soňy rahatdyr».
«Neden ki gözüň ýaşy
                  girýan baradyr?» – diýdi.
«Pyrkat ki ýaman» – diýdim.
                  – «Synam ýaradyr» – diýdi.
Boýnyga golum saldym –
                  «Duşman göredir» – diýdi.
Öpdüm ýaňagyn – «Eý waý,
                  bagtym garadyr...» – diýdi.
Diýdim: «Bu ne käýişdir?»
                  Diýdi ki: «Bu ne işdir?»
Men diýdim: «Ajap işdir».
                  Ýar diýdi: «Melamatdyr».
Ýatganda güli-gülşen
                  bir gije gelipdir men.
Durdum ki gulak saldym,
                  ukuda ýatan erken.

                    48          
Bardym ki ýüzün açdym,
                 oýgandy gazap birlen.

«Kim sen?» diýdi.
                   Diýdim: «Men».
Diýdi ki: «Nepesmu sen?»
Diýdi ki: «Gelip sen hoş,
                   Hoşwagt bola sen» diýdi.
– «Aşyk bile magşukdan
                   bir-birge hoşamatdyr»

                    49          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Köňlüm',
    'iň aramy, menzil-mekany,
Şeýda köňül joşmaz özge güllerde.

Il husnuňa dahyl, görmäge zar men,
Yşgyňda bahar men, köýüňde nar men.
Tä ölinçäm seniň ýoluň garar men,
Ryzwan kimin gözüm galdy ýollarda.

Säher seýle çyksa, ger tökse siller,
Owsunar her ýana, tutukdyr tiller,
Zerefşan gulpagy, syýa käkiller,
Çöşse ýere düşer, örseň billerde.

Nergiz gaşyň, helal gözüňe gurban,
Adyň zikr etmäge dilde ýok perman,
Bir janym bar, müň derdim bar, sen derman,
Jismim ot içinde, ýaşym sillerde.

Mis özün deň etmiş simu-zer bilen,
Muş barabar bolmuş murgy-per bilen
Zäher hemra bolmuş bir şeker bilen,
Enwer ebr içinde, göwher köllerde.

                   13          
Elwan geýip, gyýa-gyýa bakar sen,
Zerewşan zülpuňi ýere döker sen,
Seýle çyksaň, ak jeren dek böker sen,
Jeren hem sen kimin bökmez çöllerde.

Nepes diýr, adatdyr, möwç urup joşma,
Aşyga humardyr ogryn garaşma,
Hem jilwe, hem gamza, näzu-kereşme
Mekan tutmuş göz-gaşyňda, gollarda.

                 14          
            Heserli
Näzenin kamatyň, güler ýüzleriň
Bir nowça nahaldyr gülli, semerli.
Piste dodaklaryň, bal agyzlaryň
Altyn piýaladyr gandu-şekerli.

Ak gollar synada tapmyş kemaly,
On barmakda ýüzük lagl mysaly,
Serinde ebrişim, egninde aly,
Sylaý gerdenleriň tylla tumarly.

Zülpüň meňzär leňkebudyň taryna,
Göwsüň meňzär kyrk çilläniň garyna,
Gözeller haýrandyr kesbi-kärine,
Bir jady tilsimli, goly hünärli.

Nepes diýer kä aglar men, güler men,
Gähi açylar men, gähi solar men,
Gähi diriler men, gähi öler men,
Yşkyň ýoly ajap ýoldur heserli.

                 15          
 Badam gabaklaryňdan
Sapaly söwdügim, gül ýüzli ýarym,
Aýlanaýyn badam gabaklaryňdan.
Boýlaryň tubydyr, kamatyň ar-ar,
Gol uzadyp tutsam pudaklaryňdan.

Seniň husnuň hergiz gözümden gitmez,
Her niçe dalbynsam, saňa gol ýetmez,
Sen bolmasaň Aý, Gün, älem ýarytmaz,
Röwşen tapar gözüm ýaňaklaryňdan.

Gaşyňny kakyban, gözüň güldir sen,
Iba bilen aşyk küňlün doldyr sen,
Näz eýleýip, asta-asta ýylgyr sen,
Zenehdan bildir sen eňekleriňden.

Köňlüňni sowutma, söwdügim, bizden,
Umydymyz köpdür, dildarym, sizden,
Däne-däne hal çykypdyr gül ýüzden,
Örtener men emsem bulaklaryňdan.

Nepes diýer, bakyp oltur ýüzüme,
Özüm bilmen, aýp eýleme sözüme,
Şemsi kamar görünmezmiş gözüme,
Bir şöhle düşmüşdir sahaklaryňdan.

                16         
           Ol ýylan
Gara gözdür aşyklaryň guwanjy,
Guran sözüň hasta janyň söýenji,
Iki şamar saklap ýatyr bir genji,
Genç üstünde halka guran ol ýylan.

Men saňa aşyklyk lybasyn saldym,
Niçe ýyl ugruňda saralyp, soldum,
Mejnun deýin jismim otlarga saldym,
Synalarmy göz-göz eden ol ýylan.

Gara gözüň jan almagyň kastynda,
Bilbil mesgen tutmuş gülüň üstünde,
Bir jüp ýylan ýatyr göwsüň üstünde,
Synalarmy göz-göz eden ol ýylan.

Käte öýmesini başyna orap,
Käte şana bilen zülplerin darap,
Aşygyna jilwe berip, bir garap,
Synalarmy göz-göz eden ol ýylan.

Nepes diýer, işim ahy-sert bilen,
Iş salyşsaň bir töwekgel mert bilen,
Jan agalar, bir muşakgat dert bilen,
Synalarmy göz-göz eden ol ýylan.

                 17         
           Näzli ýar
Gara saçyň gije diýip, uklap men,
Gündiz eken, çoh armanym, näzli ýar!
Saba-säher wagty diýip, çaklap men,
Çeşmim açsam, arman eken, näzli ýar!

Gel, görüşseň keramatly goluňdan,
Aýlanaýyn dahanyňdan, tiliňden,
Gahar etme, golum salsam biliňden,
Ataşgähi sen, suzanym, näzli ýar!

Tarypyn eşitdim gara gözüňniň,
Gedasy men, dostum, güler ýüzüňniň,
Zybandan aýrylan her bir sözüňniň,
Kesgil başym, men gurbany, näzli ýar!

Nepes diýer, yşkym hetden aşypdyr,
Tomaşaňa ulug iller üýşüpdir,
Gözüm açsam, aýym-günüm ýaşypdyr.
Zyndan boldy giň jahanym, näzli ýar!

                 18         
            Ýaý imdi
Wysalyndan gamgyn köňlüm açyldy,
Pyrkatyndan elip kaddym ýaý imdi.
Ýüzüň nury älem ara saçyldy,
Hergiz dogmaz özüň kimin aý imdi.

Muştakdyr roýuňa bu dünýä pany,
Ýoluňda gedadyr hanlaryň hany,
Keşt eýledim on sekiz müň jahany,
Hiç tapmadym bir zülpüňe taý imdi.

Säher ýeli zülpuň perişan eder,
Gamzaň okdur, jiger bagrym gan eder,
Görse bizi şum rakyplar taň eder,
Gyz, eýlegin öz goýnuňda jaý imdi.

Senden özge ýary gözüm görmesin,
Sensiz zowky alla maňa bermesin.
Sen bolmasaň, dünýä bir dem durmasyn,
Ýykym-ýumrum bolsa, diýmen «waý» imdi...

Nepes diýr, bir ýara bilim baglar men,
Aryf özüm, dost-duşmany saglar men,
Tä ölinçäm, Durdyhal diýp aglar men.
Gözlerimden dolup aksyn çaý imdi.

                 19          
      Ýadyma düşdi
Nägehan gezerdim güli-gülşende,
Gülgün ýaňaklaryň ýadyma düşdi;
Alma enaryna gözüm düşende,
Alma ýaňaklaryň ýadyma düşdi.

Hijr elinden çekdim pygany-nala,
Elip dek kamatym ogşady dala,
Arzuw eýläp ýete bilmen wysala,
Aýralyk çaglaryň ýadyma düşdi.

Ýüzleriň şemygdyr, syýa käkiller,
Saçlaryň manendi mary-sünbüller,
Çemenler baglandy, jemyg oldy güller,
Başdan aýaklaryň ýadyma düşdi.

Seniň hesretiňden sargaryp soldum,
Jebri-tygyň bilen bagrymy dildim,
Ýüz müň arman bilen senden aýryldym,
Ol gezen jaýlaryň ýadyma düşdi.

Misli dogan aý dek göksüňniň agy,
Ganymdan reň tapmyş destiň boýagy,
Çar tarap dartylmyş serwi pudagy,
Hasa gujaklaryň ýadyma düşdi.

                20         
Nepes diýer, bagrym daglar içinde,
Bezm eýlesem ak otaglar içinde,
Badam kemal tapmyş baglar içinde,
Badam gabaklaryň ýadyma düşdi.

               21         
  Gyz-gelniň aýdyşygy
Bir gyz bilen bäs eýleýir bir gelin,
Gelin aýdar: «Husnum erem bagydyr;
Aşyk ähli tirsem diýer ter gülüm,
Aşyk bolan bir-birine ýagydyr».

Gyz hem aýdar: «Ýüzüm hurşydy-hawer,
Husnum mähtäjidir mahy-münewwer,
Uzyndyr boýlarym serwi-senuber,
Ýaşym on dört, hup mestana çagydyr».

Gelin aýdar: «Meniň söhbedim süýji,
Ança ýigitlerniň başynyň täji,
Gyýa-gyýa baksam, gözümiň ujy
Gören aşyklaryň aklyn dagydyr.»

Gyz hem aýdar: «Älem ýakar näzlerim,
Beklegli gunça dek bolsam özlerim.
Indi ger açylsa bahar ýazlarym,
Baglaryň sünbüli zülpüm dagydyr».

Gelin diýr: «Bezensem müň dürli elwan,
Görmäge ajyzdyr hurşydy-taban,
Aşyk synasynda ýaradyr çendan,
Nerkes gözlerimiň goýan dagydyr».

                 22         
Gyz hem aýdar: «Gelin maňa taý degil,
Goýnum bir jennetdir, özge jaý degil,
Deň görüngen täze dogan aý degil,
Ýakamdan görünen göwsüm agydyr».

«Gel, gyz, bäs eýleme sen meniň bilen,
Jahyllar janyna men otlar salan,
Kamatym barabar tubylar bilen,
Leblerim açylan gül ýapragydyr».

Gyz hem aýdar: «Husnum elem peýwendi,
Alynmyş geliniň galasy, kendi.
Abatdyr şährimiň müftahy-bendi,
Synam köp arzyly şa otagydyr».

Gelin aýdar: «Indi haýran olup men,
Seniň bu sözüňe teslim kylyp men.
Özüm satyp, ýüzläp tümen alyp men,
Goç ýigitnin seýran eden çagydyr».

Nepes diýer bizge barabar bary,
Serden çykmaz gyz-geliniň humary,
Ikiňiz hem täze bagyň gülzary,
Baglaryň açylgan gül pudagydyr.

                 23          
               Aňsa
Hindiniň awçysy çyksa şikäre,
Özge aw islemez, pil sesin aňsa;
Otag ören bolsa bilbili-zara,
Otaga ot salar, gül sesin aňsa.

Jereniň balasyn baksaň, bejerseň,
Suw ýerine şeker-şerbetler berseň,
Höregne gül berip, bir güni görseň,
Watandan el gögär, çöl sesin aňsa,

Gündize gün zynat, gijäge – mahtap,
Kümüş zäge mätäç, altyna – simap,
Derýa görki mähek hem dürri-naýap,
Bilur röwşen tapar, kül sesin aňsa.

Harsydünýä söýer teňňäni, maly,
Bir gün bitap bolup, gitse mejaly,
Dönüp-deprenmäge bolmasa haly,
Galar garysyna, pul sesin aňsa.

Jelep karar etmez ýeke är bilen,
Dostun görse, bolmaz kesbi-kär bilen,
Ýola gelmez taýak bilen, zor bilen,
Ýagşy zen daş gaçar, gel sesin aňsa.

                  24         
Gula döwlet gelse bilmez agasyn,
Nakyldyr: har semrär – deper eýesin,
Kyrk çillede görseň doňuz çagasyn,
Bükürdi urar gaçar jul sesin aňsa.

Ýagşy zen suhanwer, bolsa sypaýy,
Ýüzi misli mahtap, on tördi aýy,
Gaçar bethüýlerden söz guran saýy,
Çyrag iba kylar, ýel sesin aňsa.

Bedasylyň köňli açylar, şer diýseň,
Hergiz gitmez, il derdine ýör diýseň.
Bahyllaryň jany çykar, ber diýseň,
Täzeden jan geler, al sesin aňsa.

Karun mülkün alsa bir är ýa tişi,
Pulum az diýr, her gün çeker käýişi,
Nuhuň ömrün hasyl etse bir kişi,
Ýakmaz gulagyna, öl sesin aňsa.

Nepes, sen sözleseň ulus illerde,
Bilbil şeýda bolar täze güllede,
Asal ezgil dahan içre tillerde,
Ary hüjüm eýlär, bal sesin aňsa.

                  25          
         Oýanmadyň
Ýolum düşdi, geldim seniň gapyňa,
«Ýar, oýangyl» diýdim, sen oýanmadyň.
It-guş ah eýledi kylan zaryma,
Ýatanlar oýandy, sen oýanmadyň...

Daň-säherde öwser sabanyň ýeli,
Men bilbilem, ýat eýlerem ol güli,
Deňim-duşum aýdar: nedir hyýaly?
Syrym paş eýledim, ýar, oýanmadyň.

Gije garaňkydyr, gözlerim görmez,
Hyýalym keç boldy, pikirim ýörmez,
Ýagşydan, ýamandan ýarym ses bermez,
Gulagyň ker boldy, ýar, oýanmadyň.

Bir guş geldi, gondy tüýnük ustüne,
Nazar saldy akja öýüň astyna,
Ganat ýaýdy, gitdi älem pestine,
Ýatan guş oýandy, ýar, oýanmadyň.

Gapysyna geldim, görsem diýp ýüzün,
Hassa men, eşitsem ol şirin sözün,
Dünýäge taý görmen, ýar gara gözüň,
Gözlerim kör boldy, ýar, oýanmadyň.

                 26         
Şykyrt edip, ýel oýnaýar işigin,
Söndüripdir men pakyryň yşygyn,
Magşuk imdi ýada salmaz aşygyn,
Biwepa garaşdym, ýar, oýanmadyň.

Daň ýyldyzy dogdy, jahan ýagtyldyp,
Men pakyr durar men gapysyn alyp,
Oýatmaz ukudan daň ýeli çalyp,
Daň şemaly turdy, ýar, oýanmadyň.

Ne bolupdyr saňa, beýle ýatyp sen?
Pikir bilen gam laýyna batyp sen,
Öz söwdügiň ýowuz derde satyp sen,
Ýusup deý gider men, ýar, oýanmadyň.

Aşyk diýsem, kime gulagyn goýar,
Ýaşyrsam syrymny, ulus-il duýar,
Hudaýym, ýar haçan ukudan doýar,
Yns-jyns doýandyr, ýar, oýanmadyň.

Nepes diýer, indi giderem mundan,
Daň şemaly öter bu ýektaý dondan,
Imdi gol göterdim, ýar, menem senden,
Uzyn gije ötdi, ýar, oýanmadyň...

                 27         
     Berkarar bolsun
Bizden salam bolsun Garaoglan hana,
Döwletiň eliňde berkarar bolsun.
Arap at, goç ogul, zynatdyr saňa,
Söýmek, münmek saňa ygtyýar bolsun.

Dünýä pany saraý, başga jaý degil,
Müň ýyldyz jem bolsun, dogan aý degil,
Dünýä ýalan, her haryslar han degil,
Her ýerde seýranyň lälezar bolsun.

Gelinler gaşyňda gaşlary ýaýdyr,
Her haýsy bir surat, Gün bilen Aýdyr,
Ak öýüň otagydyr, tagtdyr, saraýdyr,
Seniň bu destgähiň kimde bar bolsun.

Riýaýy mollalar sözlär ýetişmän,
Ol sözünden taňla köp eder puşman,
Pil bolsa hasymyň ger bolsa duşman,
Gaşyňda peşe dek bimydar bolsun.

Zynat üçin gelmiş pany jahana,
Hasanat depderiň çykmyş asmana,
Çar tarapdan gelen azyz myhmana,
Geýip, iýip-içmek ygtyýar bolsun.

                 28         
Iki dünýä alla bersin myradyň,
Arşyň her künjünde ýazylmyş adyň,
Tilinde zikri sen ýakynyň-ýadyň,
Hakyň söwer guly medetkär bolsun.

Her kim zyýan kylsa sud-y-suz bilen,
Gara köňül bilen, sadyk söz bilen,
Bir duşman gözlese ýaman göz bilen,
Tilleri lal bolsun, gözi kör bolsun.

Özüň deýin bolmaz deňi-duşuňda,
Döwlet guşy mekan tutmyş başyňda,
Her iş tutsaň nazaryňda gaşyňda,
On iki ymam gaýyp gerek er bolsun.

Ruzy magşar sünnileriň ýarydyr,
Garyplar gamhory, howandarydyr,
Senden dogan ogul äriň äridir,
Ondan dogan ogul meger är bolsun.

Ryzkyň bostanynda açylmyş rizwan,
Bäş gün miýesserdir bu döwri, döwran,
Ýigitlik çagynda eýleseň seýran,
Dowamat düýrdügiň alma-nar bolsun.

Nepes diýr, halka, ýara sözüm ýok,
Bir näkesem, gaýratym ýok, püzüm ýok,
Mydam gaflatda men, gyşym-ýazym ýok,
Gamhorum kerem bagş, biribar bolsun.

                 29         
           Biten gyz
Bag Eremde, gül-gülüstan içinde
Gudrat bilen bir şahada biten gyz.
Waspyňny ýaza men destan içinde,
Örme saçyň ak mämäňe ýeten gyz.

Seniň kimin gözel bolmaz jahanda,
Tamam hur-periler husnuňa bende,
Leýliniň sypaty bar eken sende,
Bu gün yşkyň söwdasyna batan gyz.

Boýuň şejerge ogşar, ýüzüň zülala,
Dişiň düre meňzär, lebleriň bala,
Bagty gelse, ýagşy-ýaman bir gula
Kadyr özi ryzky-rozun çatan gyz.

Nepes diýer, on üç, on dört ýaşynda,
Gara gotaz, altyn gupba başynda,
Ýüze gülap sürtup, wesme gaşynda,
Gyrmyz geýip, dildarlyga ýeten gyz.

                 30          
            Köňlüm
Söýdüm bir perini, isledim rahat,
Talwas eýlär her dem ol ýara köňlüm;
Hiç rahat görmedim, ýetişdi apat,
Pyrkat içre galdy azara köňlüm.

Göýä pasly-bahar açylan güldür,
Koýdüm hasratyndan, söwdügim güldür,
Ýarym täze güldür, köňlüm bilbildir,
Baryp kaçan gonar gülzara köňlüm.

Tygy-peýkamyndan bagrym dilindi,
Razy men öldürseň, janym al indi,
Gara zülpüň ýüzde ýüze bölündi,
Her zülpüň ýüzüňde ýüz para köňlüm.

Aşyk bolan gulak salar bu sözge,
Mejnunam, Leýli üçin çykmyşam düzge,
Meniň köňlüm ýarda, ýar köňli özge,
Hergiz el aýyrmaz biçäre köňlüm.

Gül ýüzüne düşen ol gara gaşdyr,
Gözlesem ol gaşa, gözlerim ýaşdyr,
Halyma rehm etmez, bir bagry daşdyr.
Mydam sergerdandyr awara köňlüm.

                 31         
Sendeý gözel gelmez ýalan jahana,
Gördüm ataş düşdi bu şirin jana,
Köňlüm guşy ürküp uçmaz her ýana,
Baglydyr zülpüňde bir tara köňlüm.

Nepes diýer, serim, ýar, saňa gurban,
Jemalyň görenler husnuňa haýran,
Men yşkyň derdini gizledim pinhan,
Görüň, zahyr kylar äşkäre köňlüm.

                 32          
        Owadan gelin
Eýran, Turan, arap, ajam ilinde
Görmedim seniň deý owadan gelin.
Jahan ragnasynda, bagyň gülünde
Bolmaz özüň kimin gül beden gelin.

Gözleseň, jan alar gara gözleriň,
Ölini direlder şirin sözleriň,
Alma ýaňaklaryň, güler ýüzleriň,
Şirindir lebleriň miweden, gelin!

Gara üzüm sen, şerbet bilen ýutmaga,
Takat bermez, köňül üzüp gitmäge,
Duzak gurup, aşyklary tutmaga,
Zülpün başdan-aýak tor eden gelin.

Bizi bilbil eýläp, özün gul eýläp,
Näz odundan istihanym kül eýläp,
Saçlaryn boýnuna selasyl eýläp,
Söz balyndan bagrym suw eden gelin...

Kamatyň gubudyr, goýnuňda nardyr,
Gerdeniň dutardyr, zülpleriň tardyr,
Jemalyň görmäge gözlerim zardyr,
Görsem gül ýuzüňi, sabadan, gelin!

                 33          
Men aşyk men, aşyk sözün beslär men,
..........................
Seniň didaryňy hakdan islär men,
Salma ýoluň ertir-sabadan, gelin.

Nepes diýer, aşnalygym ýat olmaz,
Bir görmesem, hergiz köňlüm şat olmaz.
Ýer ýüzünde sen deý perizat olmaz,
Meger ýere düşdüň howadan, gelin!

                34         
       Geldi ana jananyň
Buşluk, saňa janu ten,
                      geldi ana jananyň,
Arzuwy-wysal bilen
                  ol näzli gadyrdanyň
Isterki dowa senden,
                     al eliňe galamdanyň,
Barmakny katyp ýazgyl,
                         ýok bolsa syýadanyň,
Kagyza salyp nagş et,
                      ol serwi huramany.

Eý göz maňa gile etme,
                         janana gidenden soň,
Bak ýagşy nazar birle,
                      gülgün ýüzüni görseň,
Göz-gaşyna peşgeş diýp,
                      göz nuktasyny berseň,
Perwana sypat parlap,
                      jananadan öwrülseň,
Mestana basyp gelmiş,
                      bul kebik huramany.

Eý gol saňa rugsatdyr,
                      dal gerdene dolgaşsaň,
Eý leb saňa hem peşgeş,
                      gülgün meýiden içseň,

                    35           
Sabr eýle tenim-janym,
                       her näçe ýanyp bişseň,
Köňlüňge ýeter dilber,
                      pinhan ýerde uçraşsaň,
Ister ki gara gözüm,
                   her derdine dermany.

Sen-sen periler şahy,
                     elbetde, jahan içre,
Dürdäne dişin goýmuş
                       gül-gunça dahan içre,
Aýnajan gelip düşdi,
                   tenha bu mekan içre,
Maksatly gözel ýarym,
                       girseň bu gün don içre,
Sözläne gulak salgyn
                     bu dürri suhandany.

Ýar diýdi ki rugsat ber,
                        köp söz bile durmaly,
Dostdan niçe duşman köp,
                           bu ýerde oturmaly,
Her günde gelip görsem,
                        halyňny şunuň ýaly,
Tutdum goludan pugta,
                        gitmekde anyň päli,
Seýr eýledim, eý dostlar,
                        bu bag bile bostany.

                        36      
Ýar diýdi: «Eýa dilber,
                    ah çekme asyl, hergiz,
Bagş eýlem tamamyny,
                    sen kylma bu dem ferhiz,
Duşmanlara bildirmeý,
                        paýyňny berem, al tiz»
Gerdenge golum saldym,
                        maksatga kylyp engiz,
Goýdum lebim üstüne,
                      aý dek görüp Aýnany.

Ýar diýdi: «Jemalymdan
                       ýagtyldy seniň jaýyň»,
Diýdim: «Seniň hiç bolmaz,
                       dünýäde deňiň-taýyň»,
Diýdi: «Ne üçindir bu,
                       ah birle çeken waýyň»,
Diýdim: «Meniň halym teň,
                  ýokdur seniň perwaýyň,
Rehm et maňa, eý dilber,
                         aç bagy-gülüstany».

Eý Mollanepes,
             kylgyl taňryga şükür berjaý,
Aýnaň lebiden gandyň,
                      ýok indi saňa perwaý,

                    37          
Aýnaňa bu dem rugsat ber,
                       ýene alyp ki bir paý,
Şu hylwatyň az däldir,
                      içdiň bileje gök çaý,
Şükür edeýin ýetişdi,
                   bu köňlümiň istäni.

                     38         
Diýdi: «Aýt arzyň, myhman»
  Diýdim: «Aşyklar şasy!»
      Diýdi: «Aýt arzyň, myhman!»
  Diýdim: «Geçgil günähim!»
      Diýdi: «Ötdüm damja gan»,
  Diýdim: «Tagtyň berkarar!»
      Diýdi: «Şeýle bipaýan».
  Diýdim: «Seniň deý şalar...»
      Diýdi: «Ýokdur bigüman».
  Diýdim: «Geldim. Guluň men».
      «Tur git, – diýdi, – musulman!»
  Diýdim: «Ol ne pissedir?»
      Diýdi ki: «Dahan erer».
  Diýdim: «Ol ne gumrudyr?»
      Diýdi ki: «Zyban erer».
  Diýdim: «Ak ýüzde hallar...»
      Diýdi ki: «Reýhan erer».
  Diýdim: «Bu niçik dondur?»
      Diýdi: «Zerefşan erer».
  Diýdim: «Ölsem arman ýok...»
      Diýdi: «Dökme nahak gan».

  Diýdim: «Zülpler owsunjy...»
      Diýdi: «Dagdan geldi mar».
  Diýdim: «Ne goşa alma?»
      Diýdi: «Ak göwsümde nar...».

                 39         
Diýdim: «Ol ne injirdir?»
    Diýdi ki: «Bagda enar».
Diýdim: «Çille garydyr...»
    Diýdi: «Onda gülgüzar».
.....................
Diýdim: «Bir posa bergil!»
    Diýdi: «Bereý güldürseň».
Diýdim: «Hak aşyk menem».
    Diýdi: «Käriň bildirseň».
Diýdim: «Ajyz myhman men».
    Diýdi: «Gelgil, öldürseň».
Diýdim: «Bu ne sözdür, eý!..»
    Diýdi «Gelgil, soldursaň».
Aldym derhal golumga.
    Diýdi: «Göredir bagban...»

Golum saldym boýnuga,
    geldi tawusym uçup,
Diýdim: «Gel imdi tutaý».
    Diýdi: «Gül deý çyrmaşyp...»
Diýdim: «Wysalyň ýetir».
    Diýdi: «Onda uçraşyp».
Galdy ýürek ornundan,
    gitdi karar syçraşyp.
Aşyk Nepes bu gije
    sürdi beýle çoh döwran...

               40         
41   
                 Bäri gel
Saňa düşdi nazarym, söýgüli janan, bäri gel.
Saçy müşk isli ýufar, sünbüli-reýhan, bäri gel.
Gül beden, gülgün reň, dony zerafşan, bäri gel.
Al ýaňak, kirpigi ok, alma zenehdan, bäri gel.
Janyňa sadka olam, bäri gel, eý jan, bäri gel!

Gel otur gaşymda sen, zowky-jemalyň göreli,
Gel ýüzüň şöhlesine saz bilen söhbet guraly,
Dost gadyryn bileli, duşmany otga uraly,
Dünýe bäş gündür, öter, zowky sapalar süreli,
Bu ýalan dünýä öter, ötdi-le döwran, bäri gel!

Kä gülüp bäri bakyp, näz bilen sen sallana sen,
Käte gaşyňy çytyp, her tarapga tolguna sen,
Älemge şöhle salgan türpe ajaýyp sona sen,
Öz ýüzüň şöhlesine belki özüň hem ýana sen,
Ýüregim otga ýakana taşy-suzan, bäri gel!

Duýmasyn gende rakyp, bir ýerde pinhan bolaly,
Jany jan içre goşup, bir tenu-bir jan bolaly,
Maksady hasyl edip, meşguly döwran bolaly,
Sözleşip bir-birimiz, ança gadyrdan bolaly,
Bäş gündür siz – bize,
                     biz – size myhman bäri, gel!

                       42          
Leb gysyp, gaş kakyşyp,
                  mährem olup, gol tutuşyp,
Çolaşyp hem çyrmaşyp,
               ýag ile süýt deý gatyşyp,
Oýnaşyp, seýre çykyp, ak-gyzyl alma atyşyp,
Göýä bir nowça nahal dek bir-birimize ýetişip...
Kylaly gaýgy-gamy ýer bile ýegsan, bäri gel!

Çekerem her gijelerde ah bilen zaryň seniň,
Menden özge kim çeker derdi-azaryň seniň?
Bermenem ýüz müň tümenge
                        käkili taryň seniň,
Ak göwsüňde biten ol alma-enaryň seniň, –
Tirmesem, ança galar janda köp arman, bäri gel!

Perileriň patyşasy, belli mestana gözel,
Sen ki bir şam çyragy, men ki perwana, gözel,
Hulky hoş, labzy şirin, ýüzleri nurana gözel,
Bagry buz, sözleri uz, dişleri dürdäne gözel,
Lebi lagyl, geýdigi al, jenneti-ryzwan bäri gel!

Söwdügim, her sözüňge, sözle, şirin jany bereý,
Her nuktaýy-halyňa Eýrany-Turany bereý,
Her saçyň bir taryna käpir-musulmany bereý,
Seýr kylyp bakyşyňa Balhy-Badahşany bereý.
Kylaýyn men bu jahany sana gurban, bäri gel!

                       43          
Uýalyp, ýerge bakyp bizden ki iba kyla sen,
Gözleýip göz uç ile, synamga otlar sala sen,
Bir güni ölture sen, ahyry bu janym ala sen,
Näge rehm etmes sen, halymny özüň bile sen,
Diýr Nepes, köňlüm alan täze gülüstan, bäri gel!

                      44          
       Istäp ki gözel ýary
Istäp ki gözel ýary,
                   gördüm ki salamatdyr,
Baş goýdum aýakynda.
            «Tur! – diýdi – ne halatdyr?»
Turdum, diýdim: «Arzym bar».
                   – «Arz eýle adalatdyr!»
Diýdim: «Saňa aşyk men...»
                 «Goý – diýdi – ne hajatdyr?»
Diýdim: «Periler hany,
                   Sensiz neterem jany?»
Diýdi: «Bu sözüň bizge
                   ýalgançy hekaýatdyr».

Diýdim: «Gözüň öldürdi,
                    gamzaň ki kylyp hasta».
«Şeksiz öle sen – diýdi –
                    bir gaýry watan iste».
Diýdim ki: «Özüm gitsem,
                    köňlüm saňa wabeste!».
Diýdi: «Ne alaç eýleý,
                    sen aşygy – näkeste!»
Diýdim ki: «Alaç eýle,
                    Husnuň maňa paç eýle!»
Bir güldi elin dişläp,
                    diýdi: «Ne kesapatdyr».

                     45          
Diýdim: «Ne tütündir bu?»
                   Ol: «Zülpi käkilim» – diýdi.
Diýdim: «Ne elipdir bu?»
                   Ýar: «Inçge bilim» – diýdi.
Diýdim: «Ne şekerdir bu?»
                   – «Şerbetli dilim» – diýdi.
Bir posa talap kyldym
                   – «Lazymdyr ölüm» – diýdi.

Diýdim: «Meni öltürgil
                 Ýa posa mürewwet kyl!»
Agzymga çenäp ýumruk,
                 «Goý – diýdi, – gabahatdyr».

Umydy – wasyl birlen
                  işikni kiçik açdym,
Gözläp ki ýeň astyndan,
                  göz ümledi, men düşdüm,
Duşmanlara duýdurmaý,
                  bir lahza habarlaşdym,
«Pinhan ýere bar» diýdi,
                  geldi ki gujaklaşdym...
Diýdim: «Meni yşkyňda
                  köýdürme meni, eý jan!»
Diýdi ki: «Ýanyp köýmek
                  aşyklara adatdyr».

                     46          
Diýdim ki: «Güli-jennet,
                   bir dem süreli aşrat...»
Diýdi ki: «Säher boldy...»
                   – turdy, diledi rugsat.
«Rugsat ki bereý – diýdim
                   – araga düşer pyrkat».
Ýyglap ki golum tutdy.
            «Sen çekme, – diýdi, – hasrat.
Diýdim ki: «Meni öldir bu –
                   aýralyk, eý dildar!»
Diýdi: «Saňa bu aşrat
                   her gije zyýapatdyr...»

Gapyda kişi goýdy.
                   «Gaşyga baraý» diýdim,
Diýdi ki: «Nedir kesbiň?»
                   – «Gullukda duraý» diýdim,
Perde bile sözleşdi.
                   «Aç ýüzüň göreý» diýdim,
Diýdi ki: «Getir muzduň»
                   – «Janymny bereý» diýdim.
Diýdi: «Bu ne diwana?»
                   Diýdim: «Saňa perwana».
Diýdi: «Saňa görmek ýok,
                   jan tende amanatdyr».

                     47          
Diýdim ki: «Meniň köňlüm
                  almazmy sen, eý zalym!»
Diýdi ki: «Ne akmak sen,
                  halk diýr ki saňa alym».
Diýdim: «Ne günähim bar,
                  diýgil, nedir agmalym?»
Diýdi: «Nahan syrrym
                  halk içre kylyp mälim».
Diýdim ki: «Günäkärom,
                  Mähnetge giriftaram».
Diýdi maňa ol ýarym:
                  «Mähnet soňy rahatdyr».
«Neden ki gözüň ýaşy
                  girýan baradyr?» – diýdi.
«Pyrkat ki ýaman» – diýdim.
                  – «Synam ýaradyr» – diýdi.
Boýnyga golum saldym –
                  «Duşman göredir» – diýdi.
Öpdüm ýaňagyn – «Eý waý,
                  bagtym garadyr...» – diýdi.
Diýdim: «Bu ne käýişdir?»
                  Diýdi ki: «Bu ne işdir?»
Men diýdim: «Ajap işdir».
                  Ýar diýdi: «Melamatdyr».
Ýatganda güli-gülşen
                  bir gije gelipdir men.
Durdum ki gulak saldym,
                  ukuda ýatan erken.

                    48          
Bardym ki ýüzün açdym,
                 oýgandy gazap birlen.

«Kim sen?» diýdi.
                   Diýdim: «Men».
Diýdi ki: «Nepesmu sen?»
Diýdi ki: «Gelip sen hoş,
                   Hoşwagt bola sen» diýdi.
– «Aşyk bile magşukdan
                   bir-birge hoşamatdyr»

                    49          
             Ner gezgin
Köňlüm, saňa nesihat,
                 gezseň serbeser gezgin,
Tany dosty-duşmanyň,
                 öýňe bahabar gezgin,
Ganym bilen garjaşsaň,
                 daýym muştiper gezgin.
Gezseň dünýä ýüzünde,
                 dowam täze-ter gezgin,
Kyrk ýyl maýa gezinçäň,
                 bütin bir ýyl ner gezgin.

Iki adam uruşsa,
                      öter ýaly ýol berme,
Birisine gep berip,
                   ol birine al berme,
Owwal adamdan gaçma,
                   gaçsaň asla el berme,
«Jan aga, özüň bil» – diýp,
                   her näkese ýalbarma,
Kyrk ýyl maýa gezinçäň,
                   bütin bir ýyl ner gezgin.

                        50          
Nepes, hiç bir kem durma,
                  deňi-duş-u, dost-ýardan,
Pul tapmasaň göterme
                  näkes bile süýthordan,
Her dilände gam basar,
                  köňlüň dolar gubardan,
Dogmaz togsan dört ýylda,
                  bogaz bolsa är-ärden,
Kyrk ýyl maýa gezinçäň,
                  bütin bir ýyl ner gezgin.

                    51          
            Köňlüm
Ajyz ser ýassykda, ymzanmaz tenim,
Hoşlaşyk salamyn berendir köňlüm.
Dişlerim gyjynar, ýörimiz ganym,
Ol pulsyrat oýnun görendir köňlüm.

Hoş galyň, gülşenli eý tämiz baglar!
Toý-tomaşa tutup gezilen çaglar,
Boz goçly, marally, dumanly daglar,
Size bir ajyzdyr, garandyr köňlüm.

Gyş pasly ýetişdi, gutardy ýazym,
Çillesi üzüldi, sem boldy sazym,
Ýeke byradarym Mämmetnyýazym,
Gör, ne külpetleri surendir köňlüm...

Sandyrar gollarym, galamym tutmaz,
Şunça köp oýlansam, pikirim ýetmez.
Dişlerim basmaýar, iýenim ötmez,
Ol baky tarapga ýörendir köňlüm.

Okydym destanyň, eý Hoja Ahmet,
Gudratyňa akyl haýran, Muhammet.
Hoşlaşaýly, goluň uzat, eý Ahmat!
Golun aşratlardan üzendir köňlüm.

                  52         
Diregim sanardym, açyp kurany,
Söýerdim, sylardym ýüzi nurany,
Bu gün ýetip geldi ajal permany,
Beýle bir permandan ürkendir köňlüm.

Goluň ýetmez, tutup bolmaz aljagyň,
Adam ogly, ýok panyda galjagyň,
Az-da köp ýaşasaň, ine boljagyň...
Çoh ýagşy işlere ýarandyr köňlüm.

Kimler garyp ötýär, kimseler-de aç,
Kimse köýneklidir, kimse ýalaňaç,
Ömürlik ýoldaşym bolan Bossantäç!
Kabyl ýakasynda durandyr köňlüm...

Söýgüli destanym «Zöhre-Tahyrym».
«Babaröwşen» atly ýene dildarym,
Dünýäde taşladym hem ýogum, barym.
Arz eýläp, bir haka barandyr köňlüm.

Rumuň gülşeni, hindi tawusy,
Ýalançy dünýäden öter men asy,
Nyzamy, Nowaýy, ýene Firdöwsi,
Size mydam hormat goýandyr köňlüm.

Mertler aglar, tuta bilmez ýaragy,
Eňekler gagşaşar, gandyr garagy,
Hoş gal, gökleň şiri molla Pyragy,
Size sary rowan bolandyr köňlum.

                 53          
Owgandan Eýrana ýöregen aglar,
Altyndan jylawly begres bezgitler,
Il-halk üçin baş göteren ýigigler!
Sizden karar eýläp durandyr köňlüm.

Sowukdyr yssydan gorap eklediň,
Ýüpege çoladyň, doga beklediň,
Ezizim diýip, götergiläp sakladyň,
Bagryn bozup, käbäm galandyr, köňlüm.

Aýralykdan meniň ýuregim dagly,
Uçup baran guş men, gözlerim bagly,
Luw ýylyn unutma, türkmeniň ogly!
Remezan aýynda gidendir köňlüm.

Söýerdim gyzlarny, ýagşy juwanlar,
Saz bilsn ötürdim ança döwranlar,
Gajar beg deý, Durdy han deý pälwanlar!
Sizlere dessanlar düzendir köňlüm.

Hoş galyň, gelinler, dostum, duşmanym,
Baýlarym, misginim, beglerim, hanym,
Şu gün tabşyrar men amanat janym.
Bir uýgun deňize düşendir koňlüm.

Baglarymda solup galdy ol reýhan,
Hasaplaş men bilen gel-de sen, bagban!
Ata-watan, hoş gal, eý Maru-Jahan!
Sende lybasyny atandyr köňlüm.

                 54         
Nepes, hoşlaş hanha öwüsdi ýeller,
Gözi ýaşly günler, aýlar hem ýyllar,
Daşyň alyp durdy uluslar, iller,
Hoş galyň, kepene girendir köňlüm...

                 55         ',
    ''
);

SET FOREIGN_KEY_CHECKS = 1;
