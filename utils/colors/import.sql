CREATE TABLE colors (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name_tm VARCHAR(255) NOT NULL,
    name_en VARCHAR(255) NULL,
    hex_code CHAR(7) NULL,
    category VARCHAR(100) NULL,

    PRIMARY KEY (id),
    UNIQUE KEY uq_colors_name_tm (name_tm)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;

INSERT INTO colors (name_tm, name_en, hex_code, category) VALUES
('ak', 'white', '#FFFFFF', 'basic'),
('gara', 'black', '#000000', 'basic'),
('gök', 'blue', '#0000FF', 'basic'),
('gyzyl', 'red', '#FF0000', 'basic'),
('ýaşyl', 'green', '#008000', 'basic'),
('goňur', 'brown', '#A52A2A', 'basic'),
('sary', 'yellow', '#FFFF00', 'basic'),
('gülgün', 'pink', '#FFC0CB', 'basic'),
('narynç', 'orange', '#FFA500', 'basic'),
('mämişi', 'orange', '#FFA500', 'basic'),
('melewşe', 'violet', '#EE82EE', 'basic'),

('al', 'scarlet', '#FF2400', 'shade'),
('gyrmyzy', 'crimson', '#DC143C', 'shade'),
('kümüşsöw', 'silver', '#C0C0C0', 'metallic'),
('altyn', 'gold', '#FFD700', 'metallic'),
('bürünç', 'bronze', '#CD7F32', 'metallic'),

('goýy gyrmyzy', 'dark crimson', '#8B0A1A', 'shade'),
('açyk gyzyl', 'light red', '#FF7F7F', 'shade'),
('çym-gyzyl', 'deep red', '#B00020', 'shade'),

('goýy gök', 'dark blue', '#00008B', 'shade'),
('goýy ýaşyl', 'dark green', '#006400', 'shade'),
('açyk ýaşyl', 'light green', '#90EE90', 'shade'),
('alma reňk', 'apple green', '#8DB600', 'shade'),

('açyk mawy', 'light blue', '#ADD8E6', 'shade'),
('mawy', 'sky blue / azure', '#87CEEB', 'shade'),
('gögümtil-mawy', 'bluish blue', '#6699CC', 'shade'),
('mawymtyl-ýaşyl', 'turquoise green', '#40E0D0', 'shade'),

('sarymtyl-ýaşyl', 'yellowish green', '#9ACD32', 'shade'),
('sarymtyl-gyzyl', 'yellowish red', '#FF6347', 'shade'),

('açyk goňur', 'light brown', '#C4A484', 'shade'),
('goňrumtyl-ýaşyl', 'brownish green', '#6B7045', 'shade'),
('goňras', 'brownish', '#964B00', 'shade'),
('goňur mele', 'chestnut', '#954535', 'shade'),

('gan reňk', 'blood red', '#880808', 'shade'),
('lagyl reňk', 'ruby red', '#E0115F', 'shade'),
('badamjan reňk', 'eggplant', '#614051', 'shade'),

('mis reňk', 'copper', '#B87333', 'metallic'),
('käşir reňk', 'carrot orange', '#ED9121', 'shade'),
('asman reňk', 'sky blue', '#87CEEB', 'shade'),

('kümüşsöw çal', 'silver gray', '#C0C0C0', 'shade'),
('gögümtil-çal', 'bluish gray', '#6699CC', 'shade'),
('bugdaý reňk', 'wheaten', '#F5DEB3', 'shade'),
('mele-tüsse reňk', 'smoke gray', '#848884', 'shade'),
('çakyr reňk', 'wine red', '#722F37', 'shade'),

('solgun', 'pale', NULL, 'modifier'),
('öçük reňk', 'faded color', NULL, 'modifier'),
('goýy reňk', 'dark color', NULL, 'modifier'),
('doýgun reňk', 'saturated color', NULL, 'modifier'),

('ala-mula', 'multicolored / spotted', NULL, 'pattern');