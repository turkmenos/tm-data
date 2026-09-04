SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `page_columns`;
DROP TABLE IF EXISTS `pages`;
DROP TABLE IF EXISTS `documents`;
START TRANSACTION;
CREATE TABLE `documents` (`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,`source_file` VARCHAR(255) NOT NULL,`source_path` TEXT NOT NULL,`created_at` VARCHAR(35) NOT NULL,`page_count` INT UNSIGNED NOT NULL,PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `pages` (`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,`document_id` BIGINT UNSIGNED NOT NULL,`page_number` INT UNSIGNED NOT NULL,`text` LONGTEXT NOT NULL,`character_count` INT UNSIGNED NOT NULL,PRIMARY KEY (`id`),UNIQUE KEY `document_page` (`document_id`,`page_number`),CONSTRAINT `pages_document_fk` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `documents` (`id`,`source_file`,`source_path`,`created_at`,`page_count`) VALUES (1,'magtymguly_hakynda_halk_rowayatlary.pdf','/Users/macmini/Desktop/pdf-to-stories/input/magtymguly_hakynda_halk_rowayatlary.pdf','2026-09-01T08:47:44Z',63);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (1,1,1,'

MAGTYMGULY HAKYNDA HALK ROWAÝATLARY',49);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (2,1,2,'ŞAHYRYŇ ENEDEN DOGLAN GÜNÜNIŇ 225 ÝYLLYGYNA',44);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (3,1,3,'TSSR YLYMLAR AKADEMIÝASY MAGTYMGULY ADYNDAKY EDEBIÝAT INSTITUTY

MAGTYMGULY HAKYNDA HALK ROWAÝATLARY

TÜRKMENISTAN DÖWLET NEŞIRÝATY Aşgabat —1959',145);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (4,1,4,'Çapa taýýarlan MÄTI KÖSÄÝEW

AMAN KEKILOWYŇ redaksiýasy bilen',61);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (5,1,5,'Magtymgulynyň ilki okan ýeri bolan Halaç raýonynda ýerleşýän Idris baba medresesiniň bir görnüşi.',99);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (6,1,6,'Magtymguly hakynda halk arasynda dürli rowaýat hem legendalar döredilipdir, olaryň döremegi biziň zamanamyzda hem dowam etdirilýär.

1939-njy ýyldan başlap, dürli ekspedisiýa çlenleri hem aýry-aýry adamlar tarapyndan ýüzlerçe rowaýatlar ýygnalypdyr.

Magtymgulyny öwrenýänlere hem bu barada eser ýazýanlara, azdan-känden nepi deger diýen niýet bilen, şol ýygnalan rowaýatlaryň bir bölegini çap edip, ilat arasyna ýaýratmagy makul gördük.

Çapa taýýarlananda, mümkin boldukça, maglumat beren adamyň öz aýdyşyny bolşy ýaly saklamaga çalyşdyk.',545);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (7,1,7,'Magtymgulynyň şahsyýeti barada eýýäm köp sanda legendalar aýdylýar.

Akademik A. Ý. Krymskiý

Adym düşdi ilden-ile, Nagyş ederler dilden-dile, Magtymguly, gongul güle, Hazan urup solmagynça.',193);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (8,1,8,'GÖRME-GÖRÜŞ Magtymguly Buhara medresesinde okaýan wagtynda, onuň ders berýän halypasy bolupdyr. Magtymguly öz halypasyna hormat bildirer eken. Ol medreseden gaýdyp gelenden soň hem her iki ýyldan bir gezek Buhara gidip, öz halypasy bilen duşuşyp, görme-görüş eder eken. Magtymguly bir sapar Buhara baranda, şäher derwezesi bagly bolýar, şahyr ertire çenli galanyň daşynda galýar, özi ýaly gijä galan adamlar şahyryň daşyna üýşýärler, Magtymguly olara bir näçe goşgusyny okap, dünýäniň geljeginden, boljagyndan gürrüň berýär. Emiriň dargalary Magtymgulynyň bu aýdýan zatlaryny ahyryna çenli diňläp bolanlaryndan soň: — Bu adam dünýäniň gurluşy hakynda ýaňraýar. Geljegi, boljagy hudaýdan başga adam bilmez... — diýip, şahyry zyndana salýarlar. Magtymguly hat ýazyp, bir adamdan öz halypasyna iberýär, halypasy bolsa emirden diläp, Magtymgulyny halas edýär. Magtymguly halypasynyň ýanyna baryp, saglyk, amanlyk soraşyp, bir näçe gün Buharada bolup, soň öz ýurduna gaýdýar.

Durdynepes Hojanepes ogly, Gökdepe raýon, gagşal, 18.05.1941, 842-nji bukja.

1 ',1080);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (9,1,9,'HYWA ÝOLUNDA Magtymguly Hywadaky «Şirgazy» medresesinde okan wagty, Hazreti Pälwan adynda onuň halypasy bar eken. Ondanam başga şol ýerde okanda, özbekden, garagalpakdan, gazakdan, tatardan gaty kän dostlary bolupdyr. Magtymguly Hywa argyşa gidýän kerwenleriň kerwenbaşysyndan: — Meniň hem goş-kötelimi göterişip, şol ýana atsaňyz — diýip haýyş edýär. Kerwenbaşy razy bolýar. Emma Magtymgulynyň ýoldaşy: — Seni Hywa taraplarda hem şu ýerdäki ýaly tanaýarlar, hormatlaýarlar — diýip, kän azyk-suwluk götertmändir. Magtymguly kerwenler bilen Hywa ýakynlaşanda, şahyryň gelýär sesini eşidip, Hazreti Pälwan öz şägirtlerinden bir toparyny iberip, Magtymgulynyň öňünden çykarýar. Ol ýurtlar Magtymgulyny ondan-oňa çagyryp hezzetleýärler.

Çakan Kötel ogly, Aşgabat Köşi oba, garaýörme. Ýetmiş ýaş, sowatsyz. 20.09.1941.

2 ',850);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (10,1,10,'OŇMADYK DUŞUŞYK Magtymguly zamanynda Amyderýa boýlarynda, Buhara medreselerinde köp okan Nyýazguly halypa adynda bir ulama bolanmyş. Ol adam Halaç raýonynda, soň Pendi taraplarda medrese açyp, ders berip, köp sanda sopular saklar eken. Magtymguly şahyr hem şol tarapa gidýän kerwenler bilen daklyşyp, öz eşegini münüp, Nyýazguly halypa gol bermek üçin gidenmiş. Şahyr baranda sopularyň bolýan ýerinde — myhman jaýda galmaly bolýar. Agşam oturyşykda sopular munuň näme maksat bilen gelendigini bilip, ertesi pirlerine habar berýärler: — Bir eşekli gökleň şahyry saňa gol bermäge gelipdir — diýýärler. Nyýazguly halypa bolsa özüni göreýin hem diýmän, oýlanman: — Bize olar ýaly eşek münüp, şahyrçylyk edip, agzyna gelenini samrap ýören adam gerek däl, biz olar ýaly adamyň goluny almarys, gidibersin — diýýär. Magtymgulynyň ýüregi möwç alyp joşýar, kagyz, galam alyp, «Bilmezmiň» diýen goşgusyny ýazyp, «Piriňize beriň» diýip, sopulara uzadar-da, eşegini münüp, öz ýurduna gaýdýar. Nyýazguly halypa Magtymgulynyň bu goşgusyny okap gören badyna: «Wah, elimize şunkar guşy düşen eken, arman ony uçurypdyrys» diýip, sopularyny şahyryň yzyndan iberýär. Sopular Magtymgulynyň yzyndan ýetip: — Seni pirimiz çagyrar, yzyňa dolan — diýýärler. Magtymguly:

3 ',1283);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (11,1,11,'— Ok kemandan çykan soň, yzyna gaýtmaz — diýip gidiberýär.

Bereket Allaberdi ogly, Kerki, Astanababa obaly, ärsary, şagla tiresi, 73 ýaş, 1941 ýyl.

Allaýar Gurban ogly, 53 ýaş. Garrygala r-n, Gerkez oba sowetine garaşly «Gyzyl baýdak» kolhozy, 31.07.1941.

4 ',277);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (12,1,12,'GARŞYLYKLY ÝIGRENÇ Magtymguly şahyr ylmy, bilimi bolmadyk, hüşür, zekat diýip, iliň malyna söz dikip ýören işan, mollalary ýigrenermiş, olaryň syrlaryny paş edermiş. Şonuň üçin ruhanylar hem oňa göwünleri ýetmän, Magtymgula «şahyr gökleň gul» diýer ekenler. Şonda Magtymguly «Başlady», «Sopular» diýen goşgularyny goşanmyş.

*** Magtymgulynyň dakyndy aýaly bolupdyr. Ol aýalyň iş-pişe bile hem kän höwesi bolmandyr. Şonda Magtymguly «Her ýana» diýen goşgusyny düzenmiş.

Çakan Kötel ogly, Köşi obaly, garaýörme 70 ýaş. 14.11.1941.

5 ',567);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (13,1,13,'SYRLY ÇORBA Bir sapar Eýran şasynyň garamagyndaky hanlaryň talaňçy nökerleri parahat oturan ýomut, gökleň taýpalaryny talap, köp mallaryny sürüp, bir näçe adamlaryny hem ýesir edip alyp gidipdirler. Oba ýaşulylary bir näçe oňat atlar, owadan halylar, gyzylly şaýlar, halat-serpaýlar ýygnap, Eýran şasyna sowgat eltip, ýesirlerini dilemekçi bolýarlar. Şol wagtlar Magtymguly tüýs diýen wagtyndaky ýaş ýigit eken. Magtymguly ýaşulylaryň ýanyna baryp: — Ýesir dilemäge Eýrana gidýän bolsaňyz, meni hem ýanyňyz bilen äkidiň, belki zyýanym degmez — diýse, ýaşulylar: — Seniň ýaly jahyllaryň munuň ýaly möhüm ýerlerde işi bolmaz, bu işler aksakallaryň, ýaşulylaryň işidir — diýip, Magtymgulyny özleri bile äkitmändirler. Haçan-da ýaşulylar gidende, Magtymguly hem olara duýdurman, garaba-garaba yzlaryna düşüp gidipdir. Şol wagtlar şa Mazendaran taraplarynda özüniň ýazky köşgünde bolýar eken. Türk men ýaşulylary şanyň ýanyna baryp, özleriniň matla-

6 ',979);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (14,1,14,'byny aýdanlarynda, şa: — Beýle möhüm iş üçin gelen bolsaňyz, Magtymguly şahyr haýsy biriňiz bolarsyňyz? — diýip soraýar. Şol wagt agajyň aňyrsynda gizlenip duran Magtymguly öňe çykýar-da: — Siziň alyjenabyňyz, Magtymguly diýeniňiz şu kemine guluňyzdyr — diýýär. Şa ýaşulylaryň ýüzüne-de garaman: — Siz Magtymguly bolsaňyz, näme dilegiňiz bolsa aýdyberiň — diýýär. Magtymguly:

«Resul damadydyr, öz arslanyňdyr, Ýa ymam Alyga bagyşla bizni»

— diýip başlaýan goşgusyny aýdyp ugraýar. Şahyr bu goşguda şyga mezhebinde uly hormat goýlan ymamlary hem olaryň ata-babalaryny, neberelerini birin-birin ýatlaýar. Magtymguly bu goşgusyny heniz doly aýaklamanka, şa iki eli bilen ümläp: — Berdim, berdim, berdim... — diýip aglaberipdir. Soňra şa Magtymgulynyň öz köşk şahyrlary bile goşgy aýdyşmagyny talap edýär. Magtymguly olar bile goşgy aýdyşanynda, içi gumly attorbanyň üstünde oturyp aýdyşýar. Şeýlelikde, Magtymguly hemme köşk şahyrlaryny ýeňýär. Şa bu ýagdaýa haýran galyp, näme üçin onuň attorbanyň üstünde oturýandygyny soraýar. Onda Magtymguly: — Bu torbanyň içinde hiç hili keramat ýok, munuň içinde diňe öz ata watanmyň topragy bar. Men şol topragyň üstünde oturan wagtym, oturan ýerim berk, sarsmaz hem ähli halkym arkamda duran ýaly bolup, hiç zatdan gorkmaýan hem hiç kimden ýeňilmeýän — diýip jogap berýär. Şa Magtymgulynyň köşk şahyry bolmagyny arzuw edip: — Sen iň ýagşysy şu ýerde gal, men seni ömrüň ötýänçä hor bolmaz ýaly ederin diýende, Magtymguly:

7 ',1511);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (15,1,15,'— Ýok, tagsyr, men köşk adamsy däldirin, halk adamsydyryn, halkym maňa garaşýandyr — diýýär. Şanyň gahary gelip: — Halkym, halkym... näme halkyň bar? Ne onda baş bar, ne onda aýak bar — diýende, Magtymguly:

Ýomut, gökleň täsip edip özünden, Çyksa goşun, öňi-ardy bilinmez, — Sygman çykdy Deşti-dahan düzünden, Ýörän ýoly, gonan ýurdy bilinmez —

— diýip başlaýan goşgusyny aýdýar.

Mollapüri Abam ogly, Aşgabat raýon, Büzmeýin obaly, 50 ýaş, 01.09.1941.

Durdyýew S., 1959.

8 ',500);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (16,1,16,'ASLYMDAN DÖNMEN Öz obadaşlary bilen bilelikde Magtymguly hem Eýran hanlarynyň goluna ýesir bolup düşýär. Şahyry başga ýoldaşlaryndan aýryp, ony Tährana alyp gidýärler hem şol ýerde ýene alyp galmak isleýärler. Emma Magtymguly: — Men hiç wagt aslymdan dänmen! — diýip:

«Ýaz geler, wagt-da gider, gaflata çykmyş gözlerim, Açaýyn diýsem açylmaz, — ne agyr uýkulydyr.

Bilmeýen soranlara aýdyň bu garyp adymyz: Asly-gerkez, ýurdy Etrek, ady Magtymgulydyr» —

— diýen setirler bilen gutarýan «Äleme belgilidir» diýen gazalyny aýdanmyş.

Anna Begmyrat ogly, Garrygala raýon Arapgala obaly, kolhozçy, 53 ýaş. 27.05.1940.

9 ',639);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (17,1,17,'ŞAHYRLAR NEBERESI Magtymguly Ýonaçy 40 ýaşynda Atanyýaz Kadyr han zamanynda ileri ýüzden bärik geçipdir. Magtymguly Ýonaçy Atanyýaz Kadyr handan: — Men daýhan durar ýaly kim bar? — diýip sorapdyr. Ondan soň Atanyýaz Kadyr han: — Gerkezde milletiň köpüsi gyşyklardandyr — diýip, şol tireden bolan bir adamyň öýüni salgy berýär. Magtymguly Ýonaçy bir gyşygyň öýünde boluberýär. Ol bolýan öýi bolsa Magtymguly Ýonaçyny ogullyk göterýär. «Bu her wagt özümiziňki bolar» diýip, agasynyň ýetişen gyzyny hem oňa alyp berýär. Şondan soň Magtymguly Ýonaçy-da, gerkezde gyşyk bolup giden. Şeýlelikde Magtymguly Ýonaçy ýetimlikden çykyp, Özbaşdak öý-işik bolýar. Magtymguly Ýonaçy pişekär adam bolupdyr. Ol ýüwrükýüwrük atlara ýona tiker eken, uýan, gamçy, çeki eder eken. Aýal tarapynyň işi meşik düýplär eken hem-de az-owlak kümüş ussaçylygyny edip, ýüzük-püzük we şuňa meňzeş şaýlary ýasar eken. Ol başga zada göz gezdirmändir, özüniň girdejisini artdyrjak bolmandyr. Iliň näme hyzmaty bolsa irinmändir. Şonuň üçin il hem «Bu biderek adam däl» diýip, Magtymguly Ýonaçy babamyzy gowy görer eken. Ol ilki gelende Margiziň meýdany bolan Etregiň kenarynda, gündogarsy Marawa (Çynaran), günbatarsy Süzüş, ilersi Gökböküş, gaýrasy Çendir — şu sanan dört burçumyzyň ortalygyna gelipdir. Munuň esasy ýaşan ýerleri hem şol meýdanlar bolup-

10 ',1363);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (18,1,18,'dyr. Magtymguly Ýonaçy 46 ýaşa baranda (1700 ýylda) bir ogly bolýar. Oňa Döwletmämmet (Garrymolla) at dakylýar. Ýonaçy 66 ýaşynda aradan çykypdyr.

11 ',165);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (19,1,19,'«SEÝIL EDELIŇ BU JAHANA» Döwletmämmediň aýaly hem gyşyklardan bolupdyr. Onuň adyna Orazgül diýer ekenler. Onuň ikinji ogly Baýramgulynyň (?) mazary häzirki Garrygala MTS-niň ileri gapdalynda bolan gonamçylykdadyr. 3-nji ogly Güýde zergär (kümüş ussasy) bolupdyr. Magtymgulynyň eneden bolan ýeri Etregiň boýunda, Giňjaý diýen ýerde, Akdepe atly belli depäniň ýanyndadyr. Magtymguly (Pyragy) Marawa depäniň golaýynda dünýäden ötýär. Ol dünýäden ötjek bolanda «Badysabany görsem», bile «Seýil edeliň» diýlen gazaly aýdyp ötýär. Magtymguly gara öýde ýaşap ötüpdir. Magtymgulynyň mazary serhetden ilerde.

Täçmämmet Suhanguly ogly, 77 ýaş, çala sowatly sazanda, 25.08.1941.

12 ',689);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (20,1,20,'ILKINJI MUGALLYM Magtymgulynyň iň ilki okan mollasynyň adyna Nyýaz Salyh diýer ekenler. Onuň ýerligi ärsary türkmenlerinden bolup, şu ýerlere mollaçylyk etmek üçin göçüp gelipdir.

863-nji bukja.

13 ',213);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (21,1,21,'PARASATLY YNSAN Döwletmämmet oba oglanlaryny okadar eken. Ol mundan başga az-owlak çarwaçylyk hem daýhançylyk bilen-de meşgul bolupdyr. Munuň ekin-tikin hojalyk işlerine uly ogullary Muhammetsapadyr Abdylla kömek eder ekenler. Ol bir çeşmäni bejerip, ekmäge başlaýar, munuň eken gawun-garpyzy, kädisi, jöweni gowy bitipdir. Azady ekin ekmekde ilata görelde görkezipdir. Şondan soň beýleki çarwalar hem çeşmeleri bejerip, ekin ekip başlaýarlar. Bir ýyl açlyk bolupdyr. Döwletmämmet öz eken ýerinden önen ähli hasyly jemagata paýlapdyr. Başga bir ýyl Döwletmämmediň hem eken ýerleri hasyl bermeýär. Jemagat öz eken gallalaryndan eltip, onuň öýüni bugdaýdan doldurýar. Döwletmämmet elmydam halk bilen baglanyşykly bolup, olara dürli maslahatlar berer eken. Azady argyş bahanasy bilen köp ýerleri gezipdir. Haramylar hem onuň kerwenini talamakdan çekiner ekenler.

863-nji bukja.

14 ',903);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (22,1,22,'MAGTYMGULYNYŇ ÝAŞLYGY Magtymguly ýaş wagtynda obanyň çekenesiniň owlakguzularyny bakar eken. Ol özi ýaly çopan-çoluklar bile dostlaşyp, ýakynlaryndaky öri meýdanlarynda olar bilen duşuşyp, her hili oýunlar oýnaýarlar, kä wagtlar bolsa aýdym aýdyşýarlar, tüýdük çalyşýarlar; matal, erteki we şuňa meňzeş halk döredijilik eserlerini aýdyşýarlar. Magtymguly ýedi ýaşda öz atasynda okap başlaýar, on ýaşa baranda ol okamagy, ýazmagy başarýar. Ol çopanlardan öwrenen aýdymlaryny, kitaplardan okan goşgularyny ýatdan aýdyp başlaýar. Soň özi hem bir-iki beýit kiçijik goşgular düzmäge synanyşýar. Muhammetsapadyr Abdyllanyň ölümi bularyň güzerançylyklaryny agyrlaşdyrýar. Şundan soň Magtymguly güzerançylyk işler bilen meşgul bolup başlaýar hem okuwyny dowam etdirýär.

Al şeraba el uzatdym, emendim, — Durusyn içmişler, laýa sataşdym.

Magtymguly on sekiz ýaşa baranda obadaşlary — özüniň ýakyn daýzasynyň gyzy Meňlini söýüp başlaýar, Meňli hem ony söýýär. Günlerde bir gün Magtymguly Nedir şa tarapyndan Amyderýa boýlaryna göçürilen gökleňleriň arasyna gezelenje gidýär. Polat diýen hem beýleki dostlarynyň kömek bermegi bilen Magtymguly Gyzylaýakdaky Idris babanyň medresesinde okap başlaýar.

15 ',1236);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (23,1,23,'Magtymguly görme-görşe, ylaýta-da söýgülisi Meňlini görmek üçin Etrege gelýär. Ähli oba adamlary gelip, Magtymguly bile salamlaşýarlar. Gökleňleriň ýaşulusy Buzlypolat hem gelýär. Ol geçmişden, halkyň däp-dessurlaryndan gürrüň açyp, ahyrda Muhammetsapanyň gelni Akgyzyň adamkärçiligi, ony başga ýere goýbermegiň gelşiksizdigi hakynda gürrüň açýar. Magtymguly Buzlypoladyň näme aýtjak bolýandygyna düşnüp, ýer dyrmap, derläp oturar. Soň ýaşulylar Akgyzyň razyçylygyny soraýarlar. Akgyz: — Köşegim, balam, diýip söýüp ýören gaýyn atamyzyň ojagyny taşlap gidip bilmeris. Näme etseňiz, şony ediň! — diýýär. Soň aýal-erkek üýşüp, Magtymgula ýalbaryp, oňa Akgyzy ilteýärler. Ilki Magtymgulynyň agalarynyň, soň bolsa Döwletmämmediň aradan çykmagy, olaryň hojalyklaryny agyrlaşdyrýar. Onuň üstesine-de ýurtda gymmatçylyk bolýar. Magtymgulylarda bir eşekden başga mal galmandyr. Magtymguly bilen Meňli bir-birlerini söýşüpdirler. Şeýle-de bolsa, Magtymgulydan almaga galyň bolmajakdygyna hem Akgyzyň Magtymgula dakylmagyndan üýşenip, Meňliniň razylygyna, närazylygyna garaman, doganlary ony başga ýere beripdirler. Meňlini alan adamyň adyna Şyhym Harpyk diýermişler. Meňli-de söýgülisi Magtymgulydan aýrylanyna aglap gidipdir.

Hally eje, 61 ýaş, Zeliliniň oglunyň gelni, Garrygala raýonynyň Gerkez obasy, 1941.

16 ',1341);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (24,1,24,'GÖZEL TEBIGAT AŞYGY Magtymguly oňat eserler döretmekden ötri, ýaz hem tomus wagtynda dowat-galamyny hem depder-kagyzlaryny göterip, Etrek çaýlarynyň owadan kenarlarynda, salkyn saýalarda, gyşyna bolsa daglaryň ömür şemal düşmeýän ýyly gowaklarynda oturyp ýazýar eken. Magtymguly öz-özünden ösýän injir, hoz, nar, badam, jenewüt (söwüt), arça, üzüm, zirk, böwürslen we ş. m. miwelimiwesiz agaçlar ýazyna parç bolup, dyza ýetip duran gülli otlar bilen bezelen çaýyň owadan kenarlarynda, çal goçlary, umgaaýraklary, şöwkeleri we başga dürli janawarlary bolan seri dumanly daglarda gezmegi, seýil etmegi özüne endik edinipdir.

Mämmet Nury ogly, 35 ýaş, gökleň, alatelpek tiresi, 1941. 863-nji bukja.

17 ',721);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (25,1,25,'«SIZ ELE BAKÝARSYŇYZ» Geçen asyrlarda Buhara şäheri Orta Aziýanyň, Gazagystanyň dini hem söwda merkezi bolupdyr. Ol ýerde bolan köp sanly medreselerde dürli halkdan talyplar gelip okapdyrlar. Türkmenlerden bolan talyplaryň hem köpüsi şol ýerde okapdyrlar. Biziň beýik babamyz Magtymguly hem Idris babadan soň Buharada belli bolan medreselerden Gögeltaşda okamak üçin hem ol ýerdäki kazy-kelanlara öz ýazan eserlerini pitiwa etdirmek niýeti bilen Buhara şäherine gidýär. Magtymgulynyň eserlerini okamak üçin birine berýärler. Ol ruhany birnäçe wagtdan soň, Magtymgulynyň eserlerine şeýle baha berýär: — Magtymgulynyň goşgularynda yslam dininiň köp ýerlerine şübhe döredýär. Ol özüniň başarmajak işleri, düşünmejek zatlary dogrusynda gürrüň açýar... Şundan soň ähli kazy-kelanlar üýşüp, Magtymgulynyň eserlerini mekdeplerde, medreselerde, ilat arasynda okamaga pitiwa bermändirler. Magtymguly olara ýüzlenip: — Siz egrini tapsaňyz, dogry bile bolmarsyňyz. Meniň hatyramy bir Allaýar agsakça-da görmediňiz, siz ele bakýarsyňyz, siz halkyň öňünde azdyňyz, men hem sizden pyrak hem parygdyryn — diýýär. Şondan soň şahyr:

18 ',1146);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (26,1,26,'«Pygamber ornunda oturan kazy, Para üçin elin aça başlady»

— diýen goşgusyny ýazýar.

863-nji bukja.

19 ',120);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (27,1,27,'ORAZMEŇLI ŞAHYR Magtymgulynyň ýakyn dosty bolan Orazmeňli ýaş wagtynda bir dul aýalyň Hanserwer diýen owadan gyzyny söýýär. Bu ýagdaýy duýan gyzyň hossarlary, günleriň birinde hiç kime duýdurman, aýry ýere göçüp gidýärler. Emma daglyk ýoldan barýarkalar, edil ýoluň ugrundaky bolan çeşmäniň gyrasynda bir uly gaplaň ýatyr eken. Bularyň bilgeşle gyzy alyp gaçandyklaryny eşidip, Orazmeňli atlanyp, olaryň yzyndan at depýär. Olar gaplaňdan gorkuşyp duran wagtlary Orazmeňli ýetişip, ýüzüniň ugruna baryp gaplaňy çapyp öldürýär. Soňra Orazmeňli gyzyň hossarlaryna garap: — Nähili etseňiz-de, gyz meni söýýändir — diýip, yzyna gaýdýar1 . Günlerde bir gün Orazmeňli bilen Serwer gepleşip, bir ýana gaçyp gitmek üçin dilleşýärler we hem tanyşyk ýeri diýip, dagyň çetinde bolan uly daşyň gapdalyny belleşýärler. Nowruz günleri, aý aýdyň gije. Orazmeňli belleşen wagtyna 1 Başga bir elýazmada gyzyň hossarlary: «Bu gaplaňy öldürip, bizi ölümden gutardy» diýip, Serweri Orazmeňlä bagyşlaýarlar. Emma ol: «Il bir gaýyň öldüreni üçin bir gyzy alypdyr diýip gürrüň eder» diýip, bu sapar gyzy almandyr.

20 ',1121);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (28,1,28,'çenli bir öýde ýoldaşlary bile garaşyp oturýar. Ahyrda belleşen ýerine barýar, köp garaşýar, emma Serwer ýok. Köp garaşandan soň, o ýan-bu ýana garasa, at aýagynyň yzy bar. Orazmeňli yzy alyp gidýär, görse, gyzyň eltilen ýerinde toý başlanypdyr. Gyzyň üstünde galmagal başlanýar. Şonuň üçin bu ýere derrew Magtymgulyny çagyrýarlar. Magtymguly «oýunçy utulanyny bilse ýagşy» diýip, dostuna basalyk bolýar. Orazmeňli tolgunyp:

«Deň-duşlar ýanynda boldum bikemal, Bir bikemal ýigit ili ýandyrar; Akylsyza akyl bermek abasdyr, Görüň, akyllyny däli ýandyrar.

Orazmeňli aýdar, inçedir, zildir, Ýar lebinden daman gör, nije baldyr, Han Serwerim bu gün bakjada güldür, Bilbil köp saýrasa, güli ýandyrar».

Serwer söýgülisiniň ýangynly sözlerini eşidip, başyndan bürenjegini sypyryp, zyňyp goýberýär-de: — Men bu ýeriň gelni däl, men seniň bile gitmäge razy — diýen manyny aňladýar. Magtymguly ýalňyşlyk bilen agyr ýagdaýa düşen gözi ýaşly Serweriň gyzaran ýüzlerine, balkyldap duran gözlerine garap: «Gözel sen» diýen goşgusyny aýdýar. Soň Magtymguly Orazmeňliniň elinden tutup, ony oba alyp gaýdýar. Bular ýolda ondan-mundan gürleşip, obanyň töwereklerinde gezelenç edýärler. Gezip ýörüşlerine Orazmeňliniň Serwer bilen belleşen uly çynarynyň ýanyndaky daş görünýär. Şol baýyrlyga garap, Orazmeňli şeýle aýdýar:

21 ',1345);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (29,1,29,'«Beýabanyň ýaýlagyna çykanda, Ol görünen han Serweriň dagydyr. Ýene görsem han Serweriň dagyny. Aklymy teň eden gamy — dagydyr».

Zylyha Baky gyzy, 12.08.1958.

22 ',176);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (30,1,30,'DURDY ŞAHYR Türkmeniň ata urugyndan Durdy şahyr diýen adam Döwletmämmediň deň-duşragy bolup, Etrek sebitlerinde ýaşapdyr. Magtymgulyň ýaş wagtlary Durdy şahyryň oňa göwni ýetmez ekeni. Kä wagtlar ikisi jedelleşer ekeni. Ilkinji gezek bular goşgy aýdyşanlarynda, Magtymguly, bir harpyň üstünde ýalňyşýar. Bu ýagdaýy gören Azady: — Haçan onuň bilen aýdyşjak wagtyň meniň bile gepleşgin — diýip, Magtymgula tabşyrýar. Magtymguly Durdy şahyra ikinji gezek goşgy bile sowal berýär, emma Durdy şahyr oňa jogap tapmany üçin, Magtymgulynyň özi jogap berýär. Şondan soň Magtymgulynyň güýçlüdigine Durdy şahyr boýun bolýar.

23 ',648);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (31,1,31,'MAGTYMGULY WE NURY KAZYM Buharanyň Gögeltaş we beýleki medreselerinde ders bermek üçin çagyrlan Siriýa türkmenlerinden Nury Kazym ibn Bahr diýen alym bile Magtymguly tanşyp, onuň bile dostlaşýar. Günlerde bir gün Buhara medreselerinde okaýan talyplaryň arasynda dörän ahlaky bozuklygy halaman, Nury Kazym ilki Isfihana gaýdar, soň Bagdada gidýär. Birnäçe wagt geçenden soň, Magtymguly hem Buhara medresesini taşlap, ähli türkmen ilatynyň üstüni syryp, öz ýurduna gelýär. Soňra dostuny yzarlap, Eýrana gidýär. Ol Eýranda kürtlere myhman bolýar, olar öz aralarynda galmagy Magtymgulydan haýyş edýärler, emma ol özüniň ýolagçydygyny aňladyp, olar bile hoşlaşýar. Magtymguly ilki gadymy Isfihan şäheri bilen tanşyp, soň Bagdada Nury Kazymy ýanyna baryp, ondan köp zatlary öwrenýär. Bular Nedir şanyň öňki soran ýerlerindäki geçýän syýasy özgerişleri birin-birin gözden geçirip, türkmen halkynyň erkinligi hakynda maslahatlaşyp, ikisi Owganystanyň Käbil şährine gelýärler. Bu ýerde birnäçe wagt bolanlaryndan soň, ikisi Hindistana ugraýarlar. Olar baryp, Hindistanyň köp ýerleri

24 ',1103);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (32,1,32,'bile tanyşýarlar, legendar Babyl guýusy hakynda soraşýarlar. Penjab sebitlerini gezýärler. Dostlar Hindistanda bir ýyl üç aý bolanlaryndan soň, ýene Käbil şähriniň üsti bile geçip, Özbegistanyň, Andijan, Margelan şäherlerine gelýärler. Köp ýurtlary gezenlerinden soň bular ahyrda Horezme barýarlar. Bu ýerde Hywa hany — Ilbars hanyň zulmy astynda ilat gaty horlanýan ekeni. Şol ýerdäki türkmenler, Magtymgulydyr Nury Kazymyň öz ýurtlaryna gelmeklerine gaty begenýärler. Şular ýaly abraýly alymlaryň türkmen ilatyny Hywa hanlarynyň, Buhara emirleriniň, Eýran şalarynyň zulumlaryndan gutarmak ugrunda alada edýändikleri üçin, derrew aýaga galmak, Ilbars hanyň garşysyna baş götermek isleýärler. Hatda Geldi han diýen adamyň ýolbaşçylygy bilen baş göteren türkmenler az wagtlyk özbaşdaklyk gazanýarlar. Geldi hany bolsa özlerine serdar saýlaýarlar. Bu ýagdaýdan soň, Nury Kazym bile Magtymguly maslahat edip, zamanasynyň meşhur medreselerinden bolan «Şirgazy» medresesinde galýarlar. Magtymguly «Şirgazy» medresesine girende otuz bäş ýaşynda eken. «Şirgazy» medresesinde öň diňe ýokary gatlak wekilleriniň perzentleri okadylýar eken. Bular bu ýerde galanlaryndan soň, ol medresä Arkaç sebitlerinden hem okamaga gelýänleriň sany köpelýär. Şol gelenlerden Bäherdeniň Börme obasyndan bolan Nazaraly diýen adam hem okuwa girýär. Nury Kazym, Magtymguly, Nazaraly üçüsi bir hüjrede ýaşap başlaýarlar. Nazaralynyň ilki sowady azrak bolany üçin, Magtymguly oňa kömek berer eken. Bu medresäniň ders berýän ussadyna Hazreti Pälwan diýer ekenler. Magtymguly Nury Kazymyň kömegi bile gaty ösýär, beýleki talyplardan saýlanýar.

25 ',1649);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (33,1,33,'Aradan iki ýyl geçenden soň, Magtymguly ähli talyplaryň damlasy (halypasy) bolýar. Okadýan ahun bir ýana gidende talyplary okatmagy Magtymgula tabşyrýar. Magtymguly talyplara diňe bir ders bermän, olaryň jalaýlyk edýänlerine-de çäre görýär. Bu ýagdaýdan soň, ahun ýaşalýan hüjrelere aýlanýar. Nazaraly erbetçilik edilýän hüjräni görkezýär. Şondan soň jalataýlyk edýän talyplary medreseden kowýarlar. Magtymguly medresede hem Nury Kazymda okamak bilen birlikde, öz döredijiligini alyp barýar. Onuň türkmenden, özbekden, gazakdan, garagalpakdan we başga milletlerden köp sanda dostlary we aşnalary bolupdyr. Şonuň üçin Magtymgulynyň bolýan hüjresiniň myhmansyz bolýan wagty bolmandyr. Soň ol ýeke özi aýry bir hüjrä geçýär. Onuň bolýan hüjresi hakyky döredijilik öýüne öwrülýär, hatda Magtymgulynyň döredijilik ussatlygyna ders berýän ahunlar hem pitiwa berýärler. Günleriň birinde şahyryň halypasy hazreti Pälwan onuň «Jelil» diýen goşgusyny eşidip: «Magtymgulynyň aýdan zatlary hemme adamlara başardardan açyk, muňa bu ylmyçäbikligi1 allatagallanyň dergahyndan berlipdir. Ol muňa berlen uly ülüş. Bu adam hakyky hakdan içen» — diýen ýaly bahalar berýär. Magtymgulynyň dabarasy dag aşýar, onuň ady ähli ýerlere ýaýraýar. Onuň öýüniň myhmansyz wagty bolmaýşy ýaly, onuň özüni-de köp ýerlere myhmançylyga çagyrýarlar. Ähli Kese Arkaç taraplaryndan hem ilat zat ýygnap, harçlyk diýip, Magtymgula iberer ekenler, Magtymguly hem öz nobatynda ol zatlary, harjylygy az talyplara berer eken.

863-nji bukja.

1 Çäbiklik — ýyndamlyk, ýitilik, ötgürlik.

26 ',1572);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (34,1,34,'GAÝGYLY HABAR Magtymguly hywadaky, «Şirgazy» medresesinde üç ýyl okap, dördünji ýyla aýak basanda, tätil wagty1 Etrek tarapyndan Magtymgulynyň oglunyň näsaglygy hakyndaky habar gelýär. Magtymguly Etrege gaýtmaly bolýar. Magtymgulynyň gaýtjak habary onuň dost-ýarlaryny, bile okan talyplaryny, ony tanaýan daýhanlary örän gynandyrar. Gaýgyly günde ýeke goýbermezlik üçin, onuň jangöýer dostlary bolan Nury Kazymdyr Nazaraly Magtymguly bile goşulyp, gaýdýarlar. Bular Was, Uzboý, Döwdegala, Gyzylgala, Topýatanyň üsti bile geçip, günbatarky ýoldan, Balkan daglarynyň gapdalyndan, Küren dagynyň ýany bile Etrek tarapa geçýärler. Bular gadymy şäher Maşady-Misseriana ýetenlerinde Nury Kazym näsaglaýar. Bular şol ýerde düşlemeli bolýarlar. Nurynyň durmuşy agyrlaşýar, ahyrda hem aradan çykýar. Magtymguly özüniň iň ýakyn dosty Nury Kazym ibn Bahry şol ýerde jaýlap: — Meniň hem gabrym dostumyň ýanynda goýulsyn — diýip, wesýet edýär-de, şol ýerde ýadygärlik üçin sypa galdyrýar. Soň Magtymguly Nazaraly bile Etrege gelýär. Görseler, şahyryň söýgüli ogly ýedi ýaşly neresse Mollabäbek ölüm halynda ýatyr. Şahyr perzendiniň eljagazyndan tutup, onuň bile hoşlaşýan ýaly: 1 Tätil — rugsat, dynçalyş, arakesme.

27 ',1234);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (35,1,35,'Gapymyň miweli bagy, Üzüldi ýüregmiň ýagy, Hem arkamyň gara dagy, Razy bolgun, Mollabäbek.

Ýanymda deň-duşuň oýnar, Gapymda gazanyň gaýnar, Içim ýanyp, gözüm oýnar, Depäňde käkiliň balam...

— diýen sözler bile göz ýaşyny dökýär. Oglan gutarandan soň, Nazaraly şol ýerde bir näçe wagt galyp, Magtymgulynyň agyr derdini paýlaşýar hem oňa göwünlik berýär. Soň öz obasy Börmä gaýdýar. Magtymgulynyň Ybraýym diýen ogly hem ýaşlykda — on iki ýaşynda ölýär. Çagasy üçin Magtymguly köp öz ýaş edýär. Şonda pata baranlara «Bolarmy?» diýen goşgusyny aýdyp berenmiş. Çagalarynyň ölümi şahyra uly urgy bolýar. Magtymguly gol bermek üçin Nyýazguly halypanyňka gidýär. Görse, ol öňki Nyýazguly däl, «pir» sopularyny işledip, nebsiniň yzynda haltyldap ýör. Magtymguly oňa goşgy ýazyp galdyrýar-da, ol ýerden gaýdýar.

853-nji bukja.

28 ',849);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (36,1,36,'ZAMAN GASSAP Garrygalanyň Gyzyl (düýp) obasynda Zaman işan diýen biri ýaşaýar eken. Günlerde bir gün mal almaga gelen iki adam onuň öýünde myhman bolupdyr. Bu myhmanlaryň ýanynda bir horjun teňňeleri barmyşdyk. Zaman işan bu adamlaryň teňňelerine göz gyzdyryp, iki sany haramyny tapyp: — Men şu myhmanlary ýola salyp, size habar bereýin, siz hem olar pylan ýere baranlarynda, gapdallaryndan çykyp öldüriň-de, ýanlaryndaky pullaryny alyp, meniň ýanyma getiriň, üçimiz deň paýlaşarys — diýýär. Ol iki adam Zaman işanyň diýenini edip, mal alyjy myhmanlary öldürip, iki horjun pullaryny hem alyp, getirip, Zaman işanyň öňünde goýýarlar. Soň Zaman işan öz eden işiniň bilnip, bilinmändigini derňemek üçin adamlaryň köp üýşýän ýerleri bolan Magtymgulynyň ýanyna gidipdir. Barsa Soňudagynyň ilersinde töweregi aý berip oturan märekeli Magtymguly oturanmyşdyk. Işan-da çök düşüp, Magtymguly bile görüşýär. Magtymguly işanyň ýüzüne biti-ýiti seredip: — Size kim diýerler, nireden gelersiňiz? — diýip soraýar. Işan: — Bize Zaman işan diýerler, Gyzyl obasyndan bolarys — diýýär. Onda Magtymguly: — Size Zaman işan diýmezler, size Zaman gassap diýerler.

29 ',1177);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (37,1,37,'Bu söze oturan märeke haýran bolýar, işan masgara bolup, märekeden turup gidýär.

Meňli Şyhymguly gyzy, 55 ýaş., Garrygala raýonynyň Çendir jülgesi, Ýartygala obasy, 1941.

30 ',191);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (38,1,38,'TERSAKAN

«Ýazan kitaplarym syla aldyryp, Gözlerim yzynda girýan eýledi»

Soňudagynyň üstüne Büjnürt, Astrabat hanlary hüjüm edenlerinde, Magtymguly bu ýerde oturýan gökleň ilatynyň dagyň ýeňsesindäki Gyzylbaýyr diýen ýere barmagyny maslahat berýär. Duşman atlylarynyň geçjek geçelgelerinde mergenleri ýatyrýar. Bu wagtlar Nowruz günleridi, häli-şindi çabga ýagyp, syl gelýärdi, çaýlar dolup akýardy. Soňudagyň gaýrasyndaky Tersakanyň olumyndan geçjek bolanlarynda, Magtymgulynyň göçüni syl alýar, Magtymgulynyň ýedi sany ýazan kitaby suwa akýar. Adamlara akan kitaplaryň diňe ýekejesini alyp galmak başardýär.

851-nji bukja.

31 ',646);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (39,1,39,'BOSA-BOSLUK Büjnürt, Astrabat hanlarynyň talaňçylygyndan gaçyp giden bosgunlar düýe-tegeli bolanlary üçin, hanyň atlylary olaryň yzyndan ýetip, ogul-olja, gyz ýesir edip, alyp gaýdýarlar. Şonda gökleňleriň aýderwüş tiresinden bolan bir dul aýalyň hem ýekeje ogly ýesir düşýär. Ol aýal Buzlypolat bile Magtymgula ýalbarýar: — Eger ogluma agramna-agram pul diýseler hem alyň! — diýýär. Magtymguly edermen ýigitlere ýüz tutup: — Bu gün ýesiriňizi agramyna alsaňyz, ertir nämä çekip alarsyňyz? Başga biriňiz ýesir düşse, ondan hem ýaman bolar. Minneti gylyjyň baljagyndan çekerler! — diýýär. Ýigitler hyjuw bile ata çykýarlar. Magtymguly olara ýolbaşçylyk edýär. Olar Eýran hanlarynyň nökerleriniň üstüne bir gije dökülip, degerli adamlaryny ýesir alýarlar. Soň alşyk edip, ýaňky aýalyň ogluny hem boşadýarlar. Oglanyň enesi: — Hemme il meniň oglum hem doganym ekeni... — diýip, bar zatlaryny jemagata paýlaýar.

851-nji bukja.

32 ',948);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (40,1,40,'PARASATLY JOGABYŇ NETIJESI Bir sapar ähli gökleň ilatynyň üstüne ýagy dökülýär. Obanyň köp adamlary bile barabar, Magtymguly, onuň enesi, daýysy hem giýewleri ýesir düşüpdirler. Bir gün han ýesirleriň arasyna aýlanýar, ol Magtymgulynyň enesine ýüzlenip: — Seniň menden näme dilegiň bar? — diýip soranda, ol Magtymguly öz dilewarlygy bile hem boşap biler diýen netijä gelip: — Han aga,

Ogul bolsa bildedir, Giýew bolsa ýoldadyr, Dogan weli tanylmaz, doganymy azat etseň

— diýende, han bu aýalyň parasatly sözlerine haýran galyp, bularyň hemmesini hem boşadypdyr.

Meňli Şyhymguly gyzy, 55 ýaş., Çendir jülgesi, Ýartygala obasy, 18.12.1940.

33 ',662);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (41,1,41,'ÖLÜM ÝASSYGYNDA Magtymguly näsaglap, ölüm ýassygynda ýatyrka, töwereginde üýşüp oturan adamlara garap: — Meni bir usullyk bilen, daşaryk çykarsaňyz — diýýär. Şahyryň dostlary, hossarlary onuň goltugyna girip, emaý bile daşarky işige çykarýarlar. Şonda Magtymguly daş işikde, öýe arkasyny berip oturýar, onuň oturan ýerinden seri dumanlap duran gojaman daglar, ulgam-ulgam jülgeler, beýikli-pesli baýyrlar, geçitler we ummasyz giden tekizlikler görünýär. Şahyr bir meýdan garap duran soň:

«Seýil edeliň bu jahana, Jahanda näler görüner; Isgender Jemşid saldyrmyş Beýik binalar görüner — »

— diýip başlanýan «Görüner» goşgusyny aýdanmyş. Soňra Magtymguly: — Meni indi öýe salyň — diýip aýdýar. Magtymgulyny öýe salyp, deň-duşlary ony ýerinde rahat ýatyrýarlar. Şondan soň şahyr tiz jan berenmiş.

34 ',830);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (42,1,42,'Sähetguly Taňryguly ogly, 80 ýaş, sowatsyz, Aşgabat raýon, Gökje obasy, 12.01.1941.

35 ',102);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (43,1,43,'MYNASYP ŞÄGIRTLER Hywadaky «Şirgazy» medresesinde okaýan talyplar üçin salnan darajyk hüjreleriň birinde Gündogaryň parasatly alym şahyrlaryndan biri — halkyň wepaly ogly Magtymguly ýaşapdyr. XIX asyr türkmen şahyrlary Seýdidir Zelili hem şol medresede okapdyrlar. Emma bularyň elleri ýuka bolany üçin, her haýsy bir hüjräni kireýine alyp bilmän, ikisi bir hüjrede ýaşamaly bolupdyrlar. Halk rowaýatlaryna görä bu ýerde elmydama bir hüjre boş durýar. Şol hüjrede bir wagtlar Magtymguly şahyr ýaşap geçipdir. Medresäniň däbine görä bu ýerde okap giden iň güýçli talybyň ýaşan hüjresi, her tarapdan güýçli bolan bäsdeş şahyr tapylýança boş durmaly eken. Şonuň üçin bu ýerde okan talyplardan Magtymgulynyň hujresinde ýaşamaga milt edip bilen bolmandyr. Diňe Seýdi bile Zelili käýarymlar baryp, şol hüjrede gijesine ýatar ekenler. Sebäbi bular Magtymgulyny özleriniňki, öz halypalary hasap edipdirler. Bir sapar iki şahyr şol hüjreden çykyp gelýärkäler, gapdallaryndan bir molla çykyp: — Magtymguly siziň nämäňiz bolar? — diýip sorapdyr. Bular: — Magtymguly biziň ussadymyz bolar — diýip, jogap berýärler. Onda Molla: — Beýle bolsa Magtymgulydan bir şygyr okap beriň — diý-

36 ',1207);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (44,1,44,'ýär. Şonda şahyrlaryň biri Magtymgulynyň:

Mollalar ahyret sözün söýlärler: «Müňkür bolma, boljak işlerdir bular». Kim biler ki ahyretde neýlärler, — Iýip, içip, münüp, guçup öt ýagşy.

— diýen bendini okaýar. Bu setirler molla ýaraman, hüňürdäp, bularyň ýanyndan gidiberýär.

863-nji bukja.

37 ',312);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (45,1,45,'GARAÇOMAK Magtymguly ýaşlygynda bir gyzy söýüpdir, emma ara başga bir adam düşýär. Ol adamyň adyna Şyhym diýer ekenler. Şyhym ol gyzy alypdyr, emma ondan hiç perzent önmändir. Magtymguly Şyhyma bagyşlap, «Ýary ýardan aýranyň» adynda, 7-8 bentden ybarat teýeli goşgy düzenmiş.

Saparow, Garrygala raýon magaryf bölüminiň müdiri, 25.06.1957.

38 ',365);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (46,1,46,'HORMATLY MYHMAN Bendesen obaly Amandurdy jüýk diýen şyh «Magtymgulyny göreni gördüm» — diýip aýdardy. Amandurdy gyzyleňek jahyl wagtynda ol adam togsandan aşan eken. Ol Amandurdy jüýge şeýle gürrüň beripdir: «Bahar aýlary Öwezberdi şyh ýazlaga diýip, Hasar dagy tarapa göçmekçi boldy. Men onuň göçüni göçürişdim. Baryp Mezitli diýen çeşmäniň golaýynda ýurt tutduk. Öwezberdi şyh, şol wagtlar, tapdan düşen garry bolany üçin, — Ölmänkäm dostumyň ogly Magtym jany göreýin — diýip, Garrygala sargyt etdi. Munuň sargydy bile bir adam geldi, Öwezberdi şyh ony hormat bile garşy aldy, janly öldürip, söwüş etdi. Soň men şol geleniň Magtymguly şahyrdygyny bilip galdym. Ol adam ortadan uzyn, siňirlek, goýungöz, pakga gulagy otagaly, ýaýylyp ýatan tüňňüräk maňlaýly, ýuka dodak, kak çekge1 , at ýüzli, oňurga burun, selçeň sakaly döşüni basyp duran adam eken. Ol bu ýerde iki-üç gün galdy, Hasar dagynyň gündogarsyndaky Serke diýen ýere çykyp, aw hem awlady. Soň Öwezberdi şyh ikimiz çylgym eňňitden aşýançak, Magtymgulyny ýola salyp ugratdyk. Ugradyp barýarkak, Öwezber1 Kak çekge — argas, agaç et.

39 ',1126);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (47,1,47,'di şyh onuň bilen gürrüňleşip, atyň gapdaly bilen ýöräp barýardy, men uýany elime alyp, atyň öňünden ýöräp barýardym, şonda Magtymguly kä o ýana, kä bu ýana ser salyp, Hasar dagy bilen hoşlaşyp, şu goşgyny aýtdy:

«Hasar dagy beýik bolar, Üsti doly keýik bolar, — Mergenlere seýik bolar, Barsaň Hasar dagyndadyr.

Kuh erer ýeriň soltany, Göwsünde gurmuş dükany, Üç ýüz altmyş pir mekany, Görseň Hasar dagyndadyr.

Mesgen tutar çarwadarlar, Ýalçysynda ýatar marlar, Deresinde biter barlar2 , Tirseň Hasar dagyndadyr».

Baba Nejebaly ogly, 58 ýaş, Gyzylarbat, Stalin adyndaky kolhoz, gerkez. 1957.

2 Bar — miwe, hasyl.

40 ',644);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (48,1,48,'«HÜNÄRLER KITABY» Magtymgulynyň bir gatyr ýüki kitaby bar eken. Bir gün gyzylbaşlar oba biwagt dökülip, öýleri talap, adamlary ýesir edipdirler. Şonda Magtymgulynyň kitaplary-da gidipdir. Şolaryň arasynda Magtymgulynyň «Toty guş dilli» diýen dessany hem gyzylbaşlara olja bolupdyr. Adamlar ol kitaba «Hünärler kitaby» diýer ekenler. Magtymguly aýratyn hem şu kitaba gynanypdyr. Ol «Şol kitap galan bolsa, il-güne peýda bolardy, men ony niçe ýyllar iş edinip ýazypdym» diýipdir. Magtymguly «Reýgan eýledi» diýen goşgusyny şondan soň ýazanmyş:

Gaýgy-gamda eziz ömrüm solduryp, Şum pelek azabym reýgan eýledi; Ýazan kitaplarym syla aldyryp, Gözlerim yzynda girýan eýledi.

Gapyllykda duşman aldy daşymyz, Dargatdy her ýana deňi-duşumyz, Bäş ýylda bir kitap eden işimiz, Gyzylbaşlar alyp weýran eýledi1 .

Muhammetberdi Nejebaly ogly, 50 ýaş, Gyzylarbat şäheri, 9-njy ýanwar köçesi, 23-nji jaý, gerkez, 16.03.1959.

1 Bu goşgy 5 bentden ybaratdyr.

41 ',982);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (49,1,49,'HEZIL ETMEDIM DÜNÝÄ SENDEN Döwletmämmet Azadynyň maslahaty bile 25 ýaşly Magtymgula 33 ýaşly Akgyz adynda bolan bir dul aýaly iltäpdirler. Şonda Magtymguly:

«Ýigrim bäş ýaş ötdi menden, Hezil etmedim, dünýe senden, Şirin sözli, lebi handan Bir goýna salan islärin.»

— diýen goşgusyny aýdanmyş.

Muhammetberdi Nejebaly ogly, 50 ýaş, gerkez, 16.03.1959.

42 ',379);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (50,1,50,'HYWA KÖÇESINDE Magtymguly Hywadaky «Şirgazy» medresesinde okap ýörkä, şäher köçeleriniň birinden bir ýana barýan eken. Şonda hanyň ýasawullarynyň bir topar ýesiri gamçylap, sürüp barýanlaryny görýär. Magtymguly olara garap, barmagyny dişläp durýar, ýesirlere rehmi inýär, emma näme etjegini bilmeýär-de:

Gyýmazlykdan bir söz diýdim baýakda, Garaw bardyr ýersiz urlan taýakda, Zalymlar har bolar, galar aýakda, Garyp, sen ýyglama, şir dek bolar sen!

— diýen goşgusyny düzenmiş.

A. Nursähedow, Daşhowuz, Köneürgenç raýony, mugallym.

43 ',558);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (51,1,51,'OGURLANAN ÇAGA Magtymguly öz obalaryndan bir ýigit bile dag içine tarap awa çykypdyr. Olar günüň gyrasy çykyberende bir çeşmäniň başynda düşýärler. Şol wagt olaryň ýanyna bir atly gelýär. Olar atly bile salam-helik edişip duran wagtlary, Magtymgulynyň gulagyna bir çaga sesi eşidilýär. Atly suw-söl alyp gidiberende, çaganyň sesi has-da batly çykyp başlaýar. Magtymguly ýaňky adamyň bolup barşyny halaman: — Garyndaş, bir azajyk aýak çekiň, ugruňyz nirä? — diýip sorapdyr. Atly özüni bildirmejek bolup, barýan ugrum diýip Magtymgulynyň öz obasyny salgy beripdir. Magtymguly öz gelen ugruny salgy bermegini geňirgäp duran wagty, atly ýüzin salaýypdyr. Magtymguly ýanyndaky ýigit bile atlynyň yzyndan kowup, ahyry ýetipdirler. Olar iki bolup ony öz obalaryna alyp gelipdirler. Magtymguly ýaňky adamyny äkidip barýan çagasy bile bir-iki gün öýünde saklanyndan soň, etek galalarynda bir daýhanyň çagasynyň ogurlanandygyny eşidýär. Magtymguly: «Bolsaň, ogurlanan çaga sen bolarsyň» diýip, öýündäki çagany şol adama görkezipdir. Dogrudan hem ol şol adamyň ogurlanan çagasy eken. Çaganyň kakasy begenjinden nähili hormat etjegini bilmän, ahyry özüniň gowy görýän atyny Magtymgula sylag beripdir.

Saparguly Kowus ogly, Aşgabat raýon, Büzmeýin oba, Stalin adyndaky kolhozyň çleni.

44 ',1302);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (52,1,52,'ŞAHYRLAR MEJLISI Bir wagtlar Şabende, Kemine, Myrat Talyby, Mollanepes we başga bir topar şahyrlaryň mejlisi bolupdyr. Şol şahyrlaryň biri: — Magtymguly gökleň ähli zat hakynda goşgy ýazypdyr. Ol özgelere ýazmaga zat goýmandyr. Biz nämeden ýazarkak? — diýen meseläni orta atýar. Şonda Kemine şahyr şeýle jogap berýär: — Magtymguly ýazmaga bize zat goýdumy näme? Ol söz meýdanynyň oragyny orup gidipdir, bize diňe onuň hoşasyny çöplemek galdy — diýýär.

Ahmet Ahundow—Gürgenli, Magtymguly, Saýlanan goşgular, Aşgabat, 1940, 17-nji sahypa.

45 ',567);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (53,1,53,'YLYM ÝOLUNDA Halaç raýonynda ýaşaýan ärsary türkmenleriniň arasynda şeýle rowaýat bar: ... Magtymguly öz obalarynda okanda, ony okadan mollanyň mundan beýläk Magtymgula sapak bermäge güýji ýetmändir. Şonuň üçin hem mollasy: — Men indi saňa sapak berip biljek däl, özüňe başga bir güýçlüräk halypa gözle! — diýip, oňa nesihat edipdir. Soňra Magtymguly sorap-idäp, Halaç raýonynyň Gyzylaýak obasynda bolan Idris babanyň adyny eşidip, şol taýa çöl söküp ugraýar. Ýolda oňa duş gelýän ähli türkmen çarwalary Magtymgulyny oňat garşy alýarlar. Onuň üçin ýörite söwüş edýärler. Magtymguly hem öz goşgularyny olara okap berýär. Çarwalar onuň manyly goşgularyna haýran galýarlar. Onuň her bir myhman bolup, düşüp geçen obasynyň adamlary şahyry indiki barjak obasyna ýörite atly-ýaragly ugradyp gaýdar ekenler. Ähli türkmenleriň küren-küren obalaryny söküp, Magtymguly ahyrda Lebap sebitlerine inýär. Ol sorap-idäp, iňrik garalyp ugranda Idris babanyň howlusynyň gapysyna barýar. Howlynyň gapysyndaky sopular Magtymguly bile gepleşip görýär-

46 ',1062);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (54,1,54,'ler. Onuň ylmyna-bilmine, dünýäden gep urşuna haýran galýarlar. Olar öz ýanlaryndan «Bular ýaly adam biziň aramyzda bolsa, bize san-sala ýetmez» diýen pikir bile Magtymgulyny medresä goýbermändirler. Magtymguly lapykeç bolup, yzyna dolanýar. Nirä barjagyny bilmän, oba arasy bile gidip barýarka, ýolda oňa bir ýaşuly daýhan sataşýar. Daýhan onuň üýtgeşik adamdygyny görüp, ilki salamlaşýar, soň ony öýüne alyp gidýär. Daýhan öýünde Magtymgula tapdyk hezzetini edip, ondanmundan gürrüňleşip oturýarlar. Öý eýesi Magtymgulynyň medresä goýberilmänligine haýran galýar. Bu işiň sebäbini bilmekden ötri, ertirden soň ol adam Idris babanyň ýanyna ugramakçy bolýar. Magtymguly oňa: — Bir az aýak çekiň! — diýýär. Aradan bir azajyk wagt geçenden soň, Magtymguly: — Şujagaz kagyzy ýüzüň ugruna şol ýerdäki sopulara gowşur! — diýip, ol adama bir hat ýazylan kagyzy berýär. Soň eşitseler, şol kagyzdaky:

«Altmyş ýaşan, ýetmiş ýylky sopular, Az galandyr aý-günüňiz batmaga; Çöl ýerlerde tazy görmän tilkiler Hyýal eder ýatan şiri atmaga»

— diýip başlanýan Magtymgulynyň «Sopular» goşgusy eken. Şol goşgyny okan sopular «Senden boldy-da, senden boldy!» — diýişip, biri-birleri bile ala-dawa turuzypdyrlar. Daýhan Idris baba bilen gepleşýär. Ol bolsa — myhmanyňa aýt, gelsin-de okabersin — diýýär. Magtymguly ol gije daýhanyňkyda myhman bolup, ertesi Idris babanyňka okamaga barýar. Magtymguly şol ýerde okap ýörkä, töweregindäki daýhanlar ony myhmançylyga çagyrar

47 ',1492);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (55,1,55,'ekenler. Magtymguly olara öz ýazan goşgularyny okap berer eken. Emma tiz wagtda Magtymguly şol ýerde ders berýän mollalaryň biri bolan Nyýazguly halypa bilen tersleşýär. Sebäbi Nyýazguly halypa Magtymgulynyň ýiti zehinine, hakykatçylygyna, ilat arasynda abraýynyň artmagyna göriplik edip başlapdyr. Magtymguly ol ýerden gitjek bolanda, «Bilmezmiň» diýen goşgusyny ýazýar. Soňra Magtymguly başga medresä gidýär. Emma ärsarylar ony hiç mahal ýatlaryndan çykarmaýarlar.

Beghan Ýagmyrow, Halaç raýonynyň Pelwert obasy, käri mugallym, 34 ýaşda, 19.07.1959.

48 ',576);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (56,1,56,'MAGTYMGULY HEM GELIN Günleriň bir gününde gelin-gyzlar üýşüşip, Magtymgulynyň adamkärçiligini, ahlagyny taryp edýärler. Olaryň arasynda bir haýasyzrak gelin bu sözlere pitiwa etmän: — Asyl Magtymguly şahyr meni görenden saýraberse nädersiň! — diýen. — Saýramasyna-ha saýrar-la, ýöne hanjalygyna saýrajagy belli däl! — diýip oturanlardan biri suňşurypdyr. Özüne göwni ýetýän gelin zülpüni sypap: — Göreli bakaly, şol şahyr akylyndan azaşyp, dünýäni unudaýmazmyka — diýip, öýüne gelipdir-de, geýne bilenini geýnip, dakyna bilenini dakynyp, bezenip-beslenip, Magtymgulynyň ýanyna ugrapdyr. Gün öýläne agan wagtlary, şahyr öýüň töründe kiçijik demir sandygyň üstünde kagyzyny goýupdyr-da çöküne düşüp, goşgy ýazyp otyr eken. Birden bir gara günüň öňüni kesip geçipdir. Magtymguly başyny çalarak göterip, gözüniň gytagyny gana tarap aýlapdyr. Görse, bir näzenin gelin müň näzkereşme bilen apbasyly köýnegini ýalpyldadyp, içerik giripdir. Gelniň bezenişinden hem boýnuny bir gapdala gyşardyp, göz güldürip, gaş kakyşyndan many aňlan Magtymguly ýüzüni aşak salypdyr. Gelin onuň öňünden şaňňyrdap, eýläk-beýläk geçse-de, epin aralaryna bägül salnyp, telim aýlap demir sandykda ýatan keteniň beýhuş ediji ysy burnuna ursa-da, şahyr oňa intipis etmändir.

49 ',1281);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (57,1,57,'Magtymgulynyň has golaýjagyndan geçmekçi bolan gelniň agyr gyňajynyň uzyn seçekleri syýasy kepemedik haty zaýalapdyr. Bu haýasyz gelniň gödek hereketine şahyryň aşa gahary gelipdir, ol ýüzüni galdyrman oturşyna, «Geçersiň, gelin» diýen goşgusyny düzüpdir:

«Işikden gelip sen, töre geçewer, Ajyksaň, ak ölüm, çalyn içewer, Uçgun syçramasyn, otdan gaçawer, Köýnegiň köneldip geçer sen, gelin!

Bir ujypsyz dawa üstünde bolsun, Görenleriň gözi kastynda bolsun, Ýöräňde gözleriň astynda bolsun, Isleseň dawadan gaçar sen, gelin!

Magtymguly bu sözleri diýmesin, Adamyň öýkeläp nanyň iýmesin, Etegne elmydam oglan siýmesin, Reňňiň sargaryp öçer sen, gelin!

Ýüzi çapady ýaly gyzaran gelin dodagyny dişläp, gözüne ýaş aýlapdyr-da, hamsygyp, çalt çykyp gidipdir. Şondan soň Magtymguly şahyryň durnuklylygyny synan adam tapylmandyr.

Annagözel Hümmet aýaly, 38 ýaş, Mary raýon, Peşanaly oba, Lenin adyndaky kolhozyň çleni, 1958.

50 ',949);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (58,1,58,'SEGSEN ÝYL ÖŇ Wenger alymy A. Wamberi 1863-nji ýylda Orta Aziýa syýahat edipdir. Ol özüniň 1865-nji ýylda S. Peterburgda çap edilen «Orta Aziýa syýahat» atly meşhur kitabynda (159-njy sahypasynda) Magtymguly hakynda şeýle maglumat berýär: «Gyzyl Ahunyň aýtmagyna görä, Magtymguly mundan 80 ýyl öň dünýäden ötüpdir».

Türkmen edebiýatynyň taryhçysy, merhum Ahmet Ahundow—Gürgenliniň elýazmalaryndan.

51 ',417);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (59,1,59,'«GARRY MOLLA» GONAMÇYLYGY Esenguly obaly Baýry Kary (ol 1935-nji ýylda 70 ýaşlarynda eken) diýen adam şeýle aýdýar: «1913-nji ýylda haja gitmek üçin Gökleňden Esengula gelen Gyzylbaba atly bir gökleňiň diýmegine görä, Magtymgulynyň çowlugy Annagurban şu 1913-nji ýylda Magtymgulynyň guburynyň üstünde sadaka berdi. Şol sadaka berilen wagtda (1913nji ýyl) Magtymgulynyň ölümine 100 ýyl doldy» diýip aýdypdyr. Ýene Baýry Kary: «Magtymgulynyň we onuň atasy Döwletmämmet Azadynyň guburlary bir-birlerine ýanaşyk (Magtymguly gündogar, atasy günbatar tarapynda) bolup, Etrek çaýy bile Soňudagy arasynda, «Garry molla» diýen gonamçylykdadyr» diýip aýdýar. — Olaryň guburlaryny şu Baýry Kary diýen adamyň özi hem öz sözi bilen görenmiş.

Ahmet Ahundow—Gürgenliniň elýazmalaryndan.

52 ',796);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (60,1,60,'UNUDYLMAJAK TÄSIR «Türkmen halky üçin baryp ýatan lezzet bagşynyň gelmegidir we onuň tamdyra çalyp, Göroglynyň ýa el ýetmez şaha hasaplanýan Magtymgulynyň aýdymyny aýtmagydyr. Magtymgula öwlüýä ýaly garaýarlar. Magtymgulynyň aýdymlaryny eşiden çaglarymdaky geçen minutlar mende iň ýokary derejede gyzykly hem hiç unudylmajak täsir galdyrdy».

A. Wamberi, «Orta Aziýa syýahat», Moskwa, 1874, 279-280 sahypa.

53 ',426);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (61,1,61,'MAZMUNY Görme-görüş . . . . . . . . . . . . . . . . . . . . . . . 1 Hywa ýolunda . . . . . . . . . . . . . . . . . . . . . . 2 Oňmadyk duşuşyk . . . . . . . . . . . . . . . . . . . . 3 Garşylykly ýigrenç . . . . . . . . . . . . . . . . . . . . 5 Syrly çorba . . . . . . . . . . . . . . . . . . . . . . . . 6 Aslymdan dönmen . . . . . . . . . . . . . . . . . . . . 9 Şahyrlar neberesi . . . . . . . . . . . . . . . . . . . . 10 «Seýil edeliň bu jahana» . . . . . . . . . . . . . . . . . 12 Ilkinji mugallym . . . . . . . . . . . . . . . . . . . . . 13 Parasatly ynsan . . . . . . . . . . . . . . . . . . . . . 14 Magtymgulynyň ýaşlygy . . . . . . . . . . . . . . . . . 15 Gözel tebigat aşygy . . . . . . . . . . . . . . . . . . . . 17 «Siz ele bakýarsyňyz» . . . . . . . . . . . . . . . . . . 18 Orazmeňli şahyr . . . . . . . . . . . . . . . . . . . . . 20 Durdy şahyr . . . . . . . . . . . . . . . . . . . . . . . 23 Magtymguly we Nury Kazym . . . . . . . . . . . . . . 24 Gaýgyly habar . . . . . . . . . . . . . . . . . . . . . . 27 Zaman gassap . . . . . . . . . . . . . . . . . . . . . . . 29 Tersakan . . . . . . . . . . . . . . . . . . . . . . . . . 31 Bosa-bosluk . . . . . . . . . . . . . . . . . . . . . . . . 32 Parasatly jogabyň netijesi . . . . . . . . . . . . . . . . 33

54 ',1308);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (62,1,62,'Ölüm ýassygynda . . . . . . . . . . . . . . . . . . . . . 34 Mynasyp şägirtler . . . . . . . . . . . . . . . . . . . . 36 Garaçomak . . . . . . . . . . . . . . . . . . . . . . . . 38 Hormatly myhman . . . . . . . . . . . . . . . . . . . . 39 «Hünärler kitaby» . . . . . . . . . . . . . . . . . . . . 41 Hezil etmedim dünýä senden . . . . . . . . . . . . . . 42 Hywa köçesinde . . . . . . . . . . . . . . . . . . . . . 43 Ogurlanan çaga . . . . . . . . . . . . . . . . . . . . . . 44 Şahyrlar mejlisi . . . . . . . . . . . . . . . . . . . . . 45 Ylym ýolunda . . . . . . . . . . . . . . . . . . . . . . . 46 Magtymguly hem gelin . . . . . . . . . . . . . . . . . 49 Segsen ýyl öň . . . . . . . . . . . . . . . . . . . . . . . 51 «Garry molla» gonamçylygy . . . . . . . . . . . . . . . 52 Unudylmajak täsir . . . . . . . . . . . . . . . . . . . . 53

55 ',866);
INSERT INTO `pages` (`id`,`document_id`,`page_number`,`text`,`character_count`) VALUES (63,1,63,'MAGTYMGULY HAKYNDA HALK ROWAÝATLARY

Suratçy: A. M. Salin Surat redaktory: M. P. Fedura Tehredaktor: W. N. Abramow Tiražy: 7000

—

Bu kitapdaky maglumat ”bolşy ýaly” esaslarda, kepilliksiz getirilýär. Bu iş taýýarlananda ähli seresaplyk çäreleri görlen hem bolsa, ne awtor(lar), ne «» sahypasy bu işdäki informasiýa sebäpli çekilen göni ýa gytaklaýyn ýitgi ýa zelel üçin hiç bir adamyň ýa guramanyň öňünde jogapkärçilik çekmeýär.

PDF-a geçirildi: 18 Aprel 2020 «» sahypasynyň kitaphanasy',516);
COMMIT;
SET FOREIGN_KEY_CHECKS=1;
