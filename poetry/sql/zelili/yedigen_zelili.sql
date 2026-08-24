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
VALUES ('Zelili')
ON DUPLICATE KEY UPDATE name = VALUES(name);

SET @poet_id = (
    SELECT id
    FROM poets
    WHERE name = 'Zelili'
    LIMIT 1
);


INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Zelili',
    '«ÝEDIGEN» kitaphanajygy

  Zelili

       «TURAN»
     Aşgabat, 1991
              Zelili – Goşgular
   Kitapça türkmen klassygy Gurbandurdy
         Zeliliniň goşgulary girizildi.
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
PDF-a geçirildi: 25. Awgust 2013
«» sahypasynyň kitaphanasy.
               MAZMUNY

Zelili . . . . . . . . . . . . . . . . . . . . .   iii
Janymyň jananasy . . . . . . . . . . . .            1
Gelýär . . . . . . . . . . . . . . . . . . . .      3
Köz biläni . . . . . . . . . . . . . . . . .        4
Dostdan gaçar . . . . . . . . . . . . . . .         6
Aldady meni . . . . . . . . . . . . . . . .         8
Aglar . . . . . . . . . . . . . . . . . . . .      10
Iş bolsa . . . . . . . . . . . . . . . . . . .     12
Ýalandadyr . . . . . . . . . . . . . . . .         14
Başda bellidir . . . . . . . . . . . . . . .       15
Käre döndi . . . . . . . . . . . . . . . . .       17
Gürgene gideli . . . . . . . . . . . . . .         19
Bellidir . . . . . . . . . . . . . . . . . . .     20
Boldum . . . . . . . . . . . . . . . . . . .       22
Ýoldur bu . . . . . . . . . . . . . . . . .        24
Indi . . . . . . . . . . . . . . . . . . . . .     26
Eýledi husnuna hyrydar meni . . . . . .            28
Halym perişan . . . . . . . . . . . . . . .        30
Gerekdir . . . . . . . . . . . . . . . . . .       33
Döndi . . . . . . . . . . . . . . . . . . . .      34
Meniň . . . . . . . . . . . . . . . . . . . .      36
Eý gardaş . . . . . . . . . . . . . . . . .        38
Islemen seni . . . . . . . . . . . . . . . .       40

                       ii            
Ýar senden . . . . . . . . . . . . . . . .       42
Seýle gideli . . . . . . . . . . . . . . . .     43
Nyşan, seýidi . . . . . . . . . . . . . . .      44
Salam, seýidi! . . . . . . . . . . . . . . .     46
Watanym seni . . . . . . . . . . . . . . .       49
Sil bolar boldy . . . . . . . . . . . . . . .    52
Halym bardyr . . . . . . . . . . . . . . .       53
Içinde . . . . . . . . . . . . . . . . . . . .   55
Gygyrmak bilen . . . . . . . . . . . . . .       57
Ýaraşmaz . . . . . . . . . . . . . . . . .       59
Özge dem bolmaz . . . . . . . . . . . . .        62

                      iii          
                   ZELILI

                 (1780 — 1852)

Zelili gökleň taýpasynyň gerkez tiresinden bolup,
Gürgen topragynda dogulýar. Etrek we Gürgen-
däki mekdeplerde okaýar. Tanymal şahsyýetler
Azady onuň babasy bolup, Magtymguly onuň da-
ýysydyr. Alym we şahyrlar kowmy Zelilide ylma
we şygra hyjuw oýarýar. Arap we pars edebiýaty
we ylmy onuň düşünjesini baýlaşdyrýar. Gürgen
we Etrek edebi sredasynda tiz tanalýar. 1816-njy
ýylda Hywa hany Muhammetrahym han Gürge-
ne ýöriş edýär we gökleňleriň uly bölegini ýesir
edip, Hywa sürýär. Zelili şol ýesirler bile Hywa
düşýär, 6-7 ýyl onda galyp, 1822-1823-nji ýyllar-
da Etrege dolanyp gelýär. Zelili we Seýdiniň al-
şan hatlary edebiýatda täze žanry emele getirýär.
Zelili başda Magtymgulynyň wepadar şägirdi bo-
lup, soň ol uly klassyk bolup ýetişýär. Onuň yşky
we sosial poeziýasy bar, ol halky we juda şahyra-
na. Onuň bütin goşgulary diýen ýaly türkmeniň
halk aýdymyna öwrülipdir. Zelili hakda birnäçe
monografiýa ýazyldy. Onuň kitaplary dowamly
çap edilýär.

                       iv          
Zelili hak aşyk we pidakärligiň simwolydyr.

                             Tejen Nepesow

                   v          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Janymyň jananasy',
    'Sen-sen meniň dilberim,
 Janymyň jananasy;
 Iki jahan serwerim,
 Köňlümiň gamhanasy.

 Ýüzleriň gül-gülmüdir,
 Owazyň bilbilmidir,
 Zülpleriň sünbülmidir,
 Dişleriň dür dänesi.

 Yklym perizady sen,
 Gamgyn köňlüm şady sen.
 Sen bir yşkyň ody sen,
 Men pakyr perwanasy.

 Men bir misgini-gedaý,
 Sen näzenin, husna baý,
 Kirpigiň ok, gaşyň ýaý.
 Men onuň nyşanasy.

 Jynmu sen ýa almu sen,
 Janyma ajalmu sen,
 Güňmu sen ýa lalmu sen,
 Eý, sonalar sonasy.

           1          
Gylaw berdiň duşmana,
Dosgy kyldyň bigana,
Indi görmek gümana,
Ýamandyr zamanasy.

Zelili, ahy-zaryň,
Dilberim, alla ýaryň,
Birew sorsa «Ne käriň?»
— Bir senem diwanasy!

          2          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Gelýär',
    'Eý ýaranlar, musulmanlar,
Görüň, söwer ýarym gelýär;
Halaýygy haýran edip,
Ol serwi-rowanym gelýär.

Bize dogry-dogry bakar,
Müjgäň tygy jany ýakar,
Agzy pisse, lebi şeker,
Dişleri dürdänem gelýär.

Sallanyp çykypdyr düze,
Nazaryn salandyr bize,
Kast eder bu janymyza,
Gözleri girýanym gelýär.

Gaz ýöriş, maral bakyşly,
Keýik gez, tugun nakyşly,
Badam gabak, ýakut saçly,
Zülpi zerefşanym gelýär.

Diýr Zelili, garşy alyň,
Jary alyp, ýolun çalyň,
Gol gowşuryp, hyzmat kylyň,
Meniň Döndi hanym gelýär.

            3          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Köz biläni',
    'Dilber, sen meni ýandyrdyň
Bir görünmez köz biläni;
Ýene ýüz kürsä mündürdiň,
Müň doýdurdyň näz biläni.

Ýakyp sen içim-daşymy,
Telbe edip sen başymy,
Alyp sen akyl-huşumy
Şol piýala göz biläni.

Husnuň dünýä şugla salar,
Aý-gün ýanaşsa, uýalar,
Özünden giden köp bolar,
Ýörir bolsaň düz biläni.

Bagyňa seýle barmadym,
Nowça gülüňi tirmedim,
Aý dek jemalyň görmedim,
Ötdi tomus-güýz biläni.

Düşseň men guluň eline.
Mal-başym huda ýoluna,
Men bermenem ýüz geline,
Ýene togsan gyz biläni.

           4          
Dözmen bu derdi-azara,
Güýç alýar ol bara-bara,
Synam üzre täze ýara
Burç goýup sen duz biläni.

Janym bu jepadan dynmaz,
Yşk derýasy daşar, synmaz,
Bagtym gaflatdan oýanmaz
Söhbet bilen, saz biläni.

Jepbar bagtym bendin açmaz,
Şum talygym murgy uçmaz,
Içden ýaryň ody öçmez
Baran bilen, buz biläni.

Zelili diýr, şamçyragym,
Iki jahanda geregim,
Yşkdan dolupdyr ýüregim,
Egsebilmen söz biläni.

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
    'Dostdan gaçar',
    'Mert hyzmat eder duşmana,
Muhannesler dostdan gaçar;
Gelse görünmez myhmana,
Gizlener, bir hasdan gaçar.

Barsaň, hyra-hyra bakar,
Gürrüldisi göge çykar,
Çöl ýerde çaňgörse gorkar.
Bara bilmez, pesden gaçar.

Eýlese bir ýana sapar,
Öz-özünden habar tapar,
Obadan çykgaç at çapar,
Gara görmän, sesden gaçar.

Goçaklara budur pişe,
Günde yşk eder döwüşe,
Muhannes barmaz söweşe,
Syrylyp alysdan gaçar.

Mertge destgir bolar alla,
Bes bir özi – kyrka, ellä,
Ýaby gire bilmez galla,
Gul döner, mejlisden gaçar.

             6          
Eý byradar, bäri durgun,
Gel, bu söze gulak bergin,
Il horlugyň çeker bir gün,
Her kişi ulusdan gaçar.

Zelili, sygyn jepbara,
Uýma her ýeten murdara,
Syýagüwş azm eder şire,
Özge janawar sesden gaçar.

             7          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Aldady meni',
    'Owal başda çirki dünýä
Saz bilen aldady meni;
Owadan geline meňzäp,
Näz bilen aldady meni.

Gapyl bolup, gaýnap daşdyk,
Şeýtanyň şerine gaçdyk,
Köp oýunly söwda duşduk,
Baz bilen aldady meni.

Peýda diýdiler zyýany,
Görkezip altyn kiýany,
Ýek eken soňy-paýany,
Söz bilen aldady meni.

Dünýä uly gyza meňzäp,
Görkezdiler ony bezäp,
Rahat bermän, saldy azap,
Ýüz bilen aldady meni.

Dünýä owal özün öwdi,
Tutaý diýsem, ýüzün sowdy,
Ýurtdan aýryp, Hywa kowdy,
Duz bilen aldady meni.

           8             
Bu mekana gonan göçdi,
Niçe çyra ýanyp öçdi,
Sansyz ýyllar gelip geçdi,
Ýaz bilen aldady meni.

Zelili, çekdik jebrini,
Görmedik oňat döwrüni,
Ýat eýletdirip Gürgeni,
Boz bilen aldady meni.

            9          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Aglar',
    'Beň çeken sermest humarbaz
Galar borja, «pul» diýp aglar;
Gündiz roza, gije namaz,
Çyn derwüşler «ýol» diýp aglar.

Azmaz zaty dogry är çyn,
Ýaman ýolun alar peri, jyn,
Aşyklar magşugy üçin,
Şeýda bilbil «gül» diýp aglar.

Sugun, hyrs jeňňeli söýer,
Keýik, gulan çöli söýer,
Meges peşe baly söýer,
Guwwaslar «dür», «lagl» diýp aglar.

Saýraşar murg pasly-ýazlar,
Geler hoş dürli owazlar,
Heňňam bilen uçar gazlar,
Sona, ördek «köl» diýp aglar.

Kerler: «Waý gulagym ker» diýr,
Körler: «Iki gözüm ber» diýr,
Şalar «nöker», baýlar «zer» diýr,
Pakyr, misgin «mal» diýp aglar.

               10          
Mert bolsaň, ýakyna-ýada
Barabar bol, ýet imdada,
Ýolagçylar teriň suwda
Kä «naw, taýmyl, sal» diýp aglar.

Aýdar Zelili biçäre,
Günde ýüz köý geler sere,
Her kim düşse garyp ýere,
Zarlar, «watan, il» diýp aglar.

               11          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Iş bolsa',
    'Namart öýünde gabarlar,
Bir zerre ýakmaz iş bolsa;
Özüni bilmez, göterler,
Eger on öýe baş bolsa.

Öýde bolar gyňyr kişi,
Çöle çyksa, köp teşwüşi,
Namardyň edejek işi —
Saklar, gorkusyz goş bolsa.

Namart owal öýden gitmez,
Eger gitse, goşdan ötmez,
Goç ýigit hergiz gaýytmaz,
Döndermez ýüz, müň baş bolsa.

Namartlar sözün zikr eder,
Gitdikçe özi pikir eder,
Hudaga ýüz müň şükr eder,
Duşman arasy daş bolsa.

Namartlaryň huşy göçer,
Lebi gurar, gany gaçar,
Goç ýigitler serden geçer,
Güýçli ganyma duş bolsa.

            12          
Namart şonda ýere döner,
Güwşi salyk hara döner,
Goç ýigitler şire döner,
Şol meýdanda söweş bolsa.

Zelili diýr, muhannesler,
Ýow görse, titrär namartlar,
Mestana ýöreýip mertler,
Islär, günde döwüş bolsa.

            13          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ýalandadyr',
    'Barça günäniň enesi
Gybat bilen ýalandadyr;
Ili aldamak tenesi
Az berip, köp alandadyr.

Men-menlikde gezer käsi,
Günbe-günden bolar asy,
Agyz içiniň yzasy
«Gah-gah» edip gülendedir.

Ýygjak bolup dünýä-zeri,
Garyplara derdeseri,
Zat diýp çapar baýy-piri,
Gözi gumdan dolandadyr.

Ne pakyry, ne daýhany,
Ölüm bilmez begu-hany,
Bir wagt çekerler puşmany
Haly zebun bolandadyr.

Zelili aýdar, bu haly,
Kimse egsik, kimse doly,
Eziz ömrüň zowaly
Eltip göre salandadyr.

           14         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Başda bellidir',
    'Boljak ýigit ýaşlykdan,
Ol owwal başda bellidir;
Ula-kiçä özün aldyr,
Deň bilen duşda bellidir.

Birewe ýoldaş bolanda,
Gatnaşyp, gardaş bolanda,
Ýagşy-ýaman iş bolanda,
Çyn dost geňeşde bellidir.

Bir niçe adam çen bilen,
Çeni gatadyr çyn bilen,
At tanatdyrmaz syn bilen,
Ýüwrük ýaryşda bellidir.

Köp goşun başlan serdarlar,
Mert kişiler gider barlar,
Namart gury öýde gürlär,
Batyr söweşde bellidir.

Her kişiniň bolsa akly,
Söz jaýynda sözlär hakly,
Uzak ýola agyr ýükli
Iner gidişde bellidir.

            15          
Ilden yrak çöl ülkede
Şir saýar özün tilki-de,
Suhangöýler märekede,
Jomartlar aşda bellidir.

Zelili diýer, serhoşlar,
Ýorga münüp, ýüwrük goşlar,
Eýesin islän derwüşler
Säher göz ýaşda bellidir.

            16             ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Käre döndi',
    'Ýyl-ýyldan işler pis boldy,
Her kişi bir käre döndi;
Ýaman işler peýda boldy,
Pysky-pysat bara döndi.

Il üçin aglaýan sesler,
Belent boldy niçe pesler,
Pul ýygnaýan muhannesler,
Her biri bir äre döndi.

Bir niçeler gapyl ýörer,
Eklenç üçin janyn berer,
Anty-şerti oýun görer,
Ant-kasam hünäre döndi.

Ýylda birin ikä keser,
Gelen ryzkyň ýolun tusar
Algy diläp, ýüzün asar,
Il bary süýthora döndi.

Ajy derdi jana salar,
Ondan soňra melul bolar,
Işan, sopy hem mollalar —
Barysy betkäre döndi,

            17           
Garyplar galmady sanda,
Mürewwet ýok begu-handa,
Eý ýaranlar, şu zamanda
Diwan işi para döndi.

Süýde berip, ýygar maly,
Garamazlar sagy-soly,
Şu günlerde uly ili
Gassap dek soýara döndi.

Zelili diýr, dar bu jaýlar,
Elip kaddym boldy ýaýlar,
Şu eýýamda niçe baýlar
Göýä sokjak mara döndi.

            18          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Gürgene gideli',
    'Hywa hannyň salgydy agyr,
Han ýanynda günüň ygyr.
Halap söýen maly sygyr,
Däli Gürgene gideli.

Hywa hannyň aty bolar,
Dürli gülli oty bolar,
Ýeri, ýurdy gaty bolar,
Däli Gürgene gideli.

Han ýanynda günüň hatar,
Ýazyna buzuny satar,
Hywa gelen borja batar,
Däli Gürgene gideli.

Zelili diýr, ýandym munda,
Ýarym aglaýandyr onda,
Biz galdyk hanyň zulmunda,
Däli Gürgene gideli.

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
    'Bellidir',
    'Dostlar, artyk söz çekmek,
Är ýanynda bellidir;
Supra ýaýyp, nan dökmek,
Bar ýanynda bellidir.

Ganym görende mertler,
Goş başynda namartlar,
Çölde gezen aç gurtlar
Har ýanynda bellidir.

Başa düşse ýaman iş,
Şonda gerekdir gardaş,
Şir ganymy syýagüwş
Şir ýanynda bellidir.

Men aýdaýyn bire-bir,
Agaç içinden gurt iýr,
Osolny aňtap, kişmir
Mar ýanynda bellidir.

Aňlana ber nesihat,
Aňlamaz tutmaz öwüt,
Bir tagsyply goç ýigýt
Ar ýanynda bellidir.

          20             
Bahar açylar güller,
Saýrar gumry-bilbiller,
Ziba, näzli gözeller
Tör ýanynda bellidir.

Zelili diýer, ýa hak,
Bu garyp halyma bak,
Artan-egsen, galan ýük
Ner ýanynda bellidir.

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
    'Boldum',
    'Ýesir bolup, munda gelip,
Jandan doýan ýaly boldum;
Ýagşy meýlisden aýrylyp,
Göýä çopan ýaly boldum.

Garyplyk aldy kuwwaty,
Çeker boldum muşakgaty,
Ýüz müň gaýgy-garamaty
Başa goýan ýaly boldum.

Taşlap geldik ol mekany,
Jebre saldyk şirin jany,
Pähm edip peýda-zyýany,
Indi duýan ýaly boldum.

Howp aldy aklyň öýüni,
Aldyrdyk iliň ýerini,
Indi watanyň şükrüni,
Ýagşy bilen ýaly boldum.

Görmedim köňül çagyny,
Aldyrdym ýürek ýagyny,
Çekip watanyň dagyny,
Oda köýen ýaly boldum.

           22         
Ötdi aýralyk yzasy,
Gaçdy Hywanyň mazasy,
Göýä bir otly lybasy
Egne geýen ýaly boldum.

Neler gördük zalym handan,
Aýyrdy eziz watandan,
Zelili diýr, şu mekandan
Göýä doýan ýaly boldum.

          23         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ýoldur bu',
    'Owal Adam ata döräp,
Erenler geçen ýoldur bu;
Pygamber hasasyn süýräp,
Weliler geçen ýoldur bu.

Buhar telpegi başynda,
Sürgün ýorganyň joşunda,
Aýny ýigrimi ýaşynda
Ýigitler geçen ýoldur bu.

Ol dereden derä bukan,
Çakmak çakyp, otlar ýakan,
Dagdan aýrak, umga ýykan
Mergenler geçen ýoldur bu.

Ternawly ýapdan ýakanlar,
Gülli ýorunja dakanlar,
Höwes bilen at bakanlar,
Seýisler geçen ýoldur bu.

Dogry oturyp, gyýa bakan,
Aşygynyň janyn ýakan,
Gözün süzüp, gaşyn kakan
Gözeller geçen ýoldur bu.

            24         
Ak ýüzünde haly taýly,
Şirin sözli, hoş roýly,
Uzyn boýly, göwsi jaýly
Gelinler geçen ýoldur bu.

Zelili ýar üçin aglap,
Ýandyrdy ýüregin daglap,
— Garybym – diýp, dessan baglap,
Şasenem geçen ýoldur bu.

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
    'Indi',
    'Biliň, ahyrzaman ýakyn
Gelipdir bigüman indi;
Bolupdyr il ile ýagy,
Oba oba duşman indi.

Çykypdyr täze ýol ýoda,
Galypdyr öňki urp-kada,
Gulak salmazlar nurbada,
Diňlemezler aman indi.

Köňüle kine dolduryp,
Pakyr malna göz gyzdyryp,
Ýersiz bir-birin öldürip,
Ederler nahak gan indi.

Rast dogry ýoldan gaýdarlar
Rahy-şeýtana giderler,
Jan dostlaryna aýdarlar
Aldag-ähdi ýalan indi.

Birewden pul karz alarlar,
Soň dönüp, dawa kylarlar,
Tobasyz, küfr bolarlar,
Geçerler biiman indi.

           26          
Gezerler, nämährem gözde,
Hergiz uýat bolmaz ýüzde,
Haýa-şerim gelin-gyzda,
Ýokdur edep-ekram indi.

Refs edip ylma-kelama,
Asy bolarlar möwlama,
Lukma dönüpdir harama,
Şübhelidir aş-nan indi.

Alyma hyzmat kylmazlar,
Pent-nesihat almazlar,
Aňlamazlar, hiç bilmezler,
Sud kaýsydyr, zyýan indi.

Abytlarda ybadat ýok,
Baýda haýyr-sahawat ýok,
Begde rehim, şepagat ýok,
Zalym bolmuş soltan indi.

Nebs üçin il gezer pirler,
Tamyg edip, el sererler,
Kazylary ýüz görerler,
Bolmaz dogry diwan indi.

Bet işe ederler meýli,
Ýada salmazlar jelili,
Aýdar gelipdir Zelili,
Ýagşy ötüp, ýaman indi.

            27          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Eýledi husnuna hyrydar meni',
    'Ýaňy başdan oda saldy ýar meni,
   Eýledi husnuna hyrydar meni.
   Zülpleri tar-tar meni,
   Aglatdy zar-zar meni,
   Gaşy keman, kirpikleri tir meni,
   Eger görse, gamzalary iýr meni,
   Öldir bu gün gözleri ganhor meni.

   Jahan içre meni ryswa kylypdyr,
   Bu eziz ömrümi kötä kylypdyr,
   Maňa jepa kylypdyr,
   Ýakyp eda kylypdyr,
   Gaýgy bile sargaryp,
                   gül reňkim solupdyr,
   Illere meşhur edip,
                   indi gözden salypdyr,
   Çyn owsunjy-sahyrym,
                   syýa saçy mar meni.

   Yzynda kylypdyr ýar meni sana,
   Mejnun kibi däli, telbe, diwana.
   Ýarym gözi messana,
   Dişi sadap, dürdane,
   Pelek ýardan aýyrdy,
                   kyldy meni bigana.

                   28         
Men ah urup aglar men,
                 ahym çykar asmana,
Bu azara goýdy sütemkär meni.
Ýar jemalyn görkezip,
                 otlar saldy bu jana,
Örtendi gara bagrym,
                 ýüregim döndi gana.
Ady düşdi Eýrana,
Balh, Buhar, Badahşana,
Aşak Bagdad, Müsüre,
                 Kengana, Rumustana,
Meniň ýarym deý neri
                 gelmez indi jahana,
Eýledi köýünde şermisar meni.
Zelili diýr, düşdüm ýaman söwdaýa,
Rehm etmedi men dek ejiz gedaýa,
Kaddy meňzär suraýa,
Ýüzi ogşaýyr aýa,
Bilmeýir men, niçik galdy başym belaýa,
«Dat, perýat, dilber» diýdim,
                 hiç ötmedi haraýa.
Etdi ýaman derde giriftar meni.

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
    'Halym perişan',
    'Pyrakyňda seniň, eý, serwi-rowan,
Bolupdyr bu meniň halym perişan,
Eý, biwepa ýar,
Köp berdiň azar,
Menden ne günä gördüň, eý jenan,
Alma zenahdan,
Zülpi huraman,
Ýandyrdyň meni,
Köýdürdiň meni,
Rehimsiz dildar,
Gözleri ganhor.

Çyn nurana wežh baýza berkemal,
Labzy şähdi-şeker, eý sahypjemal,
Bäri gel-bäri,
Görset didary,
Çekdirme beýle ah ile efgan.
Güldürme duşman,
Bagrym doly gan,
Ýandyrdyň meni,
Köýdürdiň meni,
Rehimsiz dildar,
Gözleri ganhor.

              30          
Magşuk aşygyna nazar salmazmy,
Jepa galyşmazmy, rahat gelmezmi?
Akdy eşgim gözden,
Sylmaklyk sizden,
Köp umydym bar, eý, mahy-taban,
Derdim perawan,
Goýduň çoh arman,
Ýandyrdyň meni,
Köýdurdiň meni,
Rehimsiz dildar,
Gözleri ganhor.

Eý, aýny-katyl, gamzasy hanjar,
Ýitidir neşterden, bagryma sanjar,
Eý, kaddy-şemşat,
Eý, zulmy apat,
Müjgenleriň tirdir, gör, ebruň-keman.
Eý, pisse dahan,
Dişleri dürden,
Ýandyrdyň meni,
Köýdürdiň meni,
Rehimsiz dildar,
Gözleri ganhor.

               31         
Bolup men yzyňda däli-diwana,
Wasly-wysalyňdan etme bigäne,
Erk sende, jan ýar!
Nurbat, aman ýar,
Zelili aýdar, eý, keremli soltan,
Ýoluňda bu jan,
Başym terjiman,
Ýandyrdyň meni,
Koýdürdiň meni,
Rehimsiz dildar,
Gözleri ganhor.

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
    'Gerekdir',
    'Dergähiňe bir arzym bar, ýaradan,
Bize bir mähriban Leýli gerekdir;
Bugdaýy reň bolsun akdan-garadan,
Ýagşy gylyk, ýagşy hoýly gerekdir.

Gaýraty köp bolsun işde, jedelde,
Gara saçy düşsün ak ýüze dalda,
Ýagşy ata, ýagşy ene görelde,
Aşygy öldürji towly gerekdir.

Boýy uzyn bolsun, ýüzi ak bolsun,
Balaman bakyşly, tugun tap bolsun,
Hemme bet işlerden süňňi sap bolsun,
Emma bezenişi şaýly gerekdir.

Zelili, dergähe ýüzüm tutar men,
Kabul kylsaň, şirin jandan öter men,
Gadam goýsaň, gaş üstünde göter men,
Didämiň üstünde ýoly gerekdir.

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
    'Döndi',
    'Gulam şahym, saňa dada gelmişem,
Eşitgin arzymny, haraýym Döndi;
Perwana dek urup, oda gelmişem,
Eger razy bolsaň, ýanaýym, Döndi.

Ýaradan alladan gaýry pena ýok,
Dilde zikir, senden başga sena ýok,
Men bilmedim, mende zerre günä ýok,
Hatam bolsa, geçgin günäýim, Döndi.

Men aglar men, zag gonupdyr gülüňe,
Gel, bir sözle, guwanaýyn tiliňe,
Beýle jebr etmegin misgin guluňa,
Syr perdäň, aç ýüzüň, göräýim, Döndi.

Hijran ody bilen ýürek daglaly,
Iki elimiz ýakamyzda baglaly,
Çola ýerde zaryn kylyp aglaly,
Ahyry işidir hudaýym, Döndi.

Bolmadym dünýäde bäş gün parahat,
Gündiz aramym ýok, gijeler rahat,
Mundan artyk hiç bir bolmaz muşakgat,
Bir günüm ýyl, ýüz ýyl bir aýym, Döndi.

                 34          
Ezeli – hakyky aşykam çyndan,
Köňlümiň riştesi üzülmez senden,
Umyt bar munda jan çykynça tenden,
Ahyretde sen-sen tamaýym, Döndi.

Zelili diýr, indi telbe bolup men,
Çykabilmän, yşk bährinde galyp men,
Seýidini alyp, seýle gelip men,
Budur meniň dostum – hemraýym, Döndi.

                35        ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Meniň',
    'Eý byradar, jellat gözli bir zalym.
Yşk oduna süňňüm ýakandyr meniň;
Hasratyndan ah çekmekden eňränim
Sadap dek dişlerim dökendir meniň.

Zowky dünýä maňa bolupdyr haram,
Ne mende takat bar, ne sabry-aram,
Aglamakdan her ruzy-şeb, subhy-şam,
Gözüm ýaşy sil dek akandyr meniň.

Köňül talwas eder, ýete bilmenem,
Baş alyp, bir ýana gide bilmenem,
Ynjalyp, parahat ýata bilmenem,
Bagryma sanjylan tikendir meniň.

Dadyma ýeten ýok, men kylsam haraý,
Onuň üçin telbe bolup men gedaý,
Kirpigin ok edip, gaşlaryny ýaý,
Synamy nyşana dikendir meniň.

Öýkäm köpdür näzli ýaryň ýüzünden,
Saldy meni uly iliň gözünden,
Iki dünýä aýrylmanam yzyndan,
Zülplerin boýnuma dakandyr meniň.

                36         
Ýokdur bu jahanda meniň deý bolan,
Hak aşygam çyndan, diýmenem ýalan,
Gahar edip, yşkyň çiriki bilen,
Gelip, ýar öýüme bukandyr meniň.

Zelili, dogry dur hakyň ýoluna,
Her söz geler şahyrlaryň tiline,
Turup, hijran pilin alyp eline,
Köňlüm ymaratyň ýykandyr meniň.

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
    'Eý gardaş',
    'Halymdan habaryň ýokdur, eý gardaş,
Öňküden zyýada boldy pyganym;
Derdimi içimde pynhan kylardym,
Indi äşgär boldy syrry-pynhanym.

Uýat-haýa, şerim gitdi ýüzümden,
Şeb bidaram, hab nist bolup gözümden,
Köňül etme, byradar, meniň özümden,
Erkim ýokdur, yşk alyp ygtyýarym.

Derdim başdan aşa, köňlüm gamlydyr,
Subhu-şam kemelmez, çeşmim nemlidir,
Girýanyň menden az, derdiň çemlidir,
Meniň saňa müň hessedir girýanym.

Yşk ýolunda mydam özümi çaglap,
Muhapbet potasyn bilime baglap,
Külbeýi-ahzanda ýatyr men aglap,
Bilmesin diýp, hiç kim ýagşy-ýamanym.

Bagtym murgy uçmaz-peri gyryldy,
Hijran meýdanyna matam öwrüldi,
Ýandym, eda boldum, külüm sowruldy,
Kimse tapmaz jahan içre nyşanym.

                38         
Galmaz, ýykylypdyr köňlüm diregi,
Aldy degre-daşym yşkyň çirigi,
Galdym haýran, ýokdur destim ýaragy,
Alar indi janym, bermez amanym.

Zelili diýr, gitmez synamyň dagy,
Ab dolmuşdyr, synyp küşdim gyragy,
Derýa batdym, eden ýokdur soragy,
Meger, sorag ede ol Döndi hanym.

                39         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Islemen seni',
    'Köp çekdim jebriňi jepaly, dilber,
El göterdim indi, islemen seni;
Bolmadyň sen maňa wepaly, dilber,
El göterdim indi, islemen seni.

Dünýe eşretinden jyda eýlediň,
Mejnun dek yzyňda geda eýlediň,
Halaýyk içinde ryswa eýlediň,
El göterdim indi, islemen seni.

«Ýar» diýip, saýramakdan tilim galmady,
Indi «ýar» diýmäge halym galmady,
Deprenere hiç mejalym galmady,
El göterdim indi, islemen seni.

Iýenim, içenim çykmaz ýüzüme,
Ebgärligim zahyr boldy özüme,
Ýakyndan ak-gara görner gözüme,
El göterdim indi, islemen seni.

Dönüp, garar bolsam öten mahala,
Ahy-hasrat bilen geldim bu hala,
Aýlansaň başyma günde ýüz ýola,
El göterdim indi, islemen seni.

                40         
Göz ýaşym akmakdan hunriz bolupdyr,
Synam jerahaty göz-göz bolupdyr,
Meniň senden iýnim bez-bez bolupdyr,
El göterdim indi, islemen seni.

Zelili diýr, keşdim suwda synandyr,
Istihanym yşk oduna ýanandyr,
Indi köňlüm senden buza Dönendir,
El göterdim indi, islemen seni.

                41         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ýar senden',
    'Ýaňaklary läläm, pisse dahanym,
Men döner men, köňlüm dönmez ýar senden;
Roýy gül-benewşäm, toty suhanym,
Men döner men, köňlüm dönmez ýar senden;

Perhat «Şirin» diýip, munça gezendir,
Mejnun, Leýli sütemine dözendir,
Diýmegil: «Ýar menden elin üzendir»,
Men döner men, köňlüm dönmez ýar senden;

Çykmak bolmaz ýaradanyň emrinden,
Adamzatdyr, görer biri-birinden,
Ölen aşyk ýokdur magşuk jebrinden,
Men döner men, köňlüm dönmez ýar senden;

Bu ýalan jahanda sen-sen daýanjym,
Göwherim, hazynam, magdanym, genjim,
Maksadym, myradym, köňül güýmenjim,
Men döner men, köňlüm dönmez ýar senden;

Zelili diýr, meniň Döndi hanym sen,
Jesedim içinde şirin janym sen,
Gyýmazym, dözmezim, mähribanym sen,
Men döner men, köňlüm dönmez ýar senden.

                 42        ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Seýle gideli',
    'Iki jahan byradarym, hemdemim,
Gel, Seýidim, ýara seýle gideli;
Hoş mübärek gül ýüzüni görmäge,
Gel, Seýidim, ýara seýle gideli.

Baraly, soraly, nedir ahwaly,
Biziň üçin talhmy aby-zulaly,
Ýaşy on dört-on bäş, aýny mahaly,
Gel, Seýidim, ýara seýle gideli.

Ýüzleri nurana, hurşydy-taban,
Kaddy şemşat erer, zülpi huraman,
Dişleri dürdäne, lagly-Badahşan,
Gel, Seýidim, ýara seýle gideli.

Agzy çün pissedir, lebleri baldyr,
Gözleri pyýala, gaşy hilaldyr,
Gören göz aýyrmaz, sahypjemaldyr,
Gel, Seýidim, ýara seýle gideli.

Zelili aýydar, ol Döndi hana,
Gideli, bir işi eýläp bahana,
Belki, gamgyn köňül bola şadýana,
Gel, Seýidim, ýara seýle gideli.

                43         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Nyşan, seýidi',
    'Ýakyn köňül bilen bu ýyrak ýerden
Gönderdim men saňa nyşan, Seýidi!
Gündogdudan, Hallygylyç serdardan,
Ýazyp bir zarynjy dessan, Seýidi!

Aldandyk, tersleşdik, hanyň hyýaly,
Dini dostdur, ýaman kuffardan päli,
Ýurdundan turuzyp, agladyp ili,
Kyldy harap, etdi weýran, Seýidi!

Galdyk bu mähnetden munda sakynyp,
Ryzkymyzny sagdan, soldan tapynyp,
Daş gaçarmyz, görenmizden gypynyp,
Mesgenimiz çöl-beýewen, Seýidi!

Häli-şindi watan düşmez agzymdan,
Nanu-nemek asan ötmez bogazymdan,
Gije-gündiz seni diýip gözümden,
Akar ýaşym bady-baran, Seýidi!

Hat ýollamak, unutmazlyk ýatlaşyp,
Aýralyk bir dag-düwündir gatlaşyp,
Gürgeniň düzünde toý-toý artlaşyp,
Ýene sürsek bile döwran, Seýidi!

                 44         
Bu otlara bu jan dözmez, men dözsem,
Ýurt şirin zat, köňül üzülmez, el üzsem,
Tapmaryn Hywany, Buhary gezsem,
Seniň deý özüme ýaran, Seýidi!

Ata-baba geçen jaýlary görsem,
Gürgenden nan iýsem, Etrekde ýörsem,
Degmeseler, at üstünden bir barsam,
Hiç bolmasa etsem seýran, Seýidi!

Men neýläýin, galdy ara daş bolup,
Ganatym ýok, uçup gitsem, guş bolup,
Saglygymyzda bir-birge duş bolup,
Aýrylyşsak, galmaz arman, Seýidi!

Gezer bu Zelili örtenip, bişip,
Bardy niçe aýrylanlar gowuşyp,
Öten bahar Kesarkaçda sataşyp,
Hany etdigiň ähdi-peýman, Seýidi?

                 45          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Salam, seýidi!',
    'Köňli çökgün — bu biçäre garypdan,
Gönderdim men saňa salam, Seýidi!
Ýollar hyz-haramy, aralyk ýaman,
Baryp, hal-ahwalyň sorma, Seýidi!

Üç ýyl boldy bir görmäli didaryň,
Gelmedi bir hat-galamyň, güftaryň,
Azaby-kyýamat—çeken azabyň,
Hak bersin derdiňe şypa, Seýidi!

Eşitdim, gidip sen karzdar bolup,
Hatyjany bir görmäge zar bolup,
Ýat illerde garyplykdan har bolup,
Göçe-göçe ilden-ile, Seýidi!

Söz sorana diýrem aklym ýetenden,
Pent alana biýrin zehnim tutandan,
Tä ölinçä aýyrmasyn watandan
Hiç bir bendesini huda, Seýidi!

Dert kän munuň kaýsysyna ýanaly,
Synam üsti çapraz-çapraz ýaraly,
Ataşsyz örtedi zalym gaýraly,
Berdi jaýsyz jebri-jepa, Seýidi!

                 46         
Ýat etsem şol öten ýowuz günleri,
Eşki-çeşmim derýa eder çölleri,
Parahat oturan abat illeri
Bibat etdi bu paňkelle, Seýidi!

Gije bardy, gündiz barmady aýyk,
Gapyllykda harap boldy halaýyk,
Iş etmedi musulmanlyga laýyk,
Saldy başlaryna gowga, Seýidi!

Sürüldiler il barysy eňşeşip,
Pyganyna daglar, daşlar gymşaşyp,
Asman joşa geldi, zemin gowşaşyp,
Bulutlar durdular nala, Seýidi!

Görmesin ol jebri musulman bende,
Bady-baran garlyp ýagar tün günde,
Köpi ölüp galdy, az çykdy zinde,
Arkaç indi uwla-uwla, Seýidi!

Müýmün bolan bolar bu işe girýan,
Bagry para-para, baglap ýürek gan,
Ýesiriň ilersi barypdyr Tähran,
Gaýrasy dolupdyr Hywa, Seýidi!

Diýmek size ne hajatdyr — gördüňiz,
Sözlemesek, egsilmeýär derdimiz,
Ýokarsy Ýolöten, aşagy deňiz,
Pytrady il bu iki ara, Seýidi!

                 47         
Kimi garyp goňşy, kimisi daýhan,
Kimi goýun çopan, kimisi sarwan,
Gözel iliň şeýle bolanna dözmän,
Men aglaryn, sen hem agla, Seýidi!

Men bilmenem, siňipmidir gargyşlar,
Geldi bir musallat, dagyldy başlar,
Pelek bakyp, ýene dönse gerdişler,
Şaýet, rehm eýlese alla, Seýidi!

Ürgenji illermiz gaýtsalar bäri,
Saga-sola dargan ýygylsa bary,
Jem bolup ýöresek, galmasa biri,
Sürüp barsak Garrygala, Seýidi!

Çomry sada bolsa, çarwa – Sergizde,
Günbatary Çatda, Öýlük düzünde,
Gündogary Hartut, ardy Margizde,
Öňi baryp gonsa Guwla, Seýidi!

Zelili diýr, şol jaýlara baransoň,
Bir niçe gün hoş günleri görensoň,
Sizler bile zowky-sapa sürensoň,
Arman galmaz, dolsa kaza, Seýidi!

                 48         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Watanym seni',
    'Ýürek telwas eder, göterler serim,
Köňül arzuw eýlär, watanym, seni!
Etrek, Gürgen ýurdum – gezen ýerlerim,
Köňül arzuw eýlär, watanym, seni!

Sugunly, umgaly, çal goçly daglar,
Belentden pesdine akan bulaglar,
Sowuk suwly, ter çemenli awlaglar,
Köňül arzuw eýlär, watanym, seni!

Miwesi bihasap, bakjaly baglar,
Awy binahaýat, uly awlaglar,
Ýada düşer ajap döwranly çaglar,
Köňül arzuw eýlär, watanym, seni!

Ýalaňaç horlanmaz mugan gyşyna,
Ýazyna dürli ot, maly başyna,
Ýaýlasynda her kim çykar daşyna,
Köňül arzuw eýlär, watanym, seni!

Tanytmaz, barabar garyby, baýy,
Hiç kişi kişiden bolmaz tamaýy,
Ekseň gyzyl biter, kemdir jepaýy,
Köňül arzuw eýlär, watanym, seni!

                 49         
Boz, ala dyrmykly zynatly öýler,
Gul, gyrnak baýrakly abraýly toýlar,
Gözüm ýaşy durmaz, gelende köýler,
Köňül arzuw eýlär, watanym, seni!

Senemleri kasap-puşeş geýerler
Hereklerne şähdi-şeker iýerler,
Aşyk-magşuk olup, ýanyp-köýerler,
Köňül arzuw eýlär, watanym, seni!

Goç ýigitler gazat üçin çykarlar,
Serdarlary baýaw ýola bakarlar,
Batyrlar gaýtmaz, gala ýykarlar,
Köňül arzuw eýlär, watanym, seni!

Haýp, abat iller ber-bibat boldy,
Dostlar gamgyn boldy, duşman şat boldy,
Aýrylyşdy, aşna-ýarlar ýat boldy.
Köňül arzuw eýlär, watanym, seni!

Gäwüre ne öýke, musulman zary,
Ata oguldan, ene gyzdan saldy aýry,
Her kimiň özüne ýagşy öz ýeri,
Köňül arzuw eýlär, watanym, seni!

Etdiler Ýusupny Müsürge soltan,
Diýdi: – «Bolsam ýegdir bir guly – Kengan»,
Ýurdundan turmasyn hiç bir musulman,
Köňül arzuw eýlär, watanym, seni!

                  50         
Köňlümiň aramy, çeşmim röwşeni,
Men neýläýin, dostlar, onsuz bu jany,
Görermikäm Seýidi deý janany,
Köňül arzuw eýlär, watanym, seni!

Zelili, bu ýurtda aýş ýok, höwes ýok,
Her kim başyna gaý, belent ýok, pes ýok,
Toý-tomaşa, märeke ýok, meýlis ýok,
Köňül arzuw eýlär, watanym, seni!

                 51          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Sil bolar boldy',
    'Gije-gündiz aglamakdan «ýar» diýip,
Indi gözüm ýaşy sil bolar boldy;
Bilbil idim, saýrar idim «gül» diýip,
Saýragan tillerim lal bolar boldy.

Diýmez boldum ahyr «ýar-ýar» diýmekden,
Ýok boldum, tükendim gussa iýmekden,
Eý ýaranlar, gam öýünde köýmekden
Elip dek kamatym dal bolar boldy.

Aklym çaşdy, gitdi dumly-duşuna,
Ahyr gark bolar men gözüm ýaşyna,
Şirin janym düşüp yşk ataşyna,
Ýanyp eda bolup, kül bolar boldy.

Gözüm aglar, köňlüm ýary unutmaz,
Hiç sowulmaz, duman serimden gitmez,
Gaýgy bilen gün ýyrakdyr, daň atmaz,
Her bir günüm indi ýyl bolar boldy.

Zelili zar aglar, bikarar bolup,
Sabyr ýoly menden gyrak sowulyp,
Rahatym kemelip, hasrat köpelip,
Derdi-elem maňa bol bolar boldy.

                  52         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Halym bardyr',
    'Eý byradar, gozgar bolsaň derdimi,
Ejiz, ebgär düşen bu halym bardyr;
Bir senem yzynda bolup diwana,
Hywa, Buhar gitmek hyýalym bardyr.

Çyn byradar bolsaň, bile gider sen,
Garyp, misgin, pakyr köňlüm güýder sen,
Sen meniň hakymda doga eder sen,
Soralmaz, idelmez ahwalym bardyr.

Hasratynda elip kaddym dal eden,
Ýyglamakdan gözde ýaşym sil eden,
Köýünde süňňümi ýakyp, kül eden,
Jebr etgiji sahypjemalym bardyr.

Meniň bu derdimi tebipler bilmez,
Gün-günden güýç alar, hiç bir egsilmez,
Bagtym gaflat içre oýanmaz, galmaz,
Keç täleý ters gelen ykbalym bardyr.

Tenimiň ruhy jeset içre jandyr,
Zülpleri sünbüldir, pisse dahandyr.
Saçlary ýakutdyr, dişi merjendir,
Lebi şeker, aby-zulalym bardyr.

                 53          
Hoş buýy misli bir müşki-anbar dek,
Gül beden hem istihany jöwher dek,
Ýagty salar gije, ýüzi göwher dek,
Gözi ahuw, gaşy hilalym bardyr.

Zelili diýr, yşk oduna dözmenem,
Baş alyp gider men, munda gezmenem,
Tä ölinçä ondan umyt üzmenem,
Rahym-kerim atly jelalym bardyr.

                 54         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Içinde',
    'Arzy-halym bir-bir beýan edeýin,
Gezer boldum ýazsyz gyşyň içinde;
Derdim güýçli, men örtenmän nädeýin,
Gowga köpdür syna-başyň içinde.

Jepa çekip, dünýä ýolun tapmadym,
Toýlar tutup, atlar her ýan çapmadym,
Çekip gonaklary, halat ýapmadym,
Bisan boldum deňi-duşuň içinde.

Bu garyplyk üstümizden gitmedi,
Köňül maksat-myradyna ýetmedi,
Gaýgy-gamsyz meniň wagtym ötmedi,
Gezmedim hiç köňül hoşuň içinde.

Pelek saldy meni tükenmez hala,
Dünýäde ugradym ýüz kylu-kala,
Kyn boldy güzeran, düşdük bir hala,
Kemdest bolduk niçe başyň içinde.

Bimaza görüner göze mekanym,
Ýyl-ýyldan ýeňledi agyr dükanym,
Aýrylyp perzentden, köýdi bu janym,
Gözlerim galdy-la ýaşyň içinde.

                55         
Ölümiň haýbaty basdy gün-gunden,
Ajydyr şirin jan aýrylsa tenden,
Iki ýar sowaly sorarlar menden,
Endişe köp akyl-huşuň içinde.

Zelili diýr, akyl her ýana çaşdy,
Dar boldy bu jaýlar, mazasy gaçdy,
Başyma köp elem-söwdalar düşdi,
Her iş gördüm elli ýaşyň içinde.

                 56         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Gygyrmak bilen',
    'Gapyl ýatma, adam, tur işiňi gör,
Geçdi kerwen, durmaz gygyrmak bilen;
Ajal gelip, tutar ýakaňdan bir gün,
Tutansoň, aýrylmaz çagyrmak bilen.

Azygyň taýýar et, ýagşy çag—bu çag,
Ara gorkulydyr, gerekdir ýarag,
Tetärik kem, wagt teň, menziliň-ýyrag,
Ýetdirmez özüňe zarp urmak bilen.

Rast ýol barka, egri ýola gider sen,
Neçün beýle özüň asy eder sen,
Aga-döne gedem-gedem eder sen,
Goýmazlar parahat şu ýörmek bilen.

Pelek tora salar ahyr aldaýyp,
Sen ondan bihabar gezer sen gaýyp,
Ýörer sen, «dünýäni tutaýyn» diýip,
Tutdurmaz bu dünýä ýüwürmek bilen.

Aýama diländen elde bar zadyň,
Jan öýünden ber diňläne öwüdiň,
Garyp bolsa, ady bolmaz ýigidiň,
Tutanda daglary oburmak bilen.

                 57         
Söweş güni mert ýarasyn baglamaz,
Namart gaçar, dönüp soňun saglamaz,
Akly bolan ölüsine aglamaz,
Ölen dirilermi bagyrmak bilen?

Wagtyna ýetmeýin, baglar bar almaz,
Hazan ýeli çalman, gül reňgi solmaz,
Adam häsiýetin adam hiç bilmez,
Köp bile gezişmen, bir görmek bilen.

Ele düşse ziba, perizat gyzy,
Arwahyň almasa, ýakmaz owazy,
Köňül islemez ýerden bir ýaman sözi
Eşitseň, iç gysar sygyrmak bilen.

Gardaşyň gardaşa sözi ötmese,
Gadyrly bolmasa, köňli ýetmese,
Ýüregi sap bolup, içi bitmese,
Ne magna ýüzüne ýylgyrmak bilen.

Ogry görmez, oba içinde ot görse,
Goýun ýatmaz, agylynda gurt görse,
Är öýüne är ger, mylakat görse,
Ýüz tapmasa, gelmez çagyrmak bilen.

Zeliliniň watan çykmaz serinden,
Aglap gezer, kim aýrylsa ýerinden,
Süňňi haramylar gaýtmaz raýyndan,
Ýaşy gaýdyp, sakgal agarmak bilen.

                58         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ýaraşmaz',
    'Götär diýip, tagna, terene etmek
Dünýä mesi bir murdara ýaraşmaz;
Nesihat bermeklik, öwüt öwretmek
Taňry guýan akyl äre ýaraşmaz.

Asly musulmana dininden dänmek,
Ömre ygtybar, jan barlygna yşanmak,
Begres geýip, bile kemer guşanmak
Çölde gezen çopanlara ýaraşmaz.

Kümüş bolmaz, ýagşy zikge ursaň mise,
Gahry gelmez, eger «gul» diýseň tüýse,
Öwüt tutmaz, öwüt berseň bir pise,
Ýagşy taglym ýaman ýara ýaraşmaz.

Näsazlyk — ata-ogul bir-birine.
Gitmeklik ýaraşmaz gyz ýas ýerine,
Haýasyzlyk, şerimsizlik geline,
Oral garry aýal töre ýaraşmaz.

Boş gaýtarmaz, dileg etseň bir mertden,
Müň ýalbarsaň, işiň bitmez namartdan,
Ker hem lezzet tapmaz asta söhbetden,
Idegsiz gezmeklik köre ýaraşmaz.

                  59         
Derýaga depelik, daglara peslik,
Zalyma rehimlilik, duşmana dostluk,
Bege berimsizlik, raýata meslik,
Gaýgysyzlyk galandara ýaraşmaz.

Aryplara oýnamaklyk, gülmeklik,
Dünýälik diýp, ýügürmeklik, ýelmeklik,
Aşrat sürmek, aş mazasyn bilmeklik,
Ejiz düşen bir bimara ýaraşmaz.

Ýada hem näz etmek, öýke – gardaşa,
Pala, gurra uýmak, ynanmak düýşe,
Dogaça – utanmak, gahar – derwüşe,
Nebis üçin il gezmek pire ýaraşmaz.

Bigadyra – gadyr, näkese – hormat,
Ýakyna hat ýazmak, ýyraga – sargyt,
Abdala – nik puşeş, aşyga – rahat,
Hatarda boş gitmek nere ýaraşmaz.

Ite palaw bermek, ata hem – kepek,
Owlak, guza – nogta, kökene – köşek,
Alamana – ýaby, ýaryşa – eşek,
Toýa münüp gitmek sygra ýaraşmaz.

Doňuz çyksa depä, jeren hem daga,
Bilbil hem jeňele, garga hem baga,
Pyşbaga – agaja, uçsa gurbaga,
Kelpezeden gaçmak mara ýaraşmaz.

                 60          
Mur yssa çydamaz, sowuga – kelguş,
Ýele hem – erbeze, köp ýagmyra – muş,
Şor aba – hemdune, bahr içre – harguş.
Näheň oýnap çyksa, gyra ýaraşmaz.

Aýdýar Zelili, hassa – hoşroýlyk,
Kerke – uzak ýaşamak, pile – garrylyk,
Gurda – dilegçilik, baýguşa – horluk,
Tilki awun iýmek şire ýaraşmaz.

                 61          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Özge dem bolmaz',
    'Ganymat bil saglyk bilen gezeniň,
Dem şu demdir, biliň, özge dem bolmaz;
Bikärdir ýaltanyp, ýaman ýöreniň,
Bu bir hassalykdyr, asla em bolmaz.

Bir niçeler gezer mele don geýip,
Örtener nebsiniň oduna köýüp,
Magtanarlar ile «sopy men» diýip,
Emma weli gözlerinde nem bolmaz.

Hergiz köňül bermäň ýalan pirlere,
Magtanyp, keramat satsa sizlere,
Dilenip gezerler, hordur gözlere,
Şeýtanyň şägirdi hergiz kem bolmaz.

Zelili, sözlegin herne bileniň,
Tiliňde olmasyn gybat-ýalanyň,
Uly iliň adyna aşyk bolanyň
Dünýä üçin ýüreginde gam bolmaz.

                62         
                 —
«» sahypasynyň kitaphanasy.
                 —',
    ''
);

SET FOREIGN_KEY_CHECKS = 1;
