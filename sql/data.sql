-- Datos de prueba para Inmobiliaria UTS (MySQL)
-- Clave para todos los usuarios pre-registrados: 123456
-- Hash: 9e21039348b89a94182874f2e2c0750a091d66c76adc3514ae07f1ec47cdeda6, Salt: salt123

-- 1. Insertar Roles
INSERT INTO roles (id, nombre) VALUES
(1, 'Visitante'),
(2, 'Cliente'),
(3, 'Inmobiliaria'),
(4, 'Administrador')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

-- 2. Insertar Ciudades
INSERT INTO ciudades (id, nombre) VALUES
(1, 'Bucaramanga'),
(2, 'Floridablanca'),
(3, 'Girón'),
(4, 'Piedecuesta'),
(5, 'Barrancabermeja'),
(6, 'San Gil'),
(7, 'Socorro'),
(8, 'Málaga'),
(9, 'Barbosa'),
(10, 'Pamplona')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

-- 3. Insertar Tipos de Propiedades
INSERT INTO tipos_propiedades (id, nombre) VALUES
(1, 'Casa'),
(2, 'Apartamento'),
(3, 'Local'),
(4, 'Oficina'),
(5, 'Terreno')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

-- 4. Insertar Características
INSERT INTO caracteristicas (id, nombre) VALUES
(1, 'Piscina'),
(2, 'Parqueadero'),
(3, 'Ascensor'),
(4, 'Gimnasio'),
(5, 'Vigilancia 24/7'),
(6, 'Aire Acondicionado'),
(7, 'Balcón'),
(8, 'Zonas Verdes'),
(9, 'Zona BBQ'),
(10, 'Cancha Múltiple')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

-- 5. Insertar Usuarios (11 usuarios)
INSERT INTO usuarios (id, correo, password_hash, password_salt, estado) VALUES
(1, 'admin@uts.edu.co', '9e21039348b89a94182874f2e2c0750a091d66c76adc3514ae07f1ec47cdeda6', 'salt123', 'activo'),
(2, 'agente1@uts.edu.co', '9e21039348b89a94182874f2e2c0750a091d66c76adc3514ae07f1ec47cdeda6', 'salt123', 'activo'),
(3, 'agente2@uts.edu.co', '9e21039348b89a94182874f2e2c0750a091d66c76adc3514ae07f1ec47cdeda6', 'salt123', 'activo'),
(4, 'cliente1@uts.edu.co', '9e21039348b89a94182874f2e2c0750a091d66c76adc3514ae07f1ec47cdeda6', 'salt123', 'activo'),
(5, 'cliente2@uts.edu.co', '9e21039348b89a94182874f2e2c0750a091d66c76adc3514ae07f1ec47cdeda6', 'salt123', 'activo'),
(6, 'cliente3@uts.edu.co', '9e21039348b89a94182874f2e2c0750a091d66c76adc3514ae07f1ec47cdeda6', 'salt123', 'activo'),
(7, 'cliente4@uts.edu.co', '9e21039348b89a94182874f2e2c0750a091d66c76adc3514ae07f1ec47cdeda6', 'salt123', 'activo'),
(8, 'cliente5@uts.edu.co', '9e21039348b89a94182874f2e2c0750a091d66c76adc3514ae07f1ec47cdeda6', 'salt123', 'activo'),
(9, 'cliente6@uts.edu.co', '9e21039348b89a94182874f2e2c0750a091d66c76adc3514ae07f1ec47cdeda6', 'salt123', 'activo'),
(10, 'cliente7@uts.edu.co', '9e21039348b89a94182874f2e2c0750a091d66c76adc3514ae07f1ec47cdeda6', 'salt123', 'activo'),
(11, 'cliente8@uts.edu.co', '9e21039348b89a94182874f2e2c0750a091d66c76adc3514ae07f1ec47cdeda6', 'salt123', 'activo')
ON DUPLICATE KEY UPDATE correo=VALUES(correo);

-- 6. Insertar Roles de Usuario
INSERT INTO usuarios_roles (id_usuario, id_rol) VALUES
(1, 4), -- admin
(2, 3), -- agente 1
(3, 3), -- agente 2
(4, 2), -- cliente 1
(5, 2), -- cliente 2
(6, 2), -- cliente 3
(7, 2), -- cliente 4
(8, 2), -- cliente 5
(9, 2), -- cliente 6
(10, 2), -- cliente 7
(11, 2) -- cliente 8
ON DUPLICATE KEY UPDATE id_rol=VALUES(id_rol);

-- 7. Insertar Perfiles
INSERT INTO perfiles (id_usuario, nombres, apellidos, documento, telefono, direccion, foto) VALUES
(1, 'Juan Carlos', 'Pérez Restrepo', '1098000001', '3151111111', 'Calle 50 # 25-10, Bucaramanga', 'assets/img/user1.png'),
(2, 'María Alejandra', 'López Castro', '1098000002', '3152222222', 'Carrera 27 # 12-40, Floridablanca', 'assets/img/user2.png'),
(3, 'Carlos Julio', 'Gómez Silva', '1098000003', '3153333333', 'Calle 105 # 4-15, Bucaramanga', 'assets/img/user3.png'),
(4, 'Ana Sofía', 'Torres Benítez', '1098000004', '3154444444', 'Diagonal 15 # 30-22, Girón', NULL),
(5, 'Pedro Nel', 'Ramírez Cárdenas', '1098000005', '3155555555', 'Calle 8 # 9-44, Piedecuesta', NULL),
(6, 'Laura Camila', 'Díaz Ortega', '1098000006', '3156666666', 'Carrera 18 # 5-60, Barrancabermeja', NULL),
(7, 'Sofía Elena', 'Castro Gómez', '1098000007', '3157777777', 'Transversal 3 # 40-50, San Gil', NULL),
(8, 'Jorge Iván', 'Ruiz Mendoza', '1098000008', '3158888888', 'Avenida del Libertador # 12-34, Socorro', NULL),
(9, 'Diego Fernando', 'Morales Rico', '1098000009', '3159999999', 'Calle Real # 8-88, Barichara', NULL),
(10, 'Luisa Fernanda', 'Herrera Plata', '1098000010', '3150000000', 'Carrera 9 # 10-12, Pamplona', NULL),
(11, 'Andrés Felipe', 'Silva Mantilla', '1098000011', '3151111112', 'Avenida Central # 4-88, Bucaramanga', NULL)
ON DUPLICATE KEY UPDATE nombres=VALUES(nombres), apellidos=VALUES(apellidos);

-- 8. Insertar Propiedades (12 propiedades)
INSERT INTO propiedades (id, titulo, descripcion, direccion, precio, matricula_inmobiliaria, id_ciudad, id_tipo, id_agente, estado) VALUES
(1, 'Hermosa Casa Campestre en Ruitoque', 'Casa moderna de dos pisos con amplia zona verde y acabados de lujo.', 'Condominio Ruitoque Golf, Lote 14', 1200000000.00, 'MAT-80001', 2, 1, 2, 'disponible'),
(2, 'Apartamento Vista Al Parque', 'Apartamento de 3 habitaciones, zona social con piscina y excelente ventilación.', 'Carrera 40 # 56-12, Cabecera', 450000000.00, 'MAT-80002', 1, 2, 2, 'disponible'),
(3, 'Local Comercial Zona Centro', 'Local de 80 metros cuadrados en zona de alto tráfico peatonal.', 'Calle 35 # 15-28, Bucaramanga Centro', 3500000.00, 'MAT-80003', 1, 3, 3, 'disponible'),
(4, 'Oficina Moderna en Cabecera', 'Oficina amoblada con aire acondicionado y parqueadero privado.', 'Carrera 33 # 48-15, Edificio San Pío', 2800000.00, 'MAT-80004', 1, 4, 3, 'disponible'),
(5, 'Lote Urbanizable en Piedecuesta', 'Excelente lote plano listo para construir vivienda familiar.', 'Vereda Guatiguará, Lote 5', 180000000.00, 'MAT-80005', 4, 5, 2, 'disponible'),
(6, 'Apartamento Económico en Girón', 'Apartamento acogedor de 2 habitaciones, cerca a parques y colegios.', 'Calle 28 # 12-40, Girón Centro', 1300000.00, 'MAT-80006', 3, 2, 2, 'disponible'),
(7, 'Casa Familiar en Floridablanca', 'Casa de tres pisos con garaje cubierto y terraza grande.', 'Calle 6 # 4-15, Cañaveral', 680000000.00, 'MAT-80007', 2, 1, 3, 'disponible'),
(8, 'Apartamento Penthouse de Lujo', 'Penthouse de 4 habitaciones con terraza privada y jacuzzi.', 'Carrera 38 # 42-10, Sotomayor', 1800000000.00, 'MAT-80008', 1, 2, 2, 'disponible'),
(9, 'Local en Centro Comercial', 'Local ideal para comidas o almacén de ropa, excelente ubicación.', 'C.C. El Cacique, Local 210', 8000000.00, 'MAT-80009', 1, 3, 3, 'arrendado'),
(10, 'Terreno Agrícola en San Gil', 'Terreno de 2 hectáreas apto para cultivos o proyecto turístico.', 'Vereda Ojo de Agua, San Gil', 320000000.00, 'MAT-80010', 6, 5, 2, 'disponible'),
(11, 'Casa Histórica en Girón', 'Casa colonial restaurada en zona histórica, ideal para restaurante u hotel.', 'Carrera 25 # 29-15, Casco Antiguo', 950000000.00, 'MAT-80011', 3, 1, 3, 'disponible'),
(12, 'Oficina Compartida Co-working', 'Espacio de oficina tipo co-working con salas de juntas incluidas.', 'Calle 48 # 28-80, Sotomayor', 1200000.00, 'MAT-80012', 1, 4, 2, 'disponible')
ON DUPLICATE KEY UPDATE titulo=VALUES(titulo), precio=VALUES(precio);

-- 9. Insertar Imágenes de Propiedades (fotografías locales por propiedad, galería completa)
-- Se borran todas las imágenes previas para evitar que queden filas viejas
-- (por ejemplo, de URLs rotas o fotos mal asignadas de una carga anterior de este script).
DELETE FROM imagenes_propiedades;
INSERT INTO imagenes_propiedades (id, id_propiedad, url_imagen) VALUES
(1, 1, 'assets/img/propiedades/13_casa_campestre_mesa_ruitoque/principal.jpg'),
(2, 1, 'assets/img/propiedades/13_casa_campestre_mesa_ruitoque/sala.jpg'),
(4, 1, 'assets/img/propiedades/13_casa_campestre_mesa_ruitoque/habitacion.jpg'),
(5, 1, 'assets/img/propiedades/13_casa_campestre_mesa_ruitoque/piscina.jpg'),

(8, 2, 'assets/img/propiedades/01_apto_vista_cabecera/principal.jpg'),
(9, 2, 'assets/img/propiedades/01_apto_vista_cabecera/sala.jpg'),
(10, 2, 'assets/img/propiedades/01_apto_vista_cabecera/cocina.jpg'),
(11, 2, 'assets/img/propiedades/01_apto_vista_cabecera/habitacion.jpg'),

(13, 3, 'https://images.unsplash.com/photo-1580554430120-94cfcb3adf25?auto=format&fit=crop&w=1400&q=85'),
(14, 3, 'https://images.unsplash.com/photo-1601600576337-c1d8a0d1373c?auto=format&fit=crop&w=1400&q=85'),
(15, 3, 'https://images.unsplash.com/photo-1686387831695-a19ab3d0b75e?auto=format&fit=crop&w=1400&q=85'),

(17, 4, 'assets/img/propiedades/25_oficina_empresarial_cabecera/principal.jpg'),
(18, 4, 'assets/img/propiedades/25_oficina_empresarial_cabecera/recepcion.jpg'),
(19, 4, 'assets/img/propiedades/25_oficina_empresarial_cabecera/reunion.jpg'),
(20, 4, 'assets/img/propiedades/25_oficina_empresarial_cabecera/trabajo.jpg'),

(21, 5, 'https://images.unsplash.com/photo-1494187570835-b188e7f0f26e?auto=format&fit=crop&w=1400&q=85'),
(22, 5, 'https://images.unsplash.com/photo-1506744476757-8407c4647c7f?auto=format&fit=crop&w=1400&q=85'),

(26, 6, 'assets/img/propiedades/10_apto_ciudadela_real/principal.jpg'),
(27, 6, 'assets/img/propiedades/10_apto_ciudadela_real/sala.jpg'),
(30, 6, 'assets/img/propiedades/10_apto_ciudadela_real/zona_comun.jpg'),

(31, 7, 'assets/img/propiedades/11_casa_modernacanaveral/principal.jpg'),
(32, 7, 'assets/img/propiedades/11_casa_modernacanaveral/sala.jpg'),
(36, 7, 'assets/img/propiedades/11_casa_modernacanaveral/bano.jpg'),

(37, 8, 'assets/img/propiedades/03_penthouse_sotomayor/principal.jpg'),
(39, 8, 'assets/img/propiedades/03_penthouse_sotomayor/terraza.jpg'),
(41, 8, 'assets/img/propiedades/03_penthouse_sotomayor/cocina.jpg'),

(43, 9, 'https://images.unsplash.com/photo-1562280963-8a5475740a10?auto=format&fit=crop&w=1400&q=85'),
(44, 9, 'https://images.unsplash.com/photo-1519520104014-df63821cb6f9?auto=format&fit=crop&w=1400&q=85'),
(45, 9, 'https://images.unsplash.com/photo-1605371924599-2d0365da1ae0?auto=format&fit=crop&w=1400&q=85'),

(48, 10, 'https://images.unsplash.com/photo-1764719396639-66ea940bb757?auto=format&fit=crop&w=1400&q=85'),
(49, 10, 'https://images.unsplash.com/photo-1469827160215-9d29e96e72f4?auto=format&fit=crop&w=1400&q=85'),

(53, 11, 'assets/img/propiedades/19_casa_familiar_giron/principal.jpg'),
(54, 11, 'assets/img/propiedades/19_casa_familiar_giron/sala.jpg'),
(55, 11, 'assets/img/propiedades/19_casa_familiar_giron/cocina.jpg'),
(56, 11, 'assets/img/propiedades/19_casa_familiar_giron/habitacion.jpg'),

(59, 12, 'assets/img/propiedades/26_oficina_premium_sotomayor/ejecutiva.jpg'),
(60, 12, 'assets/img/propiedades/26_oficina_premium_sotomayor/recepcion.jpg'),
(61, 12, 'assets/img/propiedades/26_oficina_premium_sotomayor/reunion.jpg')
ON DUPLICATE KEY UPDATE url_imagen=VALUES(url_imagen);

-- 10. Insertar Relaciones de Características (propiedades_caracteristicas)
INSERT INTO propiedades_caracteristicas (id_propiedad, id_caracteristica) VALUES
(1, 1), (1, 2), (1, 4), (1, 5), (1, 7), (1, 8), -- Casa Ruitoque tiene casi todo
(2, 1), (2, 2), (2, 3), (2, 5), (2, 7),        -- Apto Vista al Parque tiene piscina, park, ascensor
(3, 2), (3, 5),                                 -- Local Centro tiene park y vigilancia
(4, 2), (4, 3), (4, 5), (4, 6),                 -- Oficina tiene park, ascensor, vigil y aire
(5, 8),                                         -- Lote tiene zonas verdes
(6, 7),                                         -- Apto Giron tiene balcon
(7, 2), (7, 5), (7, 7), (7, 8),                 -- Casa Cañaveral
(8, 1), (8, 2), (8, 3), (8, 4), (8, 5), (8, 6), (8, 7), (8, 8), -- Penthouse tiene todo
(9, 3), (9, 5), (9, 6),                         -- Local C.C.
(10, 8),                                        -- Terreno San Gil
(11, 2), (11, 8),                               -- Casa Colonial
(12, 3), (12, 5), (12, 6)                       -- Coworking
ON DUPLICATE KEY UPDATE id_caracteristica=VALUES(id_caracteristica);

-- ============================================================
-- FASE 11 - LOTE 1: Apartamentos (carpetas huérfanas 02,04,05,06,07,08,09)
-- Propiedades 13-19, imágenes 62-98
-- ============================================================

INSERT INTO propiedades (id, titulo, descripcion, direccion, precio, matricula_inmobiliaria, id_ciudad, id_tipo, id_agente, estado) VALUES
(13, 'Apartamento en Parque San Pío', 'Apartamento cómodo de 3 habitaciones cerca al Parque San Pío, ideal para familia joven, con excelente iluminación natural.', 'Calle 45 # 30-18, Parque San Pío, Bucaramanga', 420000000.00, 'MAT-80013', 1, 2, 2, 'disponible'),
(14, 'Apartamento en Altos de Cabecera', 'Apartamento amplio con zona social de conjunto, cerca a centros comerciales y colegios del sector de Cabecera.', 'Carrera 36 # 51-22, Cabecera, Bucaramanga', 520000000.00, 'MAT-80014', 1, 2, 3, 'disponible'),
(15, 'Apartamento en Parque de las Palmas', 'Apartamento funcional de 2 habitaciones en conjunto residencial tranquilo, buena opción para primera vivienda.', 'Carrera 22 # 58-40, Bucaramanga', 390000000.00, 'MAT-80015', 1, 2, 2, 'disponible'),
(16, 'Apartamento Ejecutivo Carrera 27', 'Apartamento con estudio/oficina independiente, ideal para profesional o teletrabajo, ubicado sobre la Carrera 27.', 'Carrera 27 # 44-16, Bucaramanga', 480000000.00, 'MAT-80016', 1, 2, 3, 'disponible'),
(17, 'Apartamento en Cañaveral Living', 'Apartamento moderno con zona social de conjunto, en el corazón de Cañaveral, cerca a oficinas y comercio.', 'Calle 34 # 9-50, Cañaveral, Floridablanca', 650000000.00, 'MAT-80017', 2, 2, 2, 'disponible'),
(18, 'Apartamento en Club Campestre', 'Apartamento de lujo con vista panorámica, ubicado junto al Club Campestre de Floridablanca, acabados de alta gama.', 'Vía Club Campestre, Floridablanca', 780000000.00, 'MAT-80018', 2, 2, 3, 'disponible'),
(19, 'Apartamento en Reserva del Bosque', 'Apartamento con balcón privado y entorno natural, en conjunto campestre de Floridablanca cerca a zonas verdes.', 'Km 3 Vía a Floridablanca, Reserva del Bosque', 560000000.00, 'MAT-80019', 2, 2, 2, 'disponible')
ON DUPLICATE KEY UPDATE titulo=VALUES(titulo), precio=VALUES(precio);

INSERT INTO imagenes_propiedades (id, id_propiedad, url_imagen) VALUES
(62, 13, 'assets/img/propiedades/02_apto_parque_san_pio/bano.jpg'),
(63, 13, 'assets/img/propiedades/02_apto_parque_san_pio/cocina.jpg'),
(64, 13, 'assets/img/propiedades/02_apto_parque_san_pio/habitacion.jpg'),
(65, 13, 'assets/img/propiedades/02_apto_parque_san_pio/principal.jpg'),
(66, 13, 'assets/img/propiedades/02_apto_parque_san_pio/sala.jpg'),

(67, 14, 'assets/img/propiedades/04_apto_altos_cabecera/cocina.jpg'),
(68, 14, 'assets/img/propiedades/04_apto_altos_cabecera/habitacion.jpg'),
(69, 14, 'assets/img/propiedades/04_apto_altos_cabecera/principal.jpg'),
(70, 14, 'assets/img/propiedades/04_apto_altos_cabecera/sala.jpg'),
(71, 14, 'assets/img/propiedades/04_apto_altos_cabecera/zona_social.jpg'),

(72, 15, 'assets/img/propiedades/05_apto_parque_palmas/bano.jpg'),
(73, 15, 'assets/img/propiedades/05_apto_parque_palmas/cocina.jpg'),
(74, 15, 'assets/img/propiedades/05_apto_parque_palmas/habitacion.jpg'),
(75, 15, 'assets/img/propiedades/05_apto_parque_palmas/principal.jpg'),
(76, 15, 'assets/img/propiedades/05_apto_parque_palmas/sala.jpg'),

(77, 16, 'assets/img/propiedades/06_apto_ejecutivo_27/cocina.jpg'),
(78, 16, 'assets/img/propiedades/06_apto_ejecutivo_27/habitacion.jpg'),
(79, 16, 'assets/img/propiedades/06_apto_ejecutivo_27/oficina.jpg'),
(80, 16, 'assets/img/propiedades/06_apto_ejecutivo_27/principal.jpg'),
(81, 16, 'assets/img/propiedades/06_apto_ejecutivo_27/sala.jpg'),

(82, 17, 'assets/img/propiedades/07_apto_canaveral_living/cocina.jpg'),
(83, 17, 'assets/img/propiedades/07_apto_canaveral_living/habitacion.jpg'),
(84, 17, 'assets/img/propiedades/07_apto_canaveral_living/principal.jpg'),
(85, 17, 'assets/img/propiedades/07_apto_canaveral_living/sala.jpg'),
(86, 17, 'assets/img/propiedades/07_apto_canaveral_living/zona_social.jpg'),

(87, 18, 'assets/img/propiedades/08_apto_club_campestre/bano.jpg'),
(88, 18, 'assets/img/propiedades/08_apto_club_campestre/cocina.jpg'),
(89, 18, 'assets/img/propiedades/08_apto_club_campestre/habitacion.jpg'),
(90, 18, 'assets/img/propiedades/08_apto_club_campestre/principal.jpg'),
(91, 18, 'assets/img/propiedades/08_apto_club_campestre/sala.jpg'),
(92, 18, 'assets/img/propiedades/08_apto_club_campestre/vista.jpg'),

(93, 19, 'assets/img/propiedades/09_apto_reserva_bosque/balcon.jpg'),
(94, 19, 'assets/img/propiedades/09_apto_reserva_bosque/bano.jpg'),
(95, 19, 'assets/img/propiedades/09_apto_reserva_bosque/cocina.jpg'),
(96, 19, 'assets/img/propiedades/09_apto_reserva_bosque/habitacion.jpg'),
(97, 19, 'assets/img/propiedades/09_apto_reserva_bosque/principal.jpg'),
(98, 19, 'assets/img/propiedades/09_apto_reserva_bosque/sala.jpg')
ON DUPLICATE KEY UPDATE url_imagen=VALUES(url_imagen);

INSERT INTO propiedades_caracteristicas (id_propiedad, id_caracteristica) VALUES
(13, 2), (13, 3), (13, 5),
(14, 2), (14, 3), (14, 4), (14, 5),
(15, 2), (15, 3), (15, 5),
(16, 2), (16, 3), (16, 6),
(17, 2), (17, 4), (17, 5), (17, 8),
(18, 1), (18, 2), (18, 4), (18, 5),
(19, 2), (19, 5), (19, 7), (19, 8)
ON DUPLICATE KEY UPDATE id_caracteristica=VALUES(id_caracteristica);

-- ============================================================
-- FASE 11 - LOTE 2: Casas (carpetas huérfanas 12,14,15,16,17,18,20)
-- Propiedades 20-26, imágenes 99-142
-- ============================================================

INSERT INTO propiedades (id, titulo, descripcion, direccion, precio, matricula_inmobiliaria, id_ciudad, id_tipo, id_agente, estado) VALUES
(20, 'Casa Familiar en Ruitoque con Piscina', 'Casa campestre de tres habitaciones con jardín y piscina privada, ideal para familias que buscan tranquilidad.', 'Condominio Ruitoque Golf, Lote 22', 980000000.00, 'MAT-80020', 2, 1, 3, 'disponible'),
(21, 'Casa Colonial en San Francisco', 'Casa colonial restaurada con patio interior y comedor amplio, ubicada en el barrio histórico San Francisco.', 'Calle 32 # 24-10, San Francisco, Girón', 850000000.00, 'MAT-80021', 3, 1, 2, 'disponible'),
(22, 'Casa Familiar con Piscina en Los Lagos', 'Casa de dos pisos con jardín, piscina y comedor independiente, en conjunto cerrado cerca a Los Lagos.', 'Conjunto Los Lagos, Manzana 4 Casa 12, Floridablanca', 920000000.00, 'MAT-80022', 2, 1, 3, 'disponible'),
(23, 'Casa Moderna en El Bosque', 'Casa moderna de diseño minimalista con patio interior, en el sector residencial de El Bosque.', 'Calle 12 # 18-30, El Bosque, Floridablanca', 650000000.00, 'MAT-80023', 2, 1, 2, 'disponible'),
(24, 'Casa Campestre en Piedecuesta con Zona BBQ', 'Casa campestre con jardín, zona de BBQ y vista abierta, perfecta para reuniones familiares.', 'Vereda Menzuly, Piedecuesta', 890000000.00, 'MAT-80024', 4, 1, 3, 'disponible'),
(25, 'Casa Exclusiva en Mesa de los Santos', 'Casa de lujo con terraza y vista panorámica al cañón del Chicamocha, ubicada en Mesa de los Santos.', 'Vía Mesa de los Santos, Km 8, Piedecuesta', 1450000000.00, 'MAT-80025', 4, 1, 2, 'disponible'),
(26, 'Casa Moderna en Bellavista con Terraza', 'Casa moderna con terraza y zona social, ubicada en el sector de Bellavista, cerca a vías principales.', 'Carrera 9 # 62-14, Bellavista, Bucaramanga', 720000000.00, 'MAT-80026', 1, 1, 3, 'disponible')
ON DUPLICATE KEY UPDATE titulo=VALUES(titulo), precio=VALUES(precio);

INSERT INTO imagenes_propiedades (id, id_propiedad, url_imagen) VALUES
(99, 20, 'assets/img/propiedades/12_casa_familiar_ruitoque/bano.jpg'),
(100, 20, 'assets/img/propiedades/12_casa_familiar_ruitoque/cocina.jpg'),
(101, 20, 'assets/img/propiedades/12_casa_familiar_ruitoque/habitacion.jpg'),
(102, 20, 'assets/img/propiedades/12_casa_familiar_ruitoque/jardin.jpg'),
(103, 20, 'assets/img/propiedades/12_casa_familiar_ruitoque/piscina.jpg'),
(104, 20, 'assets/img/propiedades/12_casa_familiar_ruitoque/principal.jpg'),
(105, 20, 'assets/img/propiedades/12_casa_familiar_ruitoque/sala.jpg'),

(106, 21, 'assets/img/propiedades/14_casa_colonial_san_francisco/cocina.jpg'),
(107, 21, 'assets/img/propiedades/14_casa_colonial_san_francisco/comedor.jpg'),
(108, 21, 'assets/img/propiedades/14_casa_colonial_san_francisco/habitacion.jpg'),
(109, 21, 'assets/img/propiedades/14_casa_colonial_san_francisco/patio.jpg'),
(110, 21, 'assets/img/propiedades/14_casa_colonial_san_francisco/principal.jpg'),
(111, 21, 'assets/img/propiedades/14_casa_colonial_san_francisco/sala.jpg'),

(112, 22, 'assets/img/propiedades/15_casa_familiar_lagos/cocina.jpg'),
(113, 22, 'assets/img/propiedades/15_casa_familiar_lagos/comedor.jpg'),
(114, 22, 'assets/img/propiedades/15_casa_familiar_lagos/habitacion.jpg'),
(115, 22, 'assets/img/propiedades/15_casa_familiar_lagos/jardin.jpg'),
(116, 22, 'assets/img/propiedades/15_casa_familiar_lagos/piscina.jpg'),
(117, 22, 'assets/img/propiedades/15_casa_familiar_lagos/principal.jpg'),
(118, 22, 'assets/img/propiedades/15_casa_familiar_lagos/sala.jpg'),

(119, 23, 'assets/img/propiedades/16_casa_moderna_el_bosque/bano.jpg'),
(120, 23, 'assets/img/propiedades/16_casa_moderna_el_bosque/cocina.jpg'),
(121, 23, 'assets/img/propiedades/16_casa_moderna_el_bosque/patio.jpg'),
(122, 23, 'assets/img/propiedades/16_casa_moderna_el_bosque/principal.jpg'),
(123, 23, 'assets/img/propiedades/16_casa_moderna_el_bosque/sala.jpg'),

(124, 24, 'assets/img/propiedades/17_casa_campestre_piedecuesta/bbq.jpg'),
(125, 24, 'assets/img/propiedades/17_casa_campestre_piedecuesta/cocina.jpg'),
(126, 24, 'assets/img/propiedades/17_casa_campestre_piedecuesta/habitacion.jpg'),
(127, 24, 'assets/img/propiedades/17_casa_campestre_piedecuesta/jardin.jpg'),
(128, 24, 'assets/img/propiedades/17_casa_campestre_piedecuesta/principal.jpg'),
(129, 24, 'assets/img/propiedades/17_casa_campestre_piedecuesta/sala.jpg'),
(130, 24, 'assets/img/propiedades/17_casa_campestre_piedecuesta/vista.jpg'),

(131, 25, 'assets/img/propiedades/18_casa_exclusiva_mesa_santos/bano.jpg'),
(132, 25, 'assets/img/propiedades/18_casa_exclusiva_mesa_santos/cocina.jpg'),
(133, 25, 'assets/img/propiedades/18_casa_exclusiva_mesa_santos/habitacion.jpg'),
(134, 25, 'assets/img/propiedades/18_casa_exclusiva_mesa_santos/paisaje.jpg'),
(135, 25, 'assets/img/propiedades/18_casa_exclusiva_mesa_santos/principal.jpg'),
(136, 25, 'assets/img/propiedades/18_casa_exclusiva_mesa_santos/sala.jpg'),
(137, 25, 'assets/img/propiedades/18_casa_exclusiva_mesa_santos/terraza.jpg'),

(138, 26, 'assets/img/propiedades/20_casa_moderna_bellavista/cocina.jpg'),
(139, 26, 'assets/img/propiedades/20_casa_moderna_bellavista/principal.jpg'),
(140, 26, 'assets/img/propiedades/20_casa_moderna_bellavista/sala.jpg'),
(141, 26, 'assets/img/propiedades/20_casa_moderna_bellavista/terraza.jpg'),
(142, 26, 'assets/img/propiedades/20_casa_moderna_bellavista/zona_social.jpg')
ON DUPLICATE KEY UPDATE url_imagen=VALUES(url_imagen);

INSERT INTO propiedades_caracteristicas (id_propiedad, id_caracteristica) VALUES
(20, 1), (20, 2), (20, 5), (20, 8),
(21, 2), (21, 8),
(22, 1), (22, 2), (22, 8),
(23, 2), (23, 8),
(24, 2), (24, 5), (24, 8),
(25, 2), (25, 5), (25, 6),
(26, 2), (26, 4), (26, 5)
ON DUPLICATE KEY UPDATE id_caracteristica=VALUES(id_caracteristica);

-- ============================================================
-- FASE 11 - LOTE 3: Locales, Oficina y Terrenos (carpetas huérfanas 21,22,23,24,27,28,29,30)
-- Propiedades 27-34, imágenes 143-178
-- ============================================================

INSERT INTO propiedades (id, titulo, descripcion, direccion, precio, matricula_inmobiliaria, id_ciudad, id_tipo, id_agente, estado) VALUES
(27, 'Local Comercial en C.C. Cacique', 'Local comercial en el interior del Centro Comercial Cacique, con excelente flujo de clientes y acceso directo.', 'C.C. Cacique, Local 305, Bucaramanga', 9500000.00, 'MAT-80027', 1, 3, 2, 'disponible'),
(28, 'Local Comercial en el Centro', 'Local con salón amplio y vitrina hacia la calle, ubicado en zona comercial tradicional del centro de Bucaramanga.', 'Calle 31 # 17-20, Bucaramanga Centro', 4200000.00, 'MAT-80028', 1, 3, 3, 'disponible'),
(29, 'Local en Plaza Cabecera', 'Local con área de oficina interior y vitrina, ideal para negocio mixto de atención al público, en el sector de Cabecera.', 'Carrera 33 # 45-10, Cabecera, Bucaramanga', 5500000.00, 'MAT-80029', 1, 3, 2, 'disponible'),
(30, 'Local Comercial en Cañaveral', 'Local con vitrina amplia en zona de alto tránsito comercial de Cañaveral, cerca a oficinas y centros empresariales.', 'Calle 30 # 8-15, Cañaveral, Floridablanca', 6800000.00, 'MAT-80030', 2, 3, 3, 'disponible'),
(31, 'Oficina Corporativa en el Centro', 'Oficina con área de trabajo abierta y sala de reuniones, ubicada en edificio corporativo del centro de Bucaramanga.', 'Calle 35 # 19-40, Bucaramanga Centro', 3200000.00, 'MAT-80031', 1, 4, 2, 'disponible'),
(32, 'Lote Campestre en Ruitoque', 'Lote campestre con vegetación nativa y vista abierta, ideal para construir vivienda de descanso en Ruitoque.', 'Condominio Ruitoque Golf, Lote 30', 420000000.00, 'MAT-80032', 2, 5, 3, 'disponible'),
(33, 'Lote Residencial en Piedecuesta', 'Lote residencial en zona en desarrollo de Piedecuesta, con entorno tranquilo y vista panorámica.', 'Vereda El Carrizal, Piedecuesta', 210000000.00, 'MAT-80033', 4, 5, 2, 'disponible'),
(34, 'Terreno Campestre en San Gil', 'Terreno campestre con vegetación y paisaje natural, apto para proyecto turístico o vivienda de recreo en San Gil.', 'Vereda El Roble, San Gil', 280000000.00, 'MAT-80034', 6, 5, 3, 'disponible')
ON DUPLICATE KEY UPDATE titulo=VALUES(titulo), precio=VALUES(precio);

INSERT INTO imagenes_propiedades (id, id_propiedad, url_imagen) VALUES
(143, 27, 'assets/img/propiedades/21_local_comercial_cacique/acceso.jpg'),
(144, 27, 'assets/img/propiedades/21_local_comercial_cacique/area_comercial.jpg'),
(145, 27, 'assets/img/propiedades/21_local_comercial_cacique/bano.jpg'),
(146, 27, 'assets/img/propiedades/21_local_comercial_cacique/interior.jpg'),
(147, 27, 'assets/img/propiedades/21_local_comercial_cacique/principal.jpg'),

(148, 28, 'assets/img/propiedades/22_local_comercial_centro/bano.jpg'),
(149, 28, 'assets/img/propiedades/22_local_comercial_centro/principal.jpg'),
(150, 28, 'assets/img/propiedades/22_local_comercial_centro/salon.jpg'),
(151, 28, 'assets/img/propiedades/22_local_comercial_centro/vitrina.jpg'),

(152, 29, 'assets/img/propiedades/23_local_plaza_cabecera/area.jpg'),
(153, 29, 'assets/img/propiedades/23_local_plaza_cabecera/bano.jpg'),
(154, 29, 'assets/img/propiedades/23_local_plaza_cabecera/oficina.jpg'),
(155, 29, 'assets/img/propiedades/23_local_plaza_cabecera/vitrina.jpg'),

(156, 30, 'assets/img/propiedades/24_local_comercial_canaveral/area.jpg'),
(157, 30, 'assets/img/propiedades/24_local_comercial_canaveral/bano.jpg'),
(158, 30, 'assets/img/propiedades/24_local_comercial_canaveral/principal.jpg'),
(159, 30, 'assets/img/propiedades/24_local_comercial_canaveral/vitrina.jpg'),

(160, 31, 'assets/img/propiedades/27_oficina_corporativa_centro/area_trabajo.jpg'),
(161, 31, 'assets/img/propiedades/27_oficina_corporativa_centro/bano.jpg'),
(162, 31, 'assets/img/propiedades/27_oficina_corporativa_centro/principal.jpg'),
(163, 31, 'assets/img/propiedades/27_oficina_corporativa_centro/reunion.jpg'),

(164, 32, 'assets/img/propiedades/28_lote_campestre_ruitoque/acceso.jpg'),
(165, 32, 'assets/img/propiedades/28_lote_campestre_ruitoque/principal.jpg'),
(166, 32, 'assets/img/propiedades/28_lote_campestre_ruitoque/terreno.jpg'),
(167, 32, 'assets/img/propiedades/28_lote_campestre_ruitoque/vegetacion.jpg'),
(168, 32, 'assets/img/propiedades/28_lote_campestre_ruitoque/vista.jpg'),

(169, 33, 'assets/img/propiedades/29_lote_residencial_piedecuesta/acceso.jpg'),
(170, 33, 'assets/img/propiedades/29_lote_residencial_piedecuesta/entorno.jpg'),
(171, 33, 'assets/img/propiedades/29_lote_residencial_piedecuesta/panoramica.jpg'),
(172, 33, 'assets/img/propiedades/29_lote_residencial_piedecuesta/principal.jpg'),
(173, 33, 'assets/img/propiedades/29_lote_residencial_piedecuesta/terreno.jpg'),

(174, 34, 'assets/img/propiedades/30_terreno_campestre_san_gil/acceso.jpg'),
(175, 34, 'assets/img/propiedades/30_terreno_campestre_san_gil/paisaje.jpg'),
(176, 34, 'assets/img/propiedades/30_terreno_campestre_san_gil/principal.jpg'),
(177, 34, 'assets/img/propiedades/30_terreno_campestre_san_gil/terreno.jpg'),
(178, 34, 'assets/img/propiedades/30_terreno_campestre_san_gil/vegetacion.jpg')
ON DUPLICATE KEY UPDATE url_imagen=VALUES(url_imagen);

INSERT INTO propiedades_caracteristicas (id_propiedad, id_caracteristica) VALUES
(27, 2), (27, 5), (27, 6),
(28, 5),
(29, 2), (29, 5),
(30, 2), (30, 5),
(31, 2), (31, 3), (31, 5), (31, 6),
(32, 8),
(33, 8),
(34, 8)
ON DUPLICATE KEY UPDATE id_caracteristica=VALUES(id_caracteristica);

-- 11. Insertar Citas (11 citas)
INSERT INTO citas (id, id_propiedad, id_cliente, fecha_hora, estado, notas) VALUES
(1, 1, 4, '2026-09-01 10:00:00', 'aceptada', 'El cliente desea ver la cocina y la piscina detalladamente.'),
(2, 2, 4, '2026-09-01 15:00:00', 'pendiente', 'Solicita visita por la tarde.'),
(3, 1, 5, '2026-09-02 09:30:00', 'pendiente', 'Interesado en compra directa.'),
(4, 3, 6, '2026-09-03 11:00:00', 'aceptada', 'Cita comercial para ver local de restaurante.'),
(5, 4, 7, '2026-09-04 14:00:00', 'pendiente', 'Revisión técnica de redes eléctricas.'),
(6, 6, 8, '2026-09-05 16:00:00', 'cancelada', 'El cliente canceló por cruce de horarios.'),
(7, 7, 9, '2026-09-05 10:00:00', 'completada', 'Visita realizada satisfactoriamente, cliente interesado.'),
(8, 8, 10, '2026-09-06 11:00:00', 'aceptada', 'Mostrar penthouse a inversionista extranjero.'),
(9, 2, 5, '2026-09-07 14:00:00', 'pendiente', 'Segunda visita familiar.'),
(10, 10, 11, '2026-09-08 08:00:00', 'pendiente', 'Visita de inspección de linderos en San Gil.'),
(11, 11, 4, '2026-09-09 10:00:00', 'pendiente', 'Revisar detalles estructurales de la casa colonial.')
ON DUPLICATE KEY UPDATE fecha_hora=VALUES(fecha_hora), estado=VALUES(estado);

-- 12. Insertar Solicitudes (10 solicitudes)
INSERT INTO solicitudes (id, id_propiedad, id_cliente, tipo_solicitud, estado, fecha_solicitud) VALUES
(1, 1, 4, 'compra', 'pendiente', '2026-08-28 10:00:00'),
(2, 6, 5, 'arriendo', 'pendiente', '2026-08-28 11:30:00'),
(3, 7, 9, 'compra', 'aprobada', '2026-08-27 15:00:00'),
(4, 9, 6, 'arriendo', 'aprobada', '2026-08-26 09:00:00'), -- Esta es la que pone la propiedad 9 como arrendada
(5, 2, 7, 'compra', 'pendiente', '2026-08-28 16:20:00'),
(6, 3, 8, 'arriendo', 'pendiente', '2026-08-29 08:00:00'),
(7, 4, 10, 'arriendo', 'pendiente', '2026-08-29 09:15:00'),
(8, 5, 11, 'compra', 'pendiente', '2026-08-29 10:30:00'),
(9, 8, 4, 'compra', 'rechazada', '2026-08-25 14:00:00'), -- Solicitud de penthouse rechazada por falta de capacidad de pago
(10, 10, 5, 'compra', 'pendiente', '2026-08-29 11:00:00')
ON DUPLICATE KEY UPDATE estado=VALUES(estado);

-- 13. Insertar Documentos de Solicitudes (10 registros)
INSERT INTO documentos_solicitudes (id, id_solicitud, nombre_archivo, ruta_archivo, tipo_documento) VALUES
(1, 1, 'cedula_ana_torres.pdf', 'uploads/documentos/solicitud_1/cedula.pdf', 'identificacion'),
(2, 1, 'ingresos_ana_torres.pdf', 'uploads/documentos/solicitud_1/ingresos.pdf', 'ingresos'),
(3, 2, 'cedula_pedro_ramirez.pdf', 'uploads/documentos/solicitud_2/cedula.pdf', 'identificacion'),
(4, 3, 'cedula_diego_morales.pdf', 'uploads/documentos/solicitud_3/cedula.pdf', 'identificacion'),
(5, 3, 'contrato_compraventa_firmado.pdf', 'uploads/documentos/solicitud_3/contrato.pdf', 'contrato'),
(6, 4, 'cedula_laura_diaz.pdf', 'uploads/documentos/solicitud_4/cedula.pdf', 'identificacion'),
(7, 5, 'cedula_sofia_castro.pdf', 'uploads/documentos/solicitud_5/cedula.pdf', 'identificacion'),
(8, 6, 'declaracion_renta_jorge.pdf', 'uploads/documentos/solicitud_6/ingresos.pdf', 'ingresos'),
(9, 7, 'cedula_luisa_herrera.pdf', 'uploads/documentos/solicitud_7/cedula.pdf', 'identificacion'),
(10, 8, 'extractos_bancarios_andres.pdf', 'uploads/documentos/solicitud_8/ingresos.pdf', 'ingresos')
ON DUPLICATE KEY UPDATE nombre_archivo=VALUES(nombre_archivo);

-- 14. Insertar Favoritos (11 registros)
INSERT INTO favoritos (id_usuario, id_propiedad) VALUES
(4, 1), (4, 2), (4, 8), -- Ana Torres tiene de favoritos casa Ruitoque, apto Cabecera y Penthouse
(5, 2), (5, 6),          -- Pedro Ramirez
(6, 3), (6, 9),          -- Laura Diaz
(7, 4),                  -- Sofia Castro
(8, 7),                  -- Jorge Ruiz
(9, 11),                 -- Diego Morales
(10, 1)                  -- Luisa Herrera
ON DUPLICATE KEY UPDATE id_propiedad=VALUES(id_propiedad);

-- 15. Insertar Auditorías (12 registros)
INSERT INTO auditoria (id, id_usuario, accion, tabla_afectada, registro_id, detalles) VALUES
(1, 1, 'INICIO_SESION', 'usuarios', 1, 'Administrador inicia sesion exitosamente en el sistema.'),
(2, 2, 'PUBLICAR_PROPIEDAD', 'propiedades', 1, 'Agente publica casa campestre en Ruitoque.'),
(3, 2, 'PUBLICAR_PROPIEDAD', 'propiedades', 2, 'Agente publica apartamento Vista Al Parque.'),
(4, 3, 'PUBLICAR_PROPIEDAD', 'propiedades', 3, 'Agente publica local comercial Centro.'),
(5, 4, 'CREAR_CITA', 'citas', 1, 'Cliente solicita cita para la propiedad 1 (Ruitoque).'),
(6, 4, 'CREAR_CITA', 'citas', 2, 'Cliente solicita cita para la propiedad 2 (Cabecera).'),
(7, 2, 'ACEPTAR_CITA', 'citas', 1, 'Agente acepta cita de cliente 4.'),
(8, 4, 'CREAR_SOLICITUD', 'solicitudes', 1, 'Cliente radica solicitud de compra para propiedad 1.'),
(9, 4, 'SUBIR_DOCUMENTOS', 'documentos_solicitudes', 1, 'Cliente sube copia de documento de identidad.'),
(10, 3, 'APROBAR_SOLICITUD', 'solicitudes', 4, 'Agente aprueba solicitud de arriendo de local C.C. para cliente 6.'),
(11, 1, 'ASIGNAR_ROL', 'usuarios_roles', 2, 'Administrador reasigna rol a usuario agente1.'),
(12, 10, 'ACTUALIZAR_PERFIL', 'perfiles', 10, 'Cliente actualiza sus datos de direccion y telefono.')
ON DUPLICATE KEY UPDATE accion=VALUES(accion);
